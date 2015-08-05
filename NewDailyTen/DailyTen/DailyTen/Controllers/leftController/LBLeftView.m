//
//  LBLeftView.m
//  DailyTen
//
//  Created by King on 13-9-9.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#define PLAYVIEW_WIDTH 300.
#define PLAYVIEW_HEIGHT 300.
#define PLAYVIEW_HEAD 50.
#define PLAYVIEW_TAIL 42.

#define sheetCellCount 6

#import "LBLeftView.h"
#import <QuartzCore/QuartzCore.h>
#import "LBFileClient.h"

@implementation LBLeftView
@synthesize playerVideoView = _playerVideoView;
@synthesize instructionLabel = _instructionLabel;
@synthesize timeLabel = _timeLabel;
@synthesize nameLabel = _nameLabel;
@synthesize playCountLabel = _playCountLabel;
@synthesize avatarImage = _avatarImage;
@synthesize likedButton = _likedButton;
@synthesize commentButton =_commentButton;
@synthesize moreButton = _moreButton;
@synthesize imageViewBackground = _imageViewBackground;
//@synthesize leboDTO = _leboDTO;
@synthesize relayButton = _relayButton;
@synthesize recommendImageView = _recommendImageView;
@synthesize commentView = _commentView;
@synthesize deleteBtn = _deleteBtn;
@synthesize tempTailView = _tempTailView;
@synthesize followBtn = _followBtn;
@synthesize selectDto = _selectDto;
@synthesize customImageView = _customImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
    UIImage *image = [UIImage imageNamed:@"clip_view_background.png"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    
    if (!self.imageViewBackground) {
        self.imageViewBackground=[[UIImageView alloc] initWithImage:image];
    }
    [_imageViewBackground setFrame:CGRectMake(7, 0, 306, 100)];
    [_imageViewBackground setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview:_imageViewBackground];
    
    UIView *tempHeadView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, PLAYVIEW_WIDTH, PLAYVIEW_HEAD)];
    [tempHeadView setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    if (!self.avatarImage) {
        self.avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(7, 9, 35, 35)];
    }
    //_avatarImage.centerY = tempHeadView.centerY;
    [_avatarImage setBackgroundColor:RGB(234, 234, 234)];
    [_avatarImage.layer setCornerRadius:2.];
    [_avatarImage setClipsToBounds:YES];
    [_avatarImage setUserInteractionEnabled:YES];
