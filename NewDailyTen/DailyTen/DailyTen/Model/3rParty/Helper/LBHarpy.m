  //
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "LBHarpy.h"
#import "LBHarpyConstants.h"

#define kHarpyCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]

@interface LBHarpy ()

//+ (void)showAlertWithAppStoreVersion:(NSString*)appStoreVersion;
+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion updateContent:(NSString *)content;

@end

@implementation LBHarpy

#pragma mark - Public Methods
+ (void)checkVersion
{

    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kHarpyAppID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                NSArray *updateContentArray = [[appData valueForKey:@"results"] valueForKey:@"releaseNotes"];
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                    
                    return;
                    
                } else {

                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    NSLog(@"%@",kHarpyCurrentVersion);
                    
                    if ([kHarpyCurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
		                
                        [LBHarpy showAlertWithAppStoreVersion:currentAppStoreVersion updateContent:[updateContentArray lastObject]];
	                
                    }
                    else {
		            
                        // Current installed version is the newest public version or newer	
	                
                          }

                }
              
            });
        }
        
    }];
}

#pragma mark - Private Methods
+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion updateContent:(NSString *)content
{
    
//    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSRange range = [content rangeOfString:@"用户体验"];
    NSLog(@"%@",NSStringFromRange([content rangeOfString:@"用户体验"]));
    if (range.length > 0) {
        harpyForceUpdate = YES;
    }
    
    
    if ( harpyForceUpdate ) { // Force user to update app
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
//                                                            message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.", appName, currentAppStoreVersion]
//                                                           delegate:self
//                                                  cancelButtonTitle:kHarpyUpdateButtonTitle
//                                                  otherButtonTitles:nil, nil];
        NSString *ignoredVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"ignoredVersion"];
        if (!ignoredVersion || ![ignoredVersion isEqualToString:currentAppStoreVersion]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@%@", kHarpyAlertViewTitle ,currentAppStoreVersion]
                                                                message:[NSString stringWithFormat:@"每日十个%@版已上线，快来更新吧！\n%@新版：",currentAppStoreVersion, content]
                                                               delegate:self
                                                      cancelButtonTitle:kHarpyUpdateButtonTitle
                                                      otherButtonTitles:nil, nil];
            
            
            
            [alertView show];
            [[NSUserDefaults standardUserDefaults] setObject:currentAppStoreVersion forKey:@"ignoredVersion"];
        }
        
               
    } else { // Allow user option to update next time user launches your app
        
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
//                                                            message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.", appName, currentAppStoreVersion]
//                                                           delegate:self
//                                                  cancelButtonTitle:kHarpyCancelButtonTitle
//                                                  otherButtonTitles:kHarpyUpdateButtonTitle, nil];
        NSString *ignoredVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"ignoredVersion"];
        if (!ignoredVersion || ![ignoredVersion isEqualToString:currentAppStoreVersion]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:@"每日十个%@版已上线，快来更新吧！\n新版：%@",currentAppStoreVersion
                                                                     ,content]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyCancelButtonTitle
                                                  otherButtonTitles:kHarpyUpdateButtonTitle, nil];

            [alertView show];
            [[NSUserDefaults standardUserDefaults] setObject:currentAppStoreVersion forKey:@"ignoredVersion"];
        }
    }
}

#pragma mark - UIAlertViewDelegate Methods
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ( harpyForceUpdate ) {

        NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
        NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
        [[UIApplication sharedApplication] openURL:iTunesURL];
        
    } else {

        switch ( buttonIndex ) {
                
            case 0:{ // Cancel / Not now
        
                // Do nothing
                // 为了强制更新使用，使用后删除掉本代码
                
            } break;
                
            case 1:{ // Update
                
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
                NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:iTunesURL];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ignoredVersion"];
            } break;
                
            default:
                break;
        }
        
    }

    
}

@end
