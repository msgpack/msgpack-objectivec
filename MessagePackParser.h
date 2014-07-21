//
//  MessagePackParser.h
//  Fetch TV Remote
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct msgpack_unpacker msgpack_unpacker;

@interface MessagePackParser : NSObject

@property (nonatomic, assign) msgpack_unpacker* unpacker;

+ (id)parseData:(NSData*)data;

@end
