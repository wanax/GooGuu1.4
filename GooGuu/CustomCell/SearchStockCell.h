//
//  SearchStockCell.h
//  googuu
//
//  Created by Xcode on 13-8-29.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchStockCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *companyNameLabel;
@property (nonatomic,retain) IBOutlet UILabel *stockCodeLabel;
@property (nonatomic,retain) IBOutlet UIButton *requestValuationsBt;

- (IBAction)requestValution:(id)sender;

@end

