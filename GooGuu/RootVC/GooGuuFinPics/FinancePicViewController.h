//
//  DemoCollectionViewController.h
//  googuu
//
//  Created by Xcode on 13-10-12.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXPhotoBrowser.h"

@interface FinancePicViewController : UICollectionViewController<CXPhotoBrowserDataSource,CXPhotoBrowserDelegate>{
    CXBrowserNavBarView *navBarView;
    NSInteger page;
}

@property (nonatomic,retain) NSString *keyWord;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic,retain) UILabel *imageTitleLabel;
@property (nonatomic, strong) CXPhotoBrowser *browser;
@property (nonatomic, strong) NSMutableArray *photoDataSource;

@end
