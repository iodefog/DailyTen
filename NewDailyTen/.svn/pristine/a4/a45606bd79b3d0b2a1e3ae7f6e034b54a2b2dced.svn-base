//
//  LBModelApiViewController.m
//  lebo
//
//  Created by yong wang on 13-3-21.
//  Copyright (c) 2013年 lebo. All rights reserved.
//
#define pageSize @"10"

#import "LBModelApiViewController.h"
#import "SBJson.h"
#import "SBJsonParser.h"
#import "LBAppDelegate.h"
#import "LBMovieView.h"
#import "TKAlertCenter.h"

@implementation LBModelApiViewController
@synthesize model;

- (id)init{
    self = [super init]; 
    if (self) {
    }
    return self;
}

- (NSURLRequestCachePolicy)getPolicy
{
    NSURLRequestCachePolicy getPolicy = NSURLRequestReloadRevalidatingCacheData;
    return getPolicy;
}

- (API_GET_TYPE)modelApi
{
    return 0;
}

- (BOOL)isLoading {
    return loading;
}

- (void)loadMoreData:(NSNumber *)loadHeader
{
    BOOL loadMore = [loadHeader boolValue];
    
    [self loadData:loadMore ? NSURLRequestReloadIgnoringLocalAndRemoteCacheData :NSURLRequestReloadIgnoringLocalAndRemoteCacheData ];
    //[self loadData:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
}

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy
{
    API_GET_TYPE api_type = [self modelApi];
    loading = YES;
    
    LBFileClient *client = [LBFileClient sharedInstance];
    //client.more = more;
    switch (api_type) {
        case API_GET_LEFT_LIST:
            [client getVideoList:@"牙齿天天晒太阳" cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_CENTER_LIST:
            [client getMusicList:nil cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break; 
        case API_GET_RIGHT_LIST:
            [client getAppsList:[NSArray arrayWithObjects:pageSize, [self page], nil] cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        default:
            loading = NO;
            break;
    }
}

- (void)didFinishLoad:(id)object {
    
    if(object == model)
    {
        return;
    }
     
    if (self.model) {
        NSMutableArray *mmArray = [NSMutableArray arrayWithArray:self.model];
        [mmArray addObjectsFromArray:object];
        self.model = mmArray;
    } else {
        self.model = object;
    }
}

- (BOOL)shouldLoad {
    return !loading;
}

#pragma mark -
- (void)reloadData {
    if ([self shouldLoad] && ![self isLoading])
    {
        [self loadData:NSURLRequestReloadIgnoringCacheData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [LBMovieView pauseAll];
    [Global clearPlayStatus];
    
    [MobClick endLogPageView:[self getPageName]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [LBMovieView pauseAll];
    [Global clearPlayStatus];
    
    NSDate *  senddate=[NSDate date];
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d年%2d月%2d日",year,month,day];
    NSString *movieModel = [nsDateString stringByAppendingFormat:@"-movie"];
    NSString *musicModel = [nsDateString stringByAppendingFormat:@"-music"];
    if (self.model == nil || ![[NSUserDefaults standardUserDefaults] objectForKey:movieModel] || ![[NSUserDefaults standardUserDefaults] objectForKey:musicModel]) {
        [self reloadData];
    }
    
    [MobClick beginLogPageView:[self getPageName]];
}

- (NSString*)getChannelInfo
{
    return nil;
}

- (NSString*)getPageName
{
    API_GET_TYPE api_type = [self modelApi];
    NSString *pageName = nil;
    
    switch (api_type) {
        case API_GET_LEFT_LIST:
            pageName = @"视频页面";
            break;
        case API_GET_CENTER_LIST:
            pageName = @"音乐页面";
            break;
        case API_GET_RIGHT_LIST:
            pageName = @"应用页面";
            break;
        default:
            pageName = @"其他页面";
            break;
    }
    NSLog(@"***** %@" ,pageName);
    return pageName;
}

/*
#pragma mark -
- (void)setLogout:(AccountDTO *)account
{
    LBFileClient *client = [LBFileClient sharedInstance];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"partAccountDTO"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    BOOL bindDevice = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bindDevice"] boolValue];
    if (bindDevice == YES && deviceToken.length > 20) {
        AccountDTO *account = [AccountHelper getAccount];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"bindDevice"];
#ifdef __OPTIMIZE__
        //[client logoutDevice:[NSArray arrayWithObjects:[account token], [account ID], @"Lebo_iPhone", deviceToken, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
#else
        //[client logoutDevice:[NSArray arrayWithObjects:[account token], [account ID], @"Lebo_iPhone_Dev", deviceToken, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
#endif
    }
}
 */

- (id)transitionData:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", json_string);
    NSNumber *code = [NSNumber numberWithInt:999];
    //return nil;
    if(json_string.length > 0)
    {
        id dict = [json_string mutableObjectFromJSONString];
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            return [json_string mutableObjectFromJSONString];
        } else {
            id error = [dict objectForKey:@"error"];
            if (error && [error isKindOfClass:[NSDictionary class]]) {
                code = [error objectForKey:@"code"];
            } else{
                return [json_string mutableObjectFromJSONString];
            }
        }
        
        if ([code integerValue] == 10401) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"未登录,请登陆"];
        } else if ([code integerValue] == 0) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"重复登陆,请重新登陆"];
        }
        
        if ([code integerValue] == 10401 || [code integerValue] == 0)
        {
            LBAppDelegate *LBdelegate = (LBAppDelegate*)[UIApplication sharedApplication].delegate;
            if ([LBdelegate respondsToSelector:@selector(changedRootVCToLogin)]) {
                [LBdelegate performSelector:@selector(changedRootVCToLogin)];
                if (code == 0) {
//                    AccountDTO *account = [AccountHelper getAccount];
//                    [self setLogout:account];
                }
            }
        }
        else
        {
            
        }
    }
    else
    {
        return nil;
    }
    
    return nil;
}


