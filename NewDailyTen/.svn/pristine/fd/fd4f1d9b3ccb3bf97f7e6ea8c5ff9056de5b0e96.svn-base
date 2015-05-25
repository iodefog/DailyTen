//
//  LBRootViewController.h
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "LBModelApiViewController.h"
@class AudioPlayer;

@interface LBMusicViewController : LBModelApiViewController<UITableViewDelegate, UITableViewDataSource,EGORefreshTableHeaderDelegate, EGORefreshTableFooterViewDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _headerLoading;
    BOOL _footerLoading;
    
    AudioPlayer *_audioPlayer;
}
@property (nonatomic, retain) id model;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIView *errorView;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UIImageView *errorImageView;
@property (nonatomic, assign) BOOL enableHeader;
@property (nonatomic, assign) BOOL enableFooter;

- (void)createUI;

@end
