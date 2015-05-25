//
//  WZGuideViewController.h
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZGuideViewController : UIViewController<UIScrollViewDelegate>
{
    BOOL _animating;
    UIPageControl *pageContro;
    UIScrollView *_pageScroll;
}

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UIScrollView *pageScroll;

+ (WZGuideViewController *)sharedGuide;

+ (void)show;
+ (void)hide;

@end
