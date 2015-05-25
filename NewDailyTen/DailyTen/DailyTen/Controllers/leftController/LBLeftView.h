//
//  LBLeftView.h
//  DailyTen
//
//  Created by King on 13-9-9.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

typedef enum{
    QZone,
    QWeibo
} TencentType;


#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "LBMovieView.h"

@interface LBLeftView : UIView<RTLabelDelegate, CustomActionSheetDelegate ,MFMessageComposeViewControllerDelegate>
{
    uint nType;
    UINavigationController *currentNaVC;
    BOOL isSceneSession;
    TencentType            tecentType;
}

@property(nonatomic, retain) LBMovieView *playerVideoView;
@property(nonatomic, retain) RTLabel *instructionLabel;
@property(nonatomic, retain) UILabel *timeLabel;
@property(nonatomic, retain) RTLabel *nameLabel;
@property(nonatomic, retain) UILabel *playCountLabel;
@property(nonatomic, retain) UIImageView *avatarImage;
@property(nonatomic, retain) UIButton *likedButton;
@property(nonatomic, retain) UIButton *commentButton;
@property(nonatomic, retain) UIButton *moreButton;
@property(nonatomic, retain) UIButton *relayButton;
@property(nonatomic, retain) UIImageView *imageViewBackground;
@property(nonatomic, retain) LeboDTO *leboDTO;
@property(nonatomic, retain) UIImageView *recommendImageView;
@property(nonatomic, retain) UIView *commentView;
@property(nonatomic, retain) UIButton *deleteBtn;
@property(nonatomic, retain) UIButton *followBtn;
@property(nonatomic, retain) UIView *tempTailView;
@property (nonatomic, retain) LeboDTO *selectDto;

@property (nonatomic, strong) UIImageView *customImageView;

+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;

@end
