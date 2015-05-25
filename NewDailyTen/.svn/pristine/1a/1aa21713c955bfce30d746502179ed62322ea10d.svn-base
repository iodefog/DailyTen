//
//  LBRightViewController.h
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBModelApiViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface LBApplicationsViewController : LBModelApiViewController<UITableViewDelegate, UITableViewDataSource , EGORefreshTableHeaderDelegate, EGORefreshTableFooterViewDelegate>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _headerLoading;
    BOOL _footerLoading;
}
@property (nonatomic, retain) UIView *errorView;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UIImageView *errorImageView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) BOOL enableHeader;
@property (nonatomic, assign) BOOL enableFooter;
@end
