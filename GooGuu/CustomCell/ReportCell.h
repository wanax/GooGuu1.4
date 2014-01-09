//
//  ReportCell.h
//  googuu
//
//  Created by Xcode on 13-10-22.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UIWebView *contentWebView;
@property (nonatomic,retain) IBOutlet UILabel *timeDiferLabel;
@property (nonatomic,retain) IBOutlet UIImageView *readMarkImg;

@property (nonatomic,retain) IBOutlet UILabel *backLabel;

@end
