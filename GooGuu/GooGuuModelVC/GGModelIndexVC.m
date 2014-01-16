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
    [self initComponents];
}

-(void)initComponents {
    
    UIBarButtonItem *back = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self  action:@selector(backUp:)] autorelease];
    self.navigationItem.leftBarButtonItem = back;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:18.0]};
    self.title = @"title";
    
    self.view.backgroundColor = [UIColor cloudsColor];
    self.comAboutTable.scrollEnabled = NO;
    
    self.ggReportButton.layer.cornerRadius = 4.0;
    self.ggValueModelButton.layer.cornerRadius = 4.0;
    self.ggFinDataButton.layer.cornerRadius = 4.0;
    self.ggViewButton.layer.cornerRadius = 4.0;
    
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

- (IBAction)ggModelBtClicked:(id)sender {
}

- (IBAction)ggFinBtClicked:(id)sender {
}

- (IBAction)ggViewBtClicked:(id)sender {
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.imageView.frame = CGRectMake(0,0,10,10);
    cell.imageView.contentMode = UIViewContentModeCenter;
    int row = indexPath.row;
    
    if (row == 0) {
        cell.textLabel.text = @"公司公告";
        cell.imageView.image = [UIImage imageNamed:@"post_small_icon"];
    } else if (row == 1) {
        cell.textLabel.text = @"大行估值";
        cell.imageView.image = [UIImage imageNamed:@"dahon_small_icon"];
    } else if (row ==2) {
        cell.textLabel.text = @"估友评论";
        cell.imageView.image = [UIImage imageNamed:@"msg_small_icon"];
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
    [_comAboutTable release];
    [super dealloc];
}
@end
