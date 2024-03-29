//
//  CustomAudioPlayer.m
//  FnoDailyTen
//
//  Created by 乐播 on 13-9-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "CustomAudioPlayer.h"
#import "NSString+Addition1.h"

#define playImage @"play.png"
#define stopImage @"stop.png"

@implementation CustomAudioPlayer
@synthesize avAudioPlayer, customPlaybutton, customUrl, isPlay ,musicArray ,loopType ;

static CustomAudioPlayer *audioPlayer = nil;

+ (id)shareInstance{
    if (!audioPlayer) {
        audioPlayer = [[CustomAudioPlayer alloc] init];
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
    [customUrl release];
    [avAudioPlayer release];
    [customPlaybutton release];
    [timer invalidate];
}

- (BOOL)isProcessing
{
    return [avAudioPlayer isPlaying];
}

- (NSString *)playPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"MusicCache"];
    NSString *fileDirectory = path;
    NSString *filePath = [[NSString stringWithFormat:@"%@/%@",fileDirectory,[self.customUrl md5Value]] stringByAppendingPathExtension:@"mp3"];
    return filePath;
}

- (BOOL)checkEixstFilePath:(NSString *)filePath{
    BOOL eixst = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        eixst = YES;
    }else{
        eixst = NO;
    }
    return eixst;
}



- (void)playPrevious{
    localMusicArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"OffLineMusic"];
    if (!musicArray) {
        self.musicArray = [NSMutableArray array];
    }
    [self.musicArray removeAllObjects];
    for (NSDictionary *dict in localMusicArray) {
        [self.musicArray addObject:dict[@"address"]];
    }
    
    currentIndex = [self.musicArray indexOfObject:self.customUrl];
    if (currentIndex -1 <= 0) {
       currentIndex = 0 ;
    }else{
        currentIndex ++;
    }
    [self stop];
    [self play];
}

- (void)playNext{
    localMusicArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"OffLineMusic"];
    if (!musicArray) {
        self.musicArray = [NSMutableArray array];
    }
    [self.musicArray removeAllObjects];
    for (NSDictionary *dict in localMusicArray) {
        [self.musicArray addObject:dict[@"address"]];
    }
    
    currentIndex = [self.musicArray indexOfObject:self.customUrl];
    if (currentIndex +1 >= [self.musicArray count]) {
        currentIndex = [self.musicArray count]-1;
        ;
    }else{
        currentIndex ++;
    }
    [self stop];
    [self play];
}

- (void)configPlayingInfo
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        localMusicArray =[[NSUserDefaults standardUserDefaults] objectForKey:@"OffLineMusic"];
        if ([localMusicArray count] == 0 || !localMusicArray) {
            return;
        }
        NSDictionary *item = [localMusicArray objectAtIndex:currentIndex];
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


- (void)play
{
    stopAll = NO;
    runProgress = YES;
    if (!self.avAudioPlayer) {
        
        if (self.customUrl) {
            NSError *error = nil;
            if (![self checkEixstFilePath:[self playPath]]) {
                return;
            }
            self.avAudioPlayer = [[AVAudioPlayer alloc]  initWithData:[NSData dataWithContentsOfFile:[self playPath]] error:&error];
            self.avAudioPlayer.delegate = self;
            NSLog(@"AVAudioPlayer Error%@", error);
        }
        
        // register the streamer on notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackStateChanged:)
                                                     name:@"ASStatusChangedNotification"
                                                   object:self.avAudioPlayer];
    }
    if (avAudioPlayer) {
        if ([avAudioPlayer isPlaying]) {
            [avAudioPlayer pause];
            [customPlaybutton setImage:[UIImage imageNamed:playImage] forState:UIControlStateNormal];
        } else {
            [avAudioPlayer play];
            [customPlaybutton setImage:[UIImage imageNamed:stopImage] forState:UIControlStateNormal];

        }
    }
     [self configPlayingInfo];
}

- (void)pause{
    runProgress = YES;
    audioPlayer = [CustomAudioPlayer shareInstance];
     [customPlaybutton setImage:[UIImage imageNamed:playImage] forState:UIControlStateNormal];
    
    if (self.avAudioPlayer)
	{
		[self.avAudioPlayer pause];
    }
}