//    [_avatarImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)]];
    [tempHeadView addSubview:_avatarImage];
    
    if (!self.nameLabel) {
        self.nameLabel = [[RTLabel alloc] initWithFrame:CGRectMake(_avatarImage.right + 10, 0, 300 - _avatarImage.right - 30 - 10 - 10, 25)];
    }
    _nameLabel.top = _avatarImage.top;
    _nameLabel.delegate = self;
    _nameLabel.tag = 101;
    _nameLabel.userInteractionEnabled = YES;
    [_nameLabel setLineBreakMode:RTTextLineBreakModeWordWrapping];
    [_nameLabel setLineSpacing:1];
    [_nameLabel setTextColor:[UIColor colorWithRed:255./255. green:102./255. blue:0./255. alpha:1.0]];
    [_nameLabel setTextAlignment:UITextAlignmentLeft];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    [tempHeadView addSubview:_nameLabel];
    
    if (!self.followBtn) {
        self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    [_followBtn setFrame:CGRectMake(tempHeadView.right - 50, 0, 40, _nameLabel.height)];
    [_followBtn setImage:[UIImage imageNamed:@"add_attend"] forState:UIControlStateNormal];
    [_followBtn setBackgroundColor:[UIColor blackColor]];
    [_followBtn addTarget:self action:@selector(followVideo:) forControlEvents:UIControlEventTouchUpInside];
    [_followBtn setBackgroundColor:[UIColor clearColor]];
    [_followBtn setUserInteractionEnabled:YES];
    _followBtn.centerY = self.nameLabel.centerY;
    [tempHeadView addSubview:_followBtn];
    
    if (!self.timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImage.right + 10, _avatarImage.bottom - 10, 150, 10)];
    }
    [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    [_timeLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    [_timeLabel setText:@""];
    [_timeLabel setTextColor:[UIColor colorWithRed:101./255. green:101./255. blue:101./255. alpha:1.0]];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    [_timeLabel setAdjustsFontSizeToFitWidth:YES];
    [tempHeadView addSubview:_timeLabel];
    if (!self.playCountLabel) {
        self.playCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempHeadView.width - 110, _timeLabel.top, 100, 10)];
    }
    [_playCountLabel setTextAlignment:NSTextAlignmentRight];
    [_playCountLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [_playCountLabel setBackgroundColor:[UIColor clearColor]];
    [_playCountLabel setText:@""];
    [_playCountLabel setTextColor:[UIColor colorWithRed:101./255. green:101./255. blue:101./255. alpha:1.0]];
    _playCountLabel.userInteractionEnabled = YES;
    
    _playCountLabel.font=[UIFont systemFontOfSize:10];
    [_playCountLabel setAdjustsFontSizeToFitWidth:YES];
    [tempHeadView addSubview:_playCountLabel];
    [self addSubview:tempHeadView];
    
     if(!self.playerVideoView)
     self.playerVideoView = [[LBMovieView alloc] initWithFrame:CGRectMake(tempHeadView.left, tempHeadView.bottom, PLAYVIEW_WIDTH, PLAYVIEW_HEIGHT)];
     _playerVideoView.backgroundColor = RGB(234, 234, 234);
     [self addSubview:_playerVideoView];
    
    if(!self.instructionLabel)
        self.instructionLabel = [[RTLabel alloc] initWithFrame:CGRectMake(_playerVideoView.left + 10, _playerVideoView.bottom + 10, _playerVideoView.width - 20, 10)];
    [_instructionLabel setBackgroundColor:[UIColor clearColor]];
    [_instructionLabel setTextColor:[UIColor colorWithRed:64./255. green:64./255. blue:64./255. alpha:1.0]];
    [_instructionLabel setText:@""];
    [_instructionLabel setFont:[UIFont systemFontOfSize:14]];
    [_instructionLabel setLineSpacing:5];
    _instructionLabel.userInteractionEnabled = YES;
    [_instructionLabel setDelegate:self];
    _instructionLabel.tag = 102;
    [self addSubview:_instructionLabel];
    
    if(!self.tempTailView)
        self.tempTailView = [[UIView alloc] initWithFrame:CGRectMake(_playerVideoView.left , _instructionLabel.bottom + 10, PLAYVIEW_WIDTH, PLAYVIEW_TAIL)];
    [_tempTailView setUserInteractionEnabled:YES];
    [_tempTailView setTag:10];
    [_tempTailView setBackgroundColor:[UIColor clearColor]];

    
    if (!self.customImageView) {
        self.customImageView = [self createButtonAndTitle];
        self.customImageView.top = 0;
        [_tempTailView addSubview:self.customImageView];
    }
    
    
    [self addSubview:_tempTailView];
    if(!self.commentView)
        self.commentView = [[UIView alloc] initWithFrame:CGRectZero];
    [_commentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCommentView:)]];
    [self addSubview:_commentView];
    
    UIImage *recommendImage = [UIImage imageNamed:@"recommend"];
    self.recommendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_playerVideoView.right - recommendImage.size.width - 20, 10, recommendImage.size.width, recommendImage.size.height)];
    [_recommendImageView setImage:recommendImage];
    if(!self.deleteBtn)
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setFrame:CGRectMake(0, 0, 100, 100)];
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn_select"] forState:UIControlStateHighlighted];
    [_deleteBtn setBackgroundColor:[UIColor blackColor]];
    [_deleteBtn addTarget:self action:@selector(deleteVideo) forControlEvents:UIControlEventTouchUpInside];
    
    //[self makeData];
}

