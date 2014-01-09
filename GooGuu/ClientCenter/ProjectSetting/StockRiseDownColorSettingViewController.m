//
//  StockRiseDownColorSettingViewController.m
//  估股
//
//  Created by Xcode on 13-7-31.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "StockRiseDownColorSettingViewController.h"
#import "PrettyKit.h"


@interface StockRiseDownColorSettingViewController ()

@end

@implementation StockRiseDownColorSettingViewController

@synthesize customTable;

- (void)dealloc
{
    [customTable release];customTable=nil;
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

//退回主菜单
-(void)back:(id)sender{

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utiles iOS7StatusBar:self];
	self.customTable=[[UITableView alloc] initWithFrame:CGRectMake(0,44,SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.customTable.delegate=self;
    self.customTable.dataSource=self;
    [self.view addSubview:self.customTable];
    [self addToolBar];
}

-(void)addToolBar{
    
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#E2E2E3"]];
    UIToolbar *top=nil;
    if (IOS7_OR_LATER) {
        top=[[UIToolbar alloc] initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,44)];
    } else {
        top=[[PrettyToolbar alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,44)];
    }
    
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    NSMutableArray *myToolBarItems=[[NSMutableArray alloc] init];
    [myToolBarItems addObject:back];
    [top setItems:myToolBarItems];
    [self.view addSubview:top];
    [back release];
    [top release];
    [myToolBarItems release];
    
}

#pragma mark -
#pragma mark Table Data Source Methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:TableSampleIdentifier];
    }
    
    void (^setCellBlock)(NSString *,NSString *,UITableViewCell *)=^(NSString *title,NSString *subTitlel,UITableViewCell *cell){        
        cell.textLabel.text=title;
        cell.detailTextLabel.text=subTitlel;
        cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:16.0f];
        cell.detailTextLabel.font=[UIFont fontWithName:@"Heiti SC" size:16.0f];
    };
    
    if(indexPath.row==0){
        setCellBlock(@"红涨绿跌",@"大陆常用",cell);
    }else if(indexPath.row==1){
        setCellBlock(@"绿涨红跌",@"海外常用",cell);
    }else if(indexPath.row==2){
        setCellBlock(@"黄涨蓝跌",@"估股色",cell);
    }
    int tag=[[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"stockColorSetting" inUserDomain:YES] intValue];
    if(tag==indexPath.row){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
    
}


#pragma mark -
#pragma mark Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [Utiles setConfigureInfoTo:@"userconfigure" forKey:@"stockColorSetting" andContent:[NSString stringWithFormat:@"%d",indexPath.row]];
    [self.customTable reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



















@end
