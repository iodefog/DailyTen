//
//  CustomActionSheet.m
//  SheetDemo
//
//  Created by 乐播 on 13-10-17.
//  Copyright (c) 2013年 lihongli. All rights reserved.
//

#define itemPerPage 8

#define animationTime 0.33f

#import "CustomActionSheet.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomActionSheet()<UIScrollViewDelegate>

@property (nonatomic, retain)UIImageView *backGroundView;
@property (nonatomic, retain)UIScrollView* scrollView;
@property (nonatomic, retain)UIPageControl* pageControl;
@property (nonatomic, retain)NSMutableArray* items;
@property (nonatomic, assign)id<CustomActionSheetDelegate> IconDelegate;

@end
@implementation CustomActionSheet
@synthesize backGroundView;
@synthesize scrollView;
@synthesize pageControl;
@synthesize items;
@synthesize IconDelegate;

- (id)init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.5]];
    }
    return self;
}

-(id)initwithIconSheetDelegate:(id<CustomActionSheetDelegate>)delegate ItemCount:(int)count delButton:(BOOL)delButton{
    if ([self  init]) {
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backGroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hei.png"]];
        self.backGroundView.frame = CGRectMake(0, self.frame.size.height, 320, 310);
        self.backGroundView.userInteractionEnabled = YES;
        [self addSubview:self.backGroundView];
        
        IconDelegate = delegate;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 105*2)];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setBackgroundColor:[UIColor clearColor]];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setDelegate:self];
        [self.scrollView setScrollEnabled:YES];
        [self.scrollView setBounces:NO];
        
        [self.backGroundView addSubview:self.scrollView];
        
        if (count > 8) {
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.backGroundView.frame.size.height - 20, 0, 20)] ;
            pageControl.center = CGPointMake(self.backGroundView.center.x, pageControl.center.y);
            [pageControl setNumberOfPages:0];
            [pageControl setCurrentPage:0];
            [pageControl setHidesForSinglePage:YES];
            [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
            [self.backGroundView addSubview:pageControl];
        }
        
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(20, self.backGroundView.frame.size.height - 80, 280, 40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancel_actionSheet.png"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:cancelBtn];
        
        self.items = [[NSMutableArray alloc] initWithCapacity:count];
    }
    return self;
}

-(void)showInView:(UIView *)view
{
    UIWindow *mWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [mWindow addSubview:self];
    [self reloadData];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationTime];
    CGRect mFrame =  self.backGroundView.frame;
    mFrame = CGRectMake(mFrame.origin.x, self.frame.size.height - 310, mFrame.size.width, mFrame.size.height);
    self.backGroundView.frame = mFrame;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
}

- (void)reloadData
{
    
    for (CustomActionSheetCell* cell in items) {
        [cell removeFromSuperview];
        [items removeObject:cell];
    }
    
    int count = [IconDelegate numberOfItemsInActionSheet];
    
    if (count <= 0) {
        return;
    }
    
    int rowCount = 2;
    
    if (count <= 4) {
        [self.scrollView setFrame:CGRectMake(0, 10, 320, 200)];
        rowCount = 1;
    } else {
        [self.scrollView setFrame:CGRectMake(0, 10, 320, 400)];
        rowCount = 2;
    }
    [self.scrollView setContentSize:CGSizeMake(320*(count/itemPerPage+1), self.scrollView.frame.size.height)];
    [pageControl setNumberOfPages:count/itemPerPage+1];
    [pageControl setCurrentPage:0];
    
    
    for (int i = 0; i< count; i++) {
        
        CustomActionSheetCell* cell = [IconDelegate cellForActionAtIndex:i];
        int PageNo = i/itemPerPage;
        //        NSLog(@"page %d",PageNo);
        int index  = i%itemPerPage;
        
        if (itemPerPage == 8) {
            
            int row = index/(itemPerPage/2);
            int column = index%(itemPerPage/2);
            NSLog(@"row  %d column %d ",row , column);
            float centerY = (row)*self.scrollView.frame.size.height/(2*rowCount) +50;
            NSLog(@"centerY %f", centerY);
            float centerX = (1+column*2)*self.scrollView.frame.size.width/8;
                        
            [cell setCenter:CGPointMake(centerX+320*PageNo, centerY)];
            [self.scrollView addSubview:cell];
            if (cell.isButton) {
                cell.iconButton.tag = 100 + i;
                [cell.iconButton addTarget:self action:@selector(actionBtnForItem:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForItem:)];
                [cell addGestureRecognizer:tap];
            }
        }
        
        [items addObject:cell];
    }
    
}

- (void)actionBtnForItem:(UIButton *)sender{
    [self actionCancel:nil];

    [IconDelegate DidTapOnItemAtIndex:sender.tag - 100];
//    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)actionForItem:(UITapGestureRecognizer*)recongizer
{
    [self actionCancel:nil];

//    [self CancelAnimationStop];
    CustomActionSheetCell* cell = (CustomActionSheetCell*)[recongizer view];
    [IconDelegate DidTapOnItemAtIndex:cell.index];
}

// 取消
- (void)actionCancel:(UIButton *)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationTime];
    CGRect mFrame =  self.backGroundView.frame;
    mFrame = CGRectMake(mFrame.origin.x, mFrame.origin.y + 400, mFrame.size.width, mFrame.size.height);
    self.backGroundView.frame = mFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(CancelAnimationStop)];
    [UIView commitAnimations];
}

- (void)CancelAnimationStop{
    [self removeFromSuperview];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x /320;
    pageControl.currentPage = page;
}


@end


#pragma mark - AWActionSheetCell
@interface CustomActionSheetCell()
@end
@implementation CustomActionSheetCell
@synthesize iconView;
@synthesize titleLabel;


-(id)initIsButton:(BOOL)isButton
{
    self.isButton = isButton;
    self = [super initWithFrame:CGRectMake(0, 0, 70, 70)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if (isButton) {
            self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.iconButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.iconButton.frame = CGRectMake(6.5, 0, 57, 57);
            [self addSubview:self.iconButton];
        }else{
            self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(6.5, 0, 57, 57)] ;
            [iconView setBackgroundColor:[UIColor clearColor]];
            [[iconView layer] setCornerRadius:8.0f];
            [[iconView layer] setMasksToBounds:YES];
            
            [self addSubview:iconView];
        }
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, 70, 13)] ;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        //[titleLabel setShadowColor:[UIColor blackColor]];
        //[titleLabel setShadowOffset:CGSizeMake(0, 0.5)];
        [titleLabel setText:@""];
        [self addSubview:titleLabel];
        
    }
    return self;
}

@end
