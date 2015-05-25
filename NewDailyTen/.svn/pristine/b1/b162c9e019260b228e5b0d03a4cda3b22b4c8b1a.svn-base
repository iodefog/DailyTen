//
//  CustomActionSheet.h
//  SheetDemo
//
//  Created by 乐播 on 13-10-17.
//  Copyright (c) 2013年 lihongli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomActionSheetCell;

@protocol CustomActionSheetDelegate <NSObject>
@optional
- (int)numberOfItemsInActionSheet;
- (CustomActionSheetCell*)cellForActionAtIndex:(NSInteger)index;
- (void)DidTapOnItemAtIndex:(NSInteger)index;

@end

@interface CustomActionSheet : UIView<CustomActionSheetDelegate>


-(id)initwithIconSheetDelegate:(id<CustomActionSheetDelegate>)delegate ItemCount:(int)count delButton:(BOOL)delButton;
-(void)showInView:(UIView *)view;

@end

// tap事件，图片点击阴影
@interface CustomActionSheetCell : UIView
@property (nonatomic,retain)UIImageView * iconView;
@property (nonatomic,retain)UILabel     * titleLabel;
@property (nonatomic,assign)int           index;
@property (nonatomic, retain) UIButton  *  iconButton;
@property (nonatomic, assign) BOOL      isButton;
- (id)initIsButton:(BOOL)isButton;

@end
