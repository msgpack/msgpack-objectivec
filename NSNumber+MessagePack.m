//
//  NSNumber+MessagePack.m
//  MessagePack
//
//  Created by Charles Francoise on 22/07/14.
//  Copyright (c) 2014 Charles Francoise. All rights reserved.
//

#import "NSNumber+MessagePack.h"
#import "MessagePackPacker.h"

@implementation NSNumber (NSNumber_MessagePack)

// Packs the receiver's data into message pack data
- (NSData*)messagePack {
	return [MessagePackPacker pack:self];
}

@end
