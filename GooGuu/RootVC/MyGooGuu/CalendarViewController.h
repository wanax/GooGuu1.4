//
//  CalendarViewController.h
//  估股
//
//  Created by Xcode on 13-7-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-31 | Wanax | 投资日历

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"

@class NIAttributedLabel;

@interface CalendarViewController : UIViewController<VRGCalendarViewDelegate>{
    
    NSMutableArray *_eventArr;
    NSMutableDictionary *_dateDic;
    CGPoint standard;
    
}

@property (nonatomic,retain) NSMutableArray *eventArr;
@property (nonatomic,retain) NSMutableDictionary *dateDic;


@end
