//
//  CounterViewController.m
//  googuu
//
//  Created by Xcode on 13-10-9.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "CounterViewController.h"
#import "BetaFactorCountViewController.h"
#import "IQKeyBoardManager.h"

@interface CounterViewController ()

@end

@implementation CounterViewController

#define PARAM(x) [self getParam:x]
#define PPARAM(x) ([self getParam:x]/100)
#define StringFromFloat(f) [formatter stringFromNumber:[NSNumber numberWithFloat:f]]
#define SetText(t,g) [self setText:t tag:g]

-(void)gotBeta:(NSString *)betaFactor{
    [(UITextField*)[self.view viewWithTag:100] setText:betaFactor];
}

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
    
	[self.view setBackgroundColor:[Utiles colorWithHexString:@"#FDFBE4"]];
    [self.view setFrame:CGRectMake(0,0,320,676)];
    [self initComponents];
   
    UITapGestureRecognizer *backTap=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)] autorelease];
    [self.view addGestureRecognizer:backTap];
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
}

-(void)panView:(UIPanGestureRecognizer *)tap{
    CGPoint change=[tap translationInView:self.view];
    if(tap.state==UIGestureRecognizerStateChanged){
        self.view.frame=CGRectMake(0,MAX(MIN(standard.y+change.y,0),-100),SCREEN_WIDTH,678);
    }else if(tap.state==UIGestureRecognizerStateEnded){
        standard=self.view.frame.origin;
    }
    
}

-(void)backTap:(UITapGestureRecognizer *)tap{
    [self dismissText];
}


