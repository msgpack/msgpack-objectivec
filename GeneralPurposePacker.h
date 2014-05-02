//
//  GeneralPurposePacker.h
//  MessagePack
//
//  Created by Steven Mulder on 5/2/14.
//
//

#import <Foundation/Foundation.h>

@interface GeneralPurposePacker : NSObject

- (id) init;

- (NSData *) flush;

- (void) writeString:(NSString *) data;

- (void) writeData:(NSData *) data;

@end
