//
//  AppDelegate.m
//  GooGuu
//
//  Created by Xcode on 14-1-8.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "BPush.h"
#import "FinPicKeyWordListViewController.h"
#import "GooGuuViewController.h"
#import "GGReportListVC.h"
#import "GooGuuIndexViewController.h"
#import "MyGGIndexViewController.h"
#import "UniverseViewController.h"
#import "Reachability.h"
#import "PonyDebugger.h"
#import "tipViewController.h"
#import "AgreementViewController.h"
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow *tempWin = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window = tempWin;
    
    [self netChecked];
    [self addLoginEventListen];
    [self startCrashlytics];
    [self shouldKeepLogin];
    [self startCrashlytics];
    [self beginBaiDuPush:application lanuchOpions:launchOptions];
    [self beginBaiDuStatistics];
    [self configureShareSDK];
    //[self setPonyDebugger];
    
    SetConfigure(@"userconfigure",@"stockColorSetting",([NSString stringWithFormat:@"%d",0]));
    SetUserDefaults(@"1.1.0", @"version");
    
    [self startProcess];
    
    [self.window setBackgroundColor:[Utiles colorWithHexString:@"#DCDCD6"]];
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark -
#pragma mark Start Process
-(void)startProcess{
    [self initComponents];
}


#pragma mark -
#pragma ShareSDK

-(void)configureShareSDK {
    
    [ShareSDK registerApp:GetConfigure(@"FrameParamConfig", @"ShareSDKRegisterApp", NO)];
    
    [ShareSDK connectSinaWeiboWithAppKey:GetConfigure(@"FrameParamConfig", @"ShareSDKSinaWeiboAppKey", NO)
                               appSecret:GetConfigure(@"FrameParamConfig", @"ShareSDKSinaWeiboAppSecret", NO)
                             redirectUri:GetConfigure(@"FrameParamConfig", @"ShareSDKSinaWeiboRedirectUri", NO)];
    
    [ShareSDK connectWeChatWithAppId:GetConfigure(@"FrameParamConfig", @"ShareSDKWeChatAppId", NO) wechatCls:[WXApi class]];
    
}

#pragma WeiChatHandler

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url {
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}


#pragma mark -
#pragma mark BaiDu Statistics
-(void)beginBaiDuStatistics{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;
    statTracker.logSendWifiOnly = YES;
    [statTracker startWithAppId:GetConfigure(@"FrameParamConfig", @"BaiDuStatisticsAppID", NO)];
}


#pragma mark -
#pragma mark Net Reachable
-(void)netChecked{
    Reachability *reach = [Reachability reachabilityWithHostname:GetConfigure(@"FrameParamConfig", @"NetCheckURL", NO)];
    reach.reachableOnWWAN = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [reach startNotifier];
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable]){
        NSLog(@"Reachable");
        self.isReachable=YES;
    }else{
        NSLog(@"NReachable");
        self.isReachable=NO;
    }
}

#pragma mark -
#pragma mark Keep Login
-(void)shouldKeepLogin{
    if([Utiles isLogin]){
        [self handleTimer:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginKeeping" object:nil];
        [self loginKeeping:nil];
    }
}
-(void)addLoginEventListen{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginKeeping:) name:@"LoginKeeping" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLoginKeeping:) name:@"LogOut" object:nil];
}

-(void)loginKeeping:(NSNotification*)notification{
    self.loginTimer = [NSTimer scheduledTimerWithTimeInterval: 7000 target: self selector: @selector(handleTimer:) userInfo: nil repeats: YES];
}
-(void)cancelLoginKeeping:(NSNotification*)notification{
    [self.loginTimer invalidate];
}

