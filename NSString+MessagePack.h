//
//  NSString+MessagePack.h
//  MessagePack
//
//  Created by Charles Francoise on 21/07/14.
//  Copyright (c) 2014 Charles Francoise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_MessagePack)

// Packs the receiver's data into message pack data
- (NSData*)messagePack;

@end
