//
//  LBLeftViewController.m
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBLeftViewController.h"
#import "LBLeftCell.h"

@interface LBLeftViewController ()

@end

@implementation LBLeftViewController
@synthesize model = _model;
@synthesize tableView = _tableView;
@synthesize activityIndicator = _activityIndicator;
@synthesize errorView = _errorView;
@synthesize errorImageView = _errorImageView;
@synthesize enableFooter;
@synthesize enableHeader;

- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSDate *  senddate=[NSDate date];
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d年%2d月%2d日",year,month,day];
    NSString *movieModel = [nsDateString stringByAppendingFormat:@"-movie"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:movieModel];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self creatUI];
    [self createErrorView];
}

- (void)creatUI
{
    enableHeader = YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.origin.x, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [_tableView setBackgroundColor:[UIColor colorWithRed:241./255. green:241./255. blue:241./255. alpha:1.0]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -60, self.view.width, 60)];
    view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    [self.view addSubview:view];
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, self.view.width, 60)];
    _refreshHeaderView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    _refreshHeaderView.delegate = self;
    [_refreshHeaderView refreshLastUpdatedDate];
    [self.tableView addSubview:_refreshHeaderView];
    [self.view addSubview:self.tableView];
    
    _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 48)];
    _refreshFooterView.delegate = self;
    _headerLoading = NO;
    _footerLoading = NO;
    [_refreshFooterView refreshLastUpdatedDate];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setHidesWhenStopped:YES];
    [_activityIndicator setCenter:self.view.center];
    //[_activityIndicator setTop:_activityIndicator.top - 50];
    //[self activityIndicatorAni:YES];
    [self.view addSubview:_activityIndicator];
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
    [_errorLabel setTextAlignment:NSTextAlignmentCenter];
    [_errorLabel setBackgroundColor:[UIColor clearColor]];
    
    [_errorView addSubview:_errorImageView];
    [_errorView addSubview:_errorLabel];
    [_errorView setCenterX:self.view.centerX];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (Class)cellClass {
    return [LBLeftCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_GET_LEFT_LIST;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    if(self.model== nil)
        return 0;
    if([self.model isKindOfClass:[NSDictionary class]])
        return 1;
    
    return [(NSArray*)self.model count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    id item = nil;
    if(self.model != nil && [self.model isKindOfClass:[NSArray class]])
        item = [self.model objectAtIndex:indexPath.row];
    else if(self.model != nil && [self.model isKindOfClass:[NSDictionary class]])
        item = self.model;
    
    Class cls = [self cellClass];
    if(!cls)
    {
        return 44;
    }
    
    if ([cls respondsToSelector:@selector(rowHeightForObject:)]) {
        NSLog(@"%f", [cls rowHeightForObject:item]);
        return [cls rowHeightForObject:item];
    }
    return tableView.rowHeight; // failover
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class cls = [self cellClass];
    if(!cls)
    {
       cls = [UITableViewCell class];
    }
    
    static NSString *identifier = @"Cell";
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
       cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ([cell respondsToSelector:@selector(setObject:)]) {
        if([(NSArray*)self.model count] > indexPath.row)
        {
            id item = nil;
            if(self.model != nil && [self.model isKindOfClass:[NSArray class]])
                item = [self.model objectAtIndex:indexPath.row];
            else if(self.model != nil && [self.model isKindOfClass:[NSDictionary class]])
                item = self.model;
            
            [cell setObject:item];
        }
    }
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - RefreshTable view delegate
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
        
        if([LBLeftCell class] ==  class|| [LBLeftCell class] == [class superclass])
        {
            [Global clearPlayStatus];
            //[self changeCellPlay:[NSNumber numberWithInt:0]];
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

#pragma mark UIScrollViewDelegate Methods

#pragma mark UIScrollViewDelegate Methods
//static float _lastPosition = 0;
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    Class class = [self cellClass];
//    if(!class)
//    {
//        return;
//    }
//    
//    if([LBLeftCell class] != class&& [LBLeftCell class] != [class superclass])
//        return;
//    
//    int currentPostion = scrollView.contentOffset.y;
//    if (currentPostion - _lastPosition > 5) {
//        _lastPosition = currentPostion;
//    }
//    else if (_lastPosition - currentPostion > 5)
//    {
//        _lastPosition = currentPostion;
//    }
//    
//}


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
    
    if(!scrollView.isDecelerating && ([LBLeftCell class] == class|| [LBLeftCell class] == [class superclass]))
    {
        //[self playVideoFowScroller:scrollView];
    }
}

@end