- (UIImageView *)createButtonAndTitle{
    NSArray *iconsArray = [NSArray arrayWithObjects:@"weixinFriends.png", @"weixin.png",@"sinaweibo.png", @"share1.png" , nil];
    UIImageView *mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    mImageView.userInteractionEnabled = YES;
    for (int i = 0 ;i < 4 ;i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 + 75*i, 0, 60, 44);
        button.tag = 200+i;
        [button setImage:[UIImage imageNamed:[iconsArray objectAtIndex:i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [mImageView addSubview:button];
    }
  
    return mImageView;
}

- (void)buttonClicked:(UIButton *)sender{
    if (sender.tag == 200) {
        [self shareToWeiXinFriends:self.leboDTO];
    }else if (sender.tag == 201){
        [self shareToWeiXin:self.leboDTO];
    }else if (sender.tag == 202){
        [self shareSinaWeibo:self.leboDTO];
    }
    else if (sender.tag == 203){
        currentNaVC = (UINavigationController *)([UIApplication sharedApplication].keyWindow.rootViewController);
        [self showAWSheet];
    }
}

- (void)layoutSubviews
{
    //UITableView
	CGSize optimumSize = [self.instructionLabel optimumSize];
	CGRect frame = [self.instructionLabel frame];
	frame.size.height = (int)optimumSize.height + 5;
    CGFloat height = 0;
    CGFloat height1 = .0;
    
	[self.instructionLabel setFrame:frame];
    UIView *view = [self viewWithTag:10];
    
    if(view)
    {
        NSString* instructionText = _instructionLabel.text;//[_instructionLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        if(![_instructionLabel.text isEqualToString:@""] && [instructionText length] > 0)
        {
            height1 = self.instructionLabel.bottom + 10;
        }
        else
        {
            height1 = _playerVideoView.bottom;
        }
        
        [_tempTailView setTop:height1];
        
    }
    
    if (_leboDTO.commentsCount) {
        
        [self addSubview:_commentView];
        if([_leboDTO.comments count] != 0 && [_leboDTO.comments isKindOfClass:[NSArray class]])
        {
            //height += [LBLetfView getHeight:_leboDTO.comments commentCount:[NSNumber numberWithInt:_leboDTO.commentsCount]];
            //[commentObj intValue] * 44;
        }
        [_commentView setFrame:CGRectMake(10, _tempTailView.bottom + 1, 300, height)];
    } else {
        [_commentView removeFromSuperview];
    }
}

- (UIButton*)createButton:(SEL)selector title:(NSString*)title image:(NSString*)image backGroundImage:(NSString*)backGroundImage backGroundTapeImage:(NSString*)backGroundTapeImage frame:(CGRect)frame tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTag:tag];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_select",image]] forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:[UIImage imageNamed:backGroundImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:backGroundTapeImage] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:143./255. green:143./255. blue:143./255. alpha:1.] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    //    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    //    [button.titleLabel setShadowColor:[UIColor blackColor]];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)btnTapped:(UIButton*)sender
{
    currentNaVC = (UINavigationController *)([UIApplication sharedApplication].keyWindow.rootViewController);
    [self showAWSheet];
    [MobClick event:@"3" label:@"视频分享"];
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
    // 当isButton == NO，  cell.iconView  需添加图片
    CustomActionSheetCell* cell = [[CustomActionSheetCell alloc] initIsButton:YES];
    
    NSMutableArray *iconsArray = [[NSMutableArray alloc] initWithObjects:
                                  @"sns_icon_tencent_zone.png",
                                  @"sns_icon_tencent_weibo.png",
                                  @"sns_icon_renren.png",
                                  @"sns_icon_message.png",
                                  @"sns_icon_copy.png",
                                  nil];
    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:
                                  @"QQ空间",
                                  @"腾讯微博",
                                  @"人人网",
                                  @"短信分享",
                                  @"复制链接",
                                  nil];
    
//    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
//    {
//        [iconsArray insertObject:@"sns_icon_weixin.png" atIndex:3];
//        [iconsArray insertObject:@"sns_icon_weixin_friends.png" atIndex:4];
//        [titleArray insertObject:@"微信" atIndex:3];
//        [titleArray insertObject:@"微信朋友圈" atIndex:4];
//        if ([[QQApiHelper shareInstance] checkQQ]) {
//            [iconsArray insertObject:@"sns_icon_QQ.png" atIndex:1];
//            [titleArray insertObject:@"QQ" atIndex:1];
//        }
//    }
//    else{
        if ([[QQApiHelper shareInstance] checkQQ]) {
            [iconsArray insertObject:@"sns_icon_QQ.png" atIndex:1];
            [titleArray insertObject:@"QQ" atIndex:1];
        }
//    }
    
    
    [[cell iconButton] setImage:[UIImage imageNamed:[iconsArray objectAtIndex:index]] forState:UIControlStateNormal];
    [[cell titleLabel] setText:[titleArray objectAtIndex:index]];
    
    cell.index = index;
    return cell;
}

-(int)numberOfItemsInActionSheet
{
    
    int cellCount = sheetCellCount;
    
//    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]){
//        cellCount -= 2;
//    }
    
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
                                   NSStringFromSelector(@selector(shareToTencentZone:)),
                                   NSStringFromSelector(@selector(shareToQQWeibo:)),
                                   NSStringFromSelector(@selector(shareVideoToRenren:)),
                                   NSStringFromSelector(@selector(shareToMessage:)),
                                   NSStringFromSelector(@selector(copyMethod:)),
                                   NSStringFromSelector(@selector(deleteOneMovie:)),
                                   nil];
    
    
//    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
//        [actionArray insertObject: NSStringFromSelector(@selector(shareToWeiXin:)) atIndex:3];
//        [actionArray insertObject:NSStringFromSelector(@selector(shareToWeiXinFriends:)) atIndex:4];
//        if ([[QQApiHelper shareInstance] checkQQ]) {
//            [actionArray insertObject: NSStringFromSelector(@selector(shareToQQ:)) atIndex:1];
//        }
//    }
//    else{
        if ([[QQApiHelper shareInstance] checkQQ]) {
            [actionArray insertObject: NSStringFromSelector(@selector(shareToQQ:)) atIndex:1];
        }
//    }
    
    
    SEL sel = NSSelectorFromString([actionArray objectAtIndex:index]);
    [self performSelector:sel withObject:_leboDTO afterDelay:0.0f];
    
    return;
}

