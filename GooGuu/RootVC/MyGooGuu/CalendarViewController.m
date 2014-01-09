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

@synthesize eventArr=_eventArr;
@synthesize dateDic=_dateDic;

- (void)dealloc
{
    SAFE_RELEASE(_dateDic);
    SAFE_RELEASE(_eventArr);
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[Utiles colorWithHexString:@"#FFFFFE"];
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    [self.view addSubview:calendar];
    calendar.userInteractionEnabled=YES;
    self.view.userInteractionEnabled=YES;
    
    if(!IOS7_OR_LATER){
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
        [self.view addGestureRecognizer:pan];
        [pan release];
    }
    
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
            self.dateDic=[[NSMutableDictionary alloc] init];
            for(id key in self.eventArr){
                [self.dateDic setObject:[key objectForKey:@"data"] forKey:[self dateFormatter:[key objectForKey:@"day"]]];
            }
            SAFE_RELEASE(dates);
            SAFE_RELEASE(f);
        }else{
            [Utiles ToastNotification:[resObj objectForKey:@"msg"] andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
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
        NSString *msg=[[NSString alloc] init];
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
