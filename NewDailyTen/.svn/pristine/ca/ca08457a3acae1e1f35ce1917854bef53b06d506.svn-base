//
//  CustomSegmented.m
//  Demo
//
//  Created by 乐播 on 13-9-23.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "CustomSegmented.h"

@implementation CustomSegmented
@synthesize customDelegate;
@synthesize animalButton;
@synthesize selectedIndex;
@synthesize mImagesArray,mTitlesArray,mSelectedImagesArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initwithImagesArray:(NSArray *)imagesArray withSelectedArray:(NSArray *)selectedArray withTitleArray:(NSArray *)titlesArray withFrame:(CGRect)frame{
   CustomSegmented *customSeg = [self initWithFrame:frame];
    customSeg.mImagesArray = imagesArray;
    customSeg.mTitlesArray = titlesArray;
    customSeg.mSelectedImagesArray = selectedArray;
    [self createItemsView];
    return self;
}

- (void)createItemsView{
    // 获取文字，图片，背景图数组最大的为循环单位
    NSInteger mCount = self.mImagesArray.count>self.mSelectedImagesArray.count?self.mImagesArray.count:self.mSelectedImagesArray.count;
    NSInteger mMaxCount = self.mTitlesArray.count > mCount?self.mTitlesArray.count:mCount;
    
    for (int i = 0; i < mMaxCount; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i <= self.mTitlesArray.count) {
            [button setTitle:[self.mTitlesArray objectAtIndex:i] forState:UIControlStateNormal];
        }
        if (i <= self.mImagesArray.count) {
            [button setImage:[UIImage imageNamed:[self.mImagesArray objectAtIndex:i]] forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 100+i;
        button.frame = CGRectMake((self.frame.size.width/self.mImagesArray.count)*i, 0, self.frame.size.width/self.mImagesArray.count, self.frame.size.height);
        button.centerY = self.centerY;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
       
        
        if (i == 0) {
            self.animalButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.animalButton setImage:[UIImage imageNamed:[self.mSelectedImagesArray objectAtIndex:i]] forState:UIControlStateNormal];
            self.animalButton.titleLabel.font = [UIFont systemFontOfSize:15];
            self.animalButton.tag = button.tag;
            [self.animalButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.animalButton setTitle:[self.mTitlesArray objectAtIndex:i] forState:UIControlStateNormal];
            self.animalButton.frame = button.frame;
            [self addSubview:self.animalButton];
//            self.animalButton.hidden = YES;
        }
        [self addSubview:button];

    }
}

- (void)buttonClicked:(UIButton *)sender{
//    self.animalButton.hidden = NO;
    if (sender.tag == self.animalButton.tag) {
        return;
    }
    [UIView beginAnimations:@"annimal" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    self.animalButton.frame = sender.frame;
    self.animalButton.tag = sender.tag;
    [UIView setAnimationDidStopSelector:@selector(animationStop)];
    [UIView commitAnimations];
    selectedIndex = [NSNumber numberWithInt:sender.tag - 100];
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(customSegmentedClickedIndex:)]) {
        [self.customDelegate performSelector:@selector(customSegmentedClickedIndex:) withObject:selectedIndex];
    }
 }

- (void)animationStop{
    // 检查是否选择按钮的index 是否比背景图个数大
    if (self.selectedIndex.intValue <= self.mSelectedImagesArray.count) 
        [self.animalButton setImage:[UIImage imageNamed:[self.mSelectedImagesArray objectAtIndex:self.selectedIndex.intValue]] forState:UIControlStateNormal];
    //检查是否选择按钮的index 是否比文字个数大
    if (self.selectedIndex.intValue <= self.mTitlesArray.count) {
        [self.animalButton setTitle:[self.mTitlesArray objectAtIndex:self.selectedIndex.intValue] forState:UIControlStateNormal];
    }
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(customSegmentedClickedAnimalStopIndex:)]) {
        [self.customDelegate performSelector:@selector(customSegmentedClickedAnimalStopIndex:) withObject:selectedIndex];
    }
}

- (void)changeSelectedIndex:(NSNumber *)index{
    UIButton *button = (id)[self viewWithTag:100+index.intValue];
    [self buttonClicked:button];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
