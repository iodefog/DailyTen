//
//  LBMovieView.m
//  LeBo
//
//  Created by 乐播 on 13-3-11.
//
//

#import "LBMovieView.h"
#import "LBPlayer.h"
#import "LBCameraTool.h"
#import "Global.h"
#import "UIImageView+DispatchLoad.h"
#import "MBProgressHUD.h"
#import "FileUtil.h"
#import "LBAudioView.h"
#import "LBCacheAudioView.h"

#define MAX_RetryCount 1
@interface LBMovieView()
{
    MBProgressHUD * _hud;
    int _retryCount;
}
@property(nonatomic,copy) NSURL * movieURL;
@end

static BOOL shouldAllPause = NO;

@implementation LBMovieView
@synthesize addViewCountIDs = _addViewCountIDs;
@synthesize imageView = _imageView;
@synthesize tempImageId = _tempImageId;
@synthesize playButton = _playButton;

- (void)downloadNext:(NSString*)movieId;
{
    return;
    [self setMovieId:movieId];
    LBMovieDownloader * downloader = [LBMovieDownloader sharedInstance];
    [downloader addMoviePath:movieId delegate:self];
    if(movieId)
    {
        [self hudShowWithDeterminateStyle];
        _hud.progress = downloader.downloadPercent;
        _hud.labelText = [NSString stringWithFormat:@"%d%%",(int)(_hud.progress*100)];
        [downloader setProgressDelegate:self];
    }
    else if(downloader.progressDelegate == self)
    {
        downloader.progressDelegate = nil;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if([self respondsToSelector:@selector(setTranslatesAutoresizingMaskIntoConstraints:)])
            [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        _shouldPlay = NO;
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.userInteractionEnabled = YES;
        _supportTouch = YES;
        
        if ([[LBFileClient sharedInstance] getNetworkingType] == 1) {
            //3G == 1 wu ==0 wifi ==2
            
        }else{
            _hud = [[MBProgressHUD alloc] initWithView:self];
            _hud.color = [UIColor clearColor];
            [self addSubview:_hud];
        }
        
        self.playButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.playButton.frame = CGRectMake(self.right - 60, 0, 60, 60);
        [self.playButton setImage:[UIImage imageNamed:@"moviePlay.png"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"moviePause.png"] forState:UIControlStateSelected];
        [self.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playButton];
        
        //_hud.mode = MBProgressHUDModeIndeterminate;
        //_hud.delegate = self;
        //_hud.labelText = @"Loading";
        
//        _activity = [[LBActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [self addSubview:_activity];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseAllPlayButton) name:@"stopAll" object:nil];
    }
    return self;
}

- (void)pauseAllPlayButton{
    [self.playButton setSelected:NO];
    self.playButton.hidden = self.playButton.selected;
}

- (void)playButtonClicked:(UIButton *)sender{
    if (!sender.isSelected) {
        [self play];
    }else{
        [self pause];
    }
}

- (void)hudShowWithIndeterminateStyle
{
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = nil;
    if([_hud isHidden] == NO)
    {
        [_hud show:YES];
    }
}

- (void)hudShowWithDeterminateStyle
{
    if(_hud.mode != MBProgressHUDModeDeterminate)
    {
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.labelText = @"下载中...";
        _hud.progress = 0;
    }
    if([_hud isHidden] == NO)
    {
        [_hud show:YES];
    }
}

- (void)dealloc
{
    [self stop];
}

- (NSString *)getFinalPath:(NSString *)path
{
    if (path.length > 0 && [[path substringToIndex:4] isEqualToString:@"http"]) {
        return path;
    } else
        return [[Global getServerBaseUrl] stringByAppendingString:path];
}

- (void)setImageId:(NSString *)imageId
{
    self.tempImageId = imageId;
    if(imageId)
    {
        _imageView.image = nil;
        NSString * realUrl = [self getFinalPath:imageId];
        [_imageView setImageWithURL:[NSURL URLWithString:realUrl]];
    }
    else
    {
        _imageView.image = nil;
    }
}

- (void)setImageIdFroCache:(NSString *)imageId
{
    self.tempImageId = imageId;
    if(imageId)
    {
        _imageView.image = nil;
        NSString * realUrl = [self getFinalPath:imageId];
        [_imageView setImageWithURL:[NSURL URLWithString:realUrl]];
    }
    else
    {
        _imageView.image = nil;
    }
}

- (void)setImageFromUrl:(NSString *)imageId
{
    self.tempImageId = imageId;
    if ([imageId isEqualToString:@""]) {
        _imageView.image = nil;
        return;
    }
    if(imageId)
    {
        if(_imageView.image)
        {
            return;
        }
        _imageView.image = nil;
        NSString * realUrl = [NSString string];
        if (imageId.length > 0 && [[imageId substringToIndex:4] isEqualToString:@"http"]) {
            realUrl = imageId;
        }else
            realUrl = [self getFinalPath:imageId];
            //[_imageView setImageWithURL1:[NSURL URLWithString:realUrl]];

        NSString *str = [FileUtil getCachePicPath] ;
        NSString *aa = [str stringByAppendingFormat:@"/%@",[realUrl md5Value]];
        UIImage *avatarImage = nil;
        NSData *data = [NSData dataWithContentsOfFile:aa];
        
        if(data)
        {
            avatarImage = [UIImage imageWithData:data];
            _imageView.image = avatarImage;
        }
        else
            [_imageView setImageFromUrl:realUrl
                        completion:^(void) {
                          
                        }
         ];
    }
    else
    {
        _imageView.image = nil;
    }
}

- (void)setMovieId:(NSString *)movieId
{
    if(![_movieId isEqualToString:movieId])
    {
        _retryCount = MAX_RetryCount;
        _movieId = [movieId copy];
        [self stop];
        self.movieURL = nil;
        if(_movieId == nil)
        {
            [_hud hide:YES];
            LBMovieDownloader * downloader = [LBMovieDownloader sharedInstance];
            [downloader cancelAllWaitingOperation];
            //[_activity stopAnimating];
        }
        else
        {
            LBMovieDownloader * downloader = [LBMovieDownloader sharedInstance];
            if([Global canAutoDownLoad])
            {
                NSLog(@"[Global canAutoDownLoad]");
                [self hudShowWithIndeterminateStyle];
                //[downloader addMoviePath:movieId delegate:self];
            }
            if([[downloader dowloadingPath] isEqualToString:movieId] && [downloader isDownloading])
            {
                [self hudShowWithDeterminateStyle];
                _hud.progress = downloader.downloadPercent;
                [downloader setProgressDelegate:self];
            }
            else if(downloader.progressDelegate == self)
            {
                downloader.progressDelegate = nil;
                [_hud hide:NO];
            }
            //[_activity startAnimating];
        }
    }
}

- (void)setPlayerURL:(NSURL *)url
{
    
    self.movieURL = url;
}

- (void)layoutSubviews
{
    LBPlayer * player = [LBPlayer sharedPlayer];
    if(player.url == self.movieURL)
    {
        player.layer.frame = _imageView.bounds;
    }
    _imageView.frame = self.bounds;
    //_activity.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)play
{
    [LBCacheAudioView pauseAllCacheMusic];
    [LBAudioView pauseAllMusic];

    NSLog(@"movieview play");
    shouldAllPause = NO;
    _shouldPlay = YES;
    LBPlayer * player = [LBPlayer sharedPlayer];
    if(player.layer.superlayer != _imageView.layer)
    {
        [_imageView.layer addSublayer:player.layer];
        player.layer.frame = _imageView.bounds;
    }
    if([player.url isEqual:self.movieURL] && player.rate!=0)
        return;
    ;
    
    //NSString * baseString = [Global getServerUrl2];
    //NSString * realPath = [baseString stringByAppendingString:self.movieId];
//    [player setURL:[NSURL URLWithString:@"https://s3.amazonaws.com/houston_city_dev/video/h264-original/1/haku.mp4"]];
//    [player play];
//    NSLog(@"LBPlayer duration:%f",CMTimeGetSeconds(player.currentItem.duration));
//    return;
    
    BOOL flag  = [[NSFileManager defaultManager] fileExistsAtPath:[self.movieURL path]];
    //NSLog(@"is file exist:%d path:%@",flag,self.movieId);
    if(self.movieURL && flag)
    {
        [self.playButton setSelected:YES];
        self.playButton.hidden = self.playButton.selected;
        [MobClick event:@"4" label:@"视频播放"];
        NSLog(@"播放缓存");
        [player setURL:self.movieURL];
        [player play];
        //double duration = CMTimeGetSeconds(player.currentItem.duration);
//        if(duration == 0)
//        {
//            [[NSFileManager defaultManager] removeItemAtPath:[self.movieURL path] error:nil];
//            if(--_retryCount >= 0)
//            {
//                [self play];
//            }
//        }
    }
    else if(_movieId)
    {
        [player stop];
        
        if (!_hud) {
            _hud = [[MBProgressHUD alloc] initWithView:self];
            _hud.color = [UIColor clearColor];
            [self addSubview:_hud];
        }
        if (_hud.superview) {
            [self addSubview:_hud];
        }
        LBMovieDownloader * downloader = [LBMovieDownloader sharedInstance];
        [downloader addMoviePath:_movieId delegate:self];
       
        NSLog(@"%d  %d ",[[downloader dowloadingPath] isEqualToString:_movieId],[downloader isDownloading]);
        if([[downloader dowloadingPath] isEqualToString:_movieId] && [downloader isDownloading])
        {
            [self hudShowWithDeterminateStyle];
            _hud.progress = downloader.downloadPercent;
            _hud.labelText = [NSString stringWithFormat:@"%d%%",(int)(_hud.progress*100)];
            [downloader setProgressDelegate:self];
            NSLog(@"下载视频");
            if ([_addViewCountIDs count] == 2) {
                //[[LBFileClient sharedInstance] addViewCount:_addViewCountIDs cachePolicy:NSURLRequestReloadIgnoringLocalCacheData delegate:nil selector:nil selectorError:nil];
            }
        }
        else if(downloader.progressDelegate == self)
        {
            downloader.progressDelegate = nil;
        }
        [self.playButton setSelected:YES];
        self.playButton.hidden = self.playButton.selected;
        //[_activity startAnimating];
    }
    else
    {
        [player stop];
        NSLog(@"play stop");
    }
}

- (BOOL)isPlaying
{
    LBPlayer * player = [LBPlayer sharedPlayer];

    if([player.url isEqual:self.movieURL] && player.rate!=0)
        return YES;
    else
        return NO;
}

- (void)pause
{
    _shouldPlay = NO;
    [self.playButton setSelected:NO];
    self.playButton.hidden = self.playButton.selected;
    LBPlayer * player = [LBPlayer sharedPlayer];
    if([player.url isEqual:self.movieURL])
    {
        [player pause];
    }
}

- (void)stop
{
    _shouldPlay = NO;
    [self.playButton setSelected:NO];
    self.playButton.hidden = self.playButton.selected;
    LBPlayer * player = [LBPlayer sharedPlayer];
    if([player.url isEqual:self.movieURL] && player.layer.superlayer == _imageView.layer )
    {
        [player stop];
    }
}

+ (void)pauseAll
{
    NSLog(@"pauseAll");
    shouldAllPause = YES;
    LBPlayer * player = [LBPlayer sharedPlayer];
    [player stopAll];
    [[LBMovieDownloader sharedInstance] cancelAllWaitingOperation];
    //[player setURL:nil];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(_supportTouch)
    {
        if([self isPlaying])
            [self pause];
        else
            [self play];
    }
}

- (UIView *)contentView
{
    if(!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_contentView];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _contentView;
}

#pragma mark LbMovieDownloaderDelegate
- (void)movieDownloaderDidStart:(NSString *)path
{
    NSLog(@"movieDownloaderDidStart");
    //if([path isEqualToString: self.movieId])
    //{
        [self hudShowWithDeterminateStyle];
    //}
}

- (void)movieDownloaderDidFinished:(NSString *)path
{
    [_hud hide:YES];
    if([path isEqualToString:self.movieId])
    {

        //BOOL flag = [[NSFileManager defaultManager] fileExistsAtPath:[LBCameraTool getCachePathForRemotePath:path]];
        //NSLog(@"file exsist:%d,%@",flag,[LBCameraTool getCachePathForRemotePath:path]);
        self.movieURL = [NSURL fileURLWithPath:[LBCameraTool getCachePathForRemotePath:path]];
        if(_shouldPlay && !shouldAllPause)
        {
            [self play];
        }
    }
}

- (void)movieDownloaderDidFailed:(NSString *)path
{
    //if([path isEqualToString: self.movieId])
    {
        [_hud hide:YES];
    }
}

- (void)movieDownloaderProgress:(NSNumber *)percent
{
    _hud.progress = [percent floatValue];
    _hud.labelText = [NSString stringWithFormat:@"%d%%",(int)(_hud.progress*100)];
//    
//    if((int)(_hud.progress*100) > 99)
//    {
//        [_hud setHidden:YES];
//    }
    NSLog(@"movieDownloaderProgress:%f",_hud.progress);
}

@end
