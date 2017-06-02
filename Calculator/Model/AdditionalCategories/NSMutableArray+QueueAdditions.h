//
//  NSMutableArray+QueueAdditions.h
//  Calculator
//
//  Created by Alex on 02.06.17.
//  Copyright © 2017 study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (NGNQueueAdditions)

- (id) ngn_dequeue;
- (void) ngn_enqueue:(id)obj;
- (void) ngn_eraseQueue;

@end
