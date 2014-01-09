//
//  FinanceToolsGrade2ViewController.m
//  googuu
//
//  Created by Xcode on 13-10-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinanceToolsGrade2ViewController.h"
#import "CounterViewController.h"
#import "CounterBankViewController.h"

@interface FinanceToolsGrade2ViewController ()

@end

@implementation FinanceToolsGrade2ViewController

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

-(void)initComponents{
    
    self.customTabel=[[UITableView alloc] initWithFrame:CGRectMake(0,0,320,570) style:UITableViewStyleGrouped];
    self.customTabel.dataSource=self;
    self.customTabel.delegate=self;
    [self.view addSubview:self.customTabel];
    
}

#pragma mark -
#pragma Table DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.typeNames count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell=[self.customTabel dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14.0];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setText:[self.typeNames objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger type=[[self.types objectAtIndex:indexPath.row] integerValue];
    if(type==HSBC||type==BOC||type==SC){
        CounterBankViewController *counter=[[[CounterBankViewController alloc] init] autorelease];
        counter.params=[self.paramArr objectAtIndex:indexPath.row];
        counter.toolType=type;
        counter.title=[[[tableView  cellForRowAtIndexPath:indexPath] textLabel] text];
        counter.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:counter animated:YES];
        [self.customTabel deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        CounterViewController *counter=[[[CounterViewController alloc] init] autorelease];
        counter.params=[self.paramArr objectAtIndex:indexPath.row];
        counter.toolType=type;
        counter.title=[[[tableView  cellForRowAtIndexPath:indexPath] textLabel] text];
        counter.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:counter animated:YES];
        [self.customTabel deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
