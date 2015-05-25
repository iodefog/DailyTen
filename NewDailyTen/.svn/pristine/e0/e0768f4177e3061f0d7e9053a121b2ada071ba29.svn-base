//
//  RenRenHelper.h
//  RenRenDemo
//
//  Created by lebo on 13-7-16.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

// renren


#import <Foundation/Foundation.h>
#import <RennSDK/RennSDK.h>
@protocol RenRenHelperDelegate <NSObject>
@optional
- (void)renrenHelper:(id)service requestDidReturnResponse:(id)response;
- (void)renrenHelper:(id)service requestFailWithError:(NSError *)error;

- (void)renRenLoginSuccess;
- (void)renRenLoginFail;
- (void)renRenLoginCancelded;
- (void)rennLoginAccessTokenInvalidOrExpired:(NSError *)error;
- (void)renrenLogoutSuccess;
- (void)renrenGetUserNikeNameResult:(id)result;

@end

@interface RenRenHelper : NSObject <RennLoginDelegate ,RennServiveDelegate ,RennHttpRequestDelegate ,RenRenHelperDelegate>

@property (nonatomic, assign) id RenRenHelperDelegate;

// 登录
+ (void)renrenLoginTarget:(id)target;

// 注销
+ (void)renrenLogoutTarget:(id)target;

// token
+ (NSString *)renren_accessToken;

// uid
+ (NSString *)renren_uID;

// 分享
+ (void)shareContent:(NSString *)content movieUrl:(NSString *)movieUrl target:(id)target;

//新鲜事
+ (void)shareFeedMessage:(NSString *)message target:(id)target;

// 更新状态
+ (void)updateRenRenState:(NSString *)state target:(id)target;

//  token是否有效
+ (BOOL)isAuthorizeValid;

// 过期
+ (BOOL)isAuthorizeExpired;

// 获取用户信息
+ (void)getUserBaseMessageTarget:(id)target;

// 获取用户姓名
+ (NSString *)getRenrenUserNickNameTarget:(id)target;

@end
