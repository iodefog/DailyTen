//
//  SinaHelper.h
//  LeBo
//
//  Created by Qiang Zhuang on 1/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

#define LB_SINA_USERID @"userID"
#define LB_SINA_TOKEN @"token"
#define LB_SINA_EXPTIME @"expirationDate"

@protocol SinaHelperDelegate <NSObject>

@optional

// 新浪微博登陆成功
- (void)sinaDidLogin:(NSDictionary *)userInfo;

// 新浪微博登陆失败
- (void)sinaDidFailLogin:(NSError *)error;

// 新浪微博登陆取消
- (void)sinaDidLoginCancel;

// 检查新浪微博是否合法
- (void)sinaTokenInvalid:(NSError *)error;

// 用户退出成功
- (void)sinaDidLogout;

// 得到用户信息
- (void)sinaGetUserInfo:(NSDictionary *)userInfo;
- (void)sinaGetFailUserInfo:(NSError *)error;

// 上传图片和文字微博成功或失败
- (void)sinaUploadSuccess:(NSDictionary *)result;
- (void)sinaUploadFail:(NSError *)error;

// 获取用户的好友成功或失败
- (void)sinaGetFriends:(NSDictionary *)result;
- (void)getFriendFail:(NSError *)error;

// 上传文字微博成功或失败
- (void)sinaUpdateSuccess:(NSDictionary *)result;
- (void)sinaUpdateFail:(NSError *)error;

// 长连接转短链接 成功或失败
- (void)shortUrlSuccess:(NSDictionary *)result;
- (void)shortUrlFail:(NSError *)error;

@end

@interface SinaHelper : NSObject <SinaWeiboDelegate, SinaWeiboRequestDelegate>  {
    
    NSArray *_statuses;
    
    NSMutableDictionary *shareDict;    //    分享的内容
    BOOL           isShare;     // 分享
    NSString    *mMovieUrl;
    SinaWeibo *mSinaweibo;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, retain) NSDictionary *userInfo;

+ (SinaHelper *)getHelper;
- (SinaWeibo *)sinaweibo;

// 获取新浪姓名
+ (NSString *)getSinaNickNameDelegate:(id)delegate;
// 检查新浪token是否合法或有效
- (BOOL)sinaIsAuthValid;
// 过期
- (BOOL)sinaIsAuthorizeExpired;
- (void)login;
- (void)logout;
- (void)getUserInfo;
- (void)getFriendsCount:(NSInteger)count cursor:(NSInteger)cursor;
- (void)getFriends:(BOOL)isReload count:(NSInteger)count cursor:(NSInteger)cursor;
- (void)getFollowers;
// 发表图片到新浪weibo
- (void)uploadPicture:(NSData *)picData status:(NSString *)status target:(id)target movieUrl:(NSString *)movieUrl;// 发表文字到新浪weibo, 文字不超过140个汉字

- (void)uploadPicture:(NSData *)picData status:(NSString *)status;

- (void)updateStatus:(NSString *)status delegete:(id)delegate;
    
// 长连接转短链接
- (void)longUrlTOShortUrl:(NSString *)longUrl;

// 获取我关注的人的list
- (void)frinedShipsCount:(NSInteger)count cursor:(NSInteger)cursor;

// 评论一篇帖子
- (void)commitCommentToSinaFieldID:(NSString *)sinaID comment:(NSString *)comment delegate:(id)delegate;
@end
