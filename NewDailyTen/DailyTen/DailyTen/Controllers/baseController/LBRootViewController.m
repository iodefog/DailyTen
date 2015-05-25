//
//  LBRootViewController.m
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBRootViewController.h"
#import "LBAudioView.h"

@interface LBRootViewController ()

@end

@implementation LBRootViewController
@synthesize toolBar ,subVCsArray, musicVCArray, mSegmentedControl;

- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
//    self.navigationController.navigationBar.tintColor = RGB(191, 8, 8);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"barBg.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonWithImage:@"setting.png" backgroundImage:nil target:self action:@selector(pushSettingController)];
    self.title = @"每日十个";
    self.titleArray = [NSArray arrayWithObjects:@"乐播" ,@"音乐", @"推荐", nil];
    [self createToolBar];
    
    segmented = [[CustomSegmented alloc] initwithImagesArray:[NSArray arrayWithObjects:@" ",@" ",@" ", nil] withSelectedArray:[NSArray arrayWithObjects:@"items.png",@"items.png",@"items.png", nil]  withTitleArray:self.titleArray withFrame:CGRectMake(0, 0, 222, 38)];
    segmented.customDelegate = self;
    segmented.center = CGPointMake(self.toolBar.centerX, self.toolBar.height/2);
    segmented.image = [UIImage imageNamed:@"items_bg.png"];
    [self.toolBar addSubview:segmented];
    LBLeftViewController *leftVC = [[LBLeftViewController alloc] init];
    leftVC.view.frame = CGRectMake(0, 0, 320, self.view.height - 44);
//    if (IS_IOS7) {
//        leftVC.view.top = 64;
//        leftVC.view.height = self.view.height - 64 - 44;
//    }
    [self addChildViewController:leftVC];
    [self.view addSubview:leftVC.view];
    self.subVCsArray = [[NSMutableArray alloc] initWithObjects:leftVC,[NSNull null],[NSNull null], nil];
    self.currentViewController = (id)leftVC;
 
    UISwipeGestureRecognizer *recognizerLeft  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeVideoView:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerLeft];
    
    UISwipeGestureRecognizer *recognizerRight  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeVideoView:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerRight];
}

- (void)createToolBar{
    self.toolBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenSize().height - 2*44, screenSize().width, 44)];
//    if (IS_IOS7) {
//        self.toolBar.top = screenSize().height - 22;
//    }
    self.toolBar.userInteractionEnabled = YES;
    self.toolBar.image = [UIImage imageNamed:@"barBg.png"];
    UISwipeGestureRecognizer *recognizerLeft  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toolsBarHandleSwipeVideoView:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.toolBar addGestureRecognizer:recognizerLeft];
    
    UISwipeGestureRecognizer *recognizerRight  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toolsBarHandleSwipeVideoView:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.toolBar addGestureRecognizer:recognizerRight];
    [self.view addSubview:self.toolBar];
}

- (void)handleSwipeVideoView:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if(nSelectIndex == 1){
            [segmented changeSelectedIndex:[NSNumber numberWithInt:2]];
        }
        else if(nSelectIndex == 0){
            [segmented changeSelectedIndex:[NSNumber numberWithInt:1]];
        }
    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if(nSelectIndex == 1){
            [segmented changeSelectedIndex:[NSNumber numberWithInt:0]];
        }
        else if(nSelectIndex == 2){
            [segmented changeSelectedIndex:[NSNumber numberWithInt:1]];
        }
    }
}

- (void)toolsBarHandleSwipeVideoView:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if(nSelectIndex == 1){
            [segmented changeSelectedIndex:[NSNumber numberWithInt:2]];
        }
        else if(nSelectIndex == 0){
            [segmented changeSelectedIndex:[NSNumber numberWithInt:1]];
        }
    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if(nSelectIndex == 1){
            [segmented changeSelectedIndex:[NSNumber numberWithInt:0]];
        }
        else if(nSelectIndex == 2){
            [segmented changeSelectedIndex:[NSNumber numberWithInt:1]];
        }
    }
}

