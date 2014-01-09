//
//  AgreementViewController.h
//  googuu
//
//  Created by Xcode on 13-9-4.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreementViewController : UIViewController<UITextViewDelegate>

@property (nonatomic,retain) IBOutlet UIButton *agreeBt;
@property (nonatomic,retain) IBOutlet UIButton *disAgreeBt;

-(IBAction)agreeBtClicked:(id)sender;
-(IBAction)disAgreeBtClicked:(id)sender;

@end
