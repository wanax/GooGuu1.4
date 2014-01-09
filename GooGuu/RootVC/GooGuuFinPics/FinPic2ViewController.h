//
//  FinPic2ViewController.h
//  googuu
//
//  Created by Xcode on 13-10-17.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOTag.h"

@interface FinPic2ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AOTagDelegate>

@property (nonatomic,retain) UITableView *cusTabView;
@property (nonatomic,retain) AOTagList *tag;

@property (nonatomic,retain) id keyWordData;
@property (nonatomic,retain) NSArray *keyWordList;

@end
