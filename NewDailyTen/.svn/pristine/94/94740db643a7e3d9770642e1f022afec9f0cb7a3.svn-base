//
//  LBAppDelegate.h
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBAppDelegate : UIResponder <UIApplicationDelegate ,WXApiDelegate>{
    enum WXScene                _scene;

}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
//  发视频到微信
-(void) sendVideoContent:(NSString *)content title:(NSString *)title thumbImage:(UIImage *)thumbImage videoUrl:(NSString *)videoUrl;
// 发音乐到微信
- (void)sendMusicContent:(NSString *)content title:(NSString *)title thumbImage:(UIImage *)thumbImage musicUrl:(NSString *)musicUrl;
-(void) changeScene:(NSInteger)scene;
// 发应用信息到微信
- (void) sendAppContent;
- (void)changeToRootVC;

@end
