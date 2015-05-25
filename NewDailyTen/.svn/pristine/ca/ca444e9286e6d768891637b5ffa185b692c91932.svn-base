//
//  AccountDTO.h
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTOBase.h"

@interface AccountDTO : DTOBase {
    NSString *name;             // /*姓名*/
    NSString *profileImageUrl;  //  缩略图头像
    NSString *profileImageOriginalUrl;//原图
    NSString *profileImageBiggerUrl; // 比缩略图稍大
    NSString *provider;         // 登录方式
    NSString *screenName;       // 名字
    NSString *token;            // 
    NSString *ID;               //
    NSString *createdAt;        // 创建时间
    NSString *description;      // 签名
    BOOL blocking;              // 拉黑
    BOOL following;             // 关注
    NSInteger followersCount;   // 粉丝数
    NSInteger friendsCount;     // 关注数
    NSInteger favoritesCount;   // 喜欢数
    NSInteger statusesCount;    // 帖子数
    NSInteger beFavoriteCount;  // 收藏总数
    NSInteger viewCount;        // 播放总数
    BOOL weiboVerified;         // 是否加V
    NSInteger digestCount;      // 视频精品
    NSInteger Level;
    
    NSString *notifyOnReplyPost;    // 被评论
    NSString *notifyOnFollow;       // 被关注
    NSString *notifyOnFavorite;     // 被喜欢
    NSString *notifySound;          // 声音
    NSString *notifyVibrator;       // 震动
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, copy) NSString *profileImageUrl;
@property (nonatomic, copy) NSString *profileImageOriginalUrl;
@property (nonatomic, copy) NSString *profileImageBiggerUrl;
@property (nonatomic, readonly) NSString *provider;
@property (nonatomic, readonly) NSString *screenName;
@property (nonatomic, readonly) NSString *token;
@property (nonatomic, readonly) NSString *ID;
@property (nonatomic, readonly) NSString *createdAt;
@property (nonatomic, copy) NSString *description;
@property (nonatomic) BOOL following;
@property (nonatomic) BOOL blocking;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger friendsCount;
@property (nonatomic, assign) NSInteger favoritesCount;
@property (nonatomic, assign) NSInteger statusesCount;
@property (nonatomic, assign) NSInteger beFavoriteCount;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger digestCount;
@property (nonatomic, assign) NSInteger Level;
@property (nonatomic, assign) BOOL weiboVerified;
@property (nonatomic, copy) NSString *notifyOnReplyPost;
@property (nonatomic, copy) NSString *notifyOnFavorite;
@property (nonatomic, copy) NSString *notifyOnFollow;
@property (nonatomic, copy) NSString *notifySound;
@property (nonatomic, copy) NSString *notifyVibrator;

@end