- (void)resume{
    runProgress = YES;
    audioPlayer = [CustomAudioPlayer shareInstance];
    [customPlaybutton setImage:[UIImage imageNamed:stopImage] forState:UIControlStateNormal];
    
    if (self.avAudioPlayer)
	{
		[self.avAudioPlayer play];
    }
}

- (void)stop
{
    runProgress = YES;
    audioPlayer = [CustomAudioPlayer shareInstance];
    [customPlaybutton setImage:[UIImage imageNamed:playImage] forState:UIControlStateNormal];

    customPlaybutton = nil; // 避免播放器的闪烁问题
    [customPlaybutton release];
    
    // release streamer
	if (self.avAudioPlayer)
	{
		[self.avAudioPlayer stop];
		[self.avAudioPlayer release];
		self.avAudioPlayer = nil;
        
        // remove notification observer for streamer
		[[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"ASStatusChangedNotification"
                                                      object:self.avAudioPlayer];
	}
}

- (void)configurationButtonImages:(NSURL *)musicUrl{
    NSLog(@"customUrl %@" ,customUrl);
    if ([musicUrl.description isEqualToString:customUrl.description]) {
        runProgress = YES;
        audioPlayer = [CustomAudioPlayer shareInstance];
        [customPlaybutton setImage:[UIImage imageNamed:stopImage] forState:UIControlStateNormal];
    }else{
        
    }
}

/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateChanged:(NSNotification *)notification
{
    NSMutableArray *mArray = [NSMutableArray array];
  localMusicArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"OffLineMusic"];
    for (int i = 0; i < localMusicArray.count; i ++) {
        NSDictionary *dict = [localMusicArray objectAtIndex:i];
        [mArray addObject:[dict objectForKey:@"address"]];
    }
    self.musicArray = mArray;
	if ([self.avAudioPlayer isPlaying])
	{
        [customPlaybutton setImage:[UIImage imageNamed:stopImage] forState:UIControlStateNormal];
        NSLog(@"等待播放");
    } else if (![self.avAudioPlayer isPlaying]) {
        NSLog(@"播放结束");
        [self stop];
        if (loopType == oneLoop1) { // 单曲循环播放
            [self play];
            [customPlaybutton setImage:[UIImage imageNamed:stopImage] forState:UIControlStateNormal];
        }else if (loopType == orderLoop1){ // 顺序播放
            NSInteger mCurrentIndex = [self.musicArray indexOfObject:customUrl];
            if (mCurrentIndex+1 < self.musicArray.count) {
                self.customUrl =  [NSURL URLWithString:[self.musicArray objectAtIndex:currentIndex + 1]];
                [self play];
                [customPlaybutton setImage:[UIImage imageNamed:stopImage] forState:UIControlStateNormal];
            }
        }else if (loopType == randomLoop1){ // 随机播放
            NSInteger random = arc4random()%10;
            if (random < self.musicArray.count) {
                self.customUrl = [NSURL URLWithString:[self.musicArray objectAtIndex:random]];
                [self play];
                [customPlaybutton setImage:[UIImage imageNamed:stopImage] forState:UIControlStateNormal];
            }
        }
        else
        {
            [customPlaybutton setImage:[UIImage imageNamed:playImage] forState:UIControlStateNormal];
        }
	} else if (![self.avAudioPlayer isPlaying]) {
        NSLog(@"手动暂停");
        [customPlaybutton setImage:[UIImage imageNamed:playImage] forState:UIControlStateNormal];
    } else if ([self.avAudioPlayer isPlaying]) {
        [customPlaybutton setImage:[UIImage imageNamed:stopImage] forState:UIControlStateNormal];
        NSLog(@"开始播放");
	} else {
        
    }
}

- (void)stopAllCacheMusic{
    stopAll = YES;
    if ([self.avAudioPlayer isPlaying])
	{
        [self stop];
    }
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (stopAll) {
        return;
    }
    [self playbackStateChanged:nil];
}

@end
