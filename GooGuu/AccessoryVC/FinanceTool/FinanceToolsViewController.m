//
//  FinanceToolsViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-18.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinanceToolsViewController.h"
#import "LoginView.h"
#import "ClientLoginViewController.h"
#import "CounterViewController.h"
#import "FinanceToolsGrade2ViewController.h"
#import "HelpViewController.h"

@interface FinanceToolsViewController ()

@end

@implementation FinanceToolsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
}

-(void)initComponents{
    
    self.title=@"金融工具";
    self.customTabel=[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    
    self.customTabel.dataSource=self;
    self.customTabel.delegate=self;
    [self.view addSubview:self.customTabel];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[Utiles iOS7StatusBar:self];
    
    [self initComponents];
}

#pragma mark -
#pragma Table DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }else return 5;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 15;
    }else return 15;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int row=0;
    if (section==0) {
        row=4;
    } else if(section==1){
        row=3;
    }else if(section==2){
        row=3;
    }else if(section==3){
        row=1;
    }
    return row;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *label = [[[UILabel alloc] init] autorelease];
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    
    UIView *view = nil;
    if (section==0) {
        view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    } else {
        view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
    }
    [view autorelease];
    [view addSubview:label];
    
    return view;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell=[self.customTabel dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14.0];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    void (^setCell) (NSString *,NSString *)=^(NSString *name,NSString *img){
        [cell.textLabel setText:name];
        UIImage *image = [UIImage imageNamed:img];
        cell.imageView.image = image;
    };
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            setCell(@"贝塔系数",@"BETA");
        } else if(indexPath.row==1){
            setCell(@"折现率",@"WACC");
        }else if(indexPath.row==2){
            setCell(@"现金流折现",@"CASHCOUNT");
        }else if(indexPath.row==3){
            setCell(@"自由现金流",@"FREECRASH");
        }
    } else if(indexPath.section==1) {
        if (indexPath.row==0) {
            setCell(@"初创公司估值",@"COMVALU");
        } else if(indexPath.row==1){
            setCell(@"PE投资回报",@"PE");
        }else if(indexPath.row==2){
            setCell(@"资金的时间价值",@"FUNDTIME");
        }
    }else if(indexPath.section==2) {
        if (indexPath.row==0) {
            setCell(@"投资收益",@"INVESTCOM");
        } else if(indexPath.row==1){
            setCell(@"A股交易手续费",@"ASTOCK");
        }else if(indexPath.row==2){
            setCell(@"港股交易手续费",@"HSTOCK");
        }
    }else if(indexPath.section==3) {
        if (indexPath.row==0) {
            setCell(@"Excel快捷键(2007)",@"EXCEL");
        }
    }
    
    
    return cell;
}


