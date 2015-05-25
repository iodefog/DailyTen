//
//  LBLeftCell.m
//  DailyTen
//
//  Created by King on 13-9-9.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBLeftCell.h"
#import "LBLeftView.h"

@implementation LBLeftCell
@synthesize leftView = _leftView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftView = [[LBLeftView alloc] initWithFrame:CGRectMake(0, 2, 320, 0)];
        [self.contentView addSubview:_leftView];
    }
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)playVideo:(id)rowCell
{
    if(_leftView)
    {
        //[_centerView playVideo:((LBCenterCell*)rowCell).clipView];
    }
}

- (void)setObject:(id)item
{
    if(_leftView)
    {
        [_leftView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [LBLeftView rowHeightForObject:item];
}

@end
