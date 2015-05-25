//
//  LBOffLineMusicControllerViewController.h
//  DailyTen
//
//  Created by King on 13-9-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBOffLineMusicControllerViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *model;

@end
