//
//  EditSignViewController.m
//  LBDemo
//
//  Created by Li Hongli on 13-3-25.
//  Copyright (c) 2013年 Li Hongli. All rights reserved.
//

#import "LBShareViewController.h"
#import "AccountHelper.h"
#import "AccountDTO.h"

@interface LBShareViewController ()<TencentHelperDelegate>

@end

@implementation LBShareViewController
@synthesize movieUrl;
@synthesize shareToQQZoneMovieURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - viewLifeCycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:@"分享页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [MobClick beginLogPageView:@"分享页面"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor =  [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    // 文本背景
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 11, self.view.frame.size.width- 10, 150) ];
    UIImage *image = [UIImage imageNamed:@"input_backGroud.png"];
    [self.view addSubview:bgImageView];
    bgImageView.image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    [self addTextView:bgImageView];
    // 转换短链接
    if (self.movieUrl) {
        if ([[SinaHelper getHelper] sinaIsAuthValid]) {
            [[SinaHelper getHelper] setDelegate:self];
            [[SinaHelper getHelper] longUrlTOShortUrl:movieUrl];
        }
        else{
            [self changeLongUrlToShortUrl];
        }
    }
    
    
    if (self.movieTitle.length > 70) {
        self.movieTitle = [NSString stringWithFormat:@"%@.....",[self.movieTitle substringWithRange:NSMakeRange(0, 70)]];
    }
    
    
    if (self.actionType == Share) {
        if (self.shareType == ShareToSina) {
            self.title = @"分享到新浪微博";
            if (_movieTitle.length<1) {
                _signTextView.text = [NSString stringWithFormat:@"@%@ %@",_authorName, SHAREDEFAULTSTR];
            }else{
                _signTextView.text = [NSString stringWithFormat:@"@%@  \"%@\" %@",_authorName, self.movieTitle, SHAREDEFAULTSTR];
            }
        }
        else if (self.shareType == ShareToRenRen){
            self.title = @"分享到人人网";
            if (_movieTitle.length<1) {
                _signTextView.text = SHAREDEFAULTSTR;
            }else{
                _signTextView.text = [NSString stringWithFormat:@"\"%@\" %@",self.movieTitle ,SHAREDEFAULTSTR];
            }
        }
        else if (self.shareType == ShareToQQWeibo){
            self.title = @"分享到腾讯微博";
            if (_movieTitle.length<1) {
                _signTextView.text = SHAREDEFAULTSTR;
            }else{
                _signTextView.text = [NSString stringWithFormat:@"\"%@\" %@",self.movieTitle ,SHAREDEFAULTSTR];
            }

        }else if (self.shareType == ShareToQQZone){
            self.title = @"分享到QQ空间";
            if (_movieTitle.length<1) {
                _signTextView.text = SHAREDEFAULTSTR;
            }else{
                _signTextView.text = [NSString stringWithFormat:@"\"%@\" %@",self.movieTitle ,SHAREDEFAULTSTR];
            }
        }
        
        [self addItemsToNavBar:@"分享"];
    }else if (self.actionType == Invite){
        NSString *inviteStr = [NSString stringWithFormat:@" %@", MESSAGEDEFAULTTEXT];
        if (self.shareType == ShareToSina) {
            self.title = @"分享到新浪微博";
            _signTextView.text = inviteStr;
        }
        else if (self.shareType == ShareToRenRen){
            self.title = @"分享到人人网";
            _signTextView.text = inviteStr;
        }
        else if (self.shareType == ShareToQQWeibo){
            self.title = @"分享到腾讯微博";
            _signTextView.text = inviteStr;
        }else if (self.shareType == ShareToQQZone){
            self.title = @"分享到QQ空间";
            _signTextView.text = inviteStr;
        }
        
        [self addItemsToNavBar:@"分享"];
        
    }
    
    [self wordPrompt:bgImageView];
}

- (void)changeLongUrlToShortUrl{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://baid.ws/?url=%@",movieUrl]]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject];
        NSArray *elements = [hpple searchWithXPathQuery:@"/html/body/div[1]/div[2]/div[2]/table/tr/td/strong/a"];
        TFHppleElement *element = [elements lastObject];
        TFHppleElement *childElement = element.firstChild;
        NSLog(@"%@", childElement.content);
        if (childElement.content) {
            _shortUrl = childElement.content;
        }
        if(isUnFinishedShortUrl){
            [self shareToSNS];
        }
        isUnFinishedShortUrl = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"转换失败");
        isUnFinishedShortUrl = NO;
    }];
    [requestOperation start];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    _signTextView = nil;
    _wordRemainingCountLabel = nil;
}

