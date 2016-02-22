//
//  MessagePackParser.m
//  Fetch TV Remote
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import "MessagePackParser.h"
#include "msgpack.h"

@implementation MessagePackParser {
    // This is only for MessagePackParser+Streaming category.
    msgpack_unpacker _unpacker;
}

@dynamic unpacker;

+(id) createUnpackedObject:(msgpack_object)obj {
    switch (obj.type) {
        case MSGPACK_OBJECT_BOOLEAN:
            return [NSNumber numberWithBool:obj.via.boolean];
            break;
        case MSGPACK_OBJECT_POSITIVE_INTEGER:
            return [NSNumber numberWithUnsignedLongLong:obj.via.u64];
            break;
        case MSGPACK_OBJECT_NEGATIVE_INTEGER:
            return [NSNumber numberWithLongLong:obj.via.i64];
            break;
        case MSGPACK_OBJECT_FLOAT:
            return [NSNumber numberWithDouble:obj.via.f64];
            break;
        case MSGPACK_OBJECT_STR:
        {
            BOOL lossy = NO;
            NSString* str = nil;
            NSData* strData = [NSData dataWithBytesNoCopy:(void*)obj.via.str.ptr length:obj.via.str.size freeWhenDone:NO];
            NSStringEncoding encoding = [NSString stringEncodingForData:strData
                                                        encodingOptions:@{ NSStringEncodingDetectionSuggestedEncodingsKey : @[@(NSUTF8StringEncoding),
                                                                                                                              @(NSUTF16StringEncoding),
                                                                                                                              @(NSISOLatin1StringEncoding),
                                                                                                                              @(NSWindowsCP1252StringEncoding),
                                                                                                                              @(NSMacOSRomanStringEncoding)] }
                                                        convertedString:&str
                                                    usedLossyConversion:&lossy];
//            NSString* str = [[NSString alloc] initWithBytes:obj.via.str.ptr length:obj.via.str.size encoding:NSUTF8StringEncoding];
            return str;
        }
            break;
        case MSGPACK_OBJECT_BIN:
            return [NSData dataWithBytes:obj.via.bin.ptr length:obj.via.bin.size];
            break;
        case MSGPACK_OBJECT_ARRAY:
        {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:obj.via.array.size];
            msgpack_object* const pend = obj.via.array.ptr + obj.via.array.size;
            for(msgpack_object *p= obj.via.array.ptr;p < pend;p++){
                @autoreleasepool {
                    id newArrayItem = [self createUnpackedObject:*p];
                    [arr addObject:newArrayItem];
                }
            }
            return arr;
        }
            break;
        case MSGPACK_OBJECT_MAP:
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:obj.via.map.size];
            msgpack_object_kv* const pend = obj.via.map.ptr + obj.via.map.size;
            for(msgpack_object_kv* p = obj.via.map.ptr; p < pend; p++){
                @autoreleasepool {
                    id key = [self createUnpackedObject:p->key];
                    id val = [self createUnpackedObject:p->val];
                    [dict setValue:val forKey:key];
                }
            }
            return dict;
        }
            break;
        case MSGPACK_OBJECT_NIL:
        default:
            return [NSNull null]; // Since nsnull is a system singleton, we don't have to worry about ownership of it
            break;
    }
}

// Parse the given messagepack data into a NSDictionary or NSArray typically
+ (id)parseData:(NSData*)data {
	msgpack_unpacked msg;
	msgpack_unpacked_init(&msg);
	bool success = msgpack_unpack_next(&msg, data.bytes, data.length, NULL); // Parse it into C-land
	id results = success ? [self createUnpackedObject:msg.data] : nil; // Convert from C-land to Obj-c-land
	msgpack_unpacked_destroy(&msg); // Free the parser
    return results;
}

- (msgpack_unpacker *)unpacker
{
    return &_unpacker;
}

@end
