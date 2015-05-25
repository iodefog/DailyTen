//
//  LBOffLineMusicControllerViewController.m
//  DailyTen
//
//  Created by King on 13-9-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBOffLineMusicControllerViewController.h"
#import "LBCacheAudioCell.h"

@interface LBOffLineMusicControllerViewController ()

@end

@implementation LBOffLineMusicControllerViewController

@synthesize model = _model;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modeDataChange) name:@"modeDataChange" object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)modeDataChange{
    self.model = [[NSUserDefaults standardUserDefaults] objectForKey:@"OffLineMusic"];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.model = [[NSUserDefaults standardUserDefaults] objectForKey:@"OffLineMusic"];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self createUI];
}

- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.origin.x, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView setBackgroundColor:[UIColor colorWithRed:241./255. green:241./255. blue:241./255. alpha:1.0]];
    [self.view addSubview:self.tableView];
}

- (Class)cellClass {
    return [LBCacheAudioCell class];
}

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
