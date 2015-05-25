//
//  Global.m
//  mcare-model
//
//  Created by sam on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Global.h"
#import "Reachability.h"
#import "AFDownloadRequestOperation.h"
#import "Util.h"
#import "FileUtil.h"
//#import "VoiceRecorderBaseVC.h"

@implementation Global

UINavigationController *selected_navigation_controller()
{
    if((UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController.presentedViewController)
        return (UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController.modalViewController;
    else
        return  (UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController;
}

+ (void)clearPlayStatus
{
    id selectPlayURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectPlay"];
    if(selectPlayURL)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectPlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)getServerBaseUrl {
    //return @"http://219.142.106.230:8080";
    //return @"http://192.168.1.106:8080";
    //return @"http://219.142.106.139:8080";
    //return @"http://219.142.106.138:8080";
    //return @"http://219.142.106.138:8080";
    //return @"http://app.lebooo.com";
    return @"http://121.199.35.120:8800";
}

+ (NSString *)getImageUrl
{
#ifdef __OPTIMIZE__
    return @"http://www.baidu.com";
#else
    return @"http://file.dev.lebooo.com";
#endif
}

+ (NSString *)getShareUrl
{
    return  @"http://app.dev.lebooo.com:8080/play/";
}

+ (NSString *)getDomainName{
    return @"http://m.lebooo.com:8080";
}

+ (NSString *)getServerIP{
    //NSString *baseUrl = [Global getServerBaseUrl];
    //NSLog(@"%@",baseUrl.lastPathComponent);
    return @"http://121.199.1.164:8080";
}

+ (NSString *)getServerUrl
{
    return [NSString stringWithFormat: @"http://app.lebooo.com/api/1/"];
}
                                                                                                                                                   
+ (NSString *)getServerUrl2
{
    return [NSString stringWithFormat: @"%@/post.php", [Global getServerBaseUrl]];
}

+ (NSString *)getPublishUrl
{
    return [NSString stringWithFormat: @"%@/cmd=GEOWEIBOD.handle_upload_service/", [Global getServerBaseUrl]];
}

+ (NSString *)getPublishUrl2
{
    return [NSString stringWithFormat: @"%@/cmd=GEOWEIBOD.handle_upload_service2", [Global getServerBaseUrl]];
}

+ (NSString *)getServerCommandUrl 
{
    return [NSString stringWithFormat: @"%@/?cmd=", [Global getServerBaseUrl]];
}

+ (NSString *)getMovieUrl
{
    return [NSString stringWithFormat: @"%@/?cmd=GEOWEIBOD.topic_mime3", [Global getServerBaseUrl]];
}

+ (NSString *)getUploadUrl
{
    return [NSString stringWithFormat: @"%@/?cmd=GEOWEIBOD.handle_upload", [Global getServerBaseUrl]];
}

+ (NSString *)getUploadRegistUrl
{
    return [NSString stringWithFormat: @"%@/?cmd=GEOWEIBOD.regist", [Global getServerBaseUrl]];
}

+ (NSString *)getUploadSinaRegistUrl
{
    return [NSString stringWithFormat: @"%@/?cmd=GEOWEIBOD.handle_upload_service+sinaRegist", [Global getServerBaseUrl]];
}

+ (NSString *)getUploadImageUrl
{
    return [NSString stringWithFormat: @"%@/?cmd=GEOWEIBOD.handle_upload2", [Global getServerBaseUrl]];
}

+ (NSString *)getUploadAndReturnIdUrl:(NSString *)method
{
    return [NSString stringWithFormat: @"%@/?cmd=GEOWEIBOD.handle_upload_service+%@", [Global getServerBaseUrl], method];
}

+ (NSString *)getUploadAndPublishUrl
{
    return [NSString stringWithFormat: @"%@/?cmd=GEOWEIBOD.handle_upload_service+publishLebo", [Global getServerBaseUrl]];
}

+ (NSString *)getTopicUrl 
{
    return [NSString stringWithFormat: @"%@/?cmd=GEOWEIBOD.topic_mime2", [Global getServerBaseUrl]];
}

+ (NSString *)getPicDownloadUrl
{
    return [NSString stringWithFormat: @"%@/backgrounds", [Global getServerBaseUrl]];
}

+ (NSString *)getUpdateUrl
{
    return @"";
}

+ (NSString *)getImageSize:(NSInteger)s
{
    NSString *size = nil;
    if (s == 0) {
        size = @"100x100";
    } else if (s == 2) {
        size = @"80x80";
    } else {
#ifdef PUBLIC_IP
        size = @"480x320";
#else
        size = @"orig";
#endif
    }
    return size;
}

+ (NSString *)getClientId
{
    NSString *clientID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ClientID"];
    if (clientID == nil) {
        clientID = @"LeBo_iPhone";
    }
    return clientID;
}

NSString *access_token;

+ (NSString *)getAccessToken
{
    if (access_token == nil) {
        return @"";
    } else {
        return access_token;
    }
}

+ (void)setAccessToken:(NSString *)token
{
    access_token = [token copy];
}

+ (NSString *)getJsonRPCVerion
{
    return @"2.0";
}

+ (NSString *)getVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSMutableDictionary *)getHeader
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[Global getVersion] forKey:@"version"];
    return dict;
}

