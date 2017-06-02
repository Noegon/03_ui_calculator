//
//  NSMutableArray+QueueAdditions.m
//  Calculator
//
//  Created by Alex on 02.06.17.
//  Copyright © 2017 study. All rights reserved.
//

#import "NSMutableArray+QueueAdditions.h"

@implementation NSMutableArray (QueueAdditions)

// method returns head object and removes this object from queue
- (id) dequeue {
    id headObject = [self objectAtIndex:0];
    if (headObject) {
        [[headObject retain] autorelease];
        [self removeObjectAtIndex:0];
    }
    return headObject;
}

// method adds an object to the tail of queue
- (void) enqueue:(id)anObject {
    [self addObject:anObject];
}

- (void)eraseQueue {
    [self removeAllObjects];
}

@end
