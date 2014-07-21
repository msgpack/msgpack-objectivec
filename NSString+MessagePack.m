//
//  NSString+MessagePack.m
//  MessagePack
//
//  Created by Charles Francoise on 21/07/14.
//  Copyright (c) 2014 Charles Francoise. All rights reserved.
//

#import "NSString+MessagePack.h"
#import "MessagePackPacker.h"

@implementation NSString (NSString_MessagePack)

// Packs the receiver's data into message pack data
- (NSData*)messagePack {
	return [MessagePackPacker pack:self];
}

@end
