//
//  SettingCenterViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-21.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "SettingCenterViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "ClientLoginViewController.h"
#import "PrettyKit.h"
#import "DoubleLabelCell.h"
#import "LabelSwitchCell.h"
#import "StockRiseDownColorSettingViewController.h"
#import "AboutUsAndCopyrightViewController.h"
#import "FeedBackViewController.h"
#import "HelpViewController.h"
#import "DisclaimersViewController.h"
#import "ClientCenterViewController.h"
#import "UserRegisterViewController.h"

@interface SettingCenterViewController ()

@end

@implementation SettingCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    [self.customTabel reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"功能设置"];
    [self initCommonents];

}
#pragma mark -
#pragma mark General Methods

-(void)initCommonents{
    UITableView *temp = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStyleGrouped] autorelease];
    self.customTabel = temp;
    self.customTabel.delegate=self;
    self.customTabel.dataSource=self;
    [self.view addSubview:self.customTabel];
}

-(void)switchChange:(UISwitch *)p{

    BOOL isButtonOn = [p isOn];
    if(p.tag==1){
        [self setUserConfigure:@"wifiImg" isOn:isButtonOn];
    }else if(p.tag==2){
        [self setUserConfigure:@"checkUpdate" isOn:isButtonOn];
    }
    
}
-(void)setUserConfigure:(NSString *)key isOn:(BOOL)isButtonOn{
    if (isButtonOn) {
        [Utiles setConfigureInfoTo:@"userconfigure" forKey:key andContent:@"1"];
    }else {
        [Utiles setConfigureInfoTo:@"userconfigure" forKey:key andContent:@"0"];
    }
}

#pragma mark -
#pragma mark Table Data Source Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;//section头部高度
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 4;
    }else if(section==1){
        return 1;
    }else if(section==2){
        return 1;
    }else if(section==3){
        return 6;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return @"账号管理";
    }else if (section == 1){
        return @"功能设置";
    }else if (section == 2){
        return @"缓存设置";
    }else if(section==3){
        return @"其它";        
    }
    return @"";
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(10, 3, 300, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    if(section==0){
     
        static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 TableSampleIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:TableSampleIdentifier] autorelease];
        }
        cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:16.0f];
        cell.detailTextLabel.font=[UIFont fontWithName:@"Heiti SC" size:12.0f];
        if (row==0) {
            cell.textLabel.text = @"我的资料";
            cell.detailTextLabel.text=@"我的信息,兴趣,关注行业";
        } else if(row==1){
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            if ([Utiles isLogin]) {
                cell.textLabel.text=@"注销";
            } else {
                cell.textLabel.text=@"登录";
            }
            cell.detailTextLabel.text=@"";
        } else if(row==2){
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.textLabel.text=@"找回密码";
            
            cell.detailTextLabel.text=@"";
        }
        else if(row==3){
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.textLabel.text=@"修改密码";
            
            cell.detailTextLabel.text=@"";
        }
        
        return cell;
        
    }else if(section==1){
       
        if(row==1){
            
            static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     TableSampleIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleValue1
                        reuseIdentifier:TableSampleIdentifier] autorelease];
            }

            cell.textLabel.text = @"设置涨跌示意颜色";
            cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:16.0f];
            cell.detailTextLabel.font=[UIFont fontWithName:@"Heiti SC" size:16.0f];
            int tag=[[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"stockColorSetting" inUserDomain:YES] intValue];
            if(tag==0){
                cell.detailTextLabel.text=@"红涨绿跌";
            }else if(tag==1){
                cell.detailTextLabel.text=@"绿涨红跌";
            }else if(tag==2){
                cell.detailTextLabel.text=@"黄涨蓝跌";
            }
            
            return cell;
            
        }else if(row==0){
            
            static NSString *LabelSwitchCellIdentifier = @"LabelSwitchCellIdentifier";
            
            LabelSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     LabelSwitchCellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"LabelSwitchCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            BOOL isOn=[Utiles stringToBool:[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"checkUpdate" inUserDomain:YES]];
            [cell.controlSwitch setOn:isOn animated:YES];
            cell.titleLabel.text = @"启动检查更新";
            cell.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:16.0f];
            [cell.controlSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
            cell.controlSwitch.tag=2;
            return cell;
            
        }
  
    }else if(indexPath.section==2){
        
        static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 TableSampleIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:TableSampleIdentifier] autorelease];
        }
        
        cell.textLabel.text = @"清除缓存";
        cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:16.0f];
        cell.detailTextLabel.font=[UIFont fontWithName:@"Heiti SC" size:16.0f];
        NSString *catchSize=[NSString stringWithFormat:@"%@KB",[Utiles getCatchSize]];
        cell.detailTextLabel.text=catchSize;
        
        return cell;
        
    }else if(indexPath.section==3){
        static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 TableSampleIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:TableSampleIdentifier] autorelease];
        }
        cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:16.0f];
        cell.detailTextLabel.font=[UIFont fontWithName:@"Heiti SC" size:12.0f];
        
        if(row==0){
   
            cell.textLabel.text = @"免责声明";
            cell.detailTextLabel.text=@"";
            return cell;
        }else if(row==2){
            cell.textLabel.text = @"应用打分";
            cell.detailTextLabel.text=@"请多多支持";
            return cell;
        }else if(row==3){
            
            cell.textLabel.text = @"帮助说明";
            cell.detailTextLabel.text=@"";
            return cell;
        }else if(row==4){

            cell.textLabel.text = @"意见反馈";
            cell.detailTextLabel.text=@"用户意见反馈";
            return cell;
        }else if(row==5){
            
            cell.textLabel.text = @"关于我们";
            cell.detailTextLabel.text=@"关于我们，版权信息";            
            return cell;
        }else if(row==1){
            
            cell.textLabel.text = @"金融工具";
            cell.detailTextLabel.text=@"";
            return cell;
        }
        
    }

    return nil;
}



