//
//  GGModelIndexVC.h
//  GooGuu
//
//  Created by Xcode on 14-1-15.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGModelIndexVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UIView *part1View;
@property (retain, nonatomic) IBOutlet UIToolbar *topBar;
@property (retain, nonatomic) IBOutlet UILabel *comNameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *comIconImg;
@property (retain, nonatomic) IBOutlet UISegmentedControl *comInfoSeg;
@property (retain, nonatomic) IBOutlet UILabel *marketPriLabel;
@property (retain, nonatomic) IBOutlet UILabel *googuuPriLabel;
@property (retain, nonatomic) IBOutlet UILabel *percentLabel;
@property (retain, nonatomic) IBOutlet UIImageView *updownIndicator;
@property (retain, nonatomic) IBOutlet UISegmentedControl *comExpectSeg;
@property (retain, nonatomic) IBOutlet UIButton *ggReportButton;
@property (retain, nonatomic) IBOutlet UIButton *ggValueModelButton;
@property (retain, nonatomic) IBOutlet UIButton *ggFinDataButton;
@property (retain, nonatomic) IBOutlet UIButton *ggViewButton;
@property (retain, nonatomic) IBOutlet UITableView *comAboutTable;

- (IBAction)comInfoSegClicked:(id)sender;
- (IBAction)comExpectSegClicked:(id)sender;

- (IBAction)ggReportBtClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *ggValueModelBtClicked;
@property (retain, nonatomic) IBOutlet UIButton *finDataBtClicked;
@property (retain, nonatomic) IBOutlet UIButton *ggViewBtClicked;
-(IBAction)backUp:(UIBarButtonItem *)bt;

@end
