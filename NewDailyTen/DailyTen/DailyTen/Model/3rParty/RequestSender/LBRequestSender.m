//
//  RequestSender.m
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBRequestSender.h"
#import "SBJSON.h"
#import "AFHTTPRequestOperation.h"
#import "Global.h"
#import "AccountHelper.h"
#import "AccountDTO.h"

static const float TIME_OUT_INTERVAL = 30.0f;

@implementation LBRequestSender

@synthesize requestUrl;
@synthesize dictParam;
@synthesize delegate;
@synthesize completeSelector;
@synthesize errorSelector;
@synthesize usePost;
@synthesize cachePolicy;
@synthesize videoPath;
@synthesize image;
@synthesize progressSelector;
@synthesize theSelectorArgument;

+ (id)requestSenderWithURL:(NSString *)theUrl
                   usePost:(BOOL)isPost
                     param:(NSDictionary *)dictParam
               cachePolicy:(NSURLRequestCachePolicy)cholicy
                  delegate:(id)theDelegate
          completeSelector:(SEL)theCompleteSelector
             errorSelector:(SEL)theErrorSelector
          selectorArgument:(id)theSelectorArgument
{
    LBRequestSender *requestSender = [[LBRequestSender alloc] init];
    requestSender.requestUrl = theUrl;
    requestSender.usePost = isPost;
    requestSender.dictParam = dictParam;
    requestSender.delegate = theDelegate;
    requestSender.completeSelector = theCompleteSelector;
    requestSender.errorSelector = theErrorSelector;
    requestSender.cachePolicy = cholicy;
    requestSender.theSelectorArgument = theCompleteSelector;
    return requestSender;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.usePost = NO;
        self.dictParam = nil;
        self.delegate = nil;
        self.completeSelector = nil;
        self.errorSelector = nil;
        self.cachePolicy = 0;
    }
    
    return self;
}

- (void)send
{
    
    NSMutableString *mutableString = [NSMutableString string];
    for (int i = 0; i < ((NSDictionary *)[dictParam objectForKey:@"params"]).allKeys.count; i++) {
        requestUrl = [requestUrl stringByAppendingString:[dictParam objectForKey:@"method"] ];
        NSString *key = [((NSDictionary *)[dictParam objectForKey:@"params"]).allKeys objectAtIndex:i];
        NSString *value = [((NSDictionary *)[dictParam objectForKey:@"params"]).allValues objectAtIndex:i];
        
        
        if (value) {
            if ([value isKindOfClass:[NSString class]]) {
                value = [self encodeToPercentEscapeString:value];
            }
        }
        
        [mutableString appendFormat:@"%@%@=%@", [mutableString isEqualToString:@""]?@"":@"&",key, value];
    }
    
    if(!usePost){
        requestUrl = [requestUrl stringByAppendingFormat:@"?%@",mutableString];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]
                                                           cachePolicy:self.cachePolicy
                                                       timeoutInterval:TIME_OUT_INTERVAL];
    
    
    if (!usePost) {
        [request setHTTPMethod:@"GET"];
    }else{
        [mutableString appendFormat:@"{\"method\":\"%@\"}", [dictParam objectForKey:@"method"]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[mutableString dataUsingEncoding:NSUTF8StringEncoding]];
    }
        
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *cookies = nil;
    if(![userDefaults objectForKey:@"HTTPCookieStorage"])
    {
        NSHTTPCookieStorage *cookiestorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        cookies = [cookiestorage cookies];
        [userDefaults setObject:cookies forKey:@"HTTPCookieStorage"];
        [userDefaults synchronize];
    }
    else
    {
        cookies = [userDefaults objectForKey:@"HTTPCookieStorage"];
    }
    
    if(cookies.count)
    {
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(self.delegate && self.completeSelector)
        {
            if([self.delegate respondsToSelector:self.completeSelector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.delegate performSelector:self.completeSelector withObject:responseObject];
#pragma clang diagnostic pop
            }
        }
        
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSURLCache *urlCache = [NSURLCache sharedURLCache];
        
        NSCachedURLResponse *response =
        [urlCache cachedResponseForRequest:request];
        if(request.cachePolicy ==  NSURLRequestReturnCacheDataDontLoad)
        {
            return;
        }
        
        //判断是否有缓存
        if (response != nil && self.delegate && self.completeSelector)
        {
            if([self.delegate respondsToSelector:self.completeSelector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.delegate performSelector:self.completeSelector withObject:response.data];
#pragma clang diagnostic pop
                if([[LBFileClient sharedInstance] getNetworkingType] != 0)
                {
                    [urlCache removeCachedResponseForRequest:request];
                }
            }
        }
        else
        {
            if(self.delegate && self.errorSelector)
            {
                if([self.delegate respondsToSelector:self.errorSelector])
                {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self.delegate performSelector:self.errorSelector withObject:error];
#pragma clang diagnostic pop
                    
                }
            }
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
    
	[operation start];
}

- (NSString *)encodeToPercentEscapeString: (NSString *)input
{
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                   (CFStringRef)input,
                                                                                                   NULL,
                                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                   kCFStringEncodingUTF8));
    return outputStr;  
    
}

- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method path:(NSString *)path
{
}
@end
