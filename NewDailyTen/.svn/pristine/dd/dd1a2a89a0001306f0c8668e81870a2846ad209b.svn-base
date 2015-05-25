//
//  EditSignViewController.h
//  LBDemo
//
//  Created by Li Hongli on 13-3-25.
//  Copyright (c) 2013年 Li Hongli. All rights reserved.
//

typedef enum {
    ShareToSina,
    ShareToRenRen,
    ShareToQQWeibo,
    ShareToQQZone
} ShareType;

typedef enum{
    Invite,
    Share
} actionType;

#import <UIKit/UIKit.h>

@interface LBShareViewController : UIViewController<UITextViewDelegate, MBProgressHUDDelegate, TencentHelperDelegate>
{
    UITextView  *_signTextView;             // 签名视图
    UILabel     *_wordRemainingCountLabel;  // 剩余字个数
    NSString    *_shortUrl;
    MBProgressHUD *progress;                // 进度条
    BOOL        isUnFinishedShortUrl;       // 当点击邀请，而短链接为完成
    NSTimer     *shareTimer;                // 用来分享记录超时
}

@property (nonatomic, assign)   SEL        action;           // 回调函数
@property (nonatomic, weak)     id         parent;           // 父视图
@property (nonatomic, strong)   NSString   *movieUrl;        // 视频地址
@property (nonatomic, strong)   NSString   *movieTitle;      // 视频名
@property (nonatomic, strong)   UIImage    *thumbImage;      // 图片
@property (nonatomic, strong)   NSString   *photoUrl;        // 图片地址
@property (nonatomic, copy)     NSString   *authorName;      // 视频作者
@property (nonatomic, assign)   ShareType   shareType;       // 分享到*

@property (nonatomic, strong)   NSString   *nickname;        // 分享时要@的人名字
@property (nonatomic, assign)   actionType actionType;      // 时间类型，比如邀请或者分享
@property (nonatomic, retain)   NSString *shareToQQZoneMovieURL;

@end
