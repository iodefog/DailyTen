//
//  LBCacheAudioCell.m
//  DailyTen
//
//  Created by King on 13-9-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBCacheAudioCell.h"

@implementation LBCacheAudioCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!self.audioView) {
            self.audioView = [[LBCacheAudioView alloc] initWithFrame:CGRectMake(0, 3, 320, 0)];
            [self.contentView addSubview:self.audioView];
        }
        self.userInteractionEnabled = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setObject:(id)item
{
    if(self.audioView)
    {
        [self.audioView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [LBCacheAudioView rowHeightForObject:item];
}

@end
