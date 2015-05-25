//
//  LeboDTO.h
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTOBase.h"

@interface LeboDTO : DTOBase {
	NSString *ID;               // 当前帖子ID
    NSString *originStatusID;   // 原帖ID
	NSString *topicCreatedAt;   // 创建时间
    NSString *text;             // 描述
    NSString *source;
    NSInteger favorited;             // 是否喜欢
    NSInteger reposted;              // 是否转载
    NSInteger topicFavoritesCount;   // 喜欢数
	NSInteger repostsCount;     // 转载数
    NSInteger commentsCount;    // 评论数
    NSInteger topicViewCount;   // 播放数
    
    NSArray *comments;          // 评论
    
    NSArray *files;             // 文件：图片、视频
    //
    NSString *photoUrl;
    NSString *movieUrl;
    //
    
    NSArray *userMentions;      // @XXX
    
    NSDictionary *user;
    //
    NSString *iD;               //
    NSString *screenName;       // 名字
    NSString *profileImageUrl;  // 头像
    NSString *createdAt;        // 创建时间
    NSInteger following;        // 是否关注
    NSString *description;      // 签名
    NSInteger followersCount;   // 粉丝数
    NSInteger friendsCount;     // 关注数
    NSInteger statusesCount;    // 帖子数
    NSInteger favoritesCount;   // 喜欢数
    NSInteger beFavoritedCount; // 被喜欢总数
    NSInteger viewCount;        // 播放总数
    NSInteger weiboVerified;    // 是否加V
    NSInteger digest;           // 是否精华
    NSInteger bilateral;        // 双向关注
    //
    
    NSDictionary *reprintUser;      // 转载的user
    NSDictionary *originStatus;     // 非空-->转载。。。。里面是原帖
    //
    
    //
    NSInteger isFriend;
}

@property (nonatomic, readonly) NSString *ID;
@property (nonatomic, readonly) NSString *originStatusID;
@property (nonatomic, readonly) NSString *topicCreatedAt;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSString *source;
@property (nonatomic, assign) NSInteger favorited;
@property (nonatomic, assign) NSInteger reposted;
@property (nonatomic, assign) NSInteger topicFavoritesCount;
@property (nonatomic, assign) NSInteger repostsCount;
@property (nonatomic, assign) NSInteger commentsCount;
@property (nonatomic, assign) NSInteger topicViewCount;
@property (nonatomic, readonly) NSArray *comments;
@property (nonatomic, readonly) NSArray *files;
//
@property (nonatomic, readonly) NSString *movieUrl;
@property (nonatomic, readonly) NSString *photoUrl;
//
@property (nonatomic, readonly) NSArray *userMentions;
@property (nonatomic, readonly) NSDictionary *user;
//
@property (nonatomic, readonly) NSString *iD;
@property (nonatomic, readonly) NSString *screenName;
@property (nonatomic, readonly) NSString *profileImageUrl;
@property (nonatomic, readonly) NSString *createdAt;
@property (nonatomic, readonly) NSInteger following;
@property (nonatomic, readonly) NSString *description;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger friendsCount;
@property (nonatomic, assign) NSInteger statusesCount;
@property (nonatomic, assign) NSInteger favoritesCount;
@property (nonatomic, assign) NSInteger beFavoritedCount;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger weiboVerified;
@property (nonatomic, assign) NSInteger digest;
@property (nonatomic, assign) NSInteger bilateral;
@property (nonatomic, assign) NSInteger isFriend;
//
@property (nonatomic, readonly) NSDictionary *reprintUser;
@property (nonatomic, readonly) NSDictionary *originStatus;

@end