/*
#define mark -
- (void)setLikedButtonState:(UIButton *)sender like:(BOOL)like
{
    int nValue = 0;
    if(like)
    {
        nValue = [sender.titleLabel.text intValue];
        [sender setTitle:[NSString stringWithFormat:@"%d",nValue + 1] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"btn_like_icon_select"] forState:UIControlStateNormal];
        [sender setImageEdgeInsets:UIEdgeInsetsMake(0,-10,0,0)];
        [sender setTag:1];
        [self likedTapped:_leboDTO like:like];
    }
    else
    {
        nValue = [sender.titleLabel.text intValue] - 1;
        
        [sender setTitle:nValue == 0?@" ":[NSString stringWithFormat:@"%d", nValue] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"btn_like_icon"] forState:UIControlStateNormal];
        [sender setImageEdgeInsets:UIEdgeInsetsMake(0,nValue > 0? -10:0,0,0)];
        [sender setTag:0];
        [self likedTapped:_leboDTO like:like];
    }
}

- (void)likedTapped:(LeboDTO *)dto like:(BOOL)like
{
    nType = 2;
    self.selectDto = dto;
    if (like) {
        //[[LBFileClient sharedInstance] loveTopic:dto.ID cachePolicy:NSURLRequestReloadRevalidatingCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
    }
    else
    {
        //[[LBFileClient sharedInstance] unLoveTopic:dto.ID cachePolicy:NSURLRequestReloadRevalidatingCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
    }
}
*/
/*
- (void)setRelayButtonState:(UIButton *)sender relay:(BOOL)relay
{
    int nValue = 0;
    if(relay)
    {
        nValue = [sender.titleLabel.text intValue];
        [sender setTitle:[NSString stringWithFormat:@"%d",nValue + 1] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"btn_relay_icon_select"] forState:UIControlStateNormal];
        [sender setImageEdgeInsets:UIEdgeInsetsMake(0,-10,0,0)];
        [sender setTag:4];
        [self relayVideo:_leboDTO relay:relay];
    }
    else
    {
        nValue = [sender.titleLabel.text intValue] - 1;
        
        [sender setTitle:nValue == 0?@" ":[NSString stringWithFormat:@"%d", nValue] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"btn_relay_icon"] forState:UIControlStateNormal];
        [sender setImageEdgeInsets:UIEdgeInsetsMake(0,nValue > 0? -10:0,0,0)];
        [sender setTag:3];
        [self relayVideo:_leboDTO relay:relay];
    }
}

- (void)relayVideo:(LeboDTO *)dto relay:(BOOL)relay
{
    nType = 3;
    self.selectDto = dto;
    
    if (relay) {
        //[[LBFileClient sharedInstance] broadcastTopic:dto.ID cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
    } else {
        //[[LBFileClient sharedInstance] unBroadcastTopic:dto.originStatusID cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        
    }
}
*/

