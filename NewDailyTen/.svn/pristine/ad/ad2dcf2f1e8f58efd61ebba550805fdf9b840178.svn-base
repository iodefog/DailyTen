//
//  CustomSegmented.h
//  Demo
//
//  Created by 乐播 on 13-9-23.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSegmentedDeleate <NSObject>
// 点击按钮即执行
- (void)customSegmentedClickedIndex:(NSNumber *)index;
// 动画完成后执行
- (void)customSegmentedClickedAnimalStopIndex:(NSNumber *)index;

@end


@interface CustomSegmented : UIImageView
@property (nonatomic, assign) id      customDelegate;
@property (nonatomic, strong) NSArray *mTitlesArray;
@property (nonatomic, strong) NSArray *mImagesArray;
@property (nonatomic, strong) NSArray *mSelectedImagesArray;
@property (nonatomic, strong) UIButton *animalButton;
@property (nonatomic, strong) NSNumber *selectedIndex;

- (id)initwithImagesArray:(NSArray *)imagesArray withSelectedArray:(NSArray *)selectedArray withTitleArray:(NSArray *)titlesArray withFrame:(CGRect)frame;
- (void)changeSelectedIndex:(NSNumber *)index;

@end
