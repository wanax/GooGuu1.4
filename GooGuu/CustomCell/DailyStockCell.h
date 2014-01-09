//
//  DailyStockCell.h
//  UIDemo
//
//  Created by Xcode on 13-7-18.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-07-18 | Wanax | 我的估股栏目顶层每日一股cell

#import <UIKit/UIKit.h>

@interface DailyStockCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UIImageView *dailyStockImg;
@property (nonatomic,retain) IBOutlet UILabel *companyNameLabel;
@property (nonatomic,retain) IBOutlet UILabel *communityPriceLabel;
@property (nonatomic,retain) IBOutlet UILabel *gooGuuPriceLabel;
@property (nonatomic,retain) IBOutlet UILabel *marketLabel;
@property (nonatomic,retain) IBOutlet UILabel *marketPriceLabel;
@property (nonatomic,retain) IBOutlet UILabel *tradeLabel;
@property (nonatomic,retain) IBOutlet UILabel *outLookLabel;
@property (nonatomic,retain) IBOutlet UILabel *outLookTextLabel;
@property (nonatomic,retain) IBOutlet UIImageView *arrowImg;

@end
