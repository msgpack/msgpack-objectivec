//
//  GeneralPurposePacker.m
//  MessagePack
//
//  Created by Steven Mulder on 5/2/14.
//
//

#import "GeneralPurposePacker.h"
#include "msgpack_src/msgpack.h"

@interface GeneralPurposePacker ()

@property msgpack_sbuffer *buffer;
@property msgpack_packer *packer;

@end

@implementation GeneralPurposePacker

- (id)init 
{
    if (self = [super init]) {
        _buffer = msgpack_sbuffer_new();
        _packer = msgpack_packer_new(_buffer, msgpack_sbuffer_write);

    }
    return self;
}

- (NSData *)flush
{
    // Bridge the data back to data-c's world
    NSData *data = [NSData dataWithBytes: _buffer->data length: _buffer->size];
    
    // Free
    msgpack_sbuffer_free(_buffer);
    msgpack_packer_free(_packer);
    
    return data;
}

- (void)writeString:(NSString *)data
{
    const char *str = data.UTF8String;
    int len = strlen(str);
    msgpack_pack_raw(_packer, len);
    msgpack_pack_raw_body(_packer, str, len);
}

- (void)writeData:(NSData *)data
{
    msgpack_pack_raw(_packer, [data length]);
    msgpack_pack_raw_body(_packer, [data bytes], [data length]);
}

- (void)writeNumber:(NSNumber *)data
{
    CFNumberType numberType = CFNumberGetType((CFNumberRef) data);
    switch (numberType) {
        case kCFNumberSInt8Type:
            msgpack_pack_int8(_packer, data.shortValue);
            break;
        case kCFNumberSInt16Type:
        case kCFNumberShortType:
            msgpack_pack_int16(_packer, data.shortValue);
            break;
        case kCFNumberSInt32Type:
        case kCFNumberIntType:
        case kCFNumberLongType:
        case kCFNumberCFIndexType:
        case kCFNumberNSIntegerType:
            msgpack_pack_int32(_packer, data.intValue);
            break;
        case kCFNumberSInt64Type:
        case kCFNumberLongLongType:
            msgpack_pack_int64(_packer, data.longLongValue);
            break;
        case kCFNumberFloat32Type:
        case kCFNumberFloatType:
        case kCFNumberCGFloatType:
            msgpack_pack_float(_packer, data.floatValue);
            break;
        case kCFNumberFloat64Type:
        case kCFNumberDoubleType:
            msgpack_pack_double(_packer, data.doubleValue);
            break;
        case kCFNumberCharType: {
            int theValue = data.intValue;
            if (theValue == 0)
                msgpack_pack_false(_packer);
            else if (theValue == 1)
                msgpack_pack_true(_packer);
            else
                msgpack_pack_int16(_packer, theValue);
        }
            break;
        default:
            NSLog(@"Could not msgpack number, cannot recognise type: %@", data);
    }
}

- (void)writeObject:(NSObject *)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        msgpack_pack_array(_packer, ((NSArray *) data).count);
        for (id arrayElement in (NSArray*)data) {
            [self writeObject:arrayElement];
        }
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        msgpack_pack_map(_packer, ((NSDictionary *) data).count);
        for(id key in (NSDictionary *)data) {
            [self writeObject:key];
            [self writeObject:[(NSDictionary *)data objectForKey:key]];
        }
    } else if ([data isKindOfClass:[NSString class]]) {
        [self writeString:(NSString *)data];
    } else if ([data isKindOfClass:[NSNumber class]]) {
        [self writeNumber:(NSNumber *)data];
    } else if (data==[NSNull null]) {
        [self writeNull];
    } else if ([data isKindOfClass:[NSData class]]) {
        [self writeData:(NSData *)data];
    } else {
        NSLog(@"Could not msgpack object: %@", data);
    }
}

- (void)writeNull
{
    msgpack_pack_nil(_packer);
}

@end
