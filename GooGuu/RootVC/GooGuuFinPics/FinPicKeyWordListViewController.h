//
//  FinPicKeyWordListViewController.h
//  googuu
//
//  Created by Xcode on 13-10-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOTag.h"

@interface FinPicKeyWordListViewController : UIViewController<AOTagDelegate>

@property (nonatomic,retain) AOTagList *tag;
@property (nonatomic,retain) NSArray *colorArr;
@property (nonatomic,retain) id keyWordData;
@property (nonatomic,retain) NSArray *keyWordList;

@end
