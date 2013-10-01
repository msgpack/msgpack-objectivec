//
//  NSData+MessagePack.m
//  Fetch TV Remote
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import "NSData+MessagePack.h"
#import "MessagePackPacker.h"
#import "MessagePackParser.h"

@implementation NSData (NSData_MessagePack)

- (NSData*)messagePack {
	return [MessagePackPacker pack:self];
}

-(id)messagePackParse {
    return [MessagePackParser parseData:self];
}

- (id)messagePackParseWith:(MPRawHandling)rawHandling {
    return [MessagePackParser parseData:self rawHandling:rawHandling];
}

@end
