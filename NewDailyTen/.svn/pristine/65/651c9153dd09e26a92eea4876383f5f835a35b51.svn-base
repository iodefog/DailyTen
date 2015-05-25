//
//  LBMusicDTO.m
//  DailyTen
//
//  Created by King on 13-9-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBMusicDTO.h"

@implementation LBMusicDTO
@synthesize musicUrl, imageUrl, descripTion, btn, name, love;

- (id)init
{
    self = [super init];
    if (self) {
        //        [self initValues];
    }
    return self;
}

- (BOOL)parse2:(NSDictionary *)result
{
    BOOL tf = YES;
    self.dtoResult = (NSMutableDictionary*)result;
    musicUrl = [self getStrValue:[result objectForKey:@"address"]];
    imageUrl = [self getStrValue:[result objectForKey:@"background"]];
    descripTion = [self getStrValue:[result objectForKey:@"describe"]];
    name = [self getStrValue:[result objectForKey:@"name"]];
    love = [self getBoolValue:[NSNumber numberWithBool:[[result objectForKey:@"love"] boolValue]]];
    return tf;
}

@end
