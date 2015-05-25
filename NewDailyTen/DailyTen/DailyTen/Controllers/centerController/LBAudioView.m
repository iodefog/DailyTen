//
//  LBCenterView.m
//  DailyTen
//
//  Created by King on 13-9-9.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBAudioView.h"
#import "AudioPlayer.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "LBDownLoadMusic.h"
#import "LBCacheAudioView.h"

@implementation LBAudioView

@synthesize imagesArray = _imagesArray;
@synthesize topicImageView = _topicImageView;
@synthesize actionItemsView = _actionItemsView;
@synthesize topicLabel = _topicLabel;
@synthesize musicArray = _musicArray;
@synthesize musicUrlArray;
@synthesize currentMusicUrl;

#define PLAYVIEW_WIDTH 300.
#define PLAYVIEW_HEIGHT 300.
#define PLAYVIEW_HEAD 50.
#define PLAYVIEW_TAIL 42.

#define defaultViewHeight 300.0f
#define defaultBtnWidth  50.0f

#define sheetCellCount 9

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       self.imagesArray = [NSArray arrayWithObjects:
                                [NSArray arrayWithObjects:@"audioPlayer_Play.png",@"audioPlayer_pause.png", nil],
                                [NSArray arrayWithObjects:@"lover_black.png",@"lover_red.png", nil],
                                [NSArray arrayWithObjects:@"single_cycle.png",@"single_cycle.png", nil],
                                [NSArray arrayWithObjects:@"share.png",@"share.png", nil],
                                nil];

        [self createUI];
        NSError *setCategoryErr = nil;
        NSError *activationErr  = nil;
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
        [[AVAudioSession sharedInstance] setActive: YES error: &activationErr];
        
      
    }
    return self;
}

- (void)changeLoopToOrder:(NSNotification *)notification{
    UIButton *button = (id)[self viewWithTag:1002];
    [button setImage:[UIImage imageNamed:@"single_cycle.png"] forState:UIControlStateNormal];
}

- (void)changeLoopToRandom:(NSNotification *)notificaion{
    UIButton *button = (id)[self viewWithTag:1002];
    [button setImage:[UIImage imageNamed:@"play_random.png"] forState:UIControlStateNormal];
}

- (void)changeLoopToOneLoop:(NSNotification *)notification{
    UIButton *button = (id)[self viewWithTag:1002];
    [button setImage:[UIImage imageNamed:@"single_cycle_selected.png"] forState:UIControlStateNormal];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)pauseAllMusic{
    AudioPlayer *player = [AudioPlayer shareInstance];
    [player stop];
}

- (void)createUI
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoopToOrder:) name:@"changeLoopToOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoopToRandom:) name:@"changeLoopToRandom" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoopToOneLoop:) name:@"changeLoopToOneLoop" object:nil];
    
    self.userInteractionEnabled = YES;
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
    UIImage *image = [UIImage imageNamed:@"clip_view_background.png"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    
    if (!self.imageViewBackground) {
        self.imageViewBackground=[[UIImageView alloc] initWithImage:image];
    }
    [_imageViewBackground setFrame:CGRectMake(7, 0, 306, 100)];
    [_imageViewBackground setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview:_imageViewBackground];
    
    if (!self.topicImageView) {
        self.topicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 2, 304, defaultViewHeight)];
        self.topicImageView.image = [UIImage imageNamed:@"topic_1.png"];
        self.topicImageView.userInteractionEnabled = YES;
        [self addSubview:self.topicImageView];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToSavePhoto:)];
        [self.topicImageView addGestureRecognizer:longPress];
    }
    
    if (!self.actionItemsView) {
        self.actionItemsView = [self createItemsSubView];
        [self addSubview:self.actionItemsView];
    }
    self.actionItemsView.bottom = self.topicImageView.bottom;

    self.topicLabel = [[RTLabel alloc] initWithFrame:CGRectMake(self.topicImageView.left+5, self.topicImageView.bottom + 5, self.topicImageView.width, 20)];
    self.topicLabel.backgroundColor = [UIColor clearColor];
    self.topicLabel.font = [UIFont systemFontOfSize:14.0f];
    self.topicLabel.text = @"";
    [self.topicLabel setLineSpacing:5];
    [self addSubview:self.topicLabel];
    self.topicLabel.top = self.topicImageView.bottom + 5;
    
    self.musicDto = [[LBMusicDTO alloc] init];
}

