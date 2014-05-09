//
//  GeneralPurposeUnpacker.h
//  MessagePack
//
//  Created by Steven Mulder on 5/8/14.
//
//

#import <Foundation/Foundation.h>

@interface GeneralPurposeUnpacker : NSObject

- (id)initWithData:(NSData *)data;

- (id)readNext;

- (NSData *)readNextRaw;

- (void)destroy;

@end
