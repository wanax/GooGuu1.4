//
//  FeedBackViewController.h
//  googuu
//
//  Created by Xcode on 13-8-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,retain) IBOutlet UITextField *feedBackField;

- (IBAction)backgroundTap:(id)sender;

@end
