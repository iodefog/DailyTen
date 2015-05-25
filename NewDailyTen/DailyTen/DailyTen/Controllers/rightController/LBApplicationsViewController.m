//
//  LBRightViewController.m
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBApplicationsViewController.h"
#import "LBApplicationsCell.h"
@interface LBApplicationsViewController ()

@end

@implementation LBApplicationsViewController
@synthesize model = _model;
@synthesize errorView = _errorView;
@synthesize errorLabel = _errorLabel;
@synthesize errorImageView = _errorImageView;
@synthesize tableView = _tableView;
@synthesize activityIndicator = _activityIndicator;
@synthesize enableFooter;
@synthesize enableHeader;
- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.model) {
        self.model = nil;
    }
    [super viewWillAppear:YES];
    [self reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatUI];
    [self createErrorView];
}

- (API_GET_TYPE)modelApi
{
    return API_GET_RIGHT_LIST;
}

- (void)creatUI
{
    enableHeader = YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.origin.x, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView setBackgroundColor:[UIColor colorWithRed:241./255. green:241./255. blue:241./255. alpha:1.0]];
    [self.view addSubview:self.tableView];
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, self.view.width, 60)];
    _refreshHeaderView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    _refreshHeaderView.delegate = self;
    [_refreshHeaderView refreshLastUpdatedDate];
    [self.tableView addSubview:_refreshHeaderView];
    
    _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 48)];
    _refreshFooterView.delegate = self;
    _headerLoading = NO;
    _footerLoading = NO;
    [_refreshFooterView refreshLastUpdatedDate];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setHidesWhenStopped:YES];
    [_activityIndicator setCenter:self.tableView.center];
    [self.tableView addSubview:_activityIndicator];
}

- (void)createErrorView
{
    self.errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 70)];
    [_errorView setBackgroundColor:[UIColor clearColor]];
    self.errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_movie"]];
    [_errorImageView setBackgroundColor:[UIColor clearColor]];
    [_errorImageView setFrame:CGRectMake(40, 0, 70, 70)];
    
    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 12)];
    [_errorLabel setTop:_errorImageView.bottom +5];
    [_errorLabel setFont:[UIFont systemFontOfSize:12.]];
    [_errorLabel setTextColor:[UIColor colorWithRed:155./255. green:155./255. blue:155./255. alpha:1.0]];
    [_errorLabel setTextAlignment:UITextAlignmentCenter];
    [_errorLabel setBackgroundColor:[UIColor clearColor]];
    
    [_errorView addSubview:_errorImageView];
    [_errorView addSubview:_errorLabel];
    [_errorView setCenterX:self.tableView.centerX];
}

- (void)didFinishLoad:(id)array {
    
    [_errorView removeFromSuperview];
    
    if(_activityIndicator)
    {
        //[self activityIndicatorAni:NO];
    }
    
    if(_footerLoading)
    {
        //[self finishLoadFooterTableViewDataSource];
    }
    
    if(_headerLoading)
    {
        self.model = nil;
        [self finishLoadHeaderTableViewDataSource];
    }
    
    if([(NSArray*)array count] == 0)
    {
        if(self.model == nil)
        {
            //[self addSubErrorView];
            //[[self getTableView] reloadData];
        }
        self.enableFooter = NO;
        
        return;
    }
    
    if([(NSArray*)array count] < 10)
    {
        self.enableFooter = NO;
    }
    else
    {
        self.enableFooter = YES;
    }
    
    [super didFinishLoad:array];
    [self.tableView reloadData];
}

- (void)finishLoadHeaderTableViewDataSource
{
    //    [self checkTimeout: _refreshHeaderView];
    [self performSelector:@selector(checkTimeout:) withObject:_refreshHeaderView afterDelay:0.01];
}

- (void)checkTimeout:(id)view
{
    if ([view isKindOfClass:[EGORefreshTableHeaderView class]] == YES) {
        _headerLoading = NO;
        Class class = [self cellClass];
        if(!class)
        {
            return;
        }
        
        EGORefreshTableHeaderView *header = (EGORefreshTableHeaderView *)view;
        if ([header getState] != EGOOPullRefreshNormal) {
            [header egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
    } else if ([view isKindOfClass:[EGORefreshTableFooterView class]] == YES) {
        _footerLoading = NO;
        EGORefreshTableFooterView *footer = (EGORefreshTableFooterView *)view;
        if ([footer getState] != EGOOPullRefreshNormal) {
            [footer egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadHeaderTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _headerLoading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date];
}

- (void)reloadHeaderTableViewDataSource
{
    if([_activityIndicator isAnimating])
    {
        [self finishLoadHeaderTableViewDataSource];
        return;
    }
    _headerLoading = YES;
    if ([self respondsToSelector:@selector(loadMoreData:)] == YES) {
        [self performSelector:@selector(loadMoreData:) withObject:[NSNumber numberWithBool:NO]];
    }
    //[self finishLoadHeaderTableViewDataSource];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Class)cellClass {
    return [LBApplicationsCell class];
}


#pragma mark - Table view data source

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 140;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.model count] %2 == 0) {
        return [self.model count]/2;
    }
    return [self.model count]/2 + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class cls = [self cellClass];
    if (!cls) {
        cls = [UITableViewCell class];
    }
    static NSString *CellIdentifier = @"Cell";
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSRange range;
    
    if ((indexPath.row+1)*2 <= [self.model count]) {
        NSLog(@"%d", indexPath.row);
        range = NSMakeRange(indexPath.row*2, 2);
    }else{
        range = NSMakeRange(indexPath.row*2, 1);
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];

    [(LBApplicationsCell *)cell setObject:[self.model objectsAtIndexes:indexSet]];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //[LBMovieView pauseAll];
    [Global clearPlayStatus];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView setDelaysContentTouches:YES];
    //[Global clearPlayStatus];
    if (scrollView.contentOffset.y < 0) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    } else if (scrollView.contentOffset.y > 10) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGSize size = scrollView.frame.size;
    CGFloat offsety = scrollView.contentOffset.y;
    //NSLog(@"scrollViewDidEndDragging %f %f",scrollView.contentSize.height, offsety);
    
    CGFloat offset = scrollView.contentSize.height - size.height;
    if (offset < 0) {
        offset = 0;
    }
    if (enableHeader == YES && offsety < -50) {
        // header刷新
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    } else if (enableFooter == YES && offsety > offset+10) {
        // footer刷新
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    Class class = [self cellClass];
    if(!class)
    {
        return;
    }
    
}

@end
