//
//  BetaFactorCountViewController.m
//  googuu
//
//  Created by Xcode on 13-10-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "BetaFactorCountViewController.h"
#import "ChoseBetaFactorViewController.h"
#import "CounterViewController.h"

@interface BetaFactorCountViewController ()

@end

@implementation BetaFactorCountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.typeArr=[NSArray arrayWithObjects:@"港股(恒生指数)",@"美股(纳斯达克,标普500)",@"深圳(深证综指,沪深300)",@"上海(上证综指,沪深300)",@"创业板(创业板指，沪深300)", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stockCodeInput.returnKeyType=UIReturnKeyGo;
    self.stockCodeInput.keyboardType=UIKeyboardAppearanceDefault;
}

-(IBAction)getBetaFactorBtClicked:(id)sender{
    
    NSString *stockCode=[self.stockCodeInput text];
    NSString *type=[NSString stringWithFormat:@"%d",[self.expPicker selectedRowInComponent:0]];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:stockCode,@"stockCode",type,@"indexType", nil];
    
    [Utiles getNetInfoWithPath:@"BetaFactorCount" andParams:params besidesBlock:^(id obj) {
        
        if(obj){
            ChoseBetaFactorViewController *choseBetaVC=[[[ChoseBetaFactorViewController alloc] init] autorelease];
            choseBetaVC.benchMark=[obj objectForKey:@"data"];
            choseBetaVC.delegate=self;
            [self presentViewController:choseBetaVC animated:YES completion:nil];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

-(void)choseBetaVCDismiss:(NSString *)betaFactor{
    [self.delegate gotBeta:betaFactor];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backTap:(id)sender{
    [self.stockCodeInput resignFirstResponder];
}


#pragma mark -
#pragma mark Picker Data Soucrce Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 5;
}

#pragma mark -
#pragma mark Picker Data Delegate Methods;
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.typeArr objectAtIndex:row];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
