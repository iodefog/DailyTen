//
//  LeboDTO.m
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LeboDTO.h"

@implementation LeboDTO

@synthesize ID;
@synthesize originStatusID;
@synthesize user;
@synthesize topicCreatedAt;
@synthesize text;
@synthesize files;
//
@synthesize movieUrl;
@synthesize photoUrl;
//
@synthesize comments;
@synthesize source;
@synthesize favorited;
@synthesize reposted;
@synthesize reprintUser;
@synthesize originStatus;
@synthesize topicFavoritesCount;
@synthesize repostsCount;
@synthesize commentsCount;
@synthesize topicViewCount;
@synthesize userMentions;

//
@synthesize iD;
@synthesize screenName;
@synthesize profileImageUrl;
@synthesize createdAt;
@synthesize following;
@synthesize description;
@synthesize followersCount;
@synthesize friendsCount;
@synthesize statusesCount;
@synthesize favoritesCount;
@synthesize beFavoritedCount;
@synthesize viewCount;
@synthesize weiboVerified;
@synthesize digest;
@synthesize bilateral;
@synthesize isFriend;
//

- (id)init
{
    self = [super init];
    if (self) {
        //        [self initValues];
    }
    return self;
}
/*
 - (void)initValues
 {
 
 LeboID = [[NSString alloc] init];
 Content = [[NSString alloc] init];
 AuthorID = [[NSString alloc] init];
 AuthorKey = [[NSString alloc] init];
 AuthorPhotoID = [[NSString alloc] init];
 PhotoID = [[NSString alloc] init];
 Age = [[NSString alloc] init];
 AuthorDisplayName = [[NSString alloc] init];
 
 }
*/
- (BOOL)parse2:(NSDictionary *)result
{
    BOOL tf = YES;
    self.dtoResult = (NSMutableDictionary*)result;
    
    ID = [[self getStrValue:[result objectForKey:@"id"]] copy];

    NSDictionary *originStatusDict = [result objectForKey:@"originStatus"];
    if (originStatusDict != nil && [originStatusDict isKindOfClass:[NSDictionary class]]) {
        originStatus = [[NSDictionary alloc] initWithDictionary:originStatusDict];
        reprintUser = [result objectForKey:@"user"];
        result = originStatus;
    } else {
        originStatus = nil;
    }
    
    originStatusID = [[self getStrValue:[result objectForKey:@"id"]] copy];
    topicCreatedAt = [self getStrValue:[NSDate getFormatTime2:[result objectForKey:@"createdAt"]]];
    text = [[self getStrValue:[result objectForKey:@"text"]] copy];
    source = [[self getStrValue:[result objectForKey:@"source"]] copy];
    favorited = [self getIntValue:[result objectForKey:@"favorited"]];
    reposted = [self getIntValue:[result objectForKey:@"reposted"]];
    topicFavoritesCount = [self getIntValue:[result objectForKey:@"favoritesCount"]];
    repostsCount = [self getIntValue:[result objectForKey:@"repostsCount"]];
    commentsCount = [self getIntValue:[result objectForKey:@"commentsCount"]];
    topicViewCount = [self getIntValue:[result objectForKey:@"viewCount"]];
    digest = [self getIntValue:[result objectForKey:@"digest"]];

    NSArray *commentsArray = [result objectForKey:@"comments"];
    if (commentsArray != nil && [commentsArray isKindOfClass:[NSArray class]]) {
        comments = [[NSArray alloc] initWithArray:commentsArray];
    } else
        comments = nil;

    /*/
    NSObject *obj = [result objectForKey:@"submitTime"];
    if ([obj isKindOfClass:[NSNumber class]] == YES) {
        // since 1970
        SubmitTime = [NSDate convertTimeFromNumber2:(NSNumber *)obj];
    } else if ([obj isKindOfClass:[NSString class]] == YES) {
        // 2012-12-21
        SubmitTime = [NSDate convertTime:(NSString *)obj];
    }
    //*/
    
    /*
    NSArray *filesArray = [result objectForKey:@"files"];
    if (filesArray != nil) {
        files = [[NSArray alloc] initWithArray:filesArray];
        
        for (int i = 0 ; i < filesArray.count; i++) {
            if ([[[files objectAtIndex:i] objectForKey:@"contentType"] isEqualToString:@"video/mp4"]) {
                NSDictionary *videoDic = [[NSDictionary alloc] initWithDictionary:[files objectAtIndex:0]];
                movieUrl = [videoDic objectForKey:@"contentUrl"];
            } else if ([[[files objectAtIndex:i] objectForKey:@"contentType"] isEqualToString:@"image/jpeg"]) {
                NSDictionary *photoDic = [[NSDictionary alloc] initWithDictionary:[files objectAtIndex:1]];
                photoUrl = [photoDic objectForKey:@"contentUrl"];
            } else {
                movieUrl = nil;
                photoUrl = nil;
            }
        }
    }
     */
    movieUrl = [self getStrValue:[[result objectForKey:@"video"] objectForKey:@"contentUrl"]];
    photoUrl = [self getStrValue:[result objectForKey:@"videoFirstFrameUrl"]];
    //
    NSArray *userArray = [result objectForKey:@"userMentions"];
    if (userArray != nil) {
        userMentions = [[NSArray alloc] initWithArray:userArray];
    } else
        userMentions = nil;
    //
    
    NSDictionary *userDict = [result objectForKey:@"user"];
    if (userDict != nil && [userDict isKindOfClass:[NSDictionary class]]) {
        user = [[NSDictionary alloc] initWithDictionary:userDict];
        
        iD = [[self getStrValue:[user objectForKey:@"id"]] copy];
        profileImageUrl = [[self getStrValue:[user objectForKey:@"profileImageUrl"]] copy];
        screenName = [[self getStrValue:[user objectForKey:@"screenName"]] copy];
        followersCount = [self getIntValue:[user objectForKey:@"followersCount"]];
        createdAt = [[self getStrValue:[NSDate getFormatTime2:[user objectForKey:@"createdAt"]]] copy];
        description = [[self getStrValue:[user objectForKey:@"description"]] copy];
        following = [self getIntValue:[user objectForKey:@"following"]];
        followersCount = [self getIntValue: [user objectForKey: @"followersCount"]];
        friendsCount = [self getIntValue: [user objectForKey: @"friendsCount"]];
        statusesCount = [self getIntValue: [user objectForKey: @"statusesCount"]];
        favoritesCount = [self getIntValue: [user objectForKey: @"favoritesCount"]];
        beFavoritedCount = [self getIntValue: [user objectForKey: @"beFavoritedCount"]];
        viewCount = [self getIntValue: [user objectForKey: @"viewCount"]];
        weiboVerified = [self getIntValue:[user objectForKey:@"weiboVerified"]];
        isFriend = [self getIntValue:[user objectForKey:@"following"]];
        bilateral = [self getIntValue:[user objectForKey:@"bilateral"]];
    }
    
    return tf;
}

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    error = [[dict objectForKey:@"error"] copy];
    NSDictionary *result = [dict objectForKey:@"result"];
    if ([error isEqualToString:@"OK"] == YES && (NSObject *)result != [NSNull null] && result != nil) {
        [self parse2:result];
    } else {
        tf = NO;
    }
    //
    return tf;
}

