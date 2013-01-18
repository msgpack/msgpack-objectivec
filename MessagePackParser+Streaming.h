//
//  MessagePackParser+Streaming.h
//  msgpack-objectivec-example
//
//  Created by 松前 健太郎 on 2013/01/18.
//  Copyright (c) 2013年 kenmaz.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessagePackParser.h"

@interface MessagePackParser (Streaming)

- (id)init;
- (id)initWithBufferSize:(int)bufferSize;
- (void)feed:(NSData*)rawData;
- (id)next;

@end
