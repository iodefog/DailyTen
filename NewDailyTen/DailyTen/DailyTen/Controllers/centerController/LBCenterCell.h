//
//  LBCenterCell.h
//  DailyTen
//
//  Created by King on 13-9-9.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBAudioView.h"

@interface LBCenterCell : UITableViewCell

@property (nonatomic, retain) LBAudioView *audioView;
- (void)setObject:(id)item;
@end