- (void)layoutSubviews
{
    self.height = self.topicLabel.bottom + 5;
}

- (UIImageView *)createItemsSubView{
    UIImageView *itemsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.topicImageView.left, 0, self.topicImageView.width, 47)];
    itemsImageView.image = [UIImage imageNamed:@"audioPlayerBg.png"];
    itemsImageView.userInteractionEnabled = YES;
    for (int i = 0 ; i < 4 ; i ++) {
        UIButton *actionBtn = nil;
        if (i == 0) {
            actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            actionBtn.frame = CGRectMake(0, 0, 64, 47);
            [actionBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            [actionBtn addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            actionBtn = [UIButton createButtonWithFrame:CGRectZero Target:self Selector:@selector(actionClicked:) Image:[[self.imagesArray objectAtIndex:i] objectAtIndex:0] ImagePressed:[[self.imagesArray objectAtIndex:i] objectAtIndex:1]];
            actionBtn.frame = CGRectMake((itemsImageView.width - 4*defaultBtnWidth)/1.3*i+ 3+itemsImageView.left , 0, defaultBtnWidth, defaultBtnWidth);
        }
        
        actionBtn.tag = 1000 + i;
        actionBtn.centerY = itemsImageView.centerY;
        [itemsImageView addSubview:actionBtn];
        
        if (i == 2) {
            [self checkAudioPlayLoopType:actionBtn];
        }
    }
    
    return itemsImageView;
}

- (void)checkAudioPlayLoopType:(UIButton *)actionBtn{
    NSString *loopType = [[NSUserDefaults standardUserDefaults] objectForKey:@"loopType"];
    if ([loopType isEqualToString:@"oneLoop"]) {
        [actionBtn setImage:[UIImage imageNamed:@"single_cycle_selected.png"] forState:UIControlStateNormal];
    }else if([loopType isEqualToString:@"orderLoop"]){
        [actionBtn setImage:[UIImage imageNamed:@"single_cycle.png"] forState:UIControlStateNormal];
    }else if([loopType isEqualToString:@"randomLoop"] || !loopType){
       [actionBtn setImage:[UIImage imageNamed:@"play_random.png"] forState:UIControlStateNormal];
    }
}

- (void)checkMusicUrlInArray{
        if (!musicUrlArray) {
            musicUrlArray  = [NSMutableArray array];
             for (NSDictionary *dict in self.musicArray) {
                 [musicUrlArray addObject:dict[@"address"]];
             }
        }
      }

- (void)actionClicked:(UIButton *)sender{
    if (sender.tag == 1000) {
        // 播放按钮
        [MobClick event:@"4" label:@"音乐播放"];
        [self checkMusicUrlInArray];
        ((AudioPlayer *)[AudioPlayer shareInstance]).musicUrlArray = musicUrlArray;
        ((AudioPlayer *)[AudioPlayer shareInstance]).dataArray = self.musicArray;
        [self playAudio:sender];
        
    }else if (sender.tag == 1001){
        // 红心下载按钮
        [sender setSelected:!sender.isSelected];
//        [self.musicDto.dtoResult setObject:[NSString stringWithFormat:@"%d", love] forKey:@"love"];
        NSMutableArray *offLineMusic = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"OffLineMusic"]];
        if (self.musicDto.dtoResult && sender.selected) {
            [offLineMusic insertObject:self.musicDto.dtoResult atIndex:0];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"已收藏"];
        }
        else
        {
            [offLineMusic removeObject:self.musicDto.dtoResult];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"取消收藏"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:offLineMusic forKey:@"OffLineMusic"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [MobClick event:@"5" label:@"音乐下载"];
        LBDownLoadMusic *downloadMusic = [LBDownLoadMusic shareInstance];
        if ([downloadMusic download:self.musicDto.musicUrl name:self.musicDto.name]) {
            return;
        }
    }else if (sender.tag == 1002){
        if (self.musicDto.musicUrl) {
           NSString *loopType = [[NSUserDefaults standardUserDefaults] objectForKey:@"loopType"];
            if ([loopType isEqualToString:@"oneLoop"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLoopToOrder" object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:@"orderLoop" forKey:@"loopType"];
                [sender setImage:[UIImage imageNamed:@"single_cycle.png"] forState:UIControlStateNormal];
                ((AudioPlayer *)[AudioPlayer shareInstance]).loopType =  orderLoop;
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"顺序播放"];
            }else if([loopType isEqualToString:@"orderLoop"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLoopToRandom" object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:@"randomLoop" forKey:@"loopType"];
                 [sender setImage:[UIImage imageNamed:@"play_random.png"] forState:UIControlStateNormal];
                 ((AudioPlayer *)[AudioPlayer shareInstance]).loopType =  randomLoop;
                 [[TKAlertCenter defaultCenter] postAlertWithMessage:@"随机播放"];

            }else if([loopType isEqualToString:@"randomLoop"] || !loopType){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLoopToOneLoop" object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:@"oneLoop" forKey:@"loopType"];
                 [sender setImage:[UIImage imageNamed:@"single_cycle_selected.png"] forState:UIControlStateNormal];
                 ((AudioPlayer *)[AudioPlayer shareInstance]).loopType =  oneLoop;
                 [[TKAlertCenter defaultCenter] postAlertWithMessage:@"单曲循环"];
            }
        }
        // 循环播放按钮
        [MobClick event:@"6" label:@"音乐循环播放"];
    }else if (sender.tag == 1003){
        // 分享按钮
        [MobClick event:@"3" label:@"音乐分享点击数"];
        currentNaVC = (UINavigationController *)([UIApplication sharedApplication].keyWindow.rootViewController);
        [self showAWSheet];
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [_audioPlayer play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [_audioPlayer pause];
            break;
        case UIEventSubtypeRemoteControlStop:
            [_audioPlayer stop];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [_audioPlayer playPrevious];// 播放上一曲按钮
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [_audioPlayer playNext]; // 播放下一曲按钮
            break;
        default:
            break;
    }
}

- (void)downloadMusicSuccess:(id)data
{
    NSLog(@"下载成功");
}

- (void)playAudio:(UIButton *)button
{
    [LBCacheAudioView pauseAllCacheMusic];
    if (!self.musicDto.musicUrl) {
        return;
    }
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

    if (_audioPlayer == nil) {
        _audioPlayer = [AudioPlayer shareInstance];
    }
        
    NSString *loopType = [[NSUserDefaults standardUserDefaults] objectForKey:@"loopType"];
    if ([loopType isEqualToString:@"oneLoop"]) {
        _audioPlayer.loopType =  oneLoop;
    }else if([loopType isEqualToString:@"orderLoop"]){
        _audioPlayer.loopType =  orderLoop;
        
    }else if([loopType isEqualToString:@"randomLoop"] || !loopType){
        _audioPlayer.loopType =  randomLoop;
    }

    if (self.audioPlayer.playButton == (id)button && [self.audioPlayer.audioUrl isEqualToString:self.musicDto.musicUrl]) {
        [_audioPlayer play];
    } else {
        [_audioPlayer stop];
        _audioPlayer.playButton = (id)button;
        _audioPlayer.audioUrl = self.musicDto.musicUrl;
        [_audioPlayer play];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 0)];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = item[@"describe"];
    return defaultViewHeight + label.optimumSize.height + 12 + 10 ;
}

