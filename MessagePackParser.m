//
//  MessagePackParser.m
//  msgpack-objectivec
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import "MessagePackParser.h"
#import "GeneralPurposeParser.h"

@implementation MessagePackParser

// Parse the given messagepack data into a NSDictionary or NSArray typically
+ (id)parseData:(NSData*)data
{
	GeneralPurposeParser *parser = [[GeneralPurposeParser alloc] initWithData:data];
    id results = [parser readNext];
    [parser destroy];
    return results;
}

@end
