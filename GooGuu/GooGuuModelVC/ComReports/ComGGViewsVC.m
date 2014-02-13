//
//  ComGGViewsVC.m
//  GooGuu
//
//  Created by Xcode on 14-1-21.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "ComGGViewsVC.h"
#import "ValueViewCell.h"
#import "GooGuuArticleViewController.h"
#import "ArticleCommentViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ComGGViewsVC ()

@end

@implementation ComGGViewsVC

- (id)initWithStockCode:(NSString *)code
{
    self = [super init];
    if (self) {
        self.stockCode = code;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"估值观点"];
    
	[self initComponents];
    [self getValueViewData];
}

-(void)initComponents{
    
    UITableView *tempTable = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain] autorelease];
    self.cusTable = tempTable;
    self.cusTable.delegate = self;
    self.cusTable.dataSource = self;
    
    [self.view addSubview:self.cusTable];
}

-(void)getValueViewData {
    
    NSDictionary *params = @{
                             @"stockcode":self.stockCode
                             };
    [Utiles getNetInfoWithPath:@"GooGuuView" andParams:params besidesBlock:^(id obj) {
        
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for (id data in obj) {
            [temp addObject:data];
        }
        self.viewDataArr=temp;
        [self.cusTable reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma mark Table DataSource

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 193.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.viewDataArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ValueViewCellIdentifier = @"ValueViewCellIdentifier";
    ValueViewCell *cell = (ValueViewCell*)[tableView dequeueReusableCellWithIdentifier:ValueViewCellIdentifier];//复用cell
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ValueViewCell" owner:self options:nil];//加载自定义cell的xib文件
        cell = [array objectAtIndex:0];
        cell.conciseTextView.layoutManager.delegate = self;
        cell.conciseTextView.textContainer.size = CGSizeMake(304,100);
    }
    
    id model=[self.viewDataArr objectAtIndex:indexPath.row];
    
    if([model objectForKey:@"titleimgurl"]){
        [cell.titleImgView setImageWithURL:[NSURL URLWithString:[model[@"titleimgurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
    }
    
    [cell.titleLabel setText:model[@"title"]];
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.titleLabel.numberOfLines = 2;
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;

    NSString *temp = model[@"concise"];
    if([temp length] > 95){
        temp = [NSString stringWithFormat:@"%@......",[temp substringToIndex:80]];
    }
    
    cell.conciseTextView.text = temp;
    
    [cell.updateTimeLabel setText:model[@"updatetime"]];
    
    return cell;
    
}

#pragma mark - Layout

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect{
	return 8;
}

#pragma mark -
#pragma mark Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id model = self.viewDataArr[indexPath.row];
    GooGuuArticleViewController *articleVC = [[[GooGuuArticleViewController alloc] initWithModel:model andType:ViewArticle] autorelease];
    articleVC.articleId = model[@"articleid"];
    articleVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:articleVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (BOOL)shouldAutorotate{
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
