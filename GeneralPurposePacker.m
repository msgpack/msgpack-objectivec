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

/**
 * Prepares msgpack_sbuffer and msgpack_packer instance for writing.
 */
- (id) init {
    if (self = [super init]) {
        _buffer = msgpack_sbuffer_new();
        _packer = msgpack_packer_new(_buffer, msgpack_sbuffer_write);

    }
    return self;
}

/**
 * Converts the msgpack data into NSData, and frees the msgppack_sbuffer and msgpack_packer instances.
 */
- (NSData *) flush {
    // Bridge the data back to obj-c's world
    NSData* data = [NSData dataWithBytes: _buffer->data length: _buffer->size];
    
    // Free
    msgpack_sbuffer_free(_buffer);
    msgpack_packer_free(_packer);
    
    return data;
}

- (void) writeString:(NSString *) data {
    const char *str = data.UTF8String;
    int len = strlen(str);
    msgpack_pack_raw(_packer, len);
    msgpack_pack_raw_body(_packer, str, len);
}

- (void) writeData:(NSData *) data {
    msgpack_pack_raw(_packer, [data length]);
    msgpack_pack_raw_body(_packer, [data bytes], [data length]);
}

@end
