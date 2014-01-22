//
//  FinPicKeyWordListViewController.m
//  googuu
//
//  Created by Xcode on 13-10-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinPicKeyWordListViewController.h"
#import "FinancePicViewController.h"


@interface FinPicKeyWordListViewController ()


@end

@implementation FinPicKeyWordListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.colorArr=[NSArray arrayWithObjects:@"e92058",@"b700b7",@"216dcb",@"13bbca",@"65d223",@"f09c32",@"f15a38",nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"金融图汇";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tag =nil;
    AOTagList *tempList = [[[AOTagList alloc] initWithFrame:CGRectMake(-10.0f,
                                                                       150.0f,
                                                                       320.0f,
                                                                       300.0f)] autorelease];
    self.tag = tempList;
    
    [self.tag setDelegate:self];
    [self.view addSubview:self.tag];
    [self getKeyWordList];
    
}

-(void)addTagLabel:(NSString *)title{
    [self.tag addTag:title withColor:[Utiles colorWithHexString:[self.colorArr objectAtIndex:arc4random()%7]]];
}

-(void)allBtClicked:(UIButton *)bt{
    FinancePicViewController *picVC=[[[FinancePicViewController alloc] init] autorelease];
    picVC.keyWord=bt.titleLabel.text;
    picVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:picVC animated:YES];
}

-(void)getKeyWordList{
    
    UIButton *allBt=[UIButton buttonWithType:UIButtonTypeCustom];
    [allBt setFrame:CGRectMake(30,100,260,25)];
    [allBt setTitle:@"全部" forState:UIControlStateNormal];
    [allBt setBackgroundColor:[UIColor orangeColor]];
    [allBt addTarget:self action:@selector(allBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allBt];
    
    [Utiles getNetInfoWithPath:@"FchartKeyWord" andParams:nil besidesBlock:^(id obj) {
        
        self.keyWordData=obj;
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        
        for (id obj in self.keyWordData) {
            [temp addObject:[obj objectForKey:@"keyword"]];
            [self addTagLabel:[obj objectForKey:@"keyword"]];
        }
        [temp insertObject:@"全部" atIndex:0];
        self.keyWordList=temp;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
