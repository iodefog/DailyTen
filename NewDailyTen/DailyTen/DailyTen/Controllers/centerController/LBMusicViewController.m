//
//  LBRootViewController.m
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBMusicViewController.h"
#import "LBCenterCell.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayer.h"

@interface LBMusicViewController ()

@end

@implementation LBMusicViewController
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
    [super viewWillAppear:animated];
    
    NSDate *  senddate=[NSDate date];
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d年%2d月%2d日",year,month,day];
    NSString *musicModel = [nsDateString stringByAppendingFormat:@"-music"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:musicModel];
    
//    [self.tableView reloadData];
}

- (void)dealloc{
    [self.tableView reloadData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self createUI];
    [self createErrorView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modeDataChange) name:@"modeDataChange" object:nil];
//    LBMusicDTO *dto = [[LBMusicDTO alloc] init];
//    dto.musicUrl = @" http://music.163.com/outchain/player?type=2&id=28018075&auto=1&height=66";
//    dto.name = @"风之影";
//    dto.imageUrl = @"http://imgsize.ph.126.net/?imgurl=http://p1.music.126.net/BgIHV6Bdc1fOL8exoLAHIg==/1694347418408441.jpg_500x500x0x95.jpg";
//    dto.descripTion = @"音乐页面";

    NSDictionary *dic = @{@"address":@"/Users/lhl/Downloads/ssssss.mp3",
                          @"background":@"http://p1.music.126.net/BgIHV6Bdc1fOL8exoLAHIg==/1694347418408441.jpg_500x500x0x95.jpg",
                          @"describe":@"音乐页面",
                          @"name":@"风之影",
                          @"love":@"1"};
    self.model = @[dic];
}

- (void)modeDataChange{
    [self.tableView reloadData];
}

- (void)createUI{
    enableHeader = YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.origin.x, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setSeparatorColor:[UIColor clearColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView setBackgroundColor:[UIColor colorWithRed:241./255. green:241./255. blue:241./255. alpha:1.0]];
    
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
    [self.view addSubview:self.tableView];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (Class)cellClass {
    return [LBCenterCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_GET_CENTER_LIST;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.model== nil)
        return 0;
    if([self.model isKindOfClass:[NSDictionary class]])
        return 1;
    
    return [(NSArray*)self.model count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
//    Class cls = [self cellClass];
//    if(!cls)
//    {
//        cls = [UITableViewCell class];
//    }
    
    static NSString *identifier = @"cellName";
    LBCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LBCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

//    if ([(LBCenterCell *)cell respondsToSelector:@selector(setObject:)]) {
        if(indexPath.row < [(NSArray*)self.model count])
        {
            id item = nil;
            if(self.model != nil && [self.model isKindOfClass:[NSArray class]])
                item = [self.model objectAtIndex:indexPath.row];
            else if(self.model != nil && [self.model isKindOfClass:[NSDictionary class]])
                item = self.model;
            [cell setObject:item];
            
            LBCenterCell *centerCell = cell;
            LBAudioView *audioView = centerCell.audioView;
            audioView.musicArray = self.model;
        }
//    }

    return cell;
     
}

- (void)didFinishLoad:(id)array {
    return;
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
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark EGORefreshTableHeaderDelegate Methods

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

/*
- (void)loadMoreData:(NSNumber *)loadHeader
{
    [super loadMoreData:loadHeader];
    //[self updateFooter];
}
*/

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
        if([LBCenterCell class] == [self cellClass] || [LBCenterCell class] == [[self cellClass] superclass])
        {
            //[Global clearPlayStatus];
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
    
    if(!scrollView.isDecelerating && ([LBCenterCell class] == class|| [LBCenterCell class] == [class superclass]))
    {
        //[self playVideoFowScroller:scrollView];
    }
}

@end