- (void)requestDidFinishLoad:(NSData*)data
{
    id obj = [self transitionData:data];
    [self didFinishLoad:obj];
    loading = NO;
}

- (void)didFailWithError:(int)type
{
    
}

- (void)requestError:(NSError*)error
{
    loading = NO;
    [self didFailWithError:error.code];
}

- (void)requestDidFinishLoadSearchFriends:(NSData *)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *error = [[json_string mutableObjectFromJSONString] objectForKey:@"error"];
    if ([error isKindOfClass:[NSString class]] && [error isEqualToString:@"OK"]) {
        [self reloadData];
    }
}

//override
- (int)getModelCount
{
    if(self.model == nil)
    {
        return [pageSize intValue];
    }
    else
    {
        return [((NSArray*)(self.model)) count];
    }
}

- (NSString *)getFriendsCount:(BOOL)more
{
    int nCount = 0;
    
    if (more) {
        nCount = (self.model == nil ? 1 : [(NSArray *)self.model count] + 1);
    } else
        nCount = 1;
    
    return [NSString stringWithFormat:@"%d", nCount];
}

- (NSString *)getTopicLeboID
{
    return @"";
}

- (NSString *)getAccountID
{
    return @"";
}

- (NSString *)getComptition
{
    return @"";
}

- (NSString *)getFollow
{
    return @"";
}

- (NSString *)page
{
    /*
    if (more) {
        if (self.model) {
            int count = [pageSize intValue];
            return [NSString stringWithFormat:@"%d", [self.model count]/count];
        } else
            return @"0";
    } 
     */
        return @"0";
}

- (NSString*)getToUserID
{
    return @"";
}

- (NSString*)getLastID
{
    return @"";
}

- (NSString*)getFromAccountID
{
    return @"";
}

- (NSString *)getLeboID
{
    NSString *leboID = @"";
    /*
    if (more) {
        int nCount = [((NSArray*)(self.model)) count];
        if(nCount > 0 && [self.model isKindOfClass:[NSArray class]])
        {
            leboID = [self.model[nCount -1] objectForKey:@"id"];
            if (!leboID) {
                leboID = [[self.model[nCount -1] objectForKey:@"sender"] objectForKey:@"id"];
            }
            if (!leboID) {
                leboID = @"";
            }
        }
    } else {
        leboID = @"";
    }
    */
    return leboID;
}

- (int)getNoticeRange:(BOOL)more
{
    if(self.model && [model isKindOfClass:[NSArray class]] && more)
    {
        return [((NSArray*)(self.model)) count];
    }
    
    return 0;
}

- (NSString *)getToken
{
    return @"";
}

@end
