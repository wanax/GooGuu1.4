//
//  EnumSummary.h
//  googuu
//
//  Created by Xcode on 13-8-15.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnumSummary : NSObject

typedef enum{
    UserHelp,
    ExcelShortcutsHelp
}HelpType;

typedef enum{
    
    BetaFactor=0,//beta系数
    Discountrate=1,//折现率
    DiscountCashFlow=2,//现金流折现
    FreeCashFlow=3,//自由现金流
    StartUpComValue=4,//初创公司估值
    InvestBeforeValu=41,//投前估值
    InvestAfterValu=42,//投后估值
    MultRoundsOfFinance=43,//多轮融资计算
    PEReturnOnInvest=5,//PE投资回报
    FundsTimeValue=6,//资金的时间价值
    FundsFutureValue=61,//资金的未来价值
    FundsPresentValue=62,//资金的现值
    OrdinaryAnnuityFutureValue=63,//普通年金的未来价值
    OrdinaryAnnuityPresentValue=64,//普通年金的现值
    SusAnnuityPresentValue=65,//永续年金的现值
    InvestIncome=7,//投资收益
    InvestIncomeCal=71,//投资收益计算
    FinProductExpIncomeCal=72,//理财产品预期收益计算
    AStockTransFees=8,//A股交易手续费
    SHAStockInvestProAndLoss=81,//沪市A股投资损益
    SZAStockInvestProAndLoss=82,//深市A股投资损益
    SHAStockPreserSellPrice=83,//沪市A股保本卖出价
    SZAStockPreserSellPrice=84,//深市A股保本卖出价
    HKStockTransFees=9,//港股交易手续费
    HSBC=91,//汇丰银行
    BOC=92,//中银香港
    SC=93,//渣打银行
    ExcelShortcuts=10//Excel快捷键
  
} FinancalToolsType;

//用户注册信息相关
typedef enum{
    
    UserRegister,
    UserResetPwd,
    UserFindPwd
    
} UserActionType;

//评论类型，此页面三种评论公用
typedef enum {
    
    CompanyType,//关于股票公司的评论
    NewsType,//估股新闻中分析报告的评论
    ArticleType//股票公司中分析报告的评论
    
} CommentType;

//浏览来源，当从保存列表进入时加载保存数据 ChartViewController
typedef enum {
    ValuationModelType,
    MyConcernedType,
    MySavedType,
    ModelViewType,
    ChartViewType,
    DragableChart,
    FinancalModelChart,
    ChartSaved,
    DiscountSaved,
    SearchStockList,
    GooGuuView,
    GooGuuReport
} BrowseSourceType;

typedef enum {
    NewsBar=0,
    ValuationModelBar=1,
    MyGooGuuBar=4,
    SettingBar=3
} TabBarType;

//股票市场 CompanyListViewController
typedef enum {
    HK=1,//港股
    NYSE=2,//纽交所
    SZSE=4,//深圳
    SHSE=8,//上海
    SHSZSE=12,//沪深
    NASDAQ=16,//纳斯达克
    NANY=18,//美股
    ALL=31    
} MarketType;

//拖动图表按钮动作定义
typedef enum{
    SaveData=1,
    DragChartType=2,
    ResetChart=3,
    BackToSuperView=4
} ChartBtAction;

typedef enum{
    MainIncome=11,
    OperaFee=22,
    OperaCap=33,
    DiscountRate=44
} IndustoryModelType;

typedef enum{
    FinancialRatio=1,
    FinancialChart=2,
    FinancialOther=3,
    FinancialBack=4
}FinancialProportion;

typedef enum{
    AttentionAction=11,
    AddComment=22,
    AddShare=33
}ValuationModelAction;

typedef enum{
    OneMonth=1,
    ThreeMonth=2,
    SixMonth=3,
    OneYear=4
}DahonTimeInterval;

typedef enum {
    
    FinancalModel,//金融模型
    DragabelModel,//可调整参数模型
    DahonModel//大行数据
    
} ChartType;

typedef enum {
    TopCompany,
    RiseSpace,
    FallSpace
} TopPoints;//首页热点


typedef enum {
    ComAttentionClients,//关注了公司
    ComSaveClients//保存过公司模型
} CompanyFans;//公司关注




@end
