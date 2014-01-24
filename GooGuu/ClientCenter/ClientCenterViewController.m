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
#import "Reachability.h"
#import "UIButton+BGColor.h"
#import "ClientLoginViewController.h"
#import "UILabel+VerticalAlign.h"
#import "SDWebImageDownloader.h"


@interface ClientCenterViewController ()


@end

@implementation ClientCenterViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated{

    [ProgressHUD show:nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Utiles getUserToken], @"token",@"googuu",@"from",
                            nil];
    [Utiles postNetInfoWithPath:@"UserInfo" andParams:params besidesBlock:^(id resObj){
        
        if(![[resObj objectForKey:@"status"] isEqualToString:@"0"]){
            
            NSDictionary *occupationalList=[Utiles getConfigureInfoFrom:@"OccupationalList" andKey:nil inUserDomain:NO];
            
            id userInfo=[resObj objectForKey:@"data"];
            [self.userNameLabel setText:[Utiles isBlankString:[userInfo objectForKey:@"nickname"]]?@"":[userInfo objectForKey:@"nickname"]];
            [self.userIdLabel setText:[Utiles isBlankString:[userInfo objectForKey:@"userid"]]?@"":[userInfo objectForKey:@"userid"]];
            
            [self setInfoType:@"trade" label:self.tradeLabel userInfo:userInfo dicName:@"TradeList"];
            [self setInfoType:@"favorite" label:self.favoriteLabel userInfo:userInfo dicName:@"InterestList"];
            
            [self.occupationalLabel setText:occupationalList[userInfo[@"profile"]]];
            NSDateFormatter *date=[[NSDateFormatter alloc] init];
            [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *d=[date dateFromString:[userInfo objectForKey:@"regtime"]];
            [date setDateFormat:@"yyyy-MM-dd"];
            [self.regtimeLabel setText:[date stringFromDate:d]];
            
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
            [ProgressHUD showError:[resObj objectForKey:@"msg"]];
        }
        [ProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [ProgressHUD dismiss];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];

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
    self.view.backgroundColor = [UIColor whiteColor];

    self.favoriteLabel.numberOfLines = 10;
    self.tradeLabel.numberOfLines = 10;

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