- (NSDictionary *)JSON
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //
    [dict setObject:[self getStrValue:ID] forKey:@"id"];
    [dict setObject:[self getStrValue:topicCreatedAt] forKey:@"createdAt"];
    [dict setObject:[self getStrValue:text] forKey:@"text"];
    [dict setObject:[self getStrValue:source] forKey:@"source"];
    [dict setObject:[NSNumber numberWithBool: favorited] forKey:@"favorited"];
    [dict setObject:[NSNumber numberWithBool: topicFavoritesCount] forKey:@"reposted"];
    [dict setObject:[NSNumber numberWithInt: topicFavoritesCount] forKey:@"favoritesCount"];
    [dict setObject:[NSNumber numberWithInt: repostsCount] forKey:@"repostsCount"];
    [dict setObject:[NSNumber numberWithInt: commentsCount] forKey:@"commentsCount"];
    [dict setObject:[NSNumber numberWithInt: topicViewCount] forKey:@"viewCount"];
    //
    if (files != nil) {
        [dict setObject:files forKey:@"files"];
    }
    //
    if (user != nil) {
        [dict setObject:user forKey:@"user"];
    }
    //
    if (originStatus != nil) {
        [dict setObject:originStatus forKey:@"originStatus"];
    }
    return dict;
}

- (NSString *)toParam
{
    NSMutableString *param = [NSMutableString string];

    return param;
}

@end
