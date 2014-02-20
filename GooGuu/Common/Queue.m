//
//  Queue.m
//  GooGuu
//
//  Created by Xcode on 14-2-19.
//  Copyright (c) 2014年 Xcode. All rights reserved.
//

#import "Queue.h"

@implementation Queue

-(id)initAQueue {
    self = [super init];
    if (self) {
        NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
        self.queue = temp;
    }
    return self;
}

-(id)pop {
    id obj = [[self.queue firstObject] retain];
    [self.queue removeObject:obj];
    return [obj autorelease];
}

-(void)push:(id)obj {
    [self.queue addObject:obj];
}

-(BOOL)isEmpty {
    return [self.queue count] == 0?YES:NO;
}

@end
