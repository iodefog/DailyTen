//
//  LBMusicDTO.h
//  DailyTen
//
//  Created by King on 13-9-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "DTOBase.h"

@interface LBMusicDTO : DTOBase
{
    NSString *musicUrl;
    NSString *imageUrl;
    NSString *descripTion;
    id btn;
    NSString *name;
    BOOL love;
}

@property (nonatomic, retain)NSString *musicUrl;
@property (nonatomic, retain)NSString *imageUrl;
@property (nonatomic, retain)NSString *descripTion;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)id btn;
@property (nonatomic, assign)BOOL loop;
@property (nonatomic, assign)BOOL love;

@end
