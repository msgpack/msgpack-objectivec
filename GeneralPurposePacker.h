//
//  GeneralPurposePacker.h
//  MessagePack
//
//  Created by Steven Mulder on 5/2/14.
//
//

#import <Foundation/Foundation.h>

@interface GeneralPurposePacker : NSObject

/* Initializes the msgpack objects in C-land. Remember to call flush when you are done!
*/
- (id)init;

/* Converts the msgpack data into NSData, and frees the msgppack_sbuffer and msgpack_packer instances.
*/
- (NSData *)flush;

- (void)writeString:(NSString *)data;

- (void)writeData:(NSData *)data;

- (void)writeNumber:(NSNumber *)data;

- (void)writeNull;

- (void)writeObject:(NSObject *)data;

@end
