//
//  ClientCenterViewController.m
//  UIDemo
//
//  Created by Xcode on 13-5-29.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ClientCenterViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIButton+BGColor.h"
#import "ClientLoginViewController.h"
#import "UILabel+VerticalAlign.h"
#import "SDWebImageDownloader.h"
#import "MBProgressHUD.h"




@interface ClientCenterViewController ()


@end

@implementation ClientCenterViewController

@synthesize userIdLabel;
@synthesize favoriteLabel;
@synthesize tradeLabel;
@synthesize regtimeLabel;
@synthesize userNameLabel;
@synthesize occupationalLabel;
@synthesize logoutBt;
@synthesize avatar;

@synthesize eventArr=_eventArr;
@synthesize dateDic=_dateDic;

- (void)dealloc
{
    SAFE_RELEASE(occupationalLabel);
    SAFE_RELEASE(userIdLabel);
    SAFE_RELEASE(favoriteLabel);
    SAFE_RELEASE(tradeLabel);
    SAFE_RELEASE(regtimeLabel);
    SAFE_RELEASE(avatar);
    SAFE_RELEASE(logoutBt);
    SAFE_RELEASE(_dateDic);
    SAFE_RELEASE(_eventArr);
    SAFE_RELEASE(userNameLabel);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated{

    if ([Utiles isNetConnected]) {
        if([Utiles isLogin]){            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            logoutBt.hidden=NO;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Utiles getUserToken], @"token",@"googuu",@"from",
                                    nil];
            [Utiles postNetInfoWithPath:@"UserInfo" andParams:params besidesBlock:^(id resObj){
                
                if(![[resObj objectForKey:@"status"] isEqualToString:@"0"]){
                    
                    NSDictionary *occupationalList=[Utiles getConfigureInfoFrom:@"OccupationalList" andKey:nil inUserDomain:NO];
                    
                    id userInfo=[resObj objectForKey:@"data"];
                    [userNameLabel setText:[Utiles isBlankString:[userInfo objectForKey:@"nickname"]]?@"":[userInfo objectForKey:@"nickname"]];
                    [userIdLabel setText:[Utiles isBlankString:[userInfo objectForKey:@"userid"]]?@"":[userInfo objectForKey:@"userid"]];
                    
                    [self setInfoType:@"trade" label:self.tradeLabel userInfo:userInfo dicName:@"TradeList"];
                    [self setInfoType:@"favorite" label:self.favoriteLabel userInfo:userInfo dicName:@"InterestList"];
                    
                    [self.occupationalLabel setText:occupationalList[userInfo[@"profile"]]];
                    NSDateFormatter *date=[[NSDateFormatter alloc] init];
                    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *d=[date dateFromString:[userInfo objectForKey:@"regtime"]];
                    [date setDateFormat:@"yyyy-MM-dd"];
                    [regtimeLabel setText:[date stringFromDate:d]];
                    
                    NSString *url=[Utiles isBlankString:userInfo[@"headerpicurl"]]?@"":userInfo[@"headerpicurl"];
                    if([Utiles isBlankString:url]){
                        [self.avatar setImage:[UIImage imageNamed:@"defaultAvatar"]];
                    }else{
                        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:userInfo[@"headerpicurl"]] options:SDWebImageDownloaderProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
                        } completed:^(UIImage *aImage, NSData *data, NSError *error, BOOL finished) {
                            [self.avatar setImage:aImage];
                        }];
                    }               
                    SAFE_RELEASE(date);
                }else{
                    [Utiles ToastNotification:[resObj objectForKey:@"msg"] andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation,NSError *error){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
            }];            
        }
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }

}

-(void)setInfoType:(NSString *)type label:(UILabel *)label userInfo:(id)userInfo dicName:(NSString *)name{
    NSDictionary *dic=[Utiles getConfigureInfoFrom:name andKey:nil inUserDomain:NO];
    NSString *str=@"";
    if(![Utiles isBlankString:[userInfo objectForKey:type]]){
        NSArray *tradeArr=[[userInfo objectForKey:type] componentsSeparatedByString:@","];
        
        for(id obj in tradeArr){
            str=[str stringByAppendingFormat:@"%@,",dic[obj]];
        }
        str=[str substringToIndex:([str length]-1)];
        [label setText:str];
        [label alignTop];        
    }else{
       [label setText:@""];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"个人中心"];
    [Utiles iOS7StatusBar:self];
    
    self.view.backgroundColor=[Utiles colorWithHexString:@"#F3EFE1"];
    [self.logoutBt setBackgroundColorString:@"#C96125" forState:UIControlStateNormal];

    favoriteLabel.numberOfLines = 10;
    tradeLabel.numberOfLines = 10;

}



-(void)logoutBtClick:(id)sender{
    
    NSString *token= [Utiles getUserToken];
    if(token){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                token, @"token",@"googuu",@"from",
                                nil];
        [Utiles postNetInfoWithPath:@"LogOut" andParams:params besidesBlock:^(id info){
           
            if([[info objectForKey:@"status"] isEqualToString:@"1"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LogOut" object:nil];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
                [self.navigationController popViewControllerAnimated:YES];
            }else if([[info objectForKey:@"status"] isEqualToString:@"0"]){
                NSLog(@"logout failed:%@",[info objectForKey:@"msg"]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];
        
    }else{
        NSLog(@"logout failed");
    }
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(BOOL)shouldAutorotate{
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


















@end
