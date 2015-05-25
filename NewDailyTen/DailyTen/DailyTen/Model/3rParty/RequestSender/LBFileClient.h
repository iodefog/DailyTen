//
//  FileClient.h
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBRequestSender.h"

@interface LBFileClient : NSObject<UIAlertViewDelegate>
{
    int nNetworkingType;
    UIAlertView *alert;
}

@property(nonatomic,assign)BOOL more;
+ (LBFileClient *)sharedInstance;

#pragma mark - Login

- (int)getNetworkingType;

#pragma mark -  登录
- (void)loginByToken:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
- (void)logout:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

- (void)getVideoList:(NSString*)str cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
- (void)getMusicList:(NSString*)str cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
- (void)getAppsList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

@end


