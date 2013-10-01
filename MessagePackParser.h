//
//  MessagePackParser.h
//  Fetch TV Remote
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "msgpack_src/msgpack.h"

typedef enum
{
    MPRawsAsNSString_NSNullOnFail,
    MPRawsAsNSString_NSDataOnFail,
    MPRawsAsNSString_ExceptionOnFail,
    MPRawsAsNSData,
} MPRawHandling;


@interface MessagePackParser : NSObject {
    // This is only for MessagePackParser+Streaming category.
    msgpack_unpacker unpacker;
}

//parse the data into an NSObject. handle raw bytes as specified:
// - MPRawsAsNSString_NSNullOnFail: try to decode the bytes with utf8.
//   if the decoding fails, put an NSNull in that part of the message.
// - MPRawsAsNSString_NSDataOnFail: try to decode the bytes with utf8.
//   if the decoding fails, put an NSData in that part of the message.
// - MPRawsAsNSString_ExceptionOnFail: try to decode the bytes with utf8.
//   if the decoding fails, raise an exception
// - MPRawsAsNSData: always leave bytes as they are, leaving them as
//   NSDatas.

+ (id)parseData:(NSData*)data rawHandling:(MPRawHandling)rawHandling;

//parse the data into an NSObject, handling raws with MPRawsAsNSString_NSNullOnFail
+ (id)parseData:(NSData*)data;

@end
