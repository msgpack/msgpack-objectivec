//
//  GeneralPurposeUnpacker.h
//  MessagePack
//
//  Created by Steven Mulder on 5/8/14.
//
//

#import <Foundation/Foundation.h>

@interface GeneralPurposeUnpacker : NSObject

/* Initializes the msgpack objects in C-land. Remember to call destroy when you are done!
*/
- (id)initWithData:(NSData *)data;

/* Reads the next object from the packed message. The result is automatically converted into NSNumber, NSString, NSDictionary, NSArray or NSNull.
 @return The object that was read, or nil.
*/
- (id)readNext;

/* Returns the next raw byte array in the message, if it exists.
*/
- (NSData *)readNextRaw;

/* Returns the next string in the message, if it exists.
*/
- (NSString *)readNextString;

/* Returns the next number in the message, if it exists.
*/
- (NSNumber *)readNextNumber;

/* Cleans up the msgpack object in C-land after parsing is complete.
*/
- (void)destroy;

@end
