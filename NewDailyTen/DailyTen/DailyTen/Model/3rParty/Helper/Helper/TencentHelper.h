//
//  QzoneHelper.h
//  weiboDemo
//
//  Created by lebo on 13-5-28.
//  Copyright (c) 2013年 lihongli. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol TencentHelperDelegate<NSObject>
@optional
// 登录
- (void)tencentDidLoginSuccess;
- (void)tencentDidDotLogined:(NSNumber *)cancelled;
- (void)tencentDidNotNetWork;

// 退出
- (void)tencentDidLogout;

// 分享
- (void)tencentshareSuccess:(NSString *)message;
- (void)tencentshareFail:(NSString *)errormsg;

// 信息
- (void)getUserInfoSuccess:(NSDictionary *)response;
- (void)getUserInfoFail:(NSDictionary *)infoFail;
@end


typedef enum {
    tencentWeibo,
    tencentFriends,
    tencentZones,
} QQShareType;


@interface TencentHelper : NSObject<TencentSessionDelegate, TencentHelperDelegate ,TCAPIRequestDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOauth;
@property (nonatomic, strong) NSArray *permissions;
@property (nonatomic, weak) id TencentDelegate;

+ (id)shareInstance;

+ (BOOL)isSessionValid;

+ (void)login:(id)delegate;

+ (void)login:(id)delegate naVC:(UINavigationController *)naVC;

+ (void)logout:(id)delegate;

// 分享视频和文字等到空间
/*
 @description @param summary  摘要 @param type 4 为网页 5 为视频,这时必须传入playurl
 @param site 必须 分享的来源网站名称，请填写网站申请接入时注册的网站名称，对应上文接口说明的5。
 @param fromurl 必须 分享的来源网站对应的网站地址url，对应上文接口说明中5的超链接。
 请以http://开头。
 @param nswb 值为1时，表示分享不默认同步到微博，其他值或者不传此参数表示默认同步到微博。
 */
+ (void)shareToQZoneTitle:(NSString *)title url:(NSString *)url comment:(NSString *)comment summary:(NSString *)summary images:(NSString *)images type:(NSString *)type playurl:(NSString *)playurl delegate:(id)delegate;

+ (void)getUserInfo:(id)delegate;

+ (NSString *)getUserNikeName:(id)delegate;

// 腾讯微博图片微博：
+ (void)tenxunWeiboSharePicContent:(NSString *)content pic:(UIImage *)picData syncflag:(BOOL)syncflag target:(id)target;

// 腾讯微博文字微博：
+ (void)tenxunWeiboShareTextContent:(NSString *)content  syncflag:(BOOL)syncflag target:(id)target;

// 腾讯微博视频分享
//+ (void)tenxunWeiboShareVideoContent:(NSString *)content videoUrl:(NSString *)videoUrl  syncflag:(BOOL)syncflag target:(id)target;

@end
