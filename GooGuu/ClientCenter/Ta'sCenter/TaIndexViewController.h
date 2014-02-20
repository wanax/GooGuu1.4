//
//  TaIndexViewController.h
//  GooGuu
//
//  Created by Xcode on 14-2-20.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaIndexViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSString *userName;

@property (nonatomic,retain) IBOutlet UIImageView *avatarImg;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *chatButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *taInfoSegment;
@property (retain, nonatomic) IBOutlet UITableView *infoTable;
@property (retain, nonatomic) IBOutlet UILabel *favLabel;
@property (retain, nonatomic) IBOutlet UILabel *tradeLabel;

- (IBAction)chatButtonClicked:(id)sender;
- (IBAction)userInfoSegChanged:(id)sender;

@end