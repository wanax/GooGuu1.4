//
//  Queue.h
//  GooGuu
//
//  Created by Xcode on 14-2-19.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject

@property (nonatomic,retain) NSMutableArray *queue;

-(id)initAQueue;

-(id)pop;
-(void)push:(id)obj;
-(BOOL)isEmpty;

@end