#pragma mark -  method
// 添加导航条左右按钮
- (void)addItemsToNavBar:(NSString *)msg{
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:msg forState:UIControlStateNormal];
    finishBtn.frame = CGRectMake(0, 0, 50, 28);
    [finishBtn addTarget:self action:@selector(onShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnImage = [UIImage imageNamed:@"searchBar_cancel"];
    [finishBtn setBackgroundImage:[btnImage stretchableImageWithLeftCapWidth:14 topCapHeight:14] forState:UIControlStateNormal];
    [finishBtn setBackgroundImage:[[UIImage imageNamed:@"searchBar_cancel_tape"] stretchableImageWithLeftCapWidth:14 topCapHeight:14] forState:UIControlStateHighlighted];

    finishBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:nil image:@"back.png" target:self action:@selector(cancel)];
}



// 添加文本空间
- (void)addTextView:(UIImageView *)bgImageView{
    _signTextView = [[UITextView alloc]initWithFrame:CGRectMake( bgImageView.frame.origin.x , bgImageView.frame.origin.y +5 , bgImageView.frame.size.width, 140.0f)];
    _signTextView.backgroundColor = [UIColor clearColor];
    _signTextView.delegate = self;
    _signTextView.font = [UIFont systemFontOfSize:14.0f];
    _signTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_signTextView becomeFirstResponder];
    [self.view addSubview:_signTextView];
}

// 字数提示
- (void)wordPrompt:(UIImageView *)bgImageView{
    _wordRemainingCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(bgImageView.frame.origin.x + bgImageView.frame.size.width - 76, bgImageView.frame.origin.y + bgImageView.frame.size.height - 34, 70, 40)];
    _wordRemainingCountLabel.backgroundColor = [UIColor clearColor];
    _wordRemainingCountLabel.font = [UIFont systemFontOfSize:14.0f];
    _wordRemainingCountLabel.textColor = RGB(131, 131, 131);
    _wordRemainingCountLabel.textAlignment = UITextAlignmentRight;
    [self.view addSubview:_wordRemainingCountLabel];
    
    int remainCount;
    if (self.actionType == Invite) {
         remainCount =  140 - _signTextView.text.length;
    }else{
        remainCount =  140 - 20 - _signTextView.text.length;
    }
    _wordRemainingCountLabel.text = [NSString stringWithFormat:@"%d",remainCount];
    
}

// 返回
- (void)cancel{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 分享点击
- (void)onShareClicked:(UIButton *)sender{
    
        
    if (_signTextView.text.length > 140 - _shortUrl.length) {
        NSString *wordCount = nil;
        if (self.actionType == Invite) {
            wordCount = [NSString stringWithFormat:@"文字不能超过%d个",140];
        }else if (self.actionType == Share){
            wordCount = [NSString stringWithFormat:@"文字不能超过%d个",120];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:wordCount message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
        [alert show];
        return;
    }
    [self addProgress];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"shareData"];
    
    if (self.actionType == Share) {
        if (isUnFinishedShortUrl) {
            [self shareToSNS];
            isUnFinishedShortUrl = YES;
        
        }else{
            if (self.shareType == ShareToSina) {
                [[SinaHelper getHelper] setDelegate:self];
                [[SinaHelper getHelper] longUrlTOShortUrl:movieUrl];
            }else{
                if (isUnFinishedShortUrl == NO) {
                    [self changeLongUrlToShortUrl];
                }else{
                isUnFinishedShortUrl = YES;
                }
            }
            
        }
    }else if (self.actionType == Invite){
        if (self.shareType == ShareToSina) {
            [MobClick event:@"3" label:@"音乐新浪分享发送点击数"];
            [self inviteToSina];
        }
        else if (self.shareType == ShareToRenRen){
            [MobClick event:@"3" label:@"音乐人人网分享发送点击数"];
//            if ([RenRenHelper isAuthorizeValid]) {
//                [RenRenHelper updateRenRenState:_signTextView.text target:self];
//            }else{
//                [RenRenHelper renrenLoginTarget:self];
//            }
        }
        else if (self.shareType == ShareToQQWeibo){
            [MobClick event:@"3" label:@"音乐QQ微博分享发送点击数"];
            if ([TencentHelper isSessionValid]) {
                [TencentHelper tenxunWeiboSharePicContent:_signTextView.text pic:[dict objectForKey:@"imageData"] syncflag:NO target:self];
            }
            
        }else if (self.shareType == ShareToQQZone){
            [MobClick event:@"3" label:@"音乐QQ空间分享发送点击数"];
            if ([TencentHelper isSessionValid]) {
                [TencentHelper shareToQZoneTitle:APPLICATIONTITLE url:APPSTOREURL comment:_signTextView.text  summary:nil images:[dict objectForKey:@"imageUrl"] type:@"4" playurl:nil delegate:self];
            }
        }
    }
}

// 分享
- (void)shareToSNS{
    if (self.shareType == ShareToSina) {
        [MobClick event:@"3" label:@"视频新浪分享发送点击数"];
        [self shareToSina];
    }
    else if (self.shareType == ShareToRenRen){
        [MobClick event:@"3" label:@"视频人人分享发送点击数"];
//        if ([RenRenHelper isAuthorizeValid]) {
//            [RenRenHelper shareContent:_signTextView.text movieUrl:movieUrl target:self];
//        }else{
//            [RenRenHelper renrenLoginTarget:self];
//        }
    }else if (self.shareType == ShareToQQWeibo){
        [MobClick event:@"3" label:@"视频QQ微博分享发送点击数"];
        if ([TencentHelper isSessionValid]) {
            [TencentHelper tenxunWeiboSharePicContent:[NSString stringWithFormat:@"%@ 视频地址>>>%@",_signTextView.text, _shortUrl] pic:self.thumbImage syncflag:NO target:self];
        }
        
    }else if (self.shareType == ShareToQQZone){
        [MobClick event:@"3" label:@"视频QQ空间分享发送点击数"];
        if ([TencentHelper isSessionValid]) {
            if (shareToQQZoneMovieURL == nil) {
                shareToQQZoneMovieURL = @"http://www.lebooo.com";
            }
             [TencentHelper shareToQZoneTitle:APPLICATIONTITLE url:self.movieUrl comment:[NSString stringWithFormat:@"%@ 视频地址>>>%@",_signTextView.text, _shortUrl] summary:nil images:[NSString stringWithFormat:@"%@", self.photoUrl] type:@"5" playurl:self.shareToQQZoneMovieURL delegate:self];
        }
    }
}

// 添加进度
- (void)addProgress{
    progress = [[MBProgressHUD alloc] initWithView:_signTextView];
    [_signTextView addSubview:progress];
    progress.delegate = self;
    progress.labelText = @"加载中...";
    [progress show:YES];
    shareTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(shareOverTimer) userInfo:@"分享超时" repeats:NO];
}