#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    void (^combinePush) (NSString *,NSString *,NSString *,NSString *,FinancalToolsType)=^(NSString *pName,NSString *pUnit,NSString *rName,NSString *rUnit,FinancalToolsType type){
        
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pName,@"pName",pUnit,@"pUnit",rName,@"rName",rUnit,@"rUnit", nil];
        CounterViewController *counter=[[[CounterViewController alloc] init] autorelease];
        counter.params=params;
        counter.toolType=type;
        counter.title=[[[tableView  cellForRowAtIndexPath:indexPath] textLabel] text];
        counter.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:counter animated:YES];
        [self.customTabel deselectRowAtIndexPath:indexPath animated:YES];
        
    };
    void (^grade2Push) (NSArray *,NSArray *,NSArray *)=^(NSArray *paramArr,NSArray *typeNames,NSArray *types){

        FinanceToolsGrade2ViewController *grade2=[[[FinanceToolsGrade2ViewController alloc] init] autorelease];
        grade2.typeNames=typeNames;
        grade2.types=types;
        grade2.paramArr=paramArr;
        grade2.title=[[[tableView  cellForRowAtIndexPath:indexPath] textLabel] text];
        grade2.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:grade2 animated:YES];
        [self.customTabel deselectRowAtIndexPath:indexPath animated:YES];
    };
    
    if (indexPath.section==0) {
        //beta系数
        if (indexPath.row==0) {
            combinePush(@"贝塔系数,债务占比,有效税率",@"0,%,%",@"股权占比,无杠杆贝塔系数",@"%,1",BetaFactor);
        } else if(indexPath.row==1){
            //折现率
            combinePush(@"贝塔系数,无风险利率,市场溢价,小市值股票溢价,国家溢价,有效税率,负债成本,债务占比",@"0,%,%,%,%,%,%,%",@"权益成本,股权占比,资本成本(WACC)",@"%,%,%",Discountrate);
        }else if(indexPath.row==2){
            //现金流折现
            combinePush(@"企业无杠杆自由现金流,折现率,永续增长率,贷款金额,现金及现金等价物余额,发行股票数量",@"万元,%,%,万元,万元,万股",@"企业价值,每股价值",@"万元,元",DiscountCashFlow);
        }else if(indexPath.row==3){
            //自由现金流
            combinePush(@"企业息税前利润(EBIT),有效税率,净运营资本增加/减少,折扣和摊销,资本开支",@"万元,%,万元,万元,万元",@"企业自由现金流",@"万元",FreeCashFlow);
        }
    } else if(indexPath.section==1) {
        //初创公司估值
        if (indexPath.row==0) {
            //投前估值
            NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"投资前估值,风险投资投入前金额",@"pName",@"万元,万元",@"pUnit",@"投资后估值",@"rName",@"万元",@"rUnit", nil];
            //投后估值
            NSDictionary *params1=[NSDictionary dictionaryWithObjectsAndKeys:@"风险投资投入金额,风险投资所占股份比例",@"pName",@"万元,%",@"pUnit",@"企业估值",@"rName",@"万元",@"rUnit", nil];
            //多轮融资计算
            NSDictionary *params2=[NSDictionary dictionaryWithObjectsAndKeys:@"A轮融资金额,B轮融资金额,C轮融资金额,A轮融资投前估值,B轮融资投前估值,C轮融资投前估值",@"pName",@"万元,万元,万元,万元,万元,万元",@"pUnit",@"企业累计被稀释股份比例",@"rName",@"%",@"rUnit", nil];
            NSArray *arr=[NSArray arrayWithObjects:params,params1,params2, nil];
            NSArray *arr2=[NSArray arrayWithObjects:@"投前估值",@"投后估值",@"多轮融资计算", nil];
            NSArray *arr3=[NSArray arrayWithObjects:[NSNumber numberWithInt:InvestBeforeValu],[NSNumber numberWithInt:InvestAfterValu],[NSNumber numberWithInt:MultRoundsOfFinance], nil];
            grade2Push(arr,arr2,arr3);
            

        } else if(indexPath.row==1){
            //PE投资回报
            combinePush(@"投资金额,投后占公司股份比例,投资年份,被投公司当年利润,被投公司预计上市年份,被投公司上市前一年利润,投资支付佣金等其他费用,上市后预计是盈率",@"万元,%,年,万元,年,万元,万元,倍",@"公司投前估值,公司投前市盈率,公司投后股价,投资退出金额,投资盈利计算,投资回报倍数,内部收益率(IRR)",@"万元,倍,万元,万元,万元,倍,%",PEReturnOnInvest);
        }else if(indexPath.row==2){
            //资金时间价值
            //资金的未来价值
            NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"资金的现值,预计年收益率,时间长度,每年计息次数",@"pName",@"元,%,年,次",@"pUnit",@"资金未来价值",@"rName",@"元",@"rUnit", nil];
            //资金的现值
            NSDictionary *params1=[NSDictionary dictionaryWithObjectsAndKeys:@"资金未来价值,预计年收益率,时间长度,每年计息次数",@"pName",@"元,%,年,次",@"pUnit",@"资金现值",@"rName",@"元",@"rUnit", nil];
            //普通年金的未来价值
            NSDictionary *params2=[NSDictionary dictionaryWithObjectsAndKeys:@"每次支付金额,预计年收益率,时间长度,每次支付次数",@"pName",@"元,%,年,次",@"pUnit",@"年金未来价值",@"rName",@"元",@"rUnit", nil];
            //普通年金的现值
            NSDictionary *params3=[NSDictionary dictionaryWithObjectsAndKeys:@"每次支付金额,预计年收益率,时间长度,每次支付次数",@"pName",@"元,%,年,次",@"pUnit",@"年金现值",@"rName",@"元",@"rUnit", nil];
            //永续年金的现值
            NSDictionary *params4=[NSDictionary dictionaryWithObjectsAndKeys:@"每次支付金额,预计年收益率,每次支付次数",@"pName",@"元,%,次",@"pUnit",@"永续年金未来价值",@"rName",@"元",@"rUnit", nil];
            NSArray *arr=[NSArray arrayWithObjects:params,params1,params2,params3,params4, nil];
            NSArray *arr2=[NSArray arrayWithObjects:@"资金的未来价值",@"资金的现值",@"普通年金的未来价值",@"普通年金的现值",@"永续年金的现值",nil];
            NSArray *arr3=[NSArray arrayWithObjects:[NSNumber numberWithInt:FundsFutureValue],[NSNumber numberWithInt:FundsPresentValue],[NSNumber numberWithInt:OrdinaryAnnuityFutureValue], [NSNumber numberWithInt:OrdinaryAnnuityPresentValue],[NSNumber numberWithInt:SusAnnuityPresentValue],nil];
            grade2Push(arr,arr2,arr3);
        }
    }else if(indexPath.section==2) {
        //投资收益
        if (indexPath.row==0) {

            //投资收益计算
            NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"投资金额,投入时间,期末价值",@"pName",@"元,天,元",@"pUnit",@"年化收益率,期间收益率",@"rName",@"%,%",@"rUnit", nil];
            //理财产品预期收益计算
            NSDictionary *params1=[NSDictionary dictionaryWithObjectsAndKeys:@"年化收益率,投资金额,投入时间",@"pName",@"%,元,天",@"pUnit",@"期末价值,期间收益率",@"rName",@"元,%",@"rUnit", nil];

            NSArray *arr=[NSArray arrayWithObjects:params,params1,nil];
            NSArray *arr2=[NSArray arrayWithObjects:@"投资收益计算",@"理财产品预期收益计算", nil];
            NSArray *arr3=[NSArray arrayWithObjects:[NSNumber numberWithInt:InvestIncomeCal],[NSNumber numberWithInt:FinProductExpIncomeCal], nil];
            grade2Push(arr,arr2,arr3);
            
            
        } else if(indexPath.row==1){
            //A股交易手续费
            //沪市A股投资损益
            NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"股票买入价,股票买入数量,股票卖出价,股票卖出数量,劵商佣金比率,印花税税率,过户费税率",@"pName",@"元/股,股,元/股,股,%,%,元/千股",@"pUnit",@"过户费,印花税,券商佣金,交易手续费,总体投资损益,盈亏率",@"rName",@"元,元,元,元,元,%",@"rUnit", nil];
            //深市A股投资损益
            NSDictionary *params1=[NSDictionary dictionaryWithObjectsAndKeys:@"股票买入价,股票买入数量,股票卖出价,股票卖出数量,劵商佣金比率,印花税税率",@"pName",@"元/股,股,元/股,股,%,%",@"pUnit",@"印花税,券商佣金,交易手续费,总体投资损益,盈亏率",@"rName",@"元,元,元,元,%",@"rUnit", nil];
            //沪市A股保本卖出价
            NSDictionary *params2=[NSDictionary dictionaryWithObjectsAndKeys:@"股票买入价,股票买入数量,劵商佣金比率,印花税税率,过户费税率",@"pName",@"元/股,股,%,%,元/千股",@"pUnit",@"保本卖出价",@"rName",@"元",@"rUnit", nil];
            //深市A股保本卖出价
            NSDictionary *params3=[NSDictionary dictionaryWithObjectsAndKeys:@"股票买入价,股票买入数量,劵商佣金比率,印花税税率",@"pName",@"元/股,股,%,%",@"pUnit",@"保本卖出价",@"rName",@"元",@"rUnit", nil];
            
            NSArray *arr=[NSArray arrayWithObjects:params,params1,params2,params3,nil];
            NSArray *arr2=[NSArray arrayWithObjects:@"沪市A股投资损益",@"深市A股投资损益",@"沪市A股保本卖出价",@"深市A股保本卖出价", nil];
            NSArray *arr3=[NSArray arrayWithObjects:[NSNumber numberWithInt:SHAStockInvestProAndLoss],[NSNumber numberWithInt:SZAStockInvestProAndLoss],[NSNumber numberWithInt:SHAStockPreserSellPrice],[NSNumber numberWithInt:SZAStockPreserSellPrice], nil];
            grade2Push(arr,arr2,arr3);
            
        }else if(indexPath.row==2){
            //汇丰银行
            NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"卓越理财客户,一般客户",@"b1Name",@"网上理财电话交易",@"b2Name",@"买入价格,卖出价格,每手股数,手数",@"pName",@"2,2,股,手",@"pUnit",@"股票净价,经纪佣金,交易费,证监会徵费,印花税,结算费,手续费,仓存费,合计买入手续费,实际支出金额",@"r1Name",@"2,最低港币100元,2,2,2,2,2,最低30最高200每单位5,2,2",@"r1Unit",@"股票净价,经济佣金,交易费,证监会缴费,印花税,结算费,手续费,合计买入手续费,实际支出金额",@"r2Name",@"2,最低港币100,2,2,2,2,2,2,2",@"r2Unit",@"买卖总手续费,总盈利/亏损,盈亏率",@"r3Name",@"2,2,%",@"r3Unit", nil];
            //中银香港
            NSDictionary *params1=[NSDictionary dictionaryWithObjectsAndKeys:@"晋星,银星",@"b1Name",@"网上理财/手机银行",@"b2Name",@"买入价格,卖出价格,每手股数,手数",@"pName",@"2,2,股,手",@"pUnit",@"股票净价,经纪佣金,交易费,证监会徵费,印花税,结算费,手续费,仓存费,合计买入手续费,实际支出金额",@"r1Name",@"2,最低港币100元,2,2,2,2,2,最低30最高200每单位5,2,2",@"r1Unit",@"股票净价,经济佣金,交易费,证监会缴费,印花税,结算费,手续费,合计买入手续费,实际支出金额",@"r2Name",@"2,最低港币100,2,2,2,2,2,2,2",@"r2Unit",@"买卖总手续费,总盈利/亏损,盈亏率",@"r3Name",@"2,2,%",@"r3Unit", nil];
            //渣打银行
            NSDictionary *params2=[NSDictionary dictionaryWithObjectsAndKeys:@"默认",@"b1Name",@"网上银行,股票热线",@"b2Name",@"买入价格,卖出价格,每手股数,手数",@"pName",@"2,2,股,手",@"pUnit",@"股票净价,经纪佣金,交易费,证监会徵费,印花税,结算费,手续费,仓存费,合计买入手续费,实际支出金额",@"r1Name",@"2,最低港币100元,2,2,2,2,2,最低30最高200每单位5,2,2",@"r1Unit",@"股票净价,经济佣金,交易费,证监会缴费,印花税,结算费,手续费,合计买入手续费,实际支出金额",@"r2Name",@"2,最低港币100,2,2,2,2,2,2,2",@"r2Unit",@"买卖总手续费,总盈利/亏损,盈亏率",@"r3Name",@"2,2,%",@"r3Unit", nil];
            NSArray *arr=[NSArray arrayWithObjects:params,params1,params2,nil];
            NSArray *arr2=[NSArray arrayWithObjects:@"汇丰银行",@"中银香港",@"渣打银行", nil];
            NSArray *arr3=[NSArray arrayWithObjects:[NSNumber numberWithInt:HSBC],[NSNumber numberWithInt:BOC],[NSNumber numberWithInt:SC], nil];
            grade2Push(arr,arr2,arr3);
        }
    }else if(indexPath.section==3) {
        if (indexPath.row==0) {
            HelpViewController *help=[[HelpViewController alloc] init];
            help.type=ExcelShortcutsHelp;
            [self.navigationController pushViewController:help animated:YES];
            SAFE_RELEASE(help);
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate{
    return NO;
}




















@end