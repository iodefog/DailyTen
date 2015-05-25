//
//  LBDownLoadMusic.m
//  DailyTen
//
//  Created by King on 13-9-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBDownLoadMusic.h"

@implementation LBDownLoadMusic
@synthesize delegate = _delegate;

static LBDownLoadMusic *download = nil;

+ (id)shareInstance
{
    if (!download) {
        download = [[LBDownLoadMusic alloc] init];
    }
    return download;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)download:(NSString *)url name:(NSString *)name
{
    BOOL down;
    if (url == nil) {
        return NO;
    }
    
    NSString *amrFilePath = [[self getFilePath:[url md5Value]] stringByAppendingPathExtension:@"mp3"];
    BOOL flag = [[NSFileManager defaultManager] fileExistsAtPath:[[NSURL URLWithString:amrFilePath] path]];
    if (url && flag) {
        down = NO;
        
    }
    else
    {
        down = YES;
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [responseObject writeToFile:amrFilePath atomically:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(downloadMusicSuccess:)]) {
                [self.delegate performSelector:@selector(downloadMusicSuccess:) withObject:responseObject];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
//<<<<<<< .mine
////            [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"error:%@", error]];
//            
//            NSLog(@"%@ 下载失败", name);
//=======
//            [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"%@\n下载失败", name]];
//>>>>>>> .r7091
        }];
        //[requestOperation start];
        
        [[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:url]] enqueueHTTPRequestOperation:requestOperation];
    }
    
    return down;
}

- (NSString *)getFilePath:(NSString *)fileName{
    NSString *fileDirectory = [self getAudioCacheDirectory];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",fileDirectory,fileName];
    return filePath;
}

- (NSString*)getAudioCacheDirectory
{
    //    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"MusicCache"];
    BOOL isDir = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        
        if (!isDir) {
            if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]){
                NSLog(@"文件夹创建失败");
            }
        }
    }
    return path;
}

@end
