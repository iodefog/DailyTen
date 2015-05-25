//
//  RenRenHelper.m
//  RenRenDemo
//
//  Created by lebo on 13-7-16.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "RenRenHelper.h"
 
@implementation RenRenHelper
static RenRenHelper *helper = nil;


+ (id)sharedInstance{
    if (!helper){
        helper = [[RenRenHelper alloc] init];
        [RennClient initWithAppId:renAPPID apiKey:renAPIKEY secretKey:renSecretKey];
        //不设置则获取默认权限
        [RennClient setScope:@"read_user_blog read_user_photo read_user_status read_user_album read_user_comment read_user_share publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed operate_like"];

    }
    return helper;
}

// 是否有效
+ (BOOL)isAuthorizeValid{
    BOOL isValid = YES;
    helper = [RenRenHelper sharedInstance];
    if ([RennClient isAuthorizeValid]) {
        isValid = YES;
    }else{
        isValid = NO;
    }
          return isValid;
}

// token
+ (NSString *)renren_accessToken{
    return [RennClient accessToken].accessToken;
}

// uid
+ (NSString *)renren_uID{
    return [RennClient uid];
}

// 过期
+ (BOOL)isAuthorizeExpired{
    BOOL expired = YES;
    helper = [RenRenHelper sharedInstance];
    if ([RennClient isAuthorizeExpired] && [RennClient isLogin]) {
        expired = YES;
    }else{
        expired = NO;
    }
    return expired;
}

// 登录
+ (void)renrenLoginTarget:(id)target{
    helper = [RenRenHelper sharedInstance];
    helper.RenRenHelperDelegate = target;
    [helper renrenLogin];
}

- (void)renrenLogin{
    [RennClient loginWithDelegate:self];
}

// 注销
+ (void)renrenLogoutTarget:(id)target{
    helper = [RenRenHelper sharedInstance];
    helper.RenRenHelperDelegate = target;
    [helper renrenLogOut];
}

// 更新状态
+ (void)updateRenRenState:(NSString *)state target:(id)target{
    helper = [RenRenHelper sharedInstance];
    helper.RenRenHelperDelegate = target;
    PutStatusParam *param = [[PutStatusParam alloc] init];
    param.content = state;
    [RennClient sendAsynRequest:param delegate:helper];
}

// 获取信息
+ (void)getUserBaseMessageTarget:(id)target{
    helper = [RenRenHelper sharedInstance];
    helper.RenRenHelperDelegate = target;
    GetUserParam *param = [[GetUserParam alloc] init];
    param.userId = [RennClient uid];
    [RennClient sendAsynRequest:param delegate:helper];
}

+ (NSString *)getRenrenUserNickNameTarget:(id)target{
    helper = [RenRenHelper sharedInstance];
    helper.RenRenHelperDelegate = target;
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"renrenName"];
    if (!name) {
        [RenRenHelper getUserBaseMessageTarget:target];
    }
    return name;
}

// 分享
+ (void)shareContent:(NSString *)content movieUrl:(NSString *)movieUrl target:(id)target{
    helper = [RenRenHelper sharedInstance];
    helper.RenRenHelperDelegate = target;
    if ([RennClient isAuthorizeValid]) {
        PutShareUrlParam *param = [[PutShareUrlParam alloc] init];
        param.comment = content;
        param.url = movieUrl;
        [RennClient sendAsynRequest:param delegate:helper];
    }
}

+ (void)shareFeedMessage:(NSString *)message target:(id)target{
    helper = [RenRenHelper sharedInstance];
    PutFeedParam *param = [[PutFeedParam alloc] init];
    // 必选
    param.message = message;
    param.title = APPLICATIONTITLE;
    param.description = APPLICATIONDISCRIPTION;
    param.targetUrl = @"http://www.lebooo.com/";
    // 可选
    param.actionTargetUrl = @"http://www.lebooo.com/";
    param.imageUrl = @"http://121.199.1.164:8080/banner.png";
    param.subtitle = APPLICATIONTITLE;
    param.actionName = APPLICATIONTITLE;
    [RennClient sendAsynRequest:param delegate:helper];
}