// 分享超时
- (void)shareOverTimer{
    if (self.actionType == Share) {
         progress.labelText = @"分享超时";
    }else if(self.actionType == Invite){
     progress.labelText = @"邀请超时";
    }
   
    [self performSelector:@selector(removeProgressFail) withObject:nil afterDelay:0.5f];
}

// 成功时移除进度
- (void)removeProgressSuccess{
    [progress show:NO];
    [progress removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

// 失败时移除进度
- (void)removeProgressFail{
    [shareTimer invalidate];
    [progress show:NO];
    [progress removeFromSuperview];
}

#pragma mark - LBFileClientDelegate
- (void)responseSuccess:(id)result{
    NSLog(@"LBSinaViewController fileClient success %@",result);
}

- (void)responseFail:(NSError *)error{
    NSLog(@"LBSinaViewController fileClient fail %@",error);
}

#pragma mark - textViewDelegate
// textview 文字改变时调用
- (void)textViewDidChange:(UITextView *)textView{
    
    if (self.actionType == Invite) {
        if (_signTextView.text.length > 140 )
            _wordRemainingCountLabel.textColor = [UIColor redColor];
        else
            _wordRemainingCountLabel.textColor = RGB(131, 131, 131);
        int remainCount = 140 - _signTextView.text.length;
        _wordRemainingCountLabel.text = [NSString stringWithFormat:@"%d",remainCount];

    }else{
        if (_signTextView.text.length > 140 - 20)
            _wordRemainingCountLabel.textColor = [UIColor redColor];
        else
            _wordRemainingCountLabel.textColor = RGB(131, 131, 131);
        int remainCount = 140 - 20 - _signTextView.text.length;
        _wordRemainingCountLabel.text = [NSString stringWithFormat:@"%d",remainCount];

    }
}

#pragma mark - sianDelegate

// 调用新浪接口，分享到新浪
- (void)shareToSina{
    [[SinaHelper getHelper] setDelegate:self];
    NSData *picData = UIImageJPEGRepresentation(_thumbImage, 1.0f);
    [[SinaHelper getHelper] setDelegate:self];
    
    [[SinaHelper getHelper] uploadPicture:picData status:[NSString stringWithFormat:@"%@ 视频地址>>>%@",_signTextView.text,_shortUrl]];
}

- (void)inviteToSina{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"shareData"];
    
    [[SinaHelper getHelper] setDelegate:self];
    [[SinaHelper getHelper] uploadPicture:[dict objectForKey:@"imageData"] status:_signTextView.text];
}

// 新浪短连接转换成功
- (void)shortUrlSuccess:(id)result{
    NSString *url_short = [[[result objectForKey:@"urls"] lastObject] objectForKey:@"url_short"];
    _shortUrl = url_short;
    
    NSLog(@"result  %@",result);
    if (isUnFinishedShortUrl) {
        [self shareToSNS];
    }else{
        isUnFinishedShortUrl = YES;
    }
}

// 新浪短连接转换成功，未用
- (void)longUrlTOShortUrlSuccess:(id)result{
    NSLog(@"result  %@",result);
    NSString *url_short = [[[result objectForKey:@"urls"] lastObject] objectForKey:@"url_short"];
    _shortUrl = url_short;
}

// 新浪短连接转换失败
- (void)shortUrlFail:(NSError *)error{
    NSLog(@"%@",error);
}

// 新浪邀请成功
- (void)sinaUpdateSuccess:(NSDictionary *)result{
    [MobClick event:@"3" label:@"音乐新浪分享成功数"];
}

// 新浪邀请失败
- (void)sinaUpdateFail:(NSError *)error{
    
}

// 新浪分享成功
- (void)sinaUploadSuccess:(id)result{
    NSLog(@"%@",result);
    [MobClick event:@"3" label:@"视频新浪分享成功数"];
    progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    progress.mode = MBProgressHUDModeCustomView;
    if (self.actionType == Share) {
         progress.labelText = @"分享成功";
    }else if (self.actionType == Invite){
        progress.labelText = @"分享成功";
    }
    [_signTextView addSubview:progress];
    [self performSelector:@selector(removeProgressSuccess) withObject:nil afterDelay:0.3f];
}

// 新浪分享失败
- (void)sinaUploadFail:(NSError *)error{
    [self removeProgressFail];
    NSLog(@"%@",error);
    if (self.actionType == Share) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:ALERTSINASHARE origin_y:100];
        
    }else if (self.actionType == Invite){
       [[TKAlertCenter defaultCenter] postAlertWithMessage:ALERTSINAINVITE origin_y:100];    }
   
}

