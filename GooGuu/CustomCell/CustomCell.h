//
//  CustomCell.h
//  welcom_demo_1
//
//  Created by Xcode on 13-5-7.
//  Copyright (c) 2013年 Pony Finance.. All rights reserved.
//
//  Vision History
//  2013-05-07 | Wanax | 我的估股栏目股票cell  

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *topImageView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *belongLabel;
@property (strong, nonatomic) IBOutlet UILabel *gPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic,retain) IBOutlet UILabel *backLabel;
@property (nonatomic,retain) IBOutlet UILabel *outLookLabel;
@property (nonatomic,retain) IBOutlet UILabel *percentLabel;



@property (nonatomic,retain) UIImage *topImg;
@property (nonatomic,retain) UIImage *bottomImg;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *belong;
@property (nonatomic,retain) NSString *gPrice;
@property (nonatomic,retain) NSString *price;

@end