+ (CGFloat)getScreenWidth
{
    return 320;
}

+ (CGFloat)getScreenHeight
{
    return 460;
}

+ (NSInteger)getPageCount
{
    return 10;
}

NSString *sessionID;
+ (NSString *)getSessionID
{
    if (sessionID == nil) {
        return @"";
    } else {
        return sessionID;
    }
}

+ (void)setSessionID:(NSString *)sid
{
    sessionID = [sid copy];
}

NSString *userName;
+ (NSString *)getUserName
{
    if (userName != nil) {
        return userName;
    } else {
        return @"";
    }
}

+ (void)setUserName:(NSString *)name
{
    userName = [name copy];
}

NSMutableArray *cookies;

+ (NSMutableArray *)getCookies
{
    return cookies;
}

+ (void)setCookies:(NSMutableArray *)cs
{
    cookies = cs;
}

+ (NSInteger)checkNetWorkWifiOf3G{
    //    Reachability *r = [Reachability reachabilityWithHostName:GetAdInfoList];
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.lebooo.com"];
    
    [reach startNotifier];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"没有网络");
            return 0;
            break;
        case ReachableViaWWAN:
            NSLog(@"正在使用3G网络");
            return 1;
            break;
        case ReachableViaWiFi:
            NSLog(@"正在使用wifi网络");
            return 2;
            break;
    }
//
    return 0;
}

+ (BOOL)canAutoDownLoad
{
    NSNumber * number = [[NSUserDefaults standardUserDefaults] objectForKey:AutoPlay];
    if([Global checkNetWorkWifiOf3G] == 1 && [number boolValue] == NO)
    {
        return NO;
    }
    return YES;
}


+ (NSMutableDictionary *)getPostJsonHeader
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:[self getVersion] forKey:@"version"];
    //[dict setObject:[self getAppVersion] forKey:@"version"];
    return dict;
}

// 计算本地缓存的大小
+ (float) getCalculateCacheFilesSize{
    long long filesize1 = [Util folderSizeAtPath2: [FileUtil getCachePicPath]];
    long long filesize2 = [Util folderSizeAtPath2: [FileUtil getMovieCachePath]];
    long long filesize3 = [Util folderSizeAtPath2: [FileUtil getMovieTempPath]];
    long long filesize4 = [Util folderSizeAtPath2: [AFDownloadRequestOperation cacheFolder]];
//    long long filesize5 = [Util folderSizeAtPath2: [VoiceRecorderBaseVC getCacheDirectory]];
//    long long filesize6 = [Util folderSizeAtPath2: [VoiceRecorderBaseVC getAudioCacheDirectory]];
    NSLog(@"%f", (filesize1 + filesize2 + filesize3 + filesize4)/(1024*1024.0));
    return (filesize1 + filesize2 + filesize3 + filesize4 )/(1024*1024.0);
}

@end

@implementation UIColor (RGB)
+ (UIColor *)colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b {
    return [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1.];
}
@end