- (void) handleTimer: (NSTimer *) timer{

    id userInfo = [GetUserDefaults(@"UserInfo") objectFromJSONString];
    NSDictionary *params = @{
                             @"username":userInfo[@"username"],
                             @"password":[Utiles md5:userInfo[@"password"]],
                             @"from":@"googuu"
                             };
    [Utiles getNetInfoWithPath:@"Login" andParams:params besidesBlock:^(id resObj){
        
        if([[resObj objectForKey:@"status"] isEqualToString:@"1"]){
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"UserToke"];
            [userDefaults setObject:[resObj objectForKey:@"token"] forKey:@"UserToken"];
            
            NSLog(@"%@",[resObj objectForKey:@"token"]);
            
        }else {
            NSLog(@"%@",[resObj objectForKey:@"msg"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -
#pragma mark PonyDebugger
-(void)setPonyDebugger{
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    
    [debugger enableViewHierarchyDebugging];
    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque"]];
    
    [debugger enableRemoteLogging];
    [debugger connectToURL:[NSURL URLWithString:GetConfigure(@"FrameParamConfig", @"PonyDebuggerURL", NO)]];
}
#pragma mark -
#pragma mark Start Crashlytics
-(void)startCrashlytics{
    //[Crashlytics startWithAPIKey:GetConfigure(@"FrameParamConfig", @"CrashlyticsAPIKey", NO)];
}

#pragma mark -
#pragma mark BaiDu Push
-(void)beginBaiDuPush:(UIApplication *)application lanuchOpions:(NSDictionary *)launchOptions{
    [BPush setupChannel:launchOptions]; // 必须
    [BPush setDelegate:self];
    [application setApplicationIconBadgeNumber:0];
    [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
}
- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Did receive a Remote Notification" message:[NSString stringWithFormat:@"The application received this remote notification while it was running:\n%@", alert] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    [application setApplicationIconBadgeNumber:0];
    [BPush handleNotification:userInfo];
}

#pragma mark -
#pragma mark Generate Components

-(void)initComponents{
    UITabBarItem *barItem=[[[UITabBarItem alloc] initWithTitle:@"估股首页" image:[UIImage imageNamed:@"googuuLogoBar"] tag:1] autorelease];
    UITabBarItem *barItem2=[[[UITabBarItem alloc] initWithTitle:@"业绩简报" image:[UIImage imageNamed:@"googuuNewsBar"] tag:2] autorelease];
    UITabBarItem *barItem3=[[[UITabBarItem alloc] initWithTitle:@"估值模型" image:[UIImage imageNamed:@"companyListBar"] tag:3] autorelease];
    UITabBarItem *barItem4=[[[UITabBarItem alloc] initWithTitle:@"估值观点" image:[UIImage imageNamed:@"googuuViewBar"] tag:4] autorelease];
    UITabBarItem *barItem5=[[[UITabBarItem alloc] initWithTitle:@"我的估股" image:[UIImage imageNamed:@"myGooGuuBar"] tag:5] autorelease];
    //估股首页
    GooGuuIndexViewController *ggIndexVC = [[[GooGuuIndexViewController alloc] init] autorelease];
    ggIndexVC.tabBarItem = barItem;
    UINavigationController *ggIndexNav = [[[UINavigationController alloc] initWithRootViewController:ggIndexVC] autorelease];
    //业绩简报
    GGReportListVC *ggNewsVC = [[[GGReportListVC alloc] init] autorelease];
    ggNewsVC.tabBarItem = barItem2;
    UINavigationController *ggNewsNav = [[[UINavigationController alloc] initWithRootViewController:ggNewsVC] autorelease];
    //估值模型
    UniverseViewController *ggModelVC = [[[UniverseViewController alloc] init] autorelease];
    ggModelVC.tabBarItem=barItem3;
    UINavigationController *ggModelNav = [[[UINavigationController alloc] initWithRootViewController:ggModelVC] autorelease];
    //估值观点
    GooGuuViewController *ggViewVC = [[[GooGuuViewController alloc] init] autorelease];
    ggViewVC.tabBarItem = barItem4;
    UINavigationController *ggViewNav = [[[UINavigationController alloc] initWithRootViewController:ggViewVC] autorelease];
    //我的估股
    MyGGIndexViewController *myGGVC = [[[MyGGIndexViewController alloc] init] autorelease];
    myGGVC.tabBarItem = barItem5;
    UINavigationController *myGGNav = [[[UINavigationController alloc] initWithRootViewController:myGGVC] autorelease];
    
    UITabBarController *tempBar = [[[UITabBarController alloc] init] autorelease];
    //AppDelegate本身无法完成代理任务，交给ggIndexVC完成
    tempBar.delegate = ggIndexVC;
    self.tabBarController = tempBar;
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:ggIndexNav,ggNewsNav,ggModelNav,ggViewNav,myGGNav,nil];
    [self configureBarIndicator];
    self.window.backgroundColor=[UIColor clearColor];
    self.window.rootViewController = self.tabBarController;
}

-(void)configureBarIndicator {
    
    [Utiles getNetInfoWithPath:@"GetRootBarIndicator" andParams:nil besidesBlock:^(id obj) {
        
        int viewCount = [GetConfigure(@"BarIndicator", @"ViewCount", YES) integerValue];
        int modelCount = [GetConfigure(@"BarIndicator", @"ModelCount", YES) integerValue];
        int reportCount = [GetConfigure(@"BarIndicator", @"ReportCount", YES) integerValue];
        
        viewCount = [obj[@"ggviewcount"] integerValue] - viewCount;
        modelCount = [obj[@"modelcount"] integerValue] - modelCount;
        reportCount = [obj[@"reportcount"] integerValue] - reportCount;
        
        [self.tabBarController.tabBar.items[1] setBadgeValue:reportCount == 0?nil:[NSString stringWithFormat:@"%d",reportCount]];
        [self.tabBarController.tabBar.items[2] setBadgeValue:modelCount == 0?nil:[NSString stringWithFormat:@"%d",modelCount]];
        [self.tabBarController.tabBar.items[3] setBadgeValue:viewCount == 0?nil:[NSString stringWithFormat:@"%d",viewCount]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


@end
