//
//  LBCacheAudioView.m
//  DailyTen
//
//  Created by King on 13-9-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBCacheAudioView.h"
#import "LBDownLoadMusic.h"
#import "AudioPlayer.h"

@implementation LBCacheAudioView
@synthesize cusotomAudioPlayer = _cusotomAudioPlayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)actionClicked:(UIButton *)sender{
    if (sender.tag == 1000) {
        // 播放按钮
        [MobClick event:@"4" label:@"音乐播放"];
        self.musicArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"OffLineMusic"];;
//        [super actionClicked:sender];
        [self playAudio:sender];
        
    }else if (sender.tag == 1001){
        // 红心下载按钮
        [sender setSelected:!sender.isSelected];
        NSMutableArray *offLineMusic = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"OffLineMusic"]];
        [offLineMusic removeObject:self.musicDto.dtoResult];
        [[NSUserDefaults standardUserDefaults] setObject:offLineMusic forKey:@"OffLineMusic"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"modeDataChange" object:nil];
        [MobClick event:@"5" label:@"音乐下载"];
    }else if (sender.tag == 1002){
        //        [sender setSelected:!sender.isSelected];
//        if ([self.audioPlayer.url isEqual:[NSURL URLWithString:self.musicDto.musicUrl]]) {
            NSString *loopType = [[NSUserDefaults standardUserDefaults] objectForKey:@"loopType"];
            if ([loopType isEqualToString:@"oneLoop"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLoopToOrder" object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:@"orderLoop" forKey:@"loopType"];
                [sender setImage:[UIImage imageNamed:@"single_cycle.png"] forState:UIControlStateNormal];
                self.cusotomAudioPlayer.loopType =  orderLoop;
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"顺序播放"];
            }else if([loopType isEqualToString:@"orderLoop"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLoopToRandom" object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:@"randomLoop" forKey:@"loopType"];
                [sender setImage:[UIImage imageNamed:@"play_random.png"] forState:UIControlStateNormal];
                self.cusotomAudioPlayer.loopType = randomLoop;
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"随机播放"];
                
            }else if([loopType isEqualToString:@"randomLoop"] || !loopType){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLoopToOneLoop" object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:@"oneLoop" forKey:@"loopType"];
                [sender setImage:[UIImage imageNamed:@"single_cycle_selected.png"] forState:UIControlStateNormal];
                self.cusotomAudioPlayer.loopType =  oneLoop;
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"单曲循环"];
            }
//        }
        // 循环播放按钮
        [MobClick event:@"6" label:@"音乐循环播放"];
    }else if (sender.tag == 1003){
        // 分享按钮
        [MobClick event:@"3" label:@"音乐分享点击数"];
        currentNaVC = (UINavigationController *)([UIApplication sharedApplication].keyWindow.rootViewController);
        [self showAWSheet];
    }
}



- (void)playAudio:(UIButton *)button
{
    [LBAudioView pauseAllMusic];
    if (!self.musicDto.musicUrl) {
        return;
    }
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"MusicCache"];
    NSString *fileDirectory = path;
    NSString *filePath = [[NSString stringWithFormat:@"%@/%@",fileDirectory,[self.musicDto.musicUrl md5Value]] stringByAppendingPathExtension:@"mp3"];
    BOOL flag = [[NSFileManager defaultManager] fileExistsAtPath:[[NSURL URLWithString:filePath] path]];
    if (!flag) {
        [[LBDownLoadMusic shareInstance] download:self.musicDto.musicUrl name:self.musicDto.name];
    }
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    if (_cusotomAudioPlayer == nil) {
        _cusotomAudioPlayer = [CustomAudioPlayer shareInstance];
    }
    
    NSString *loopType = [[NSUserDefaults standardUserDefaults] objectForKey:@"loopType"];
    if ([loopType isEqualToString:@"oneLoop"]) {
        _cusotomAudioPlayer.loopType =  oneLoop;
    }else if([loopType isEqualToString:@"orderLoop"]){
        _cusotomAudioPlayer.loopType =  orderLoop;
        
    }else if([loopType isEqualToString:@"randomLoop"] || !loopType){
        _cusotomAudioPlayer.loopType =  randomLoop;
    }
    
    if (self.cusotomAudioPlayer.customPlaybutton == (id)button && [self.cusotomAudioPlayer.customUrl isEqualToString:self.musicDto.musicUrl]) {
        if ([self.cusotomAudioPlayer.avAudioPlayer isPlaying]) {
             [_cusotomAudioPlayer pause];
        }else{
             [_cusotomAudioPlayer resume];
        }
       
    } else {
        [_cusotomAudioPlayer stop];
        _cusotomAudioPlayer.customPlaybutton = (id)button;
        _cusotomAudioPlayer.customUrl = self.musicDto.musicUrl;
        [_cusotomAudioPlayer play];
    }
}

- (void)setObject:(id)item
{
    [super setObject:item];
}

+ (void)pauseAllCacheMusic{
    [[CustomAudioPlayer shareInstance] stopAllCacheMusic];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [_cusotomAudioPlayer play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [_cusotomAudioPlayer pause];
            break;
        case UIEventSubtypeRemoteControlStop:
            [_cusotomAudioPlayer stop];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [_cusotomAudioPlayer playPrevious];// 播放上一曲按钮
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [_cusotomAudioPlayer playNext]; // 播放下一曲按钮
            break;
        default:
            break;
    }
}


@end
