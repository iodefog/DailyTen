//
//  AccountDTO.m
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccountDTO.h"

@implementation AccountDTO

@synthesize name;
@synthesize profileImageUrl;
@synthesize profileImageOriginalUrl;
@synthesize profileImageBiggerUrl;
@synthesize provider;
@synthesize screenName;
@synthesize token;
@synthesize ID;
@synthesize createdAt;
@synthesize description;
@synthesize blocking;
@synthesize following;
@synthesize followersCount;
@synthesize friendsCount;
@synthesize favoritesCount;
@synthesize statusesCount;
@synthesize beFavoriteCount;
@synthesize viewCount;
@synthesize weiboVerified;
@synthesize digestCount;
@synthesize Level;
@synthesize notifyOnFavorite;
@synthesize notifyOnFollow;
@synthesize notifyOnReplyPost;
@synthesize notifySound;
@synthesize notifyVibrator;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)parse:(NSDictionary *)result
{
    BOOL tf = YES;
    self.dtoResult = (NSMutableDictionary*)result;
    name = [[self getStrValue:[result objectForKey:@"screenName"]] copy];
    profileImageUrl = [[self getStrValue:[result objectForKey:@"profileImageUrl"]] copy];
    profileImageOriginalUrl = [[self getStrValue:[result objectForKey:@"profileImageOriginalUrl"]] copy];
    profileImageBiggerUrl = [[self getStrValue:[result objectForKey:@"profileImageBiggerUrl"]] copy];
    provider = [[self getStrValue:[result objectForKey:@"provider"]] copy];
    screenName = [[self getStrValue:[result objectForKey:@"screenName"]] copy];
    description = [[self getStrValue:[result objectForKey:@"description"]] copy];
    token = [[self getStrValue:[result objectForKey:@"token"]] copy];
    ID = [[self getStrValue:[result objectForKey:@"id"]] copy];
    followersCount = [self getIntValue:[result objectForKey:@"followersCount"]];
    createdAt = [self getStrValue:[NSDate getFormatTime2:[result objectForKey:@"createdAt"]]];
    blocking = [self getBoolValue:[result objectForKey:@"blocking"]];
    following = [self getBoolValue:[result objectForKey:@"following"]];
    //createdAt = [NSDate convertTimeFromNumber:[result objectForKey:@"createdAt"]];
    /*
    NSArray *array = [result objectForKey:@"attachments"];
    if (array != nil) {
        Attachments = [[NSArray alloc] initWithArray:array];
    }
     */
    followersCount = [self getIntValue: [result objectForKey: @"followersCount"]];
    friendsCount = [self getIntValue: [result objectForKey: @"friendsCount"]];
    favoritesCount = [self getIntValue: [result objectForKey: @"favoritesCount"]];
    statusesCount = [self getIntValue: [result objectForKey: @"statusesCount"]];
    beFavoriteCount = [self getIntValue: [result objectForKey: @"beFavoritedCount"]];
    viewCount = [self getIntValue: [result objectForKey:@"viewCount"]];
    weiboVerified = [self getBoolValue:[result objectForKey:@"verified"]];
    digestCount = [self getIntValue:[result objectForKey:@"digestCount"]];
    Level = [self getIntValue:[result objectForKey:@"level"]];

    notifyOnReplyPost = [self getStrValue:[result objectForKey:@"notifyOnReplyPost"]];
    notifyOnFollow = [self getStrValue:[result objectForKey:@"notifyOnFollow"]];
    notifyOnFavorite = [self getStrValue:[result objectForKey:@"notifyOnFavorite"]];
    notifySound = [self getStrValue:[result objectForKey:@"notifySound"]];
    notifyVibrator = [self getStrValue:[result objectForKey:@"notifyVibrator"]];
    return tf;
}

- (BOOL)parse2:(NSDictionary *)result
{
    BOOL tf = YES;
    return tf;
}

- (NSString *)toParam
{
    NSMutableString *param = [NSMutableString string];
    return param;
}

- (NSDictionary *)JSON
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //
    [dict setObject:name forKey:@"name"];
    [dict setObject:profileImageUrl forKey:@"profileImageUrl"];
    [dict setObject:provider forKey:@"provider"];
    [dict setObject:screenName forKey:@"screenName"];
    [dict setObject:token forKey:@"token"];
    [dict setObject:ID forKey:@"id"];
    [dict setObject:[NSDate getFormatTime2:createdAt] forKey:@"createdAt"];

    //[dict setObject:[NSDate getFormatTime:createdAt] forKey:@"createdAt"];
    [dict setObject:description forKey:@"description"];
    [dict setObject:[NSNumber numberWithBool:blocking] forKey:@"blocking"];
    [dict setObject:[NSNumber numberWithBool:following] forKey:@"following"];
    [dict setObject:[NSNumber numberWithInt:followersCount] forKey:@"followersCount"];
    [dict setObject:[NSNumber numberWithInt:friendsCount] forKey:@"friendsCount"];
    [dict setObject:[NSNumber numberWithInt:favoritesCount] forKey:@"favoritesCount"];
    [dict setObject:[NSNumber numberWithInt:statusesCount] forKey:@"statusesCount"];
    [dict setObject:[NSNumber numberWithInt:beFavoriteCount] forKey:@"beFavoritedCount"];
    [dict setObject:[NSNumber numberWithInt:viewCount] forKey:@"viewCount"];
    [dict setObject:[NSNumber numberWithBool:weiboVerified] forKey:@"verified"];
    
    return dict;
}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone {
    AccountDTO *dto = [super copyWithZone: zone];
    dto->name = name;
    dto->profileImageUrl = profileImageUrl;
    dto->provider = provider;
    dto->screenName = screenName;
    dto->token = token;
    dto->ID = ID;
    dto->createdAt = createdAt;
    dto->description = [description copy];
    dto->followersCount = followersCount;
    dto->friendsCount = friendsCount;
    dto->favoritesCount = favoritesCount;
    dto->statusesCount = statusesCount;
    dto->beFavoriteCount = beFavoriteCount;
    dto->viewCount = viewCount;
    dto->following = following;
    dto->blocking = blocking;
    dto->weiboVerified = weiboVerified;
    
    return dto;
}

@end
