//
//  WZGuideViewController.m
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import "WZGuideViewController.h"

@interface WZGuideViewController ()

@end

@implementation WZGuideViewController

@synthesize animating = _animating;

@synthesize pageScroll = _pageScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -

- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;
}

- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[WZGuideViewController sharedGuide].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[WZGuideViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideShown
{
	_animating = NO;
}

- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
	[[[WZGuideViewController sharedGuide] view] removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(changeToRootVC)]) {
        [self.delegate performSelector:@selector(changeToRootVC)];
    }
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

+ (void)show
{
    [Global clearPlayStatus];
    [[WZGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[WZGuideViewController sharedGuide] showGuide];
}

+ (void)hide
{
	[[WZGuideViewController sharedGuide] hideGuide];
}

#pragma mark - 

+ (WZGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static WZGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton
{
    [checkButton setSelected:!checkButton.selected];
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstPage"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
//    CGPoint offset = scrollView.contentOffset;
//    CGRect bounds = scrollView.frame;
//    NSInteger pageInt = offset.x / bounds.size.width;
//    [pageContro setCurrentPage:pageInt];
    [Global clearPlayStatus];
    
//    if (pageInt == 2) {
//        [pageContro setHidden:YES];
//    } else
//        [pageContro setHidden:NO];
    
//    NSArray *subViews = pageContro.subviews;
//    for (int i = 0; i < [subViews count]; i++) {
//        UIView* subView = [subViews objectAtIndex:i];
//        if ([NSStringFromClass([subView class]) isEqualToString:NSStringFromClass([UIImageView class])]) {
//            ((UIImageView*)subView).image = (pageContro.currentPage == i ? [UIImage imageNamed:@"orangePoint"] : [UIImage imageNamed:@"grayPoint"]);
//        }
//    }
}

//-(void)pageChanged:(UIPageControl*)pc{
//   
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *imageNameArray = [NSArray array];
    if([[UIDevice currentDevice] platformType] == UIDevice5iPhone)
        imageNameArray = [NSArray arrayWithObjects:@"guide1_5.png",nil];
    else
        imageNameArray = [NSArray arrayWithObjects:@"guide1.png",nil];

    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, self.view.height)];
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.delegate = self;
    self.pageScroll.contentSize = CGSizeMake(screenSize().width * imageNameArray.count, self.view.height);
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.pageScroll];
    
//    pageContro = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 10, screenSize().width, 10)];
//    pageContro.numberOfPages = 0;
//    pageContro.currentPage = 0;
//    pageContro.centerX = screenSize().width/2;
//    [pageContro setTop:screenSize().height - 50];
//    pageContro.backgroundColor = [UIColor clearColor];
//    NSArray *subViews = pageContro.subviews;
//    for (int i = 0; i < [subViews count]; i++) {
//        UIView* subView = [subViews objectAtIndex:i];
//        if ([NSStringFromClass([subView class]) isEqualToString:NSStringFromClass([UIImageView class])]) {
//            ((UIImageView*)subView).image = (pageContro.currentPage == i ? [UIImage imageNamed:@"orangePoint"] : [UIImage imageNamed:@"grayPoint"]);
//        }
//    }
//    [pageContro addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:pageContro];
    
    NSString *imgName = nil;
    UIImageView *view;
    for (int i = 0; i < imageNameArray.count; i++) {
        imgName = [imageNameArray objectAtIndex:i];
        view = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize().width * i), 0.f, screenSize().width, self.view.height)];
        view.image = [UIImage imageNamed:imgName];
        view.userInteractionEnabled = YES;
        [self.pageScroll addSubview:view];
        
        if (i == imageNameArray.count - 1) {
            /*
            UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(80.f, 355.f, 15.f, 15.f)];
            [checkButton setImage:[UIImage imageNamed:@"checkBox_selectCheck"] forState:UIControlStateSelected];
            [checkButton setImage:[UIImage imageNamed:@"checkBox_blankCheck"] forState:UIControlStateNormal];
            [checkButton addTarget:self action:@selector(pressCheckButton:) forControlEvents:UIControlEventTouchUpInside];
            [checkButton setSelected:YES];
            [view addSubview:checkButton];
            */
            
            UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if([[UIDevice currentDevice] platformType] == UIDevice5iPhone)
            {
                enterButton.frame = CGRectMake(0.f, 0.f, 150.f, 53.f);

            }else
            {
                enterButton.frame = CGRectMake(0.f, 0.f, 166.f, 53.f);

            }
            [enterButton setTitle:@"每日十个" forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [enterButton setCenter:CGPointMake(self.view.center.x, 420.f)];
            if (isPhone5()) {
                [enterButton setTop:screenSize().height - 250];
            }else{
                [enterButton setTop:screenSize().height - 200];
            }
            
            [enterButton setBackgroundImage:[UIImage imageNamed:@"guide_enter.png"] forState:UIControlStateNormal];
//            [enterButton setBackgroundImage:[UIImage imageNamed:@"firstBtn_select"] forState:UIControlStateHighlighted];
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:enterButton];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