- (void)setObject:(id)item
{
    UIButton *button = (id)[self viewWithTag:1000];
    [button setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    
    if ([[[AudioPlayer shareInstance] audioUrl] isEqualToString:[item objectForKey:@"address"]]) {
        [button setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    }
    
    NSLog(@"item %@" ,item);
    if ([self.musicDto parse2:item]) {
        //        [[AudioPlayer shareInstance] configurationButtonImages:self.musicDto.musicUrl];
        
        // 把播放列表传入播放器
        NSMutableArray *mArray = [NSMutableArray array];
        for (int i = 0; i < self.musicArray.count; i ++) {
            NSDictionary *mDict = [self.musicArray objectAtIndex:i];
            if ([mDict objectForKey:@"address"]) {
                [mArray addObject:[mDict objectForKey:@"address"]];
            }
        }
//        if (mArray.count>0) {
//            ((AudioPlayer *)[AudioPlayer shareInstance]).musicUrlArray = mArray;
//        }
        UIButton *loveButton = (id)[self viewWithTag:1001];
        [loveButton setSelected:NO];
        // 判断音乐url 是否已经存在于本地
        NSMutableArray *localArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"OffLineMusic"];
        for (int i = 0; i < localArray.count;  i ++) {
            NSDictionary *dict = [localArray objectAtIndex:i];
            if ([[dict objectForKey:@"address"] isEqualToString:self.musicDto.musicUrl]) {
                [loveButton setSelected:YES];
            }
        }
        
        self.topicLabel.text = self.musicDto.descripTion;
        self.topicLabel.height = self.topicLabel.optimumSize.height + 5;
        [self.topicImageView setImageWithURL:[NSURL URLWithString:self.musicDto.imageUrl]];
        musicName = self.musicDto.name;
        

//        [(UIButton *)[self viewWithTag:1001] setSelected:love];
    }
}

#pragma mark - AWActionSheetDelegateAndMethod
- (void)showAWSheet{
    //NSString *accountID = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initwithIconSheetDelegate:self ItemCount:[self numberOfItemsInActionSheet] delButton:NO];
    sheet.tag = 104;
    [sheet showInView:self];
}

-(CustomActionSheetCell *)cellForActionAtIndex:(NSInteger)index
{
    // 当isButton == YES ,cell.iconButton 需添加图片
    // 当isButton == NO  ,cell.iconView  需添加图片
    CustomActionSheetCell* cell = [[CustomActionSheetCell alloc] initIsButton:YES];
    
    NSMutableArray *iconsArray = [[NSMutableArray alloc] initWithObjects:
                                  @"sns_icon_sina.png",
                                  @"sns_icon_tencent_zone.png",
                                  @"sns_icon_tencent_weibo.png",
                                  @"sns_icon_renren.png",
                                  @"sns_icon_message.png",
                                  @"sns_icon_copy.png",
                                  @"delete_movie.png",
                                  nil];
    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:
                                  @"新浪微博",
                                  @"QQ空间",
                                  @"腾讯微博",
                                  @"人人网",
                                  @"短信分享",
                                  @"复制链接",
                                  @"删除视频",
                                  nil];
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        [iconsArray insertObject:@"sns_icon_weixin.png" atIndex:3];
        [iconsArray insertObject:@"sns_icon_weixin_friends.png" atIndex:4];
        [titleArray insertObject:@"微信" atIndex:3];
        [titleArray insertObject:@"微信朋友圈" atIndex:4];
        if ([[QQApiHelper shareInstance] checkQQ]) {
            [iconsArray insertObject:@"sns_icon_QQ.png" atIndex:1];
            [titleArray insertObject:@"QQ" atIndex:1];
        }
    }
    else{
        if ([[QQApiHelper shareInstance] checkQQ]) {
            [iconsArray insertObject:@"sns_icon_QQ.png" atIndex:1];
            [titleArray insertObject:@"QQ" atIndex:1];
        }
    }
    
    [[cell iconButton] setImage:[UIImage imageNamed:[iconsArray objectAtIndex:index]] forState:UIControlStateNormal];
    [[cell titleLabel] setText:[titleArray objectAtIndex:index]];
    
    cell.index = index;
    return cell;
}

