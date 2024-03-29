//
//  LBAppDelegate.m
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBAppDelegate.h"
#import "FnoDailyTen.h"
#import "LaunchImageTransition.h"
@implementation LBAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    // 友盟
    [MobClick startWithAppkey:youMengAPPID reportPolicy:0 channelId:@""];
    // 注册微信
    [WXApi registerApp:wxAPPID];
    // 3G自动播放
    if (![[NSUserDefaults standardUserDefaults] objectForKey:AutoPlay]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:AutoPlay];
    }
    
    // 每周提醒
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"firstUse"]) {
         [self startLocalPushOrNot];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"firstUse"];
    }
   
    
    NSDate *  senddate=[NSDate date]; 
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *  nsDateString= [NSString  stringWithFormat:@"%4ld年%2ld月%2ld日",(long)year,(long)month,(long)day];
    NSString *movieModel = [nsDateString stringByAppendingFormat:@"-movie"];
    NSString *musicModel = [nsDateString stringByAppendingFormat:@"-music"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:movieModel];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:musicModel];
    
    if ([self checkVersionIsChangeOrFisrtUse]) {
        WZGuideViewController *guideVC = [[WZGuideViewController alloc] init];
        guideVC.delegate = self;
        self.window.rootViewController = guideVC;
    }else{
        LBRootViewController *RootVC = [[LBRootViewController alloc] init];
        UINavigationController *RootNav = [[UINavigationController alloc] initWithRootViewController:RootVC];
        LaunchImageTransition *launchTransition = [[LaunchImageTransition alloc] initWithViewController:RootNav animation:UIModalTransitionStyleCrossDissolve delay:2.0f];
        self.window.rootViewController = launchTransition;
    }
    
//    [self startAPServiceWithLaunchOptions:launchOptions];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)changeToRootVC{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"preVersion"];
    LBRootViewController *RootVC = [[LBRootViewController alloc] init];
    UINavigationController *RootNav = [[UINavigationController alloc] initWithRootViewController:RootVC];
    self.window.rootViewController = RootNav;
}

- (BOOL)checkVersionIsChangeOrFisrtUse{
    BOOL mm = YES;
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *preVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"preVersion"];
    NSLog(@"version  %@", version);
    NSLog(@"preVersion  %@" ,preVersion);
    if (!preVersion && ![preVersion isEqualToString:version]) {
        mm = YES;
    }else{
        mm = NO;
    }
    return mm;
}

//// 开启aps服务
//- (void)startAPServiceWithLaunchOptions:(NSDictionary *)launchOptions{
//    // Required
//    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                   UIRemoteNotificationTypeSound |
//                                                   UIRemoteNotificationTypeAlert)
//                                       categories:nil];
//    [APService setupWithOption:launchOptions];
//    
//}

// 开启本地推送
- (void)startLocalPushOrNot{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:DailyPush]) {
        [LocalPushHelper performSelectorInBackground:@selector(setLocationPush) withObject:nil];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:DailyPush];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // 检查新版本
    [LBHarpy checkVersion];
}

//  第二步：接收本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    // 图标上的数字减1
    application.applicationIconBadgeNumber -= 1;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error  %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@", userInfo);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL mm = YES;
    mm = [TencentOAuth HandleOpenURL:url] || [QQApiInterface handleOpenURL:url delegate:[QQApiHelper shareInstance]];
    if ([[url scheme] isEqualToString:@"lebo"]) {
//        mm = [self handleOpenUrl:url delegate:self];
    }
//    mm = [self.sinaweibo handleOpenURL:url];
    return mm;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    /*
     //如果有客户端，则打开客户端。否则打开APP选择下载
     
     if([[UIApplication sharedApplication] canOpenURL:url]){
     return [self.share myhandleOpenURL:url];
     } else {
     //暂时为NULL 因为没有苹果对应产品ID号
     NSURL *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", NULL];
     [[UIApplication sharedApplication] openURL:url];
     }
     */
    BOOL mm = NO;
    
    if ([sourceApplication isEqualToString:sinaSource]) {
        mm = [[SinaHelper getHelper].sinaweibo handleOpenURL:url];
    }
    else if ([sourceApplication isEqualToString:weixinSource]){
        mm = [WXApi handleOpenURL:url delegate:self];
    }
    else if ([sourceApplication isEqualToString:renSource]){
//        mm = [RennClient handleOpenURL:url];
    }
    
    mm = [TencentOAuth HandleOpenURL:url] || [QQApiInterface handleOpenURL:url delegate:[QQApiHelper shareInstance]];
    
    if ([[url scheme] isEqualToString:@"lebo"]){
        if ([[url host] isEqualToString:@"topic"]) {
//            mm = [self handleOpenUrl:url delegate:self];
        }else {
            
        }
    }
    
    return mm;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - 微信 method
// 发视频到微信好友回调
- (void)onResp:(BaseResp*)resp
{
    if (resp.errCode == 0) {
        [MobClick event:@"3" label:@"微信分享成功数"];
    }
    NSLog(@"微信发送完毕,  返回时调用!");
}

// 发视频到微信好友
- (void)sendVideoContent:(NSString *)content title:(NSString *)title thumbImage:(UIImage *)thumbImage videoUrl:(NSString *)videoUrl
{
    WXMediaMessage *message = [WXMediaMessage message];
    if (!title || [title isEqualToString:@""]) {
        message.title = WXDEFAULTTEXT;
        message.description = title;
    }else{
        message.title = title;
    }
    // 压缩视频缩略图 wx上传图片需小于32k
    LeBoImagePicker *picker = [[LeBoImagePicker alloc] init];
    NSData *data = [picker compressImage:thumbImage PixelCompress:YES MaxPixel:200 JPEGCompress:YES MaxSize_KB:32.0f];
    
    NSLog(@"%f",data.length/1024.0f);
    message.thumbData = data;
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = videoUrl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.text = @"Hello World";
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

//切换 分享到对话或者是朋友圈
- (void)changeScene:(NSInteger)scene{
    _scene = scene;
}

- (void)sendMusicContent:(NSString *)content title:(NSString *)title thumbImage:(UIImage *)thumbImage musicUrl:(NSString *)musicUrl
{
    WXMediaMessage *message = [WXMediaMessage message];
    if (content) {
        message.title = content;
    }else{
        message.title = MusicWXDEFAULTTEXT;
    }
    
    message.description = content;
    // 压缩视频缩略图 wx上传图片需小于32k
    LeBoImagePicker *picker = [[LeBoImagePicker alloc] init];
    NSData *data = [picker compressImage:thumbImage PixelCompress:YES MaxPixel:200 JPEGCompress:YES MaxSize_KB:32.0f];
    [message setThumbData:data];
    NSLog(@"%f",data.length/1024.0f);
//    [message setThumbImage:[UIImage imageNamed:@"thumbData"]];
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = musicUrl;
    ext.musicDataUrl = musicUrl;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}


#define BUFFER_SIZE 1024 * 100
- (void)sendAppContent
{
    // 发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = APPLICATIONTITLE;
    message.description = WXDEFAULTTEXT;
    LeBoImagePicker *picker = [[LeBoImagePicker alloc] init];
    NSData *data = [picker compressImage:[UIImage imageNamed:@"LOGOWX.png"] PixelCompress:YES MaxPixel:200 JPEGCompress:YES MaxSize_KB:32.0f];
    
    [message setThumbData:data];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.url = APPSTOREURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

@end
