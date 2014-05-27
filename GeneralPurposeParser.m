//
//  GeneralPurposeParser.m
//  MessagePack
//
//  Created by Steven Mulder on 5/8/14.
//
//

#import "GeneralPurposeParser.h"
#include "msgpack_src/msgpack.h"

@interface GeneralPurposeParser ()

@property NSData *data;
@property size_t offset;
@property msgpack_unpacked msg;

@end

@implementation GeneralPurposeParser

// Prepares msgpack_unpacked instance for parsing the data.
- (id)initWithData:(NSData *)data
{
    if (self = [super init]) {
        _data = data;
        _offset = 0;
        msgpack_unpacked_init(&_msg);
    }
    return self;
}

- (id)readNext
{
    id result = nil;
    if (msgpack_unpack_next(&_msg, _data.bytes, _data.length, &_offset)) {
        result = [GeneralPurposeParser copyUnpackedObject:_msg.data];
    }
#if !__has_feature(objc_arc)
    return [result autorelease];
#else
    return result;
#endif
}

- (NSData *)readNextRaw
{
    id result = nil;
    if (msgpack_unpack_next(&_msg, _data.bytes, _data.length, &_offset)) {
        if (_msg.data.type == MSGPACK_OBJECT_RAW) {
            result = [[NSData alloc] initWithBytes:_msg.data.via.raw.ptr length:_msg.data.via.raw.size];
        }
    }
#if !__has_feature(objc_arc)
    return [result autorelease];
#else
    return result;
#endif
}

- (NSString *)readNextString
{
    id result = nil;
    if (msgpack_unpack_next(&_msg, _data.bytes, _data.length, &_offset)) {
        if (_msg.data.type == MSGPACK_OBJECT_RAW) {
            result = [[NSString alloc] initWithBytes:_msg.data.via.raw.ptr length:_msg.data.via.raw.size encoding:NSUTF8StringEncoding];
        }
    }
#if !__has_feature(objc_arc)
    return [result autorelease];
#else
    return result;
#endif
}

- (NSNumber *)readNextNumber
{
    id result = nil;
    if (msgpack_unpack_next(&_msg, _data.bytes, _data.length, &_offset)) {
        switch (_msg.data.type) {
            case MSGPACK_OBJECT_BOOLEAN:
                result = [[NSNumber alloc] initWithBool:_msg.data.via.boolean];
                break;
            case MSGPACK_OBJECT_POSITIVE_INTEGER:
                result = [[NSNumber alloc] initWithUnsignedLongLong:_msg.data.via.u64];
                break;
            case MSGPACK_OBJECT_NEGATIVE_INTEGER:
                result = [[NSNumber alloc] initWithLongLong:_msg.data.via.i64];
                break;
            case MSGPACK_OBJECT_DOUBLE:
                result = [[NSNumber alloc] initWithDouble:_msg.data.via.dec];
                break;
            default:; // nothing to do
        }
    }
#if !__has_feature(objc_arc)
    return [result autorelease];
#else
    return result;
#endif
}

- (void)dealloc
{
    msgpack_unpacked_destroy(&_msg); // Free the parser
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

// This function returns a parsed object that you have the responsibility to release/autorelease (see 'create rule' in apple docs)
+ (id)copyUnpackedObject:(msgpack_object)obj
{
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
                id newArrayItem = [GeneralPurposeParser copyUnpackedObject:*p];
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
                id key = [GeneralPurposeParser copyUnpackedObject:p->key];
                id val = [GeneralPurposeParser copyUnpackedObject:p->val];
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
            return nil;
            break;
    }
}

@end
