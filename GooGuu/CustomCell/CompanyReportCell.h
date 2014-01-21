//
//  CompanyReportCell.h
//  googuu
//
//  Created by Xcode on 13-10-22.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyReportCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UITextView *contentTextView;
@property (nonatomic,retain) IBOutlet UILabel *timeDiferLabel;

@end
