//
//  MessagePackParser.m
//  Fetch TV Remote
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import "MessagePackParser.h"
#include "GeneralPurposeUnpacker.h"

@implementation MessagePackParser

// Parse the given messagepack data into a NSDictionary or NSArray typically
+ (id)parseData:(NSData*)data {
	GeneralPurposeUnpacker *unpacker = [[GeneralPurposeUnpacker alloc] initWithData:data];
    id results = [unpacker readNext];
    [unpacker destroy];
    return results;
}

@end
