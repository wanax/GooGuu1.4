//
//  CounterBankViewController.m
//  googuu
//
//  Created by Xcode on 13-10-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "CounterBankViewController.h"
#import "IQKeyBoardManager.h"

#define PARAM(x) [self getParam:x]
#define PPARAM(x) ([self getParam:x]/100)
#define StringFromFloat(f) [formatter stringFromNumber:[NSNumber numberWithFloat:f]]
#define SetText(t,g) [self setText:t tag:g]

#define ScreenHeight 1500

@interface CounterBankViewController ()

@end

@implementation CounterBankViewController

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
    [self.view setFrame:CGRectMake(0,0,320,ScreenHeight)];
    [self initComponents];
    
    UITapGestureRecognizer *backTap=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)] autorelease];
    [self.view addGestureRecognizer:backTap];
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
}

-(void)initComponents{
    
    [IQKeyBoardManager installKeyboardManager];
    [IQKeyBoardManager enableKeyboardManger];
    //添加户口类别Bt
    NSArray *acBtNames=[[self.params objectForKey:@"b1Name"] componentsSeparatedByString:@","];
    int n=100,m=100,i=0,j=0;
    [self addLabel:@"户口类别" y:n andBt:acBtNames index:300];
    //添加交易途径
    NSArray *trBtNames=[[self.params objectForKey:@"b2Name"] componentsSeparatedByString:@","];
    n+=30,m=30+n,i=0,j=0;
    [self addLabel:@"交易途径" y:n andBt:trBtNames index:400];
    
    //添加参数名和参数输入input
    NSArray *pNames=[[self.params objectForKey:@"pName"] componentsSeparatedByString:@","];
    NSArray *pUnits=[[self.params objectForKey:@"pUnit"] componentsSeparatedByString:@","];
    m=n;
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
    n+=50,m+=50;
    [self addSingleLabel:@"买入" frame:CGRectMake(10,n+=30,150,25)];
    NSArray *r1Names=[[self.params objectForKey:@"r1Name"] componentsSeparatedByString:@","];
    NSArray *r1Units=[[self.params objectForKey:@"r1Unit"] componentsSeparatedByString:@","];
    m=n,i=0,j=0;
    for(NSString *name in r1Names){
        [self addLabel:name frame:CGRectMake(10,n+=30,150,25) inputFrame:CGRectMake(160,m+=30,150,25) unit:[r1Units objectAtIndex:i++] index:j++ enable:NO];
    }

    [self addSingleLabel:@"卖出" frame:CGRectMake(10,n+=30,150,25)];
    NSArray *r2Names=[[self.params objectForKey:@"r2Name"] componentsSeparatedByString:@","];
    NSArray *r2Units=[[self.params objectForKey:@"r2Unit"] componentsSeparatedByString:@","];
    m=n,i=0;
    for(NSString *name in r2Names){
        [self addLabel:name frame:CGRectMake(10,n+=30,150,25) inputFrame:CGRectMake(160,m+=30,150,25) unit:[r2Units objectAtIndex:i++] index:j++ enable:NO];
    }
    
    [self addSingleLabel:@"统计" frame:CGRectMake(10,n+=30,150,25)];
    NSArray *r3Names=[[self.params objectForKey:@"r3Name"] componentsSeparatedByString:@","];
    NSArray *r3Units=[[self.params objectForKey:@"r3Unit"] componentsSeparatedByString:@","];
    m=n,i=0;
    for(NSString *name in r3Names){
        [self addLabel:name frame:CGRectMake(10,n+=30,150,25) inputFrame:CGRectMake(160,m+=30,150,25) unit:[r3Units objectAtIndex:i++] index:j++ enable:NO];
    }
    
    
}

-(void)panView:(UIPanGestureRecognizer *)tap{
    CGPoint change=[tap translationInView:self.view];
    if(tap.state==UIGestureRecognizerStateChanged){
        self.view.frame=CGRectMake(0,MAX(MIN(standard.y+change.y,0),-800),SCREEN_WIDTH,ScreenHeight);
    }else if(tap.state==UIGestureRecognizerStateEnded){
        standard=self.view.frame.origin;
    }
    
}

