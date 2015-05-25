//
//  LBCacheAudioView.h
//  DailyTen
//
//  Created by King on 13-9-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBAudioView.h"
#import "CustomAudioPlayer.h"

@interface LBCacheAudioView : LBAudioView
@property (nonatomic, strong) CustomAudioPlayer *cusotomAudioPlayer;
- (void)actionClicked:(UIButton *)sender;

+ (void)pauseAllCacheMusic;

@end