-(int)numberOfItemsInActionSheet
{
    int cellCount = sheetCellCount;
    
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]){
        cellCount -= 2;
    }
    
    if (![[QQApiHelper shareInstance] checkQQ]) {
        cellCount --;
    }
    
    //    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"account"] isEqualToString:_leboDTO.iD]) {
    //        cellCount --;
    //    }
    
    return cellCount;
}

-(void)DidTapOnItemAtIndex:(NSInteger)index
{
    NSLog(@"tap on %d",index);
    
    NSMutableArray *actionArray = [NSMutableArray arrayWithObjects:
                                   NSStringFromSelector(@selector(shareSinaWeibo:)),
                                   NSStringFromSelector(@selector(shareToTencentZone:)),
                                   NSStringFromSelector(@selector(shareToQQWeibo:)),
                                   NSStringFromSelector(@selector(shareVideoToRenren:)),
                                   NSStringFromSelector(@selector(shareToMessage:)),
                                   NSStringFromSelector(@selector(copyMethod:)),
                                   NSStringFromSelector(@selector(deleteOneMovie:)),
                                   nil];
    
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
        [actionArray insertObject: NSStringFromSelector(@selector(shareToWeiXin:)) atIndex:3];
        [actionArray insertObject:NSStringFromSelector(@selector(shareToWeiXinFriends:)) atIndex:4];
        if ([[QQApiHelper shareInstance] checkQQ]) {
            [actionArray insertObject: NSStringFromSelector(@selector(shareToQQ:)) atIndex:1];
        }
    }
    else{
        if ([[QQApiHelper shareInstance] checkQQ]) {
            [actionArray insertObject: NSStringFromSelector(@selector(shareToQQ:)) atIndex:1];
        }
    }
    
    
    SEL sel = NSSelectorFromString([actionArray objectAtIndex:index]);
    [self performSelector:sel withObject:self.musicDto afterDelay:0.0f];
    
    return;
}


