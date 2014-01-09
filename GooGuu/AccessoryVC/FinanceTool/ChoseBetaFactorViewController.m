//
//  ChoseBetaFactorViewController.m
//  googuu
//
//  Created by Xcode on 13-10-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ChoseBetaFactorViewController.h"

@interface ChoseBetaFactorViewController ()

@end

@implementation ChoseBetaFactorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    NSMutableArray *temp2=[[NSMutableArray alloc] init];
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setPositiveFormat:@"###0.##"];
    for (id obj in self.benchMark){
        [temp addObject:obj];
    }
    for (id obj in [self.benchMark objectForKey:[temp objectAtIndex:0]]){
        [temp2 addObject:obj];
    }
    self.index=temp;
    self.floatSource=temp2;
    [self components2DataCombian];
    SAFE_RELEASE(temp);
    SAFE_RELEASE(temp2);
}

-(IBAction)sureBtClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate choseBetaVCDismiss:[self.returnFloat objectAtIndex:[self.betaPicker selectedRowInComponent:1]]];
    }];    
}
-(IBAction)cancelBtClicked:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)components2DataCombian{
    
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    NSMutableArray *temp2=[[NSMutableArray alloc] init];
    for(id obj in self.floatSource){
        int i=1;
        [temp addObject:[NSString stringWithFormat:@"%d年原始Beta值%@",i++,[self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:[obj floatValue]]]]];
        [temp addObject:[NSString stringWithFormat:@"%d年调整Beta值%@",i++,[self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:([obj floatValue]*2/3+(1/3))]]]];
        
        [temp2 addObject:[self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:[obj floatValue]]]];
        [temp2 addObject:[self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:([obj floatValue]*2/3+(1/3))]]];
    }
    self.component2Source=temp;
    self.returnFloat=temp2;
    SAFE_RELEASE(temp2);
    SAFE_RELEASE(temp);
    
    
}

#pragma mark -
#pragma mark Picker Data Soucrce Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return [self.index count];
    } else {
        return 4;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel *mycom = view ? (UILabel *) view : [[UILabel alloc] init];
    
    mycom.backgroundColor = [UIColor clearColor];
    if (component==0) {
        [mycom setFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
        [mycom setFont:[UIFont boldSystemFontOfSize:20]];
        [mycom setTextAlignment:NSTextAlignmentCenter];
        mycom.text =[Utiles getConfigureInfoFrom:@"BenchmarkIndex" andKey:[self.index objectAtIndex:row] inUserDomain:NO];
    }else if(component==1){
        [mycom setFrame:CGRectMake(200.0f, 0.0f, 220.0f, 30.0f)];
        [mycom setFont:[UIFont boldSystemFontOfSize:16]];
        [mycom setTextAlignment:NSTextAlignmentCenter];
        mycom.text =[self.component2Source objectAtIndex:row];
    }
    return mycom;
}


#pragma mark -
#pragma mark Picker Data Delegate Methods;
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return [Utiles getConfigureInfoFrom:@"BenchmarkIndex" andKey:[self.index objectAtIndex:row] inUserDomain:NO];
    } else {
        return [self.component2Source objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (component==0) {
        NSMutableArray *temp=[[NSMutableArray alloc] init];
        for(id obj in [self.benchMark objectForKey:[self.index objectAtIndex:row]]){
            [temp addObject:obj];
        }
        self.floatSource=temp;
        [self components2DataCombian];
        [self.betaPicker selectRow:0 inComponent:1 animated:YES];
        [self.betaPicker reloadAllComponents];
        SAFE_RELEASE(temp);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
