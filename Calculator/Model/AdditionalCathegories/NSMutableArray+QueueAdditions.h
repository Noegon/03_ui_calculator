//
//  NSMutableArray+QueueAdditions.h
//  Calculator
//
//  Created by Alex on 02.06.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueAdditions)

- (id) dequeue;
- (void) enqueue:(id)obj;
- (void) eraseQueue;

@end
