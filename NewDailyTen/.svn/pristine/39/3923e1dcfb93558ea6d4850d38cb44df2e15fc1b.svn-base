//
//  LBCenterView.h
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
#import "LeboDTO.h"
#import <MessageUI/MessageUI.h>
#import "LBMusicDTO.h"
@interface LBAudioView : UIView <CustomActionSheetDelegate , MFMessageComposeViewControllerDelegate ,UIActionSheetDelegate>
{
    UINavigationController *currentNaVC;
    BOOL    isSceneSession;
    TencentType tecentType;
    id viewController;
    NSString *musicName;
    UIActionSheet *actionSheet;
}
@property (nonatomic, strong) LBMusicDTO *musicDto;;
@property (nonatomic, strong) NSString   *currentMusicUrl;;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) RTLabel *topicLabel;
@property (nonatomic, strong) UIImageView *topicImageView;
@property (nonatomic, strong) UIImageView *actionItemsView;
@property (nonatomic, strong) NSDictionary *item;
@property (nonatomic, retain) AudioPlayer *audioPlayer;
@property (nonatomic, retain) UIImageView *imageViewBackground;
@property (nonatomic, strong) NSMutableArray *musicArray;
@property (nonatomic, strong) NSMutableArray *musicUrlArray;

+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;
- (void)downloadMusicSuccess:(id)data;
- (void)playAudio:(UIButton *)button;
+ (void)pauseAllMusic;
- (void)showAWSheet;

- (void)actionClicked:(UIButton *)sender;

@end
