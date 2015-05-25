//
//  AudioPlayer.m
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioStreamer.h"

#define playImage @"play.png"
#define stopImage @"stop.png"

@implementation AudioPlayer

@synthesize streamer, playButton, audioUrl, isPlay ,musicUrlArray ,loopType , dataArray;


static AudioPlayer *audioPlayer = nil;

+ (id)shareInstance{
    if (!audioPlayer) {
        audioPlayer = [[AudioPlayer alloc] init];
    }
    return audioPlayer;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }

    return self;
}

- (void)dealloc
{
    [super dealloc];
    [audioUrl release];
    [streamer release];
    [playButton release];
    [timer invalidate];
}


- (BOOL)isProcessing
{
    return [streamer isPlaying] || [streamer isWaiting] || [streamer isFinishing] ;
}

- (void)playPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"MusicCache"];
    NSString *fileDirectory = path;
    NSString *filePath = [[NSString stringWithFormat:@"%@/%@",fileDirectory,self.audioUrl] stringByAppendingPathExtension:@"mp3"];
    
    BOOL flag = [[NSFileManager defaultManager] fileExistsAtPath:[[NSURL URLWithString:filePath] path]];
    if (playing == 1) {
        [avAudioPlayer pause];
        playing = 2;
    } else if (playing == 2) {
        [avAudioPlayer play];
        playing = 1;
    } else if (flag) {
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        //avAudioPlayer.delegate = self;
        [avAudioPlayer play];
        playing = 1;
    }
    
    
}

- (void)playPrevious{
     currentIndex = [self.musicUrlArray indexOfObject:audioUrl];
    if (currentIndex - 1 <=0) {
        currentIndex = 0;
        audioUrl = [self.musicUrlArray objectAtIndex:0];
    }
    else{
        audioUrl = [self.musicUrlArray objectAtIndex:--currentIndex];
    }
    [self.streamer stop];
     self.streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:audioUrl]];
    [streamer start];
    [self configPlayingInfo];

}

- (void)playNext{
    
    currentIndex = [self.musicUrlArray indexOfObject:audioUrl];
    if (currentIndex+1 >= [self.musicUrlArray count]){
        audioUrl = [self.musicUrlArray objectAtIndex:[self.musicUrlArray count] -1];
    }else{
         audioUrl = [self.musicUrlArray objectAtIndex:++currentIndex];
    }
    [self.streamer stop];
     self.streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:audioUrl]];
    [streamer start];
    [self configPlayingInfo];
}

- (void)play
{
    runProgress = YES;
    
    [self configPlayingInfo];
    if (!streamer) {
        
        self.streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:audioUrl]];
        
        // register the streamer on notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackStateChanged:)
                                                     name:ASStatusChangedNotification
                                                   object:streamer];
    }
    
    if ([streamer isPlaying]) {
        [streamer pause];
    } else {
        [streamer start];
    }
}

- (void)stop
{
    runProgress = YES;
    // release streamer
	if (streamer)
	{      
		[streamer stop];
		[streamer release];
		streamer = nil;
        
        // remove notification observer for streamer
		[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:ASStatusChangedNotification
                                                      object:streamer];		
	}
}


- (void)pause
{
    runProgress = YES;
    // release streamer
	if (streamer){
		[streamer pause];
	}
}


- (void)configPlayingInfo
{
    UIBackgroundTaskIdentifier bgTask = 0;
    if([UIApplication sharedApplication].applicationState== UIApplicationStateBackground) {
        
        NSLog(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx后台播放");
        UIApplication*app = [UIApplication sharedApplication];
        
        UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:nil];
        
        if(bgTask!= UIBackgroundTaskInvalid) {
            [app endBackgroundTask: bgTask];
        }
        bgTask = newTask;
    }
    
    else {
        NSLog(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx前台播放");
    }
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSDictionary *item = [self.dataArray objectAtIndex:currentIndex];
        UIImageView *preImageView = [[[UIImageView alloc] init]autorelease];
        [preImageView setImageWithURL:[NSURL URLWithString:item[@"background"]]];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        if (!item[@"name"] || [item[@"name"] isEqualToString:@""]) {
            [dict setObject:@"每日十个" forKey:MPMediaItemPropertyTitle];
        }else{
            [dict setObject:item[@"name"] forKey:MPMediaItemPropertyTitle];
        }
//        [dict setObject:@"每日十个" forKey:MPMediaItemPropertyArtist];
        [dict setObject:[[[MPMediaItemArtwork alloc] initWithImage:preImageView.image] autorelease] forKey:MPMediaItemPropertyArtwork];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}

- (void)configurationButtonImages:(NSString *)musicUrl{
    NSLog(@"audioUrl %@" ,self.audioUrl);
    NSLog(@"musicUrl %@" ,musicUrl);

    if ([musicUrl isEqualToString:self.audioUrl]) {
        [self.playButton setImage:[UIImage imageNamed:playImage] forState:UIControlStateNormal] ;
    }else{
        [self.playButton setImage:[UIImage imageNamed:stopImage] forState:UIControlStateNormal] ;
    }
}

/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateChanged:(NSNotification *)notification
{
	if ([streamer isWaiting])
	{
        NSLog(@"等待播放");
    } else if ([streamer isIdle]) {
        NSLog(@"播放结束");
        [self stop];
        
        if (loopType == oneLoop) { // 单曲循环播放
            [self play];
        }else if (loopType == orderLoop){ // 顺序播放
             currentIndex = [self.musicUrlArray indexOfObject:self.audioUrl];
            if (currentIndex+1 < self.musicUrlArray.count) {
                self.audioUrl = [self.musicUrlArray objectAtIndex:currentIndex + 1];
                [self play];
                currentIndex += 1;
                [self configPlayingInfo];
            }
        }else if (loopType == randomLoop){ // 随机播放
            NSInteger random = arc4random()%10;
            if (random < self.musicUrlArray.count) {
                self.audioUrl = [self.musicUrlArray objectAtIndex:random];
                [self play];
            }
        }
        else
        {
            [self.playButton setImage:[UIImage imageNamed:playImage] forState:UIControlStateNormal] ;
        }
	} else if ([streamer isPaused]) {
        NSLog(@"手动暂停");
        [self.playButton setImage:[UIImage imageNamed:playImage] forState:UIControlStateNormal] ;
    } else if ([streamer isPlaying] || [streamer isFinishing]) {
        [self.playButton setImage:[UIImage imageNamed:stopImage] forState:UIControlStateNormal] ;
        NSLog(@"开始播放");
	} else {
        
    }
}

@end
