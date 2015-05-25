//
//  LBCenterCell.m
//  DailyTen
//
//  Created by King on 13-9-9.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBCenterCell.h"
#import "LBAudioView.h"

@implementation LBCenterCell
@synthesize audioView = _audioView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!self.audioView) {
            self.audioView = [[LBAudioView alloc] initWithFrame:CGRectMake(0, 3, 320, 0)];
            [self.contentView addSubview:self.audioView];
        }
        self.userInteractionEnabled = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)playVideo:(id)rowCell
{
    if(self.audioView)
    {
        //[_centerView playVideo:((LBCenterCell*)rowCell).clipView];
    }
}

- (void)setObject:(id)item
{
    [self.audioView setObject:item];
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [LBAudioView rowHeightForObject:item];
}

@end
