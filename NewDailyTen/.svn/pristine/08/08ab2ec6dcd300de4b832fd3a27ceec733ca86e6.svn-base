
//
//  FileClient.m
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBFileClient.h"
#import "LBUploadSender.h"
#import "Reachability.h"

@implementation LBFileClient 
@synthesize more;

static LBFileClient* _sharedInstance = nil;

+ (LBFileClient *)sharedInstance
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
            _sharedInstance = [[LBFileClient alloc] init];
    }
    return _sharedInstance;
}

#pragma mark - Login

- (id)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        [reach startNotifier];
    }
    
    return self;
}

- (int)getNetworkingType
{
    return nNetworkingType;
}

- (void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:{
//            if (nNetworkingType != 0) {
//                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"没有网络"];
//            }
            nNetworkingType = 0;
            NSLog(@"没有网络");
            break;
        }
        case ReachableViaWWAN:{
//             if (nNetworkingType != 1) {
//                 if (!alert) {
//                     alert= [[UIAlertView alloc] initWithTitle:@"提醒" message:@"正在使用3G网络，可能会产生流量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
//                 }
//                [alert show];
//             }
            nNetworkingType = 2;
            NSLog(@"正在使用3G网络");
            break;
        }
        case ReachableViaWiFi:{
//            if (nNetworkingType != 2) {
//                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"正在使用wifi网络"];
//            }
            nNetworkingType = 2;
            NSLog(@"正在使用wifi网络");
            break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        nNetworkingType = 1;
    }
}

#pragma mark - 登录
- (void)loginByToken:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"oauthLogin.json" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"provider"];
        [params setObject:[array objectAtIndex:1] forKey:@"token"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:YES
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

#pragma mark - 登出
- (void)logout:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"logout.json" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //user可以是空
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:YES
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

#pragma mark - 首页
- (void)getVideoList:(NSString*)str cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"everyday10/list.json" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:str forKey:@"screenName"];
        [dict setObject:params forKey:@"params"];
    }
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl]/*[Global getServerUrl2]*/
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:@""];
    [requestSender send];
}

- (void)getMusicList:(NSString*)str cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getMusicList" forKey:@"method"];

    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]/*[Global getServerUrl2]*/
                                                                   usePost:YES
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:@""];
    [requestSender send];
}

- (void)getAppsList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getAppList" forKey:@"method"];
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]/*[Global getServerUrl2]*/
                                                                   usePost:YES
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:@""];
    [requestSender send];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