+ (CGFloat)rowHeightForObject:(id)item
{
    float height = .0;
    
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        __autoreleasing LeboDTO *leboDTO = [[LeboDTO alloc] init];
        if([leboDTO parse2:item])
        {
            if(leboDTO.text && [leboDTO.text length] > 0)
            {
                __autoreleasing RTLabel *label = [[RTLabel alloc] initWithFrame: CGRectMake(10,10,280,0)];
                [label setFont:[UIFont systemFontOfSize:14]];
                [label setLineSpacing:5];
                [LBLeftView getChannelRangeForChannel:leboDTO.text label:label];
                [LBLeftView getChannelRangeforAT:leboDTO.text append:NO label:label item:leboDTO];
                height = 20  +  label.optimumSize.height ;
            }
            else
            {
                height = 0;
            }
            
            id commentObj = leboDTO.comments;
            if(commentObj &&[(NSArray *)commentObj count] != 0 && [commentObj isKindOfClass:[NSArray class]])
            {
                //                height += 48*([(NSArray *)commentObj count] > 3?3:[(NSArray *)commentObj count]);
                for (int i = 0; i < [(NSArray *)commentObj count]; i ++) {
                    //height +=  [LBOnlyCommentView rowHeightForObject:[commentObj objectAtIndex:i]];
                }
            }
        }
    }
    return PLAYVIEW_HEIGHT + PLAYVIEW_HEAD + PLAYVIEW_TAIL + height + 12;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        if (!self.leboDTO) {
            self.leboDTO = [[LeboDTO alloc] init];
        }
        
        if([_leboDTO parse2:item])
        {
            // 备份帖子
            if (_leboDTO.profileImageUrl .length > 0 && [[_leboDTO.profileImageUrl substringToIndex:4] isEqualToString:@"http"]) {
                [_avatarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _leboDTO.profileImageUrl]]];
            } else
                [_avatarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerBaseUrl], _leboDTO.profileImageUrl]]];
            
            UIFont *font = [UIFont systemFontOfSize:14];
            
            if (!_leboDTO.originStatus) {
                [_nameLabel setText:[NSString stringWithFormat:@"<a #='%@'><font face=%@ size=14  color='#ff6600'>%@</font></a>",_leboDTO.screenName,font.fontName,_leboDTO.screenName]];
            } else {
                [_nameLabel setText:[NSString stringWithFormat:@"<a #='%@'><font face=%@ size=14  color='#ff6600'>%@</font></a><font face=Futura size=12 color='#656565'>由</font><a #='%@'><font face=Futura size=12 color='#ff6600'>%@</font></a><font face=Futura size=12 color='#838383'>转播</font>", _leboDTO.screenName, font.fontName, _leboDTO.screenName, [_leboDTO.reprintUser objectForKey:@"screenName"], [_leboDTO.reprintUser objectForKey:@"screenName"]]];
            }
            
            [_playCountLabel setText:[NSString stringWithFormat:@"%d 播放",_leboDTO.topicViewCount + 1]];
            [_instructionLabel setText:@""];
            if(_leboDTO.text)
            {
                [self getChannelRangeForChannel:_leboDTO.text];
                [self getChannelRangeforAT:_instructionLabel.text append:NO];
            }
            //[_instructionLabel setHeight:0];
            [_likedButton setTitle:_leboDTO.topicFavoritesCount == 0?@" ":[NSString stringWithFormat:@"%d",_leboDTO.topicFavoritesCount] forState:UIControlStateNormal];
            [_likedButton setImageEdgeInsets:UIEdgeInsetsMake(0,_leboDTO.topicFavoritesCount > 0?-10:0,0,0)];
            [_likedButton setImage: [UIImage imageNamed:_leboDTO.favorited == 1?@"btn_like_icon_select":@"btn_like_icon"] forState:UIControlStateNormal];
            _likedButton.tag = [[NSNumber numberWithBool:_leboDTO.favorited] integerValue];
            
            [_relayButton setTitle:_leboDTO.repostsCount == 0?@" ":[NSString stringWithFormat:@"%d",_leboDTO.repostsCount] forState:UIControlStateNormal];
            [_relayButton setImageEdgeInsets:UIEdgeInsetsMake(2,_leboDTO.repostsCount > 0?-10:0,0,0)];
            [_relayButton setImage: [UIImage imageNamed:_leboDTO.reposted == 1?@"btn_relay_icon_select":@"btn_relay_icon"] forState:UIControlStateNormal];
            _relayButton.tag = _leboDTO.reposted > 0?4:3;
            
            //[_commentButton setTitle:_leboDTO.commentsCount == 0?@" ":[NSString stringWithFormat:@"%d",_leboDTO.commentsCount] forState:UIControlStateNormal];
            //[_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0,_leboDTO.commentsCount > 0?-10:0,0,0)];
            [_timeLabel setText:_leboDTO.topicCreatedAt];
            
            //[_playerVideoView setImageId:nil];
            dispatch_async(dispatch_get_current_queue(), ^{
                [_playerVideoView setImageIdFroCache:_leboDTO.photoUrl];
            });
            //[_playerVideoView setMovieId:nil];
            [_playerVideoView setImageId:_leboDTO.photoUrl];
            [_playerVideoView setMovieId:_leboDTO.movieUrl];
            
            [_playerVideoView setMovieId:@"http://js.tudouui.com/bin/player2/olc_8.swf?iid=227538343&swfPath=http://js.tudouui.com/bin/lingtong/SocialPlayer_163.swf&tvcCode=-1&tag=%E6%80%A7%E6%84%9F%E7%83%AD%E8%88%9E%2C%E7%BE%8E%E5%A5%B3%E8%A7%86%E9%A2%91&title=%E5%85%81%E7%86%9920150403++13&mediaType=vi&totalTime=200000&hdType=1&hasPassword=1&nWidth=-1&isOriginal=0&channelId=14&nHeight=-1&banPublic=false&videoOwner=437024124&videoOwner=437024124&ocode=Y3K3QVu-x_M&tict=3&channelId=14&cs=&k=%E6%80%A7%E6%84%9F%E7%83%AD%E8%88%9E|%E7%BE%8E%E5%A5%B3%E8%A7%86%E9%A2%91&panelRecm=http://css.tudouui.com/bin/lingtong/PanelRecm_9.swz&panelDanmu=http://css.tudouui.com/bin/lingtong/PanelDanmu_18.swz&panelEnd=http://css.tudouui.com/bin/lingtong/PanelEnd_13.swz&pepper=http://css.tudouui.com/bin/binder/pepper_17.png&panelShare=http://css.tudouui.com/bin/lingtong/PanelShare_7.swz&panelCloud=http://css.tudouui.com/bin/lingtong/PanelCloud_12.swz&hasWaterMark=1&autoPlay=false&listType=0&rurl=&amp;resourceId=28965907_04_05_99&amp;rpid=28965907&autostart=false&snap_pic=http%3A%2F%2Fg4.tdimg.com%2Fee3bbf186df831f24bfe132054b17b64%2Fw_2.jpg&code=XXL9vSdz4zQ&aopRate=0.001&p2pRate=0.95&adSourceId=81000&yjuid=null&yseid=null&yseidtimeout=null&yseidcount=null&uid=null&juid=null&vip=0"];
            if(_leboDTO.digest == 1)
            {
                [_recommendImageView removeFromSuperview];
                [_playerVideoView.contentView addSubview:_recommendImageView];
            }
            else
            {
                [_recommendImageView removeFromSuperview];
            }
            
            if(_leboDTO.comments && [_leboDTO.comments isKindOfClass:[NSArray class]])
            {
                //[_commentView setCommentItem:_leboDTO.comments commentCount:[NSNumber numberWithInt:_leboDTO.commentsCount]];
            }
            else
            {
                //[_commentView setCommentItem:nil commentCount:nil];
            }
            
            if(_leboDTO.bilateral == 1)
            {
                [_followBtn setHidden:YES];
                [_nameLabel setWidth:300 - _avatarImage.right - 30];
            }
            else
            {
                //if(_leboDTO.isFriend == 1 || [_leboDTO.iD isEqualToString:[[AccountHelper getAccount] ID]])
                if(_leboDTO.isFriend == 1)
                {
                    [_followBtn setHidden:YES];
                    [_nameLabel setWidth:300 - _avatarImage.right - 30];
                }
                else
                {
                    [_followBtn setHidden:NO];
                    [_followBtn setImage:[UIImage imageNamed:@"add_attend"] forState:UIControlStateNormal];
                    [_nameLabel setWidth:300 - _avatarImage.right - 50];
                }
            }
        }
    }
    
    [self setNeedsLayout];
}