- (void)pushSettingController{
    LBSettingViewController *settingVC = [[LBSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}


- (void)customSegmentedClickedAnimalStopIndex:(NSNumber *)index{
    
}

- (void)customSegmentedClickedIndex:(NSNumber *)index{
    [LBMovieView pauseAll];
    
    nSelectIndex = index.intValue;
    UITableViewController *oldViewController = nil;
    id viewController = [self.subVCsArray objectAtIndex:index.intValue];
    if (viewController == [NSNull null]) {
        if (index.intValue == 1){
            LBMusicViewController *centerVC = [[LBMusicViewController alloc] init];
            [self.subVCsArray replaceObjectAtIndex:index.intValue withObject:centerVC];
            [self addChildViewController:centerVC];
            centerVC.view.frame = CGRectMake(0, 0, 320, self.view.height - 44);
//            if (IS_IOS7) {
//                centerVC.view.top = 64;
//                centerVC.view.height = self.view.height - 64 - 44;
//            }
            if (!musicVCArray) {
                musicVCArray = [[NSMutableArray alloc] initWithCapacity:2];
            }
            [musicVCArray addObject:centerVC];
        }
        if (index.intValue == 2){
//            UMTableViewController *applicationsVC = [[UMTableViewController alloc] init];
//            [self.subVCsArray replaceObjectAtIndex:index.intValue withObject:applicationsVC];
//            [self addChildViewController:applicationsVC];
//            applicationsVC.view.frame = CGRectMake(0, 0, 320, self.view.height - 44);
//            if (IS_IOS7) {
//                applicationsVC.view.top = 64;
//                applicationsVC.view.height = self.view.height - 64 - 44;
//            }
        }
    }
    viewController = [self.subVCsArray objectAtIndex:index.intValue];
    
    if (_segmentIndex == 1) {
        [self segmentedViewController:mSegmentedControl touchedAtIndex:0];
    }
    
    [self transitionFromViewController:self.currentViewController toViewController:viewController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
    }  completion:^(BOOL finished) {
        if (finished) {
            self.currentViewController = viewController;
        }else{
            self.currentViewController = oldViewController;
        }
    }];
    
    if (index.intValue == 1) {
        if (mSegmentedControl == nil) {
            [self createSegment];
        }
        self.navigationItem.titleView = mSegmentedControl;
    }
    else
    {
        self.navigationItem.titleView = nil;
        self.title = @"每日十个";
    }
}

- (void)createSegment
{
    mSegmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 180, 37)];
    mSegmentedControl.backgroundColor = [UIColor clearColor];
    mSegmentedControl.delegate = self;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 90, 37);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"leftBtn_select"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"leftBtn_select"]  forState:UIControlStateHighlighted];
    [leftBtn setTitle:@"音乐" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 90, 37);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"rightBtn"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"rightBtn_select"] forState:UIControlStateHighlighted];
    [rightBtn setTitle:@"离线" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    [mSegmentedControl setButtonsArray:[NSArray arrayWithObjects:leftBtn, rightBtn, nil]];
    [self segmentedViewController:mSegmentedControl touchedAtIndex:0];
    _segmentIndex = 0;
}

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    if (index == _segmentIndex) {
        return;
    }

    if (!self.offLineMusicVC) {
        self.offLineMusicVC = [[LBOffLineMusicControllerViewController alloc] init];
        self.offLineMusicVC.view.frame = CGRectMake(0, 0, 320, self.view.height - 44);
//        if (IS_IOS7) {
//            self.offLineMusicVC.view.top = 64;
//            self.offLineMusicVC.view.height = self.view.height - 64 - 44;
//        }
        [self addChildViewController:self.offLineMusicVC];
        [musicVCArray addObject:self.offLineMusicVC];
    }
    
    UIButton *button = ((UIButton*)segmentedControl.buttonsArray[_segmentIndex]);
    [button setTitleColor:[UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1.0] forState:UIControlStateNormal];
    NSString *imageName1  =  index == 1 ? @"leftBtn.png" : @"rightBtn.png";
    [button setBackgroundImage:[UIImage imageNamed:imageName1] forState:UIControlStateNormal];
    
    [self transitionFromViewController:[musicVCArray objectAtIndex:_segmentIndex] toViewController:[musicVCArray objectAtIndex:index] duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
    }  completion:^(BOOL finished) {
        
    }];
    
    _segmentIndex = index;
    button = ((UIButton*)segmentedControl.buttonsArray[_segmentIndex]);

    NSString *imageName2  =  _segmentIndex == 0 ? @"leftBtn_select.png" : @"rightBtn_select.png";
    [button setBackgroundImage:[UIImage imageNamed:imageName2] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
