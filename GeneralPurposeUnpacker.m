//
//  GeneralPurposeUnpacker.h
//  MessagePack
//
//  Created by Steven Mulder on 5/8/14.
//
//

#import "GeneralPurposeUnpacker.h"
#include "msgpack_src/msgpack.h"

@interface GeneralPurposeUnpacker ()

@property NSData *data;
@property msgpack_unpacked msg;

@end

@implementation GeneralPurposeUnpacker

/**
 * Prepares msgpack_sbuffer and msgpack_packer instance for writing.
 */
- (id)initWithData:(NSData *)data {
    if (self = [super init]) {
        _data = data;
        msgpack_unpacked_init(&_msg);
    }
    return self;
}

- (id)readNext; {
    // Parse it into C-land
    size_t offset = 0;
    bool success = msgpack_unpack_next(&_msg, _data.bytes, _data.length, &offset);
    // Convert from C-land to Obj-c-land
	id results = success ? [GeneralPurposeUnpacker createUnpackedObject:_msg.data] : nil;
#if !__has_feature(objc_arc)
	return [results autorelease];
#else
    return results;
#endif
}

- (void)destroy {
	msgpack_unpacked_destroy(&_msg); // Free the parserr
    return;
}

// This function returns a parsed object that you have the responsibility to release/autorelease (see 'create rule' in apple docs)
+ (id)createUnpackedObject:(msgpack_object)obj {
    switch (obj.type) {
        case MSGPACK_OBJECT_BOOLEAN:
            return [[NSNumber alloc] initWithBool:obj.via.boolean];
            break;
        case MSGPACK_OBJECT_POSITIVE_INTEGER:
            return [[NSNumber alloc] initWithUnsignedLongLong:obj.via.u64];
            break;
        case MSGPACK_OBJECT_NEGATIVE_INTEGER:
            return [[NSNumber alloc] initWithLongLong:obj.via.i64];
            break;
        case MSGPACK_OBJECT_DOUBLE:
            return [[NSNumber alloc] initWithDouble:obj.via.dec];
            break;
        case MSGPACK_OBJECT_RAW:
            return [[NSString alloc] initWithBytes:obj.via.raw.ptr length:obj.via.raw.size encoding:NSUTF8StringEncoding];
            break;
        case MSGPACK_OBJECT_ARRAY:
        {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:obj.via.array.size];
            msgpack_object* const pend = obj.via.array.ptr + obj.via.array.size;
            for(msgpack_object *p= obj.via.array.ptr;p < pend;p++){
				id newArrayItem = [self createUnpackedObject:*p];
                [arr addObject:newArrayItem];
#if !__has_feature(objc_arc)
                [newArrayItem release];
#endif
            }
            return arr;
        }
            break;
        case MSGPACK_OBJECT_MAP:
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:obj.via.map.size];
            msgpack_object_kv* const pend = obj.via.map.ptr + obj.via.map.size;
            for(msgpack_object_kv* p = obj.via.map.ptr; p < pend; p++){
                id key = [self createUnpackedObject:p->key];
                id val = [self createUnpackedObject:p->val];
                [dict setValue:val forKey:key];
#if !__has_feature(objc_arc)
				[key release];
				[val release];
#endif
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

@end
