//
//  FinPic2ViewController.m
//  googuu
//
//  Created by Xcode on 13-10-17.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinPic2ViewController.h"
#import "FinancePicViewController.h"

@interface FinPic2ViewController ()

@end

@implementation FinPic2ViewController

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
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#FDFBE4"]];
    self.title=@"金融图汇";
    self.tag = [[AOTagList alloc] initWithFrame:CGRectMake(-10.0f,
                                                           150.0f,
                                                           320.0f,
                                                           300.0f)];
    
    [self.tag setDelegate:self];
    [self.view addSubview:self.tag];
    [self getKeyWordList];
    
}

-(void)addTagLabel:(NSString *)title{
    [self.tag addTag:title withImage:nil];
}

-(void)initComponents{
    
    self.cusTabView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-40)];
    self.cusTabView.delegate=self;
    self.cusTabView.dataSource=self;
    [self.view addSubview:self.cusTabView];
    
}


-(void)getKeyWordList{
    [Utiles getNetInfoWithPath:@"FchartKeyWord" andParams:nil besidesBlock:^(id obj) {
        
        self.keyWordData=obj;
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for (id obj in self.keyWordData) {
            [temp addObject:[obj objectForKey:@"keyword"]];
            [self addTagLabel:[obj objectForKey:@"keyword"]];
        }
        [temp insertObject:@"全部" atIndex:0];
        self.keyWordList=temp;
        [self.cusTabView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.keyWordList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *KeyWordCellIdentifier = @"KeyWordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KeyWordCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:KeyWordCellIdentifier];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.textLabel setText:[self.keyWordList objectAtIndex:indexPath.row]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    
    return cell;
    
}

#pragma mark -
#pragma Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FinancePicViewController *picVC=[[[FinancePicViewController alloc] init] autorelease];
    picVC.keyWord=[self.keyWordList objectAtIndex:indexPath.row];
    picVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:picVC animated:YES];
    
}

- (void)tagDidSelectTag:(AOTag *)tag
{
    FinancePicViewController *picVC=[[[FinancePicViewController alloc] init] autorelease];
    picVC.keyWord=tag.tTitle;
    picVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:picVC animated:YES];

}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
