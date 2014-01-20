//
//  GooGuuIndexViewController.m
//  GooGuu
//
//  Created by Xcode on 14-1-14.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "GooGuuIndexViewController.h"
#import "DailyStock2Cell.h"
#import "TopArticlesViewController.h"
#import "TopComsViewController.h"
#import "TopCommentsViewController.h"
#import "WishesComListViewController.h"
#import "GGModelIndexVC.h"
#import "HelpViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GooGuuIndexViewController ()

@end

@implementation GooGuuIndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)helpAction:(id)sender{
    
    HelpViewController *help=[[HelpViewController alloc] init];
    help.type=UserHelp;
    help.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:help animated:YES];
    SAFE_RELEASE(help);
    
}
-(void)addHelpBt{
    
    UIButton *wanSay = [[[UIButton alloc] initWithFrame:CGRectMake(200, 10.0, 30, 30)] autorelease];
    [wanSay setImage:[UIImage imageNamed:@"searchBt"] forState:UIControlStateNormal];
    [wanSay addTarget:self action:@selector(helpAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextStepBarBtn = [[[UIBarButtonItem alloc] initWithCustomView:wanSay] autorelease];
    [self.navigationItem setRightBarButtonItem:nextStepBarBtn animated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"估股首页";
	[self initComponents];
    [self getGooGuuNews];
}

-(void)initComponents {
    
    [self addHelpBt];
    
    UITableView *temp = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain] autorelease];
    temp.backgroundColor = [UIColor cloudsColor];
    temp.showsVerticalScrollIndicator = NO;
    temp.delegate = self;
    temp.dataSource = self;
    self.indexTable = temp;
    [self.view addSubview:self.indexTable];
}

//网络获取数据
- (void)getGooGuuNews{
    
    [Utiles getNetInfoWithPath:@"DailyStock" andParams:nil besidesBlock:^(id obj) {
        self.imageUrl = [NSString stringWithFormat:@"%@",[obj objectForKey:@"imageurl"]];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[obj objectForKey:@"stockcode"],@"stockcode", nil];
        [Utiles getNetInfoWithPath:@"GetCompanyInfo" andParams:params besidesBlock:^(id resObj) {
            
            self.dailyComInfo = resObj;
            [self.indexTable reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            NSLog(@"%@",error.localizedDescription);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        [self.indexTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
    
}

#pragma mark -
#pragma Table DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 5;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"每日一股";
    } else if (section == 1) {
        return @"常用功能";
    } else if (section == 2) {
        return @"近期热点";
    }
    return @"";
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 171.0;
    } else if (indexPath.section == 1) {
        return 50.0;
    } else if (indexPath.section == 2) {
        return 44.0;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        
        static NSString *DailyStockCellIdentifier = @"DailyStock2CellIdentifier";
        DailyStock2Cell *cell = (DailyStock2Cell *)[tableView dequeueReusableCellWithIdentifier:DailyStockCellIdentifier];//复用cell
        
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DailyStock2Cell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        if(self.imageUrl){
            [cell.comImg setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
        }
        static NSNumberFormatter *formatter;
        if(formatter==nil){
            formatter=[[[NSNumberFormatter alloc] init] autorelease];
            [formatter setPositiveFormat:@"##0.##"];
        }
        
        [cell.indicatorLable setBackgroundColor:[UIColor blackColor]];
        [cell.indicatorLable setAlpha:0.6];
        [cell.indicatorLable setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [cell.indicatorLable setTextColor:[UIColor whiteColor]];
        
        NSNumber *marketPrice=self.dailyComInfo[@"marketprice"];
        NSNumber *ggPrice=self.dailyComInfo[@"googuuprice"];
        float outLook=([ggPrice floatValue]-[marketPrice floatValue])/[marketPrice floatValue];
        
        cell.indicatorLable.text=[NSString stringWithFormat:@" %@(%@.%@) 潜在空间:%@",self.dailyComInfo[@"companyname"],self.dailyComInfo[@"stockcode"],self.dailyComInfo[@"market"],[NSString stringWithFormat:@"%.2f%%",outLook*100]];
        if(!self.dailyComInfo){
            cell.indicatorLable.text=@"";
        }
        
        [cell.backLabel setBackgroundColor:[UIColor whiteColor]];
        cell.backLabel.layer.cornerRadius = 5;
        cell.backLabel.layer.borderColor = [UIColor grayColor].CGColor;
        cell.backLabel.layer.borderWidth = 0;

        return cell;
        
    } else if (indexPath.section == 1) {
        
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
        cell.imageView.contentMode = UIViewContentModeCenter;
        int row = indexPath.row;
        
        if (row == 0) {
            cell.textLabel.text = @"估值模型";
            cell.detailTextLabel.text = @"上市公司现金流折现模型";
            cell.imageView.image = [UIImage imageNamed:@"modelIcon"];
        } else if (row == 1) {
            cell.textLabel.text = @"心愿榜";
            cell.detailTextLabel.text = @"希望看到哪些公司的财务模型";
            cell.imageView.image = [UIImage imageNamed:@"wishes_small_icon"];
        } else if (row ==2) {
            cell.textLabel.text = @"财经图汇";
            cell.detailTextLabel.text = @"金融图谱虽简，熟悉经济生活";
            cell.imageView.image = [UIImage imageNamed:@"finpic_small_icon"];
        }
        return cell;
        
    } else if (indexPath.section == 2) {
        
        static NSString *TopCellIdentifier = @"TopCellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 TopCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleValue1
                     reuseIdentifier:TopCellIdentifier] autorelease];
        }
        cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        int row = indexPath.row;
        
        if (row == 0) {
            cell.textLabel.text = @"热门文章";
        } else if (row == 1) {
            cell.textLabel.text = @"热门公司";
        } else if (row == 2) {
            cell.textLabel.text = @"上涨潜力";
        } else if (row == 3) {
            cell.textLabel.text = @"下跌空间";
        } else if (row ==4) {
            cell.textLabel.text = @"精彩评论";
        }
        
        return cell;
        
    }
    return nil;
}


#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = indexPath.section;
    int row = indexPath.row;
    //dailyCompany
    if (section == 0) {
        
        GGModelIndexVC *modelIndex = [[[GGModelIndexVC alloc] initWithNibName:@"GGModelIndexView" bundle:nil] autorelease];
        modelIndex.companyInfo = self.dailyComInfo;
        UINavigationController *navModel = [[[UINavigationController alloc] initWithRootViewController:modelIndex] autorelease];
        [self presentViewController:navModel animated:YES completion:nil];
        
    } else if (section == 1) {//custom
        
        if (row == 0) {//modelvalue
            
        } else if (row == 1) {//wishes
            
            WishesComListViewController *wishList = [[[WishesComListViewController alloc] init] autorelease];
            wishList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wishList animated:YES];
            
        } else if (row == 2) {//financepic
            
        }
        
    } else if (section == 2) {//topPoints
        
        //topArticle
        if (row == 0) {
            
            TopArticlesViewController *articleVC = [[[TopArticlesViewController alloc] init] autorelease];
            articleVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:articleVC animated:YES];
            
        } else if (row == 1) {//topCompany
            
            TopComsViewController *comVC = [[[TopComsViewController alloc] initWithTopical:@"热门公司" type:TopCompany] autorelease];
            comVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:comVC animated:YES];
            
        } else if (row == 2) {//risespace
            
            TopComsViewController *comVC = [[[TopComsViewController alloc] initWithTopical:@"上涨潜力" type:RiseSpace] autorelease];
            comVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:comVC animated:YES];
            
        } else if (row == 3) {//fallspace
            
            TopComsViewController *comVC = [[[TopComsViewController alloc] initWithTopical:@"下跌空间" type:FallSpace] autorelease];
            comVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:comVC animated:YES];
            
        } else if (row == 4) {//topcomments
            
            TopCommentsViewController *commentVC = [[[TopCommentsViewController alloc] init] autorelease];
            commentVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:commentVC animated:YES];
            
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    [Utiles getNetInfoWithPath:@"GetRootBarIndicator" andParams:nil besidesBlock:^(id obj) {
        
        //业绩简报
        if (tabBarController.selectedIndex == 1) {

            SetConfigure(@"BarIndicator", @"ReportCount", obj[@"reportcount"]);
            
        } else if (tabBarController.selectedIndex == 2) {//估值模型
            
            SetConfigure(@"BarIndicator", @"ModelCount", obj[@"modelcount"]);
            
        } else if (tabBarController.selectedIndex == 3) {//估值观点
            
            SetConfigure(@"BarIndicator", @"ViewCount", obj[@"ggviewcount"]);
 
        }
        viewController.tabBarItem.badgeValue = nil;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
