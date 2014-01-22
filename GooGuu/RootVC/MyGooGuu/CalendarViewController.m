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
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[Utiles colorWithHexString:@"#FFFFFE"];
    VRGCalendarView *calendar = [[[VRGCalendarView alloc] init] autorelease];
    calendar.delegate=self;
    calendar.center = CGPointMake(SCREEN_WIDTH/2,44);
    [self.view addSubview:calendar];
    calendar.userInteractionEnabled=YES;
    self.view.userInteractionEnabled=YES;
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
    
}

-(void)panView:(UIPanGestureRecognizer *)tap{
    CGPoint change=[tap translationInView:self.view];
    if(change.x>100){
        [(MHTabBarController *)self.parentViewController setSelectedIndex:1 animated:YES];
    }
    if(tap.state==UIGestureRecognizerStateChanged){
        
        self.view.frame=CGRectMake(0,MAX(MIN(standard.y+change.y,0),-100),SCREEN_WIDTH,442);
        
    }else if(tap.state==UIGestureRecognizerStateEnded){
        standard=self.view.frame.origin;
    }
    
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
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Utiles getUserToken], @"token",
                            [NSString stringWithFormat:@"%d",[dateNow year]],@"year",[NSString stringWithFormat:@"%d",month],@"month",@"googuu",@"from",
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

-(NSUInteger)supportedInterfaceOrientations{
    
    //NSLog(@"concern supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskAllButUpsideDown;
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
