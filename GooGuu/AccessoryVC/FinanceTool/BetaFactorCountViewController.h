//
//  BetaFactorCountViewController.h
//  googuu
//
//  Created by Xcode on 13-10-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  2013-10-15 | Wanax | 金融工具 Beta 系数选择一级页面，对行业进行选择

#import <UIKit/UIKit.h>
#import "ChoseBetaFactorViewController.h"

@class CounterViewController;

@protocol BetaFactorVCDelegate <NSObject>
@optional
-(void)gotBeta:(NSString *)betaFactor;
@end

@interface BetaFactorCountViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ChoseBetaVCDelegate>

@property (nonatomic,retain) NSArray *typeArr;

@property (nonatomic,retain) id<BetaFactorVCDelegate> delegate;

@property (nonatomic,retain) IBOutlet UITextField *stockCodeInput;
@property (nonatomic,retain) IBOutlet UIPickerView *expPicker;
@property (nonatomic,retain) IBOutlet UIButton *getBetaFactorBt;

@end