- (void)renrenLogOut{
    [RennClient logoutWithDelegate:self];
}

// 登录reback
- (void)rennLoginSuccess{
    NSLog(@"登录成功");
    [RenRenHelper getUserBaseMessageTarget:self.RenRenHelperDelegate];
    if (self.RenRenHelperDelegate && [self.RenRenHelperDelegate respondsToSelector:@selector(renRenLoginSuccess)]) {
        [self.RenRenHelperDelegate performSelector:@selector(renRenLoginSuccess)];
    }
}

- (void)rennLoginDidFailWithError:(NSError *)error{
    if (self.RenRenHelperDelegate && [self.RenRenHelperDelegate respondsToSelector:@selector(renRenLoginFail)]) {
        [self.RenRenHelperDelegate performSelector:@selector(renRenLoginFail)];
    }
}

- (void)rennLoginCancelded{
    if (self.RenRenHelperDelegate && [self.RenRenHelperDelegate respondsToSelector:@selector(renRenLoginCancelded)]) {
        [self.RenRenHelperDelegate performSelector:@selector(renRenLoginCancelded)];
    }
}

- (void)rennLoginAccessTokenInvalidOrExpired:(NSError *)error{
    if (self.RenRenHelperDelegate && [self.RenRenHelperDelegate respondsToSelector:@selector(rennLoginAccessTokenInvalidOrExpired:)]) {
        [self.RenRenHelperDelegate performSelector:@selector(rennLoginAccessTokenInvalidOrExpired:) withObject:error];
    }
}

// 注销reback
- (void)rennLogoutSuccess{
    NSLog(@"人人注销成功");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"renrenName"];
    if (self.RenRenHelperDelegate && [self.RenRenHelperDelegate respondsToSelector:@selector(renrenLogoutSuccess)]) {
        [self.RenRenHelperDelegate performSelector:@selector(renrenLogoutSuccess)];
    }
}

// responseback
- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    NSLog(@"requestSuccessWithResponse:%@", [response description]);
    //    NSLog(@"requestSuccessWithResponse:%@", [[SBJSON new]  stringWithObject:response error:nil]);
    NSLog(@"请求成功:%@", service.type);
    
    if ([service.type isEqualToString:@"GetUser"]) {
        NSDictionary *result = (NSDictionary *)response;
        NSString *name = [result objectForKey:@"name"];
        if (name) {
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"renrenName"];
        }
        if (self.RenRenHelperDelegate && [self.RenRenHelperDelegate respondsToSelector:@selector(renrenGetUserNikeNameResult:)]) {
            [self.RenRenHelperDelegate performSelector:@selector(renrenGetUserNikeNameResult:) withObject:response];
        }
    }else{
        if (self.RenRenHelperDelegate && [self.RenRenHelperDelegate respondsToSelector:@selector(renrenHelper:requestDidReturnResponse:)]) {
            [self.RenRenHelperDelegate performSelector:@selector(renrenHelper:requestDidReturnResponse:) withObject:service withObject:response];
        }
    }
}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    //NSLog(@"requestFailWithError:%@", [error description]);
    //NSString *domain = [error domain];
    //NSString *code = [[error userInfo] objectForKey:@"code"];
    //NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@", domain, code);
    //NSLog(@"请求失败: %@", domain);
        if (self.RenRenHelperDelegate && [self.RenRenHelperDelegate respondsToSelector:@selector(renrenHelper:requestFailWithError:)]) {
        [self.RenRenHelperDelegate performSelector:@selector(renrenHelper:requestFailWithError:) withObject:service withObject:error];
    }
}

- (void)request:(RennHttpRequest *)request failWithError:(NSError *)error{

}

- (void)request:(RennHttpRequest *)request responseWithData:(NSData *)data{

}

@end