#define mark - sinashare

- (void)sinaDidLogin:(NSDictionary *)userInfo{
    [self initSinaWeiboShare:self.musicDto];
}


- (void)sinaDidFailLogin:(NSError *)error{
    NSLog(@"新浪登录失败,%@", error);
}

- (void)shareSinaWeibo:(LeboDTO *)dto
{
    [MobClick event:@"3" label:@"音乐新浪分享点击数"];
    [self pauseVideoClear];
    if ([[SinaHelper getHelper] sinaIsAuthValid]) {
        [self initSinaWeiboShare:dto];
    }else{
        [SinaHelper getHelper].delegate = self;
        [[SinaHelper getHelper] login];
    }
}

- (void)pauseVideoClear
{
    [LBMovieView pauseAll];
    [Global clearPlayStatus];
}

- (void)initSinaWeiboShare:(LeboDTO *)dto{
    LBShareViewController *sinaShare = [[LBShareViewController alloc]init];
    sinaShare.shareType = ShareToSina;
    sinaShare.movieTitle = dto.text;
    NSString *movieUrl = [NSString stringWithFormat:@"%@%@", [Global getShareUrl], [dto.ID lastPathComponent]];
    sinaShare.movieUrl = movieUrl;      //url+视频ID
    sinaShare.thumbImage = nil;
    sinaShare.authorName = dto.screenName;
    sinaShare.actionType = Invite;
    [currentNaVC pushViewController:sinaShare animated:YES];
    [MobClick event:@"10" label:@"新浪分享"];
    NSLog(@"shareVideo");
}

- (void)sinaUpdateSuccess:(id)result{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"分享成功"];
}

- (void)sinaUpdateFail:(NSError *)error{
    NSLog(@"error  %@",error);
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"分享失败"];
}

#pragma mark - QQ
- (void)shareToQQ:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"音乐QQ分享点击数"];
    
    [[QQApiHelper shareInstance] sendAudioMessageImage:self.topicImageView.image urlStr:self.musicDto.musicUrl title:MusicDefaultShareTitle description:self.musicDto.descripTion];
}

#pragma mark - Copy
- (void)copyMethod:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"音乐copy链接点击数"];
    NSString *movieUrl = [NSString stringWithFormat:@"%@%@", [Global getShareUrl], [dto.ID lastPathComponent]];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:movieUrl];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"拷贝成功"];
}

#pragma mark - MessageShare
- (void)shareToMessage:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"音乐短信分享点击数"];
    [self showSMSPicker];
}

