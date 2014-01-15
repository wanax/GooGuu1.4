//
//  GGModelIndexVC.m
//  GooGuu
//
//  Created by Xcode on 14-1-15.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "GGModelIndexVC.h"

@interface GGModelIndexVC ()

@end

@implementation GGModelIndexVC

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
	self.view.backgroundColor = [UIColor cloudsColor];
    self.comAboutTable.scrollEnabled = NO;
}

#pragma mark -
#pragma NetWork

-(void)getComInfo {
    
}

#pragma mark -
#pragma Button Action

- (IBAction)comInfoSegClicked:(id)sender {
}

- (IBAction)comExpectSegClicked:(id)sender {
}

- (IBAction)ggReportBtClicked:(id)sender {
}

-(IBAction)backUp:(UIBarButtonItem *)bt {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma Table DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CustomCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:CustomCellIdentifier] autorelease];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:14.0f];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    int row = indexPath.row;
    
    if (row == 0) {
        cell.textLabel.text = @"公司公告";
        cell.imageView.image = [UIImage imageNamed:@"ASTOCK"];
    } else if (row == 1) {
        cell.textLabel.text = @"大行估值";
        cell.imageView.image = [UIImage imageNamed:@"FUNDTIME"];
    } else if (row ==2) {
        cell.textLabel.text = @"估友评论";
        cell.imageView.image = [UIImage imageNamed:@"MSG"];
    }
    return cell;
    
}

#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_part1View release];
    [_topBar release];
    [_comNameLabel release];
    [_comInfoSeg release];
    [_comIconImg release];
    [_comInfoSeg release];
    [_marketPriLabel release];
    [_googuuPriLabel release];
    [_percentLabel release];
    [_updownIndicator release];
    [_comExpectSeg release];
    [_ggReportButton release];
    [_ggValueModelButton release];
    [_ggFinDataButton release];
    [_ggViewButton release];
    [_ggValueModelBtClicked release];
    [_finDataBtClicked release];
    [_ggViewBtClicked release];
    [_comAboutTable release];
    [super dealloc];
}
@end
