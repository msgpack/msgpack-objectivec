//
//  MessagePackParser.m
//  Fetch TV Remote
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import "MessagePackParser.h"

@implementation MessagePackParser

// This function returns a parsed object that you have the responsibility to release/autorelease (see 'create rule' in apple docs)
+(id) createUnpackedObject:(msgpack_object)obj rawHandling:(MPRawHandling)rawHandling {
    switch (obj.type) {
        case MSGPACK_OBJECT_BOOLEAN:
            return [[NSNumber alloc] initWithBool:obj.via.boolean];
        case MSGPACK_OBJECT_POSITIVE_INTEGER:
            return [[NSNumber alloc] initWithUnsignedLongLong:obj.via.u64];
        case MSGPACK_OBJECT_NEGATIVE_INTEGER:
            return [[NSNumber alloc] initWithLongLong:obj.via.i64];
        case MSGPACK_OBJECT_DOUBLE:
            return [[NSNumber alloc] initWithDouble:obj.via.dec];
        case MSGPACK_OBJECT_RAW:
        {
            if (rawHandling == MPRawsAsNSData) {
                return [[NSData alloc] initWithBytes:obj.via.raw.ptr length:obj.via.raw.size];
            }
            
            NSString *res =  [[NSString alloc] initWithBytes:obj.via.raw.ptr
                                                      length:obj.via.raw.size
                                                    encoding:NSUTF8StringEncoding];
            if (res) {
                return res;
            }
            
            switch (rawHandling) {
                case MPRawsAsNSString_NSNullOnFail:
                    return [NSNull null];
                case MPRawsAsNSString_ExceptionOnFail:
                    [NSException raise:@"Invalid string encountered"
                                format:@"Raw bytes did not decode into utf8"];
                    return res;
                case MPRawsAsNSString_NSDataOnFail: {
                    return [[NSData alloc] initWithBytes:obj.via.raw.ptr length:obj.via.raw.size];
                case MPRawsAsNSData: //suppress compiler warning
                    return res;
                }
            }
        }
        case MSGPACK_OBJECT_ARRAY:
        {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:obj.via.array.size];
            msgpack_object* const pend = obj.via.array.ptr + obj.via.array.size;
            for(msgpack_object *p= obj.via.array.ptr;p < pend;p++){
				id newArrayItem = [self createUnpackedObject:*p rawHandling:rawHandling];
                [arr addObject:newArrayItem];
#if !__has_feature(objc_arc)
                [newArrayItem release];
#endif
            }
            return arr;
        }
        case MSGPACK_OBJECT_MAP:
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:obj.via.map.size];
            msgpack_object_kv* const pend = obj.via.map.ptr + obj.via.map.size;
            for(msgpack_object_kv* p = obj.via.map.ptr; p < pend; p++){
                id key = [self createUnpackedObject:p->key rawHandling:rawHandling];
                id val = [self createUnpackedObject:p->val rawHandling:rawHandling];
                [dict setValue:val forKey:key];
#if !__has_feature(objc_arc)
				[key release];
				[val release];
#endif
            }
            return dict;
        }
        case MSGPACK_OBJECT_NIL:
            return [NSNull null]; // Since nsnull is a system singleton, we don't have to worry about ownership of it
        default:
            [NSException raise:@"Unsupported object type"
                        format:@"Unrecognized msgpack object type %d", obj.type];
            return [NSNull null]; // suppress compiler warning
    }
}

+ (id)parseData:(NSData*)data rawHandling:(MPRawHandling)rawHandling {
	msgpack_unpacked msg;
	msgpack_unpacked_init(&msg);
	bool success = msgpack_unpack_next(&msg, data.bytes, data.length, NULL); // Parse it into C-land
    // Convert from C-land to Obj-c-land
	id results = success ? [self createUnpackedObject:msg.data rawHandling:rawHandling] : nil;
	msgpack_unpacked_destroy(&msg); // Free the parser
#if !__has_feature(objc_arc)
	return [results autorelease];
#else
    return results;
#endif    
}

// Parse the given messagepack data into a NSDictionary or NSArray typically
+ (id)parseData:(NSData*)data {
    return [self parseData:data rawHandling:MPRawsAsNSString_NSNullOnFail];
}

@end
