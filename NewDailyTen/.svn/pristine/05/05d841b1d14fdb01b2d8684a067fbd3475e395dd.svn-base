//
//  LBApplicationView.m
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBApplicationView.h"

@implementation LBApplicationView

@synthesize appImageView, appName, appSize, appVersion, appDownloadUrl, appDescription;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    self.appImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 48, 48)];;
    self.appImageView.backgroundColor = [UIColor clearColor];
    
    self.appName = [[RTLabel alloc] initWithFrame:CGRectMake(self.appImageView.right + 4, 0, self.right - self.appImageView.right - 30, self.appImageView.height)];
    self.appName.font = [UIFont boldSystemFontOfSize:14];
    [self.appName setLineSpacing:2];
    self.appName.top = self.appImageView.top;
    [self.appName setTextColor:[UIColor whiteColor]];
    self.appName.backgroundColor = [UIColor clearColor];
    self.appName.width = 140 - 48 - 20;
    
    self.appVersion = [[UILabel alloc] initWithFrame:CGRectMake(self.appName.left, 0, self.appName.width, 15)];
    self.appVersion.backgroundColor = [UIColor clearColor];
    self.appVersion.font = [UIFont systemFontOfSize:10];
    self.appVersion.textAlignment = UITextAlignmentLeft;
    
    self.appSize = [[UILabel alloc] initWithFrame:CGRectMake(self.appVersion.left, 0, self.appVersion.width, 15)];
    self.appSize.backgroundColor = [UIColor clearColor];
    self.appSize.font = [UIFont systemFontOfSize:10];
    self.appSize.textAlignment = UITextAlignmentLeft;
    
    self.appDescription = [[UILabel alloc] initWithFrame:CGRectMake( 5, 0, 130, 40)];
    appDescription.font = [UIFont systemFontOfSize:13];
    appDescription.backgroundColor = [UIColor clearColor];
    appDescription.lineBreakMode = NSLineBreakByWordWrapping;
    appDescription.textAlignment = UITextAlignmentLeft;
    appDescription.numberOfLines = 3;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAppDownloadUrl:)];
    [self addGestureRecognizer:tapGesture];
    
    [self addSubview:self.appImageView];
    [self addSubview:self.appName];
    [self addSubview:self.appVersion];
    [self addSubview:self.appSize];
    [self addSubview:self.appDescription];

}

- (void)setObject:(NSDictionary *)item{
    self.hidden = NO;
    if (!item || item == (id)[NSNull null]) {
        self.hidden = YES;
        return;
    }
    self.backgroundColor = [UIColor grayColor];
    [self.appImageView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"icon"]]];
    self.appName.text = [item objectForKey:@"title"];
    if (self.appName.optimumSize.height > 15) {
        self.appName.height = 35;
    } else
        self.appName.height = 14;
    self.appVersion.text = [NSString stringWithFormat:@"版本:%@",[item objectForKey:@"version"]];
     self.appVersion.top = self.appName.bottom;
    self.appSize.text = [NSString stringWithFormat:@"大小:%@",[item objectForKey:@"size"]];
    self.appSize.top = self.appVersion.bottom;
    self.appDownloadUrl = [item objectForKey:@"address"];
    self.appDescription.text = [item objectForKey:@"description"];
    self.appDescription.top = self.appSize.bottom;
}

- (void)openAppDownloadUrl:(UITapGestureRecognizer *)gesture{
    [MobClick event:@"3" label:self.appName.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appDownloadUrl]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