#pragma mark -
#pragma mark RenRenDelegate
/* 发布成功
 @param renren 传回代理服务器接口请求的 Renren 类型对象。@param response 传回接口请求的响应
 */
- (void)renrenHelper:(id)service requestDidReturnResponse:(id)response{
    if (self.actionType == Share) {
        [MobClick event:@"3" label:@"视频人人网分享成功数"];
    }else if(self.actionType == Invite){
        [MobClick event:@"3" label:@"音乐人人网分享成功数"];
    }
    NSLog(@"response.rootObject %@",response);
    progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    progress.mode = MBProgressHUDModeCustomView;
	progress.labelText = @"成功";
    [_signTextView addSubview:progress];
    [self performSelector:@selector(removeProgressSuccess) withObject:nil afterDelay:0.3f];
}

/* 人人发布失败
 @param renren 传回代理服务器接口请求的 Renren 类型对象。@param response 传回接口请求的错误对象。
 */
- (void)renrenHelper:(id)service requestFailWithError:(NSError *)error{
    [self removeProgressFail];
    NSLog(@"%@",error);
    if (self.actionType == Share) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:ALERTRENRENSHARE origin_y:100];
        
    }else if (self.actionType == Invite){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:ALERTRENRENINVITE origin_y:100];
    }
}

// 人人登陆成功回调
- (void)renRenLoginSuccess{
    [self addProgress];
//    [RenRenHelper shareContent:_signTextView.text movieUrl:_shortUrl target:self];
}

// 人人登陆失败回调
- (void)renRenLoginFail{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:ALERTRENRENLOGIN];
}

#pragma mark - QQZone

- (void)tencentshareFail:(NSString *)errormsg{
    [self removeProgressFail];
    NSLog(@"%@",errormsg);
    if (self.actionType == Share) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:ALERTTENCENTSHARE origin_y:100];
        
    }else if (self.actionType == Invite){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:ALERTTENCENTINVITE origin_y:100];
    }
}

- (void)tencentshareSuccess:(NSString *)message{
    progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    progress.mode = MBProgressHUDModeCustomView;
    if (self.actionType == Share) {
         progress.labelText = @"分享成功";
    }else if (self.actionType == Invite){
     progress.labelText = @"分享成功";
    }
   
    if (self.actionType == Share) {
        if (self.shareType == ShareToQQWeibo) {
            [MobClick event:@"3" label:@"视频QQ微博分享成功数"];
        }else if(self.shareType == ShareToQQZone){
            [MobClick event:@"3" label:@"视频QQ空间分享成功数"];
        }
    }else if (self.actionType == Invite){
        if (self.shareType == ShareToQQWeibo) {
            [MobClick event:@"3" label:@"音乐QQ微博分享成功数"];
        }else if(self.shareType == ShareToQQZone){
            [MobClick event:@"3" label:@"音乐QQ空间分享成功数"];
        }
    }
    [self performSelector:@selector(removeProgressSuccess) withObject:nil afterDelay:0.3f];
    NSLog(@"response success %@", message);
}

@end
