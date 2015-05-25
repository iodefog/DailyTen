//
//  LBModelApiViewController.h
//  lebo
//
//  Created by yong wang on 13-3-21.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBBaseController.h"
#import "JSON.h"
#import "JSONKit.h"

typedef enum
{
    API_GET_LEFT_LIST  = 0,
    API_GET_CENTER_LIST,     
    API_GET_RIGHT_LIST,      

}API_GET_TYPE;

@interface LBModelApiViewController : LBBaseController  {
    BOOL loading;
}

@property (nonatomic, retain) id model;

// subclass to override
- (BOOL)shouldLoad;
- (BOOL)isLoading;
- (void)reloadData;

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy;
- (void)didFinishLoad:(id)object;
- (id)transitionData:(NSData*)data;
- (void)didFailWithError:(int)type;
- (void)requestDidFinishLoad:(NSData*)data;
- (void)requestError:(NSError*)error;

- (void)loadMoreData:(NSNumber *)loadHeader;
//- (NSString *)getLeboID:(BOOL)more;
//- (NSString *)channelTitles;
//- (NSString *)getKey;
//- (int)getNoticeRange;

- (NSString *)getFollow;
- (NSString *)getTopicLeboID;
- (NSString *)getAccountID;
- (NSString *)getComptition;
- (NSString *)getFriendsCount:(BOOL)more;
//- (NSString *)page:(BOOL)more;
- (API_GET_TYPE)modelApi;
- (NSString*)getToUserID;
- (NSString*)getLastID;
- (NSString*)getFromAccountID;
- (NSString*)getChannelInfo;

- (NSString *)getToken;
@end
