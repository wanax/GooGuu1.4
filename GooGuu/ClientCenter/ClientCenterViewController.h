//
//  ClientCenterViewController.h
//  UIDemo
//
//  Created by Xcode on 13-5-29.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-05-29 | Wanax | 用户中心 

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"


@interface ClientCenterViewController : UIViewController<VRGCalendarViewDelegate>{
    
    NSMutableArray *_eventArr;
    NSMutableDictionary *_dateDic;
    
}

@property (nonatomic,retain) IBOutlet UILabel *userNameLabel;
@property (nonatomic,retain) IBOutlet UILabel *userIdLabel;
@property (nonatomic,retain) IBOutlet UILabel *favoriteLabel;
@property (nonatomic,retain) IBOutlet UILabel *tradeLabel;
@property (nonatomic,retain) IBOutlet UILabel *regtimeLabel;
@property (nonatomic,retain) IBOutlet UILabel *occupationalLabel;
@property (nonatomic,retain) IBOutlet UIButton *logoutBt;
@property (nonatomic,retain) IBOutlet UIImageView *avatar;

@property (nonatomic,retain) NSMutableArray *eventArr;
@property (nonatomic,retain) NSMutableDictionary *dateDic;



-(IBAction)logoutBtClick:(id)sender;








@end
