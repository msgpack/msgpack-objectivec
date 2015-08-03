//
//  MessagePackParser.m
//  msgpack-objectivec
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import "MessagePackParser.h"
#import "GeneralPurposeParser.h"
#include "msgpack_src/msgpack.h"

static const int kUnpackerBufferSize = 1024;

@interface GeneralPurposeParser ()
// Implemented in GeneralPurposeParser.m
+ (id)copyUnpackedObject:(msgpack_object)obj;
@end

@implementation MessagePackParser

// Parse the given messagepack data into a NSDictionary or NSArray typically
+ (id)parseData:(NSData*)data
{
	GeneralPurposeParser *parser = [[GeneralPurposeParser alloc] initWithData:data];
    id results = [parser readNext];
#if !__has_feature(objc_arc)
    [parser autorelease];
#endif
    return results;
}

msgpack_unpacker unpacker;

- (id)init {
    return [self initWithBufferSize:kUnpackerBufferSize];
}

- (id)initWithBufferSize:(int)bufferSize {
    if (self = [super init]) {
        msgpack_unpacker_init(&unpacker, bufferSize);
    }
    return self;
}

// Feed chunked messagepack data into buffer.
- (void)feed:(NSData*)chunk {
    msgpack_unpacker_reserve_buffer(&unpacker, [chunk length]);
    memcpy(msgpack_unpacker_buffer(&unpacker), [chunk bytes], [chunk length]);
    msgpack_unpacker_buffer_consumed(&unpacker, [chunk length]);
}

// Put next parsed messagepack data. If there is not sufficient data, return nil.
- (id)next {
    id unpackedObject = nil;
    msgpack_unpacked result;
    msgpack_unpacked_init(&result);
    if (msgpack_unpacker_next(&unpacker, &result)) {
        msgpack_object obj = result.data;
        unpackedObject = [GeneralPurposeParser copyUnpackedObject:obj];
    }
    msgpack_unpacked_destroy(&result);
    
#if !__has_feature(objc_arc)
    return [unpackedObject autorelease];
#else
    return unpackedObject;
#endif
}

@end
