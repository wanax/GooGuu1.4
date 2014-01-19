//
//  AppDelegate.m
//  GooGuu
//
//  Created by Xcode on 14-1-8.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "AppDelegate.h"
#import "MyGooguuViewController.h"
#import "FinPicKeyWordListViewController.h"
#import "GooGuuViewController.h"
#import "GGReportListVC.h"
#import "GooGuuIndexViewController.h"
#import "UniverseViewController.h"
#import "Reachability.h"
#import "PonyDebugger.h"
#import "tipViewController.h"
#import "AgreementViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow *tempWin = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window = tempWin;
    
    [self netChecked];
    [self addLoginEventListen];
    [self startCrashlytics];
    [self shouldKeepLogin];
    //[self setPonyDebugger];
    
    SetConfigure(@"userconfigure",@"stockColorSetting",([NSString stringWithFormat:@"%d",0]));
    SetUserDefaults(@"1.0.3", @"version");
    
    [self startProcess];
    
    [self.window setBackgroundColor:[Utiles colorWithHexString:@"#DCDCD6"]];
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark -
#pragma mark Start Process
-(void)startProcess{
    if (GetUserDefaults(@"firstLaunch") == nil) {
        SetConfigure(@"userconfigure", @"checkUpdate", @"0");
        TipViewController * startView = [[TipViewController alloc]init];
        self.window.rootViewController = startView;
        [startView release];
    }else if([[NSUserDefaults standardUserDefaults] objectForKey:@"agreement"]==nil){
        
        AgreementViewController * agreement = [[AgreementViewController alloc]init];
        self.window.rootViewController = agreement;
        [agreement release];
        
    }else {
        if(GetConfigure(@"userconfigure", @"checkUpdate", YES)){
            BOOL isOn=[Utiles stringToBool:GetConfigure(@"userconfigure", @"checkUpdate", YES)];
            if(isOn){
                [self checkUpdate];
            }
        }
        [self initComponents];
    }
}

#pragma mark -
#pragma mark Update Checked
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GetConfigure(@"FrameParamConfig", @"AppDownLoadURL", NO)]];
    }
}
-(void)checkUpdate{
    AFHTTPClient *getAction=[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:GetConfigure(@"FrameParamConfig", @"iTunesURL", NO)]];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:GetConfigure(@"FrameParamConfig", @"GooguuAPPID", NO),@"id",nil];
    
    [getAction getPath:@"/lookup" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        NSString *version = @"";
        NSArray *configData = [[operation.responseString objectFromJSONString] valueForKey:@"results"];
        
        for (id config in configData){
            version = [config valueForKey:@"version"];
        }
        if (![version isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"version"]]){
            UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"新版本" message: @"下载新的版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"下载", nil];
            [createUserResponseAlert show];
            [createUserResponseAlert release];
        }
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
    }];
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
    
    NSUserDefaults *userDeaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[[[userDeaults objectForKey:@"UserInfo"] objectForKey:@"username"] lowercaseString],@"username",[Utiles md5:[[userDeaults objectForKey:@"UserInfo"] objectForKey:@"password"]],@"password",@"googuu",@"from", nil];
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
#pragma mark Generate Components

-(void)initComponents{
    UITabBarItem *barItem=[[[UITabBarItem alloc] initWithTitle:@"估股首页" image:[UIImage imageNamed:@"googuuNewsBar"] tag:1] autorelease];
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
    MyGooguuViewController *myGGVC = [[[MyGooguuViewController alloc] init] autorelease];
    myGGVC.tabBarItem = barItem5;
    UINavigationController *myGGNav = [[[UINavigationController alloc] initWithRootViewController:myGGVC] autorelease];
    
    UITabBarController *tempBar = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController = tempBar;
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:ggIndexNav,ggNewsNav,ggModelNav,ggViewNav,myGGNav,nil];
    
    self.window.backgroundColor=[UIColor clearColor];
    self.window.rootViewController = self.tabBarController;
}


@end
