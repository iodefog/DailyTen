//
//  LBUploadSender.m
//  lebo
//
//  Created by 乐播 on 13-3-29.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBUploadSender.h"

#import "SBJSON.h"
#import "AFHTTPRequestOperation.h"
#import "Global.h"
#import "AccountHelper.h"
#import "AccountDTO.h"

static const float TIME_OUT_INTERVAL = 30.0f;

@implementation LBUploadSender

//@synthesize requestUrl;
//@synthesize usePost;
//@synthesize dictParam;
//@synthesize delegate;
//@synthesize completeSelector;
//@synthesize errorSelector;
//@synthesize cachePolicy;
+ (id)currentClient
{
    static AFHTTPClient *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        sharedInstance = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        [sharedInstance.operationQueue setMaxConcurrentOperationCount:1];
    });
    return sharedInstance;
}

+ (id)requestSenderWithURL:(NSString *)theUrl
                   usePost:(BOOL)isPost
               cachePolicy:(NSURLRequestCachePolicy)cholicy
                  delegate:(id)theDelegate
          completeSelector:(SEL)theCompleteSelector
             errorSelector:(SEL)theErrorSelector
          selectorArgument:(id)theSelectorArgument
{
    LBUploadSender *requestSender = [[self alloc] init];
    requestSender.usePost = isPost;
    requestSender.requestUrl =  [theUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    requestSender.delegate = theDelegate;
    requestSender.completeSelector = theCompleteSelector;
    requestSender.errorSelector = theErrorSelector;
    requestSender.cachePolicy = cholicy;
    NSLog(@"%@", theUrl);
    return requestSender;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.usePost = NO;
        self.cachePolicy = 0;
    }
    
    return self;
}

- (void)send
{
    NSLog(@"%@", self.requestUrl);
   
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:self.requestUrl  parameters:nil constructingBodyWithBlock: ^(id formData)
    {
        if(!self.audioPath)
        {
            if (self.videoPath) {
                NSLog(@"self.videoPath:%@",self.videoPath);
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.videoPath] name:@"video" fileName:@"movie.mp4" mimeType:@"video/mp4" error:nil];
            }
        }
        else
        {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.audioPath] name:@"audio" fileName:@"audio.amr" mimeType:@"audio/amr" error:nil];
        }
        
        if (self.image) {
            NSLog(@"self.image:%@",self.image);
            NSData * data = UIImageJPEGRepresentation(self.image, 0.8);
            [formData appendPartWithFileData:data name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
        if (self.description) {
            NSLog(@"self.description %@", self.description);
            NSData *data = [self.description dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:data name:@"description"];
        }
        
        if (self.nickName) {
            NSLog(@"self.nickName %@", self.nickName);
            NSData *data = [self.nickName dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:data name:@"screenName"];
        }
    }];
    
    [request setTimeoutInterval:999999];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(self.delegate && self.completeSelector)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.delegate performSelector:self.completeSelector withObject:responseObject];
#pragma clang diagnostic pop

        }
        
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error : %@",error);
        if(self.delegate && self.errorSelector){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.delegate performSelector:self.errorSelector withObject:error];
#pragma clang diagnostic pop

        }
	}];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if([self.delegate respondsToSelector:self.progressSelector])
        {
            float percent = (float)totalBytesWritten/totalBytesExpectedToWrite;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.delegate performSelector:self.progressSelector withObject:[NSNumber numberWithFloat:percent]];
#pragma clang diagnostic pop

        }
    }];
    
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
//         [operation pause];
        if(self.delegate && self.errorSelector){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.delegate performSelector:self.errorSelector withObject:nil];
#pragma clang diagnostic pop
            
        }

    }];
    
    [[LBUploadSender currentClient] enqueueHTTPRequestOperation:operation];
}

+ (void)cancelCurrentUploadRequest
{
    for (NSOperation *operation in [[[LBUploadSender currentClient] operationQueue] operations])
    {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]])
            continue;
        [operation cancel];
    }
}
@end