+ (void)getChannelRangeForChannel:(NSString*)comment label:(RTLabel*)_instructionLabel
{
    NSRange rangeFrom = [comment rangeOfString: @"#"];
    
    if (rangeFrom.length)
    {
        [_instructionLabel setText:[NSString stringWithFormat:@"%@%@", _instructionLabel.text, [comment substringToIndex:rangeFrom.location]]];
        
        NSString *rangeText = [comment substringFromIndex:rangeFrom.location + 1];
        NSRange rangeTo = [rangeText rangeOfString: @"#"];
        if(rangeTo.length)
        {
            NSString *filter = [NSString stringWithFormat:@"#%@", [rangeText substringWithRange:NSMakeRange(0, rangeTo.location+ 1)]];
            [_instructionLabel setText:[NSString stringWithFormat:@"%@<a #='%@'><font face=Futura size=14 color='#3F89C6'>%@</font></a>",_instructionLabel.text,filter, filter]];
            
            [LBLeftView getChannelRangeForChannel:[rangeText substringFromIndex:rangeTo.location + 1] label:_instructionLabel];
        }
        else
        {
            [_instructionLabel setText:[NSString stringWithFormat:@"%@%@",_instructionLabel.text, [comment substringFromIndex:rangeFrom.location]]];
        }
    }
    else
    {
        [_instructionLabel setText:[NSString stringWithFormat:@"%@%@",_instructionLabel.text, comment]];
    }
}

+ (void)getChannelRangeforAT:(NSString*)comment append:(BOOL)append label:(RTLabel*)_instructionLabel item:(LeboDTO*)_leboDTO
{
    NSRange rangeFrom = [comment rangeOfString: @"@"];
    
    if (rangeFrom.length)
    {
        if(!append)
            [_instructionLabel setText:[NSString stringWithFormat:@"%@", [comment substringToIndex:rangeFrom.location]]];
        
        NSString *rangeText = [comment substringFromIndex:rangeFrom.location + 1];
        NSRange rangeTo = [rangeText rangeOfString: @" "];
        if(rangeTo.length)
        {
            NSString *filter = [NSString stringWithFormat:@"%@", [rangeText substringWithRange:NSMakeRange(0, rangeTo.location+ 1)]];
            NSString *stringID = nil;
            if(_leboDTO && filter)
            {
                for(NSDictionary *dict in _leboDTO.userMentions)
                {
                    if(dict)
                    {
                        NSString *stringName = [dict objectForKey:@"screenName"];
                        if([filter rangeOfString:stringName].length)
                        {
                            stringID = [dict objectForKey:@"id"];
                        }
                    }
                }
            }
            
            NSString *str = [NSString string];
            if (stringID) {
                str = [NSString stringWithFormat:@"%@<a @='%@'><font face=Futura size=14 color='#3F89C6'>@%@</font></a>",_instructionLabel.text,stringID?stringID:[@"@" stringByAppendingString:filter], filter];
            } else
                str = [NSString stringWithFormat:@"%@<font face=Futura size=14 color='#3F89C6'>@%@</font></a>",_instructionLabel.text, filter];
            
            [_instructionLabel setText:str];
            
            [LBLeftView getChannelRangeforAT:[rangeText substringFromIndex:rangeTo.location + 1] append:YES label:_instructionLabel item:_leboDTO];
        }
        else
        {
            [_instructionLabel setText:[NSString stringWithFormat:@"%@%@",_instructionLabel.text, [comment substringFromIndex:rangeFrom.location]]];
        }
    }
    else
    {
        if(append)
            [_instructionLabel setText:[NSString stringWithFormat:@"%@%@",_instructionLabel.text, comment]];
    }
}

