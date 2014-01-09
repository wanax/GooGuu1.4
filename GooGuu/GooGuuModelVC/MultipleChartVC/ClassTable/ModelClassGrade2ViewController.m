//
//  ModelClassGrade2ViewController.m
//  估股
//
//  Created by Xcode on 13-8-2.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ModelClassGrade2ViewController.h"

#define ClassGrade2CellIdentifier  @"UITable2ViewCell"

@interface ModelClassGrade2ViewController ()

@end

@implementation ModelClassGrade2ViewController

@synthesize delegate;

@synthesize savedData;
@synthesize classTitle;
@synthesize jsonData;
@synthesize indicator;
@synthesize indicatorClass;
@synthesize savedDataName;

- (void)dealloc
{
    SAFE_RELEASE(savedDataName);
    SAFE_RELEASE(savedData);
    SAFE_RELEASE(classTitle);
    [delegate release];delegate=nil;
    [jsonData release];jsonData=nil;
    [indicator release];indicator=nil;
    [indicatorClass release];indicatorClass=nil;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:classTitle];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addTabel];
    self.indicatorClass=[jsonData objectForKey:indicator];
    NSMutableArray *tmpName=[[NSMutableArray alloc] init];
    if(savedData){
        for(id obj in savedData){
            [tmpName addObject:[obj objectForKey:@"itemname"]];
        }
    }
    self.savedDataName=tmpName;
    SAFE_RELEASE(tmpName);

}


-(void)addTabel{
    self.cusTable=[[UITableView alloc] initWithFrame:CGRectMake(0,20,SCREEN_HEIGHT,SCREEN_HEIGHT)];
    self.cusTable.delegate=self;
    self.cusTable.dataSource=self;
    [self.view addSubview:self.cusTable];
}


#pragma mark -
#pragma mark UITableViewController
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell  forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.savedDataName containsObject:[[self.indicatorClass objectAtIndex:indexPath.row] objectForKey:@"name"]]){
      [cell setBackgroundColor:[Utiles colorWithHexString:@"#ccd4d9"]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.indicatorClass count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0;
}


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassGrade2CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:ClassGrade2CellIdentifier] autorelease];
	}

	NSString *text =[[self.indicatorClass objectAtIndex:indexPath.row] objectForKey:@"name"];
	[cell.textLabel setText:text];
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:13.0f];
    cell.textLabel.textColor=[Utiles colorWithHexString:@"#9f3c0b"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView.backgroundColor = [Utiles colorWithHexString:@"d57631"];
	
	return cell;
}

#pragma mark -
#pragma mark Table Methods Delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
    [delegate modelClassChanged:[[self.indicatorClass objectAtIndex:indexPath.row] objectForKey:@"id"] isShowDisView:self.isShowDiscountView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}


-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationLandscapeLeft;
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
