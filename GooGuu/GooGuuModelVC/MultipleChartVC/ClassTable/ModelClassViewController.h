//
//  ModelClassViewController.h
//  估股
//
//  Created by Xcode on 13-8-1.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClassGrade2ViewController.h"

@protocol HubDelegate <NSObject>
@optional
-(void)toldYouClassChanged:(NSString *)driverId andIndustry:(NSString *)industry;
@end

@interface ModelClassViewController :UITableViewController<ModelClassGrade2Delegate>

@property (nonatomic,retain) id<HubDelegate> delegate;
@property (nonatomic,retain) id jsonData;
@property (nonatomic,retain) NSArray *modelClass;
@property (nonatomic,retain) UITableView *customTable;
@property (nonatomic,retain) NSDictionary *industry;

@end