- (void)getChannelRangeForChannel:(NSString*)comment
{
    
    NSRange rangeFrom = [comment rangeOfString: @"#"];
    
    if (rangeFrom.length)
    {
        [_instructionLabel setText:[NSString stringWithFormat:@"%@%@", _instructionLabel.text, [comment substringToIndex:rangeFrom.location]]];
        
        //[message stringByReplacingCharactersInRange:rangeFrom withString:@""];
        NSString *rangeText = [comment substringFromIndex:rangeFrom.location + 1];
        NSRange rangeTo = [rangeText rangeOfString: @"#"];
        if(rangeTo.length)
        {
            NSString *filter = [NSString stringWithFormat:@"#%@", [rangeText substringWithRange:NSMakeRange(0, rangeTo.location+ 1)]];
            [_instructionLabel setText:[NSString stringWithFormat:@"%@<a #='%@'><font face=Futura size=14 color='#3F89C6'>%@</font></a>",_instructionLabel.text,filter, filter]];
            
            [self getChannelRangeForChannel:[rangeText substringFromIndex:rangeTo.location + 1]];
        }
        else
        {
            [_instructionLabel setText:[NSString stringWithFormat:@"%@%@",_instructionLabel.text, [comment substringFromIndex:rangeFrom.location]]];
        }
    }
    else
    {
        [_instructionLabel setText:[NSString stringWithFormat:@"%@%@",_instructionLabel.text, comment]];
    }
    
}

- (void)getChannelRangeforAT:(NSString*)comment append:(BOOL)append
{
    NSRange rangeFrom = [comment rangeOfString: @"@"];
    
    if (rangeFrom.length)
    {
        if(!append)
            [_instructionLabel setText:[NSString stringWithFormat:@"%@", [comment substringToIndex:rangeFrom.location]]];
        
        NSString *rangeText = [comment substringFromIndex:rangeFrom.location + 1];
        NSRange rangeTo = [rangeText rangeOfString: @" "];
        if(rangeTo.length)
        {
            NSString *filter = [NSString stringWithFormat:@"%@", [rangeText substringWithRange:NSMakeRange(0, rangeTo.location+ 1)]];
            NSString *stringID = nil;
            if(_leboDTO && filter)
            {
                for(NSDictionary *dict in _leboDTO.userMentions)
                {
                    if(dict)
                    {
                        NSString *stringName = [dict objectForKey:@"screenName"];
                        if([filter rangeOfString:stringName].length)
                        {
                            stringID = [dict objectForKey:@"id"];
                        }
                    }
                }
            }
            
            NSString *str = [NSString string];
            if (stringID) {
                str = [NSString stringWithFormat:@"%@<a @='%@'><font face=Futura size=14 color='#3F89C6'>@%@</font></a>",_instructionLabel.text,stringID?stringID:[@"@" stringByAppendingString:filter], filter];
            } else
                str = [NSString stringWithFormat:@"%@<font face=Futura size=14 color='#3F89C6'>@%@</font></a>",_instructionLabel.text, filter];
            
            [_instructionLabel setText:str];
            
            [self getChannelRangeforAT:[rangeText substringFromIndex:rangeTo.location + 1] append:YES];
        }
        else
        {
            [_instructionLabel setText:[NSString stringWithFormat:@"%@%@",_instructionLabel.text, [comment substringFromIndex:rangeFrom.location]]];
        }
    }
    else
        
    {
        if(append)
            [_instructionLabel setText:[NSString stringWithFormat:@"%@%@",_instructionLabel.text, comment]];
    }
}


- (void)updateItem:(LeboDTO*)dto
{
    [_leboDTO.dtoResult setObject:[NSString stringWithFormat:@"%d",dto.favorited] forKey:@"favorited"];
    [_leboDTO.dtoResult setObject:[NSString stringWithFormat:@"%d",dto.topicFavoritesCount] forKey:@"favoritesCount"];
    [_leboDTO.dtoResult setObject:[NSString stringWithFormat:@"%d",dto.reposted] forKey:@"reposted"];
    [_leboDTO.dtoResult setObject:[NSString stringWithFormat:@"%d",dto.repostsCount] forKey:@"repostsCount"];
    //[_leboDTO.dtoResult setObject:[NSString stringWithFormat:@"%d",dto.commentsCount] forKey:@"commentsCount"];
}

- (void)playVideo:(id)rowCell
{
    [_playerVideoView setImageId:_leboDTO.photoUrl];
    [_playerVideoView setMovieId:_leboDTO.movieUrl];
    NSArray *itemIDs = [NSArray arrayWithObjects:_leboDTO.originStatusID, _leboDTO.iD, nil];
    _playerVideoView.addViewCountIDs = itemIDs;
    
//    id selectPlayURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectPlay"];
    if(_playerVideoView == nil)
        return;
    /*
    if(_leboDTO.movieUrl && ![_leboDTO.movieUrl isEqualToString:selectPlayURL])
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:AutoPlay] boolValue] || [super checkNetWorkWifiOf3G] != 1)
        {
            [[NSUserDefaults standardUserDefaults] setObject:_leboDTO.movieUrl forKey:@"selectPlay"];
            [_playerVideoView play];
            if(rowCell)
            {
                return;
                [((LBTempClipView*)rowCell).playerVideoView downloadNext: ((LBTempClipView*)rowCell).leboDTO.movieUrl];
            }
        }
    }
     */
}