- (void)showSMSPicker{
    Class messageClass = NSClassFromString(@"MFMessageComposeViewController");
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备没有短信功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

- (void)displaySMSComposerSheet{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.body = MessageDefult;
    [currentNaVC presentViewController:picker animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result){
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备没有短信功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    [currentNaVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WeixinShareMethod

// isSceneSession == YES  为微信对话 isSceneSession == NO 为微信朋友圈
- (void)sendMusicContent:(LeboDTO *)dto
{
    LBAppDelegate *lbDelegate = (LBAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (lbDelegate && [lbDelegate respondsToSelector:@selector(sendMusicContent:title:thumbImage:musicUrl:)])
    {
        if (isSceneSession) {
            [lbDelegate changeScene:WXSceneSession];
        }else{
            [lbDelegate changeScene:WXSceneTimeline];
        }
        
        [lbDelegate sendMusicContent:self.musicDto.descripTion title:self.musicDto.descripTion thumbImage:self.topicImageView.image musicUrl:self.musicDto.musicUrl];
        
        [MobClick event:@"10" label:@"音乐微信朋友圈分享"];
    }
}


- (void)shareToWeiXin:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"音乐微信好友分享点击数"];
    isSceneSession = YES;
    [self performSelector:@selector(sendMusicContent:) withObject:self.musicDto afterDelay:0.0f];
}

- (void)shareToWeiXinFriends:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"音乐微信朋友圈分享点击数"];
    isSceneSession = NO;
    [self performSelector:@selector(sendMusicContent:) withObject:self.musicDto afterDelay:0.0f];
}

#pragma mark - LeBoDelegate
- (void)movieIDResponseSuccess:(id)result{
    NSLog(@"movieIDresult %@", [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
}

- (void)movieIDResponseFail:(NSError *)error{
    NSLog(@"movieIDerror %@",error);
}

#pragma mark - RenrenDelegate Method
// 人人分享VC
- (void)initRenRenShareVC{
    LBShareViewController *shareToRenRen = [[LBShareViewController alloc] init];
    shareToRenRen.shareType = ShareToRenRen;
    NSString *movieUrl = self.musicDto.musicUrl;
    shareToRenRen.movieUrl = movieUrl;
    shareToRenRen.movieTitle = self.musicDto.descripTion;
    shareToRenRen.actionType = Invite;
    //if (self.leboDTO.MovieID)
    {
        [currentNaVC pushViewController:shareToRenRen animated:YES];
    }
}

// 人人登陆
- (void)shareVideoToRenren:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"音乐人人网分享点击数"];
//    if([RenRenHelper isAuthorizeValid]){
//        [self initRenRenShareVC];
//    }else{
        [self performSelector:@selector(loginRenren) withObject:nil afterDelay:0.5f];
//    }
}

- (void)loginRenren{
//    [RenRenHelper renrenLoginTarget:self];
    [LBMovieView pauseAll];
    [Global clearPlayStatus];
}

// 登陆成功回调
- (void)renRenLoginSuccess{
    [self initRenRenShareVC];
}

// 登陆失败回调
- (void)renRenLoginFail{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"登陆失败"];
}

#pragma mark - QQWeibo Method
- (void)shareToQQWeibo:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"音乐QQ微博分享点击数"];

    if ([TencentHelper isSessionValid]) {
        [self tencentPushVCIsZone:NO];
    }else{
        [TencentHelper login:self naVC:currentNaVC];
        tecentType = QWeibo;
    }
}


#pragma mark - tencentZone

- (void)tencentPushVCIsZone:(BOOL)isZone{
    LBShareViewController *share = [[LBShareViewController alloc] init];
    
    if (isZone) {
        share.shareType = ShareToQQZone;
    }else{
        share.shareType = ShareToQQWeibo;
    }
    
    share.shareToQQZoneMovieURL = [NSString stringWithFormat:@"http://www.lebooo.com/movie/player.swf?vcastr_file=%@&IsAutoPlay=1&IsContinue=1&IsShowBar=0", self.musicDto.musicUrl];
    NSString *movieUrl = self.musicDto.musicUrl;
    share.movieUrl = movieUrl;
    share.photoUrl = self.musicDto.imageUrl;
    share.movieTitle = self.musicDto.descripTion;
    share.thumbImage = nil;
    share.actionType = Invite;
    [currentNaVC pushViewController:share animated:YES];
}

- (void)shareToTencentZone:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"音乐QQ空间分享点击数"];
    if ([TencentHelper isSessionValid]) {
        [self tencentPushVCIsZone:YES];
    }else{
        [TencentHelper login:self naVC:currentNaVC];
        tecentType = QZone;
    }
}

- (void)tencentDidLoginSuccess{
    NSLog(@"loginSuccess");
    if (tecentType == QZone) {
        [self tencentPushVCIsZone:YES];
    }else if (tecentType == QWeibo){
        [self tencentPushVCIsZone:NO];
    }
}

- (void)tencentDidNotLogin:(NSNumber *)cancelled{
    if (cancelled) {
        NSLog(@"取消登录");
    }else{
        NSLog(@"loginFail");
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"登录失败"];
    }
}

#pragma mark -  LongPressGuesture
- (void)longPressToSavePhoto:(UILongPressGestureRecognizer *)gesture{
    if (self.topicImageView.image) {
        if (!actionSheet) {
              actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"不保存" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        }
        
        [actionSheet showInView:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(self.topicImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"保存错误，请重试"];
        
    }
    else  // No errors
    {
         [[TKAlertCenter defaultCenter] postAlertWithMessage:@"照片保存成功"];
        // Show message image successfully saved
    }
}



@end
