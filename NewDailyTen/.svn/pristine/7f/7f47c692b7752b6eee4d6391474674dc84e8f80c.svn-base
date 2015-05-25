//
//  LBRootViewController.h
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKSegmentedControl.h"

@interface LBRootViewController : UIViewController<CustomSegmentedDeleate, AKSegmentedControlDelegate>{
    int                      nSelectIndex;
    CustomSegmented          *segmented;
    AKSegmentedControl       *mSegmentedControl;
    NSInteger _segmentIndex;
    NSMutableArray *musicVCArray;
}

@property (nonatomic, strong)  UIImageView *toolBar;
@property (nonatomic, strong)  NSArray *titleArray;
@property (nonatomic, strong)  UITableViewController *currentViewController;
@property (nonatomic, strong)  NSMutableArray *subVCsArray;
@property (nonatomic, strong)  NSMutableArray *musicVCArray;
@property (nonatomic, strong)  AKSegmentedControl       *mSegmentedControl;
@property (nonatomic, strong)  LBOffLineMusicControllerViewController *offLineMusicVC;

@end