- (void)makeData
{
//    _playerVideoView.backgroundColor = [UIColor redColor];
    [_avatarImage setImage:[UIImage imageNamed:@"dayima_icon"]];
    _timeLabel.text = @"1分钟前";
    _nameLabel.text = @"lebo";
    [_playerVideoView setImageId:@"http://file.dev.lebooo.com/post/2013-09-14/5233ef5f0cf24cfad096e8b2-video-first-frame-34630.jpg"];
    [_playerVideoView setMovieId:@"http://file.dev.lebooo.com/post/2013-09-14/5233ef5f0cf24cfad096e8b2-video-648278.mp4"];
}

#pragma mark - share

- (void)sinaDidLogin:(NSDictionary *)userInfo{
    [self initSinaWeiboShare:_leboDTO];
}


- (void)sinaDidFailLogin:(NSError *)error{
    NSLog(@"新浪登录失败,%@", error);
}

- (void)shareSinaWeibo:(LeboDTO *)dto
{
    [MobClick event:@"3" label:@"视频新浪分享点击数"];
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
    sinaShare.thumbImage = _playerVideoView.imageView.image;
    sinaShare.authorName = dto.screenName;
    sinaShare.actionType = Share;
    [currentNaVC pushViewController:sinaShare animated:YES];
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
    [MobClick event:@"3" label:@"视频QQ分享点击数"];

    NSString *movieUrl = [NSString stringWithFormat:@"%@%@", [Global getShareUrl], [dto.ID lastPathComponent]];
    if (!_playerVideoView.imageView.image) {
        [_playerVideoView.imageView setImageWithURL:[NSURL URLWithString:_playerVideoView.tempImageId]];
    }
    [[QQApiHelper shareInstance] sendVideoMessageImage:_playerVideoView.imageView.image urlStr:movieUrl title:VideoDefaultShareTitle description:dto.text];
}

#pragma mark - Copy
- (void)copyMethod:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"视频copy链接点击数"];
    NSString *movieUrl = [NSString stringWithFormat:@"%@%@", [Global getShareUrl], [dto.ID lastPathComponent]];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:movieUrl];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"拷贝成功"];
}

#pragma mark - MessageShare
- (void)shareToMessage:(LeboDTO *)dto{
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
    [MobClick event:@"3" label:@"视频短信分享点击数"];
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
- (void)sendVideoContent:(LeboDTO *)dto
{
    LBAppDelegate *lbDelegate = (LBAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (lbDelegate && [lbDelegate respondsToSelector:@selector(sendVideoContent:title:thumbImage:videoUrl:)])
    {
        if (isSceneSession) {
            [lbDelegate changeScene:WXSceneSession];
        }else{
            [lbDelegate changeScene:WXSceneTimeline];
        }
        
        NSString *movieUrl = [NSString stringWithFormat:@"%@%@", [Global getShareUrl], [dto.ID lastPathComponent]];
        [lbDelegate sendMusicContent:self.leboDTO.text title:self.leboDTO.text thumbImage:(UIImage *)_playerVideoView.imageView.image musicUrl:movieUrl];    }
}


- (void)shareToWeiXin:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"视频微信好友点击数"];
    isSceneSession = YES;
    [self performSelector:@selector(sendVideoContent:) withObject:_leboDTO afterDelay:0.0f];
}

- (void)shareToWeiXinFriends:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"视频微信朋友圈点击数"];
    isSceneSession = NO;
    [self performSelector:@selector(sendVideoContent:) withObject:_leboDTO afterDelay:0.0f];
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
    NSString *movieUrl = [NSString stringWithFormat:@"%@%@", [Global getShareUrl], [self.leboDTO.ID lastPathComponent]];
    shareToRenRen.movieUrl = movieUrl;
    shareToRenRen.movieTitle = self.leboDTO.text;
    shareToRenRen.actionType = Share;
    //if (self.leboDTO.MovieID)
    {
        [currentNaVC pushViewController:shareToRenRen animated:YES];
    }
}

// 人人登陆
- (void)shareVideoToRenren:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"视频人人网分享点击数"];
//    if([RenRenHelper isAuthorizeValid]){
//        [self initRenRenShareVC];
//    }else{
        [self performSelector:@selector(loginRenren) withObject:dto afterDelay:0.5f];
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
    [MobClick event:@"3" label:@"视频QQ微博分享点击数"];
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
    
    share.shareToQQZoneMovieURL = [NSString stringWithFormat:@"http://www.lebooo.com/movie/player.swf?vcastr_file=%@&IsAutoPlay=1&IsContinue=1&IsShowBar=0", self.leboDTO.movieUrl];
    NSString *movieUrl = [NSString stringWithFormat:@"%@%@", [Global getShareUrl], [self.leboDTO.ID lastPathComponent]];
    share.movieUrl = movieUrl;
    share.photoUrl = self.leboDTO.photoUrl;
    share.movieTitle = _leboDTO.text;
    share.thumbImage = self.playerVideoView.imageView.image;
    share.actionType = Share;
    [currentNaVC pushViewController:share animated:YES];
}

- (void)shareToTencentZone:(LeboDTO *)dto{
    [MobClick event:@"3" label:@"视频QQ空间分享点击数"];
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

@end