-(void)initComponents{
    
    [IQKeyBoardManager installKeyboardManager];
    [IQKeyBoardManager enableKeyboardManger];

    //添加参数名和参数输入input
    NSArray *pNames=[[self.params objectForKey:@"pName"] componentsSeparatedByString:@","];
    NSArray *pUnits=[[self.params objectForKey:@"pUnit"] componentsSeparatedByString:@","];
    int n=50,m=50,i=0,j=0;
    for(NSString *name in pNames){
        [self addLabel:name frame:CGRectMake(10,n+=30,150,25) inputFrame:CGRectMake(160,m+=30,100,25) unit:[pUnits objectAtIndex:i++] index:j++ enable:YES];
    }
    
    //添加计算button
    UIButton *calBt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [calBt setTitle:@"计算" forState:UIControlStateNormal];
    [calBt setBackgroundColor:[UIColor grayColor]];
    [calBt setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [calBt setFrame:CGRectMake(10,m+40,SCREEN_WIDTH-20,30)];
    [calBt.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    [calBt addTarget:self action:@selector(calBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:calBt];
    
    //添加结果名和结果显示label
    NSArray *rNames=[[self.params objectForKey:@"rName"] componentsSeparatedByString:@","];
    NSArray *rUnits=[[self.params objectForKey:@"rUnit"] componentsSeparatedByString:@","];
    n+=50,m+=50,i=0,j=0;
    for(NSString *name in rNames){
        [self addLabel:name frame:CGRectMake(10,n+=30,150,25) inputFrame:CGRectMake(160,m+=30,150,25) unit:[rUnits objectAtIndex:i++] index:j++ enable:NO];
    }
    
}


-(void)calBtClicked:(UIButton *)bt{

    self.floatParams=[self getParams];
    [self calTool];
}

-(void)dismissText{
    for(int i=0;i<[[[self.params objectForKey:@"pName"] componentsSeparatedByString:@","] count];i++){
        [(UITextField*)[self.view viewWithTag:100+i] resignFirstResponder];
    }
}

-(float)getMax:(float)a and:(float)b{
    if (a>b) {
        return a;
    } else {
        return b;
    }
}

-(float)getText:(NSInteger)tag{
    return [[(UITextField*)[self.view viewWithTag:tag] text] floatValue];
}
-(void)setText:(NSString *)str tag:(NSInteger)tag{
    UITextField *field=(UITextField*)[self.view viewWithTag:tag];
    [field setText:[NSString stringWithFormat:@"%@",str]];
}

-(float)getParam:(NSInteger)n{
    return [[self.floatParams objectAtIndex:n] floatValue];
}

-(NSArray *)getParams{
    NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
    for(int i=0;i<[[[self.params objectForKey:@"pName"] componentsSeparatedByString:@","] count];i++){
        [temp addObject:[NSNumber numberWithFloat:[self getText:100+i]]];
    }
    return temp;
}

-(void)getBetaFactor:(UIButton *)bt{
    
    BetaFactorCountViewController *betaVC=[[[BetaFactorCountViewController alloc] init] autorelease];
    [betaVC setTitle:@"获取Beta系数"];
    betaVC.delegate=self;
    betaVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:betaVC animated:YES];
    
}

-(void)calTool{
    NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
    [formatter setPositiveFormat:@"####.##"];
    if (self.toolType==BetaFactor) {
        float f200=1-PPARAM(1);
        float f201=PARAM(0)/(1+(1-PPARAM(2))*PPARAM(1)/f200);
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [self setText:StringFromFloat(f200) tag:200];
        [self setText:StringFromFloat(f201) tag:201];
    }else if (self.toolType==Discountrate){
        float f200=(PARAM(0)*PARAM(2)+PARAM(3)+PARAM(4)+PARAM(1))/100;
        float f201=1-PPARAM(7);
        float f202=f200*f201+(1-PPARAM(5))*PARAM(6)*PARAM(7)/10000;
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [formatter setPositiveSuffix:@"%"];
        [self setText:StringFromFloat(f200*100) tag:200];
        [self setText:StringFromFloat(f201*100) tag:201];
        [self setText:StringFromFloat(f202*100) tag:202];
    }else if (self.toolType==DiscountCashFlow){
        float f200=((PPARAM(2)*PARAM(0)+PARAM(0))/((PARAM(1)-PARAM(2))/100))/(1+PPARAM(1))+PARAM(0)/(1+PPARAM(1));
        float f201=(f200-PARAM(3)+PARAM(4))/PARAM(5);
        [formatter setPositiveSuffix:@"万元"];
        [self setText:StringFromFloat(f200) tag:200];
        [formatter setPositiveSuffix:@"元"];
        [self setText:StringFromFloat(f201) tag:201];
    }else if (self.toolType==FreeCashFlow){
        float f200=PARAM(0)*(1-PPARAM(1))+PARAM(2)+PARAM(3)-PARAM(4);
        [formatter setPositiveSuffix:@"万元"];
        [self setText:StringFromFloat(f200) tag:200];
    }else if(self.toolType==InvestBeforeValu){
        float f200=PARAM(0)+PARAM(1);
        [formatter setPositiveSuffix:@"万元"];
        [self setText:StringFromFloat(f200) tag:200];
    }else if(self.toolType==InvestAfterValu){
        float f200=PARAM(0)/PPARAM(1);
        [formatter setPositiveSuffix:@"万元"];
        [self setText:StringFromFloat(f200) tag:200];
    }else if(self.toolType==MultRoundsOfFinance){
        float f100=PARAM(0);
        float f101=PARAM(1);
        float f102=PARAM(2);
        float f103=PARAM(3);
        float f104=PARAM(4);
        float f105=PARAM(5);
        float f1=f100/(f100+f103);
        float f2=f101/(f101+f104);
        float f3=f102/(f102+f105);
        float f200=1-(1-f1)*(1-f2)*(1-f3);
        [formatter setPositiveSuffix:@"%"];
        [self setText:StringFromFloat(f200*100) tag:200];
    }else if (self.toolType==PEReturnOnInvest){
        float f200=PARAM(0)/PPARAM(1)-PARAM(0);
        float f202=PARAM(0)/PPARAM(1);
        float f203=PARAM(5)*PARAM(7)*0.75*PARAM(1)/100-PARAM(0);
        float f204=f203-PARAM(6);
        float f205=(f203-PARAM(6))/PARAM(0);
        float f206=powf(f205,(1/(PARAM(4)-PARAM(2))))-1;
        [formatter setPositiveSuffix:@"万元"];
        [self setText:StringFromFloat(f200) tag:200];
        [self setText:StringFromFloat(f202) tag:202];
        [self setText:StringFromFloat(f203) tag:203];
        [self setText:StringFromFloat(f204) tag:204];
        [formatter setPositiveSuffix:@"倍"];
        [self setText:StringFromFloat(f205) tag:205];
        [formatter setPositiveSuffix:@"%"];
        [self setText:StringFromFloat(f206) tag:206];
    }else if(self.toolType==FundsFutureValue){
        float f200=PARAM(0)*powf((1+PPARAM(1)/PARAM(3)),(PARAM(2)*2));
        [formatter setPositiveSuffix:@"元"];
        [self setText:StringFromFloat(f200) tag:200];
    }else if(self.toolType==FundsPresentValue){
        float f200=PARAM(0)/(powf(1+PPARAM(1)/PARAM(3),(PARAM(2)*PARAM(3))));
        [formatter setPositiveSuffix:@"元"];
        [self setText:StringFromFloat(f200) tag:200];
    }else if(self.toolType==OrdinaryAnnuityFutureValue){
        float f200=PARAM(0)*(powf((1+(PPARAM(1)/PARAM(3))),(PARAM(2)*PARAM(3)))-1)/(PPARAM(1)/PARAM(3));
        [formatter setPositiveSuffix:@"元"];
        [self setText:StringFromFloat(f200) tag:200];
    }else if(self.toolType==OrdinaryAnnuityPresentValue){
        float f200=PARAM(0)*((1-powf((1+PPARAM(1)/PARAM(3)),(PARAM(2)*PARAM(3)*(-1))))/(PPARAM(1)/PARAM(3)));
        [formatter setPositiveSuffix:@"元"];
        [self setText:StringFromFloat(f200) tag:200];
    }else if(self.toolType==SusAnnuityPresentValue){
        float f200=(PARAM(0)*PARAM(2))/(powf(1+PPARAM(1)/PARAM(2),PARAM(2))-1);
        [formatter setPositiveSuffix:@"元"];
        [self setText:StringFromFloat(f200) tag:200];
    }else if(self.toolType==InvestIncomeCal){
        float f200=365*(PARAM(2)-PARAM(0))/PARAM(0)/PARAM(1);
        float f201=(PARAM(2)-PARAM(0))/PARAM(0);
        [formatter setPositiveSuffix:@"%"];
        [self setText:StringFromFloat(f200*100) tag:200];
        [self setText:StringFromFloat(f201*100) tag:201];
    }else if(self.toolType==FinProductExpIncomeCal){
        float f200=PARAM(1)+PARAM(1)*PPARAM(0)*PARAM(2)/365;
        float f201=(f200-PARAM(1))/PARAM(1);
        [formatter setPositiveSuffix:@"元"];
        [self setText:StringFromFloat(f200) tag:200];
        [formatter setPositiveSuffix:@"%"];
        [self setText:StringFromFloat(f201*100) tag:201];
    }else if(self.toolType==SHAStockInvestProAndLoss){
        float f200=2*((PARAM(3)<1000)?1:PARAM(3)/6);
        float f201=PARAM(3)*PARAM(2)*PPARAM(5);
        float f202=[self getMax:5.0 and:PARAM(2)*PARAM(3)*PPARAM(4)]+[self getMax:5.0 and:PARAM(0)*PARAM(1)*PPARAM(4)];
        float f203=f200+f201+f202;
        float f204=PARAM(3)*(PARAM(2)-PARAM(0))+(PARAM(1)-PARAM(3))*(PARAM(2)-PARAM(0))-f203;
        float f205=f204/(PARAM(0)*PARAM(1));
        [formatter setPositiveSuffix:@"元"];
        [self setText:StringFromFloat(f200) tag:200];
        [self setText:StringFromFloat(f201) tag:201];
        [self setText:StringFromFloat(f202) tag:202];
        [self setText:StringFromFloat(f203) tag:203];
        [self setText:StringFromFloat(f204) tag:204];
        [formatter setPositiveSuffix:@"%"];
        [self setText:StringFromFloat(f205*100) tag:205];
    }else if(self.toolType==SZAStockInvestProAndLoss){
        float f200=PARAM(2)*PARAM(3)*PPARAM(5);
        float f201=[self getMax:5.0 and:PARAM(2)*PARAM(3)*PPARAM(4)]+[self getMax:5.0 and:PARAM(0)*PARAM(1)*PPARAM(4)];
        float f202=f200+f201;
        float f203=PARAM(3)*(PARAM(2)-PARAM(0))+(PARAM(1)-PARAM(3))*(PARAM(2)-PARAM(0))-f202;
        float f204=f203/(PARAM(0)/PARAM(1));
        [formatter setPositiveSuffix:@"元"];
        [self setText:StringFromFloat(f200) tag:200];
        [self setText:StringFromFloat(f201) tag:201];
        [self setText:StringFromFloat(f202) tag:202];
        [self setText:StringFromFloat(f203) tag:203];
        [formatter setPositiveSuffix:@"%"];
        [self setText:StringFromFloat(f204/100) tag:204];
    }else if(self.toolType==SHAStockPreserSellPrice){
        float f200=PARAM(0)+(PARAM(0)+2*(PARAM(1)<1000?1:(PARAM(0)/1000*PARAM(4)))+PARAM(0)*PARAM(1)*PPARAM(2))/(PARAM(1)-PARAM(1)*PARAM(2)-PARAM(1)*PPARAM(3));
        [formatter setPositiveSuffix:@"元"];
        [self setText:StringFromFloat(f200) tag:200];
    }else if(self.toolType==SZAStockPreserSellPrice){
        float f200=PARAM(0)+(PARAM(0)+PARAM(0)*PARAM(1)*PPARAM(2))/(PARAM(1)-PARAM(1)*PPARAM(2)-PARAM(1)*PPARAM(3));
        [formatter setPositiveSuffix:@"元"];
        [self setText:StringFromFloat(f200) tag:200];
    }
    
}

-(void)addLabel:(NSString *)name frame:(CGRect)rect inputFrame:(CGRect)rect2 unit:(NSString *)unit index:(NSInteger)index enable:(BOOL)flag{
    
    UILabel *label=[[[UILabel alloc] initWithFrame:rect] autorelease];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [label setText:name];
    [self.view addSubview:label];

    UITextField *textField=[[UITextField alloc] initWithFrame:rect2];
    textField.delegate=self;
    textField.keyboardType=UIKeyboardTypeDecimalPad;
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.placeholder = unit;
    [textField setEnabled:flag];
    [textField placeholderRectForBounds:CGRectMake(20,5,80,20)];
    textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    textField.borderStyle=UITextBorderStyleRoundedRect;
    
    textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    if (flag) {
        textField.tag=100+index;
        textField.clearButtonMode=UITextFieldViewModeUnlessEditing;
    } else {
        textField.tag=200+index;
        textField.clearButtonMode=UITextFieldViewModeNever;
    }
    [textField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];
    [self.view addSubview:textField];
    
    if([unit isEqualToString:@"0"]){
        UIButton *getBetaBt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [getBetaBt setTitle:@"获取Beta值" forState:UIControlStateNormal];
        [getBetaBt setFrame:CGRectMake(rect2.origin.x+rect2.size.width-15,rect2.origin.y-3,70,30)];
        [getBetaBt.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:12.0]];
        [getBetaBt addTarget:self action:@selector(getBetaFactor:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:getBetaBt];
        [textField setFrame:CGRectMake(rect2.origin.x-20,rect2.origin.y,rect2.size.width,rect2.size.height)];
    }

}

-(void)enableKeyboardManger:(UIBarButtonItem*)barButton
{
    [IQKeyBoardManager enableKeyboardManger];
}

-(void)disableKeyboardManager:(UIBarButtonItem*)barButton
{
    [IQKeyBoardManager disableKeyboardManager];
}

-(void)previousClicked:(UISegmentedControl*)segmentedControl
{
    [(UITextField*)[self.view viewWithTag:selectedTextFieldTag-1] becomeFirstResponder];
}

-(void)nextClicked:(UISegmentedControl*)segmentedControl
{
    [(UITextField*)[self.view viewWithTag:selectedTextFieldTag+1] becomeFirstResponder];
}

-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    selectedTextFieldTag = textField.tag;
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
