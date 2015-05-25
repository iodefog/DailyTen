//
//  LBApplicationsCell.m
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBApplicationsCell.h"
#import "LBApplicationView.h"

#define rowAppCount 2

@implementation LBApplicationsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createSubViews{
    for (int i = 0; i < rowAppCount; i ++) {
        LBApplicationView *applicationView = [[LBApplicationView alloc] initWithFrame:CGRectMake(17.5+ 145*i, 5, 140, 130)];
        applicationView.tag = 100+i;
        [self addSubview:applicationView];
    }
}

- (void)setObject:(NSArray *)itemsArray{
    if (itemsArray) {
        NSMutableArray *temArray = nil;
        if (itemsArray.count %2 != 0) {
            temArray = [NSMutableArray arrayWithArray:itemsArray];
            [temArray addObject:[NSNull null]];
        }else{
            temArray = (id)itemsArray;
        }
        for (int i = 0; i < temArray.count ; i ++) {
            NSDictionary *item = [temArray objectAtIndex:i];
            LBApplicationView *applicationView = (LBApplicationView *)[self viewWithTag:100 + i];
            [applicationView setObject:item];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
