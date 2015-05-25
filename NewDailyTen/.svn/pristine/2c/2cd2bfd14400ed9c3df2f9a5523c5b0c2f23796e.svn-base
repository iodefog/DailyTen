//
//  LBMovieView.h
//  LeBo
//
//  Created by 乐播 on 13-3-11.
//
//

#import <UIKit/UIKit.h>
#import "LBMovieDownloader.h"
#import "LBActivityIndicatorView.h"
#import "LeboDTO.h"
@interface LBMovieView : UIView<LBMovieDownloaderDelegate,LBMovieProgressDelegate>
{
    BOOL _shouldPlay;
    UIView * _contentView;
    UIImageView * _imageView;
}
@property(nonatomic,strong) NSString * imageId;
@property(nonatomic,strong) NSString * tempImageId;
@property (nonatomic,strong) UIImageView * imageView;
@property(nonatomic,retain) NSString * movieId;
@property(nonatomic,readonly) UIView * contentView;
@property(nonatomic,retain) NSArray *addViewCountIDs;
@property(nonatomic,strong) UIButton *playButton;
@property(nonatomic,assign) BOOL supportTouch;//支持触摸暂停 默认为支持
- (void)setPlayerURL:(NSURL *)url;//不用调用该函数

- (void)play;

- (void)pause; //view 保留当前播放祯

- (void)stop; //view变为透明

+ (void)pauseAll;//view变为透明

- (BOOL)isPlaying;

- (void)setMovieId:(NSString *)movieId;

- (void)downloadNext:(NSString*)movieId;
- (void)setImageIdFroCache:(NSString *)imageId;
- (void)setImageFromUrl:(NSString *)imageId;
@end
