//
//  CustomAudioPlayer.h
//  FnoDailyTen
//
//  Created by 乐播 on 13-9-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

//#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
typedef enum{
    oneLoop1,
    orderLoop1,
    randomLoop1
}LoopType1;

@class AudioButton;

@interface CustomAudioPlayer : NSObject <AVAudioPlayerDelegate>{
    AVAudioPlayer *avAudioPlayer;
    UIButton *customPlaybutton;
    NSString *customUrl;
    NSTimer *timer;
    BOOL    runProgress;
    BOOL isPlay;
    BOOL    stopAll;
    NSArray *localMusicArray;
    NSInteger currentIndex;
}

@property (nonatomic ,strong) AVAudioPlayer *avAudioPlayer;
@property (nonatomic, retain) UIButton *customPlaybutton;
@property (nonatomic, retain) NSMutableArray *musicArray;
@property (nonatomic, retain) NSString *customUrl;
@property (nonatomic, assign) LoopType1 loopType;
@property (nonatomic, assign) BOOL isPlay;
+ (id)shareInstance;
- (void)configurationButtonImages:(NSURL *)musicUrl;
- (void)playPrevious;
- (void)playNext;
- (void)play;
- (void)pause;
- (void)stop;
- (void)resume;
- (BOOL)isProcessing;
- (void)stopAllCacheMusic;
@end
