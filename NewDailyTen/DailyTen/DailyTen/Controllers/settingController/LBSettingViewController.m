//
//  LBSettingViewController.m
//  DailyTen
//
//  Created by 乐播 on 13-9-8.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBSettingViewController.h"
#import "LBSettingCell.h"

#define CancelTheAuthorization @"未授权"

@interface LBSettingViewController () <UIActionSheetDelegate ,SinaHelperDelegate, TencentHelperDelegate ,UMFeedbackDataDelegate>{
    UMFeedback *_umFeedback;            // 友盟
    float       cacheFileSize;          // 缓存文件大小

}

@property (nonatomic, strong)  NSMutableArray *titleArray;
@property (nonatomic, strong)  NSMutableArray *contentsArray;

@end

@implementation LBSettingViewController
@synthesize titleArray, contentsArray, mtableView;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:@"设置页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"设置页面"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithImage:@"back.png" backgroundImage:nil target:self action:@selector(backClicked:)];
    self.mtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 44) style:UITableViewStyleGrouped];
//    if (IS_IOS7) {
//        self.mtableView.top = 64;
//        self.mtableView.height = self.view.height - 64;
//    }
    self.mtableView.delegate = self;
    self.mtableView.dataSource = self;
    self.mtableView.backgroundView = [[UIView alloc] init];
    self.mtableView.backgroundColor = RGB(241, 241, 241);
    [self.mtableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.mtableView setSeparatorColor:RGB(228, 228, 228)];
    [self.view addSubview:self.mtableView];
    cacheFileSize = [Global getCalculateCacheFilesSize];
    
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"新浪微博", @"人人网", @"腾讯空间/微博", nil];
    self.contentsArray = [[NSMutableArray alloc] initWithObjects:CancelTheAuthorization, CancelTheAuthorization, CancelTheAuthorization, nil];
    if ([SinaHelper getSinaNickNameDelegate:self]) {
        [self.contentsArray replaceObjectAtIndex:0 withObject:[SinaHelper getSinaNickNameDelegate:self]];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"renrenName"]) {
        [self.contentsArray replaceObjectAtIndex:1 withObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"renrenName"]];
    }if ([[NSUserDefaults standardUserDefaults] objectForKey:@"tencentNickName"]) {
        [self.contentsArray replaceObjectAtIndex:2 withObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"tencentNickName"]];
    }

    [UMFeedback setLogEnabled:NO];
    _umFeedback = [UMFeedback sharedInstance];
    [_umFeedback setAppkey:youMengAPPID delegate:self];

}

- (void)backClicked:(UIBarButtonItem *)barItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    if (section == 4) {
        return 20.0f;
    }
    if (section == 6) {
        return 20;
    }
    return  0.1f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = nil;
    if (section == 6) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"lebo://"]]) {
            title = @"已下载的应用";
        }else{
            title = @"未下载的应用";
        }
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier1 = @"Cell1";
    
    if (indexPath.section > 5) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        cell.imageView.image = [UIImage imageNamed:@"leboicon.png"];
        cell.textLabel.text = @"乐播";
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"lebo://"]]) {
            UIButton *startAppBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            startAppBtn.frame = CGRectMake(250, 8, 60, 30);
            [startAppBtn setTitle:@"启动" forState:UIControlStateNormal];
            [startAppBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [startAppBtn addTarget:self action:@selector(startAppBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:startAppBtn];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;

    }
    
    
    LBSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[LBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.customLabel.hidden = YES;
    cell.customSwich.hidden = YES;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    if (indexPath.section < self.titleArray.count) {
        cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.section];
        cell.customLabel.text = [self.contentsArray objectAtIndex:indexPath.section];
        cell.customLabel.hidden = NO;
    }
    
//    if(indexPath.section == 3){
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.textLabel.text = @"2G/3G网络自动播放";
//        [self check3GAutoPlay:cell];
//    }
    else if (indexPath.section == 3){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"每周定时提醒";
        [self checkDailyPush:cell];
    }
    else if(indexPath.section == 4){
        cell.textLabel.text = @"意见反馈";
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barBg.png"]];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }else if(indexPath.section == 5){
        cell.textLabel.text = [NSString stringWithFormat:@"清除缓存   %.1fMB", cacheFileSize];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barBg.png"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < self.contentsArray.count) {
        NSString *content = [self.contentsArray objectAtIndex:indexPath.section];
        if ([content isEqualToString:CancelTheAuthorization]) {
            if (indexPath.section == 0) {
                [self sinaLogin];
            }else if (indexPath.section == 1){
                [self renrenLogin];
            }else if (indexPath.section == 2){
                [self tencentLogin];
            }
        }else{
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除授权", nil];
            sheet.tag = indexPath.section + 100;
            [sheet showInView:self.view];
        }
    }
    
    if (indexPath.section == 4) {
        [UMFeedback showFeedback:self withAppkey:youMengAPPID];
    }
    else if (indexPath.section == 5){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"清除所有缓存,离线视频" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        actionSheet.tag = 133;
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [actionSheet showInView:self.view];
    }
    else if (indexPath.section == 6){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"lebo://"]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"lebo://"]];
        }
        else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LEBOAPPSTOREURL]];
    }
}

- (void)startAppBtnClicked:(UIButton *)sender{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"lebo://"]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"lebo://"]];
    }
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LEBOAPPSTOREURL]];
}

- (void)check3GAutoPlay:(LBSettingCell *)cell{
    cell.customSwich.tag = 100;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:AutoPlay];
    [cell.customSwich setOn:number.boolValue];
    cell.customSwich.hidden = NO;
}

