//
//  AudioPlayer.h
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
typedef enum{
    oneLoop,
    orderLoop,
    randomLoop
}LoopType;

@class AudioButton;
@class AudioStreamer;

@interface AudioPlayer : NSObject {
    AudioStreamer *streamer;
    UIButton *playButton;
    NSString *audioUrl;
    NSTimer *timer;
    BOOL runProgress;
    BOOL isPlay;
    
    AVAudioPlayer *avAudioPlayer;
    int playing;
    NSInteger currentIndex;
}

@property (nonatomic, retain) AudioStreamer *streamer;
@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) NSMutableArray *musicUrlArray;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSString *audioUrl;
@property (nonatomic, assign) LoopType loopType;
@property (nonatomic, assign) BOOL isPlay;

+ (id)shareInstance;
- (void)configurationButtonImages:(NSString *)musicUrl;
- (void)playPrevious;
- (void)playNext;
- (void)play;
- (void)stop;
- (void)pause;
- (BOOL)isProcessing;
- (void)playPath;

@end