-(void)backTap:(UITapGestureRecognizer *)tap{
    [self dismissText];
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
-(float)getMin:(float)a and:(float)b{
    if (a>b) {
        return b;
    } else {
        return a;
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

-(void)calTool{
    NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
    //[formatter setPositiveFormat:@"####.##"];
    float f200=PARAM(0)*PARAM(2)*PARAM(3);
    float f201=0;
    if (selectedBtTag==300) {
        if (self.toolType==HSBC) {
            f201=[self getMax:100 and:(f200*0.004)];
        } else {
            f201=[self getMax:100 and:(f200*0.0025)];
        }
    } else if (selectedBtTag==301){
        if (self.toolType==HSBC) {
            f201=[self getMax:100 and:(f200*0.0025)];
        } else {
            f201=[self getMax:100 and:(f200*0.0023)];
        }
    }else if (selectedBtTag==400) {
        f201=[self getMax:100 and:(f200*0.002)];
    } else if (selectedBtTag==401){
        f201=[self getMax:100 and:(f200*0.003)];
    }
    float f202=PARAM(3)*PARAM(2)*PARAM(0)*0.00005;
    float f203=PARAM(0)*PARAM(2)*PARAM(3)*0.00003;
    float f204=PARAM(3)*PARAM(2)*PARAM(0)*0.001;
    float f206=0;float f205=0;
    float f207=[self getMin:([self getMax:(PARAM(3)*5) and:30]) and:200];
    if (self.toolType==SC) {
        f205=[self getMin:100 and:[self getMax:2 and:PARAM(0)*PARAM(2)*PARAM(3)*0.00002]];
        f207=0;
    }
    float f208=f201+f202+f203+f204+f205+f206+f207;
    float f209=f208+f200;
    
    float f210=PARAM(2)*PARAM(1)*PARAM(3);
    float f211=0;
    if (selectedBtTag==300) {
        if (self.toolType==HSBC) {
            f211=[self getMax:100 and:(f210*0.004)];
        } else {
            f211=[self getMax:100 and:(f210*0.0025)];
        }
    } else if (selectedBtTag==301) {
        if (self.toolType==HSBC) {
            f211=[self getMax:100 and:(f210*0.0025)];
        } else {
            f211=[self getMax:100 and:(f210*0.0023)];
        }
    } else if (selectedBtTag==400) {
        f211=[self getMax:100 and:(f210*0.002)];
    } else if (selectedBtTag==401){
        f211=[self getMax:100 and:(f210*0.003)];
    }
    float f212=PARAM(3)*PARAM(2)*PARAM(1)*0.00005;
    float f213=PARAM(1)*PARAM(2)*PARAM(3)*0.00003;
    float f214=PARAM(3)*PARAM(2)*PARAM(1)*0.001;
    float f216=0;float f215=0;
    if (self.toolType==SC) {
        f215=2;
    }
    float f217=f211+f212+f213+f214+f215+f216;
    float f218=f210-f217;
    
    float f219=f217+f208;
    float f220=f218-f209;
    float f221=f220/f209;

    [self setText:StringFromFloat(f200) tag:200];
    [self setText:StringFromFloat(f201) tag:201];
    [self setText:StringFromFloat(f202) tag:202];
    [self setText:StringFromFloat(f203) tag:203];
    [self setText:StringFromFloat(f204) tag:204];
    [self setText:StringFromFloat(f205) tag:205];
    [self setText:StringFromFloat(f206) tag:206];
    [self setText:StringFromFloat(f207) tag:207];
    [self setText:StringFromFloat(f208) tag:208];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self setText:StringFromFloat(f209) tag:209];
    [self setText:StringFromFloat(f210) tag:210];
    [self setText:StringFromFloat(f211) tag:211];
    [self setText:StringFromFloat(f212) tag:212];
    [self setText:StringFromFloat(f213) tag:213];
    [self setText:StringFromFloat(f214) tag:214];
    [self setText:StringFromFloat(f215) tag:215];
    [self setText:StringFromFloat(f216) tag:216];
    [self setText:StringFromFloat(f217) tag:217];
    [self setText:StringFromFloat(f218) tag:218];
    [self setText:StringFromFloat(f219) tag:219];
    [self setText:StringFromFloat(f220) tag:220];
    [formatter setPositiveSuffix:@"%"];
    [self setText:StringFromFloat(f221*100) tag:221];
    
}

-(void)setBtChosen:(UIButton *)bt{
    
    [bt setSelected:YES];
    if ((UIButton *)[self.view viewWithTag:selectedBtTag]!=bt) {
        [(UIButton *)[self.view viewWithTag:selectedBtTag] setSelected:NO];
    }
    selectedBtTag=bt.tag;
    
}

-(void)addSingleLabel:(NSString *)name frame:(CGRect)rect{
    UILabel *label=[[[UILabel alloc] initWithFrame:rect] autorelease];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [label setText:name];
    [self.view addSubview:label];
}

-(void)addLabel:(NSString *)name y:(float)y andBt:(NSArray *)btNames index:(NSInteger)index{
    
    UILabel *label=[[[UILabel alloc] initWithFrame:CGRectMake(10,y,80,25)] autorelease];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [label setText:name];
    [self.view addSubview:label];
    
    NSInteger beginX=120;
    NSInteger width=(SCREEN_WIDTH-120)/[btNames count];
    for(int i=0;i<[btNames count];i++){
        UIButton *choseBt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [choseBt setTitle:[btNames objectAtIndex:i] forState:UIControlStateNormal];
        [choseBt setFrame:CGRectMake(beginX,y,width,30)];
        [choseBt setTag:index+i];
        [choseBt.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:12.0]];
        [choseBt addTarget:self action:@selector(setBtChosen:) forControlEvents:UIControlEventTouchUpInside];
        if ([btNames count]==1) {
            [choseBt setEnabled:NO];
            [choseBt setSelected:YES];
        }
        if ([btNames count]>1&&i==0) {
            [choseBt setSelected:YES];
            selectedBtTag=index+i;
        }
        [self.view addSubview:choseBt];
        beginX+=(width+10);
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
    textField.placeholder = [unit isEqualToString:@"2"]?@"":unit;
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
