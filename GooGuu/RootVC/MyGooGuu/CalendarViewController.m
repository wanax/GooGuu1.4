//
//  CalendarViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "CalendarViewController.h"
#import "MHTabBarController.h"
#import "UILabel+VerticalAlign.h"
#import "NSDate+convenience.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    VRGCalendarView *temp = [[[VRGCalendarView alloc] init] autorelease];
    self.calendar = temp;
    self.calendar.delegate=self;
    self.calendar.center = CGPointMake(SCREEN_WIDTH/2,44);
    [self.view addSubview:self.calendar];
    self.calendar.userInteractionEnabled=YES;
    self.view.userInteractionEnabled=YES;
    
}



#pragma mark -
#pragma mark Calendar Delegate Methods

-(NSString *)dateFormatter:(NSString *)date{
    NSString *returnData=@"";
    if ([date length]==1) {
        returnData=[NSString stringWithFormat:@"0%@",date];
    }else{
        returnData=date;
    }
    return returnData;
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    id dateNow=[NSDate date];
    
    if ([Utiles isLogin]) {
        NSString *reg = @"\\d+";
        NSArray *num = [self.calendar.labelCurrentMonth.text componentsMatchedByRegex:reg];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [Utiles getUserToken], @"token",
                                [NSString stringWithFormat:@"%d",[num[0] intValue]==0?[dateNow year]:[num[0] intValue]],@"year",[NSString stringWithFormat:@"%d",month],@"month",@"googuu",@"from",
                                nil];

        [Utiles postNetInfoWithPath:@"UserStockCalendar" andParams:params besidesBlock:^(id resObj){
            if(![[resObj objectForKey:@"status"] isEqualToString:@"0"]){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                NSMutableArray *dates=[[NSMutableArray alloc] init];
                self.eventArr=[resObj objectForKey:@"data"];
                for(id obj in self.eventArr){
                    [dates addObject:[f numberFromString:[obj objectForKey:@"day"]]];
                }
                [calendarView markDates:dates];
                NSMutableDictionary *tempDic = [[[NSMutableDictionary alloc] init] autorelease];
                self.dateDic = tempDic;
                for(id key in self.eventArr){
                    [self.dateDic setObject:[key objectForKey:@"data"] forKey:[self dateFormatter:[key objectForKey:@"day"]]];
                }
                SAFE_RELEASE(dates);
                SAFE_RELEASE(f);
            }else{
                [ProgressHUD showError:[resObj objectForKey:@"msg"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];
    } else {
        [ProgressHUD showError:@"请先登录"];
    }
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd"];
    NSString *currentDateStr = [dateFormat stringFromDate:date];
    [dateFormat setDateFormat:@"YYYY/MM/dd"];
    NSString *pointerDate=[NSString stringWithFormat:@"%@相关信息",[dateFormat stringFromDate:date]];
    if ([[self.dateDic allKeys] containsObject:currentDateStr]){
        NSString *msg=[[[NSString alloc] init] autorelease];
        for(id obj in [self.dateDic objectForKey:currentDateStr]){
            msg=[msg stringByAppendingFormat:@"%@:%@\n",[obj objectForKey:@"companyname"],[obj objectForKey:@"desc"]];
        }
        [Utiles showToastView:self.view withTitle:pointerDate andContent:msg duration:2.0];
        
    }
   
    [dateFormat release];
    
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    
    return NO;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


















@end