- (void)checkDailyPush:(LBSettingCell *)cell{
    cell.customSwich.tag = 101;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:DailyPush];
    [cell.customSwich setOn:number.boolValue];
    cell.customSwich.hidden = NO;
    if (number.boolValue) {
        if (![LocalPushHelper checkLocalPush]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"needLocalPush"];
        }
    }else{
        [LocalPushHelper removeLocalPush];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"needLocalPush"];

    }
}

#pragma mark - sheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        switch (actionSheet.tag) {
            case 100:{
                [self sinaLogout];
                break;
            }
            case 101:{
                [self renrenLogout];
                break;
            }
            case 102:{
                [self tencentLogout];
                break;
            }case 133:{
                if (buttonIndex == 0) {
                    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.labelText = @"清理中...";
                    [FileUtil performSelectorInBackground:@selector(clearCache) withObject:nil];
                    hud.labelText = @"清除成功";
                    [hud hide:YES afterDelay:1];
                    [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
                    cacheFileSize = 0;
                    [self.mtableView reloadData];
                    
                }
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - sina
- (void)sinaLogin{
    if (![[SinaHelper getHelper] sinaIsAuthValid]) {
        [[SinaHelper getHelper] setDelegate:self];
        [[SinaHelper getHelper] login];
    }else{
        if ([SinaHelper  getSinaNickNameDelegate:self]) {
            [self.contentsArray replaceObjectAtIndex:0 withObject:[SinaHelper  getSinaNickNameDelegate:self]];
            [self.mtableView reloadData];
        }
    }
}

- (void)sinaLogout{
    [[SinaHelper getHelper] setDelegate:self];
    [[SinaHelper getHelper] logout];
}

- (void)sinaGetUserInfo:(NSDictionary *)userInfo{
    if ([SinaHelper  getSinaNickNameDelegate:self]) {
        [self.contentsArray replaceObjectAtIndex:0 withObject:[SinaHelper  getSinaNickNameDelegate:self]];
    }
    [self.mtableView reloadData];
}
- (void)sinaGetFailUserInfo:(NSError *)error{

}

- (void)sinaDidLogin:(NSDictionary *)userInfo{
   
}

- (void)sinaDidLogout{
    [self.contentsArray replaceObjectAtIndex:0 withObject:CancelTheAuthorization];
    [self.mtableView reloadData];
}

- (void)sinaDidFailLogin:(NSError *)error{

}

- (void)sinaDidLoginCancel{

}

#pragma mark - renren
- (void)renrenLogin{
//    if (![RenRenHelper isAuthorizeValid]) {
//        [RenRenHelper renrenLoginTarget:self];
//    }else{
//        if ([RenRenHelper getRenrenUserNickNameTarget:self]) {
//            [self.contentsArray replaceObjectAtIndex:1 withObject:[RenRenHelper getRenrenUserNickNameTarget:self]];
//            [self.mtableView reloadData];
//        }
//    }
}

- (void)renrenLogout{
//    [RenRenHelper renrenLogoutTarget:self];
}

- (void)renRenLoginSuccess{
//    if ([RenRenHelper getRenrenUserNickNameTarget:self]) {
//        [self.contentsArray replaceObjectAtIndex:1 withObject:[RenRenHelper getRenrenUserNickNameTarget:self]];
//        [self.mtableView reloadData];
//    }
}

- (void)renrenLogoutSuccess{
    [self.contentsArray replaceObjectAtIndex:1 withObject:CancelTheAuthorization];
    [self.mtableView reloadData];
}

- (void)renRenLoginFail{

}

- (void)renRenLoginCancelded{
}

- (void)renrenGetUserNikeNameResult:(id)result{
//    if ([RenRenHelper getRenrenUserNickNameTarget:self]) {
//        [self.contentsArray replaceObjectAtIndex:1 withObject:[RenRenHelper getRenrenUserNickNameTarget:self]];
//        [self.mtableView reloadData];
//    }
}

#pragma mark - tencent
- (void)tencentLogin{
    if (![TencentHelper isSessionValid] ) {
        [TencentHelper  login:self];
    }else{
        if ([TencentHelper getUserNikeName:self]) {
             [self.contentsArray replaceObjectAtIndex:2 withObject:[TencentHelper getUserNikeName:self]];
            [self.mtableView reloadData];
        }
    }
}

- (void)tencentLogout{
    [TencentHelper  logout:self];
}

- (void)tencentDidLoginSuccess{
    if ([TencentHelper getUserNikeName:self]) {
        [self.contentsArray replaceObjectAtIndex:2 withObject:[TencentHelper getUserNikeName:self]];
        [self.mtableView reloadData];
    }
}

- (void)tencentDidLogout{
    [self.contentsArray replaceObjectAtIndex:2 withObject:CancelTheAuthorization];
    [self.mtableView reloadData];
}

- (void)tencentDidDotLogined:(NSNumber *)cancelled{

}

- (void)getUserInfoSuccess:(NSDictionary *)userinfo{
    if ([userinfo objectForKey:@"nickname"]) {
        [self.contentsArray replaceObjectAtIndex:2 withObject:[userinfo objectForKey:@"nickname"]];
        [self.mtableView reloadData];
    }
    NSLog(@"用户名获取成功");
}

- (void)getUserInfoFail:(NSDictionary *)failinfo {
    NSLog(@"用户名获取失败 %@  " ,failinfo);
}

@end
