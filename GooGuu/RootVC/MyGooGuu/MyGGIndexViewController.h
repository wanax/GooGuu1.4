//
//  MyGGIndexViewController.h
//  GooGuu
//
//  Created by Xcode on 14-1-19.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGGIndexViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (retain, nonatomic) IBOutlet UIView *part1View;
@property (retain, nonatomic) IBOutlet UIImageView *clientAvatar;
@property (retain, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *clientActionButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *clientInfoSeg;

@property (retain, nonatomic) IBOutlet UITableView *clientTable;

- (IBAction)clientInfoSegClicked:(id)sender;
- (IBAction)clientActionBtClicked:(id)sender;

@end
