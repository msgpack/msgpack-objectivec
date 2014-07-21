//
//  NSNumber+MessagePack.h
//  MessagePack
//
//  Created by Charles Francoise on 22/07/14.
//  Copyright (c) 2014 Charles Francoise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (NSNumber_MessagePack)

// Packs the receiver's data into message pack data
- (NSData*)messagePack;

@end