#pragma mark -
#pragma mark Table Delegate Methods
-(void)pushViewController:(NSString *)viewName{
    
    UIViewController *viewController = [[NSClassFromString(viewName) alloc] init];
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
    SAFE_RELEASE(viewController);
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=indexPath.row;
    NSInteger section=indexPath.section;
    if(section==0){
        if ([Utiles isNetConnected]) {
            if (row==0) {
                if([Utiles isLogin]){
                    [self pushViewController:@"ClientCenterViewController"];
                }else{
                    [Utiles showToastView:self.view withTitle:nil andContent:@"您尚未登录" duration:1.0];
                }
            } else if(row==1){
                if ([Utiles isLogin]) {
                    [self logout];
                    [self.customTabel reloadData];
                } else {
                    ClientLoginViewController *loginViewController = [[[ClientLoginViewController alloc] initWithNibName:@"ClientLogin2View" bundle:nil] autorelease];
                    [self presentViewController:loginViewController animated:YES completion:nil];
                }
            }else if(row==2){//找回密码
                if ([Utiles isLogin]) {
                    [Utiles showToastView:self.view withTitle:nil andContent:@"您已登录" duration:1.5];
                } else {
                    UserRegisterViewController *regVC=[[[UserRegisterViewController alloc] init] autorelease];
                    regVC.actionType=UserFindPwd;
                    [self presentViewController:regVC animated:YES completion:nil];
                }
                
            }else if(row==3){//修改密码
                if (![Utiles isLogin]) {
                    [Utiles showToastView:self.view withTitle:nil andContent:@"您尚未登录" duration:1.5];
                } else {
                    UserRegisterViewController *regVC=[[[UserRegisterViewController alloc] init] autorelease];
                    regVC.actionType=UserFindPwd;
                    [self presentViewController:regVC animated:YES completion:nil];
                }
                
            }
        } else {
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }

    }else if(section==1){
        if(row==0){
            StockRiseDownColorSettingViewController *set=[[[StockRiseDownColorSettingViewController alloc] init] autorelease];
            [self presentViewController:set animated:YES completion:nil];
        }
    }else if(section==2){
        //[Utiles deleteSandBoxContent];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text=@"0";
    }else if(section==3){
        if(row==0){
            [self pushViewController:@"DisclaimersViewController"];
        }else if (row==2){
            
            NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",703282718];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }else if(row==3){
            [self pushViewController:@"HelpViewController"];
        }else if(row==4){
            [self pushViewController:@"FeedBackViewController"];
        }else if(row==5){
            if ([Utiles isNetConnected]) {
                [self pushViewController:@"AboutUsAndCopyrightViewController"];
            } else {
                [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
            }        
        }else if(row==1){
            [self pushViewController:@"FinanceToolsViewController"];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)logout{
    
    NSString *token= [Utiles getUserToken];
    if(token){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                token, @"token",@"googuu",@"from",
                                nil];
        [Utiles postNetInfoWithPath:@"LogOut" andParams:params besidesBlock:^(id info){
            
            if([[info objectForKey:@"status"] isEqualToString:@"1"]){
                
                [ProgressHUD showSuccess:@"注销成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LogOut" object:nil];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
                //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
                
            }else if([[info objectForKey:@"status"] isEqualToString:@"0"]){
                NSLog(@"logout failed:%@",[info objectForKey:@"msg"]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];
        
    }else{
        NSLog(@"logout failed");
    }
    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


-(BOOL)shouldAutorotate{
    return NO;
}




















@end
