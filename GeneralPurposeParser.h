//
//  GeneralPurposeParser.h
//  msgpack-objectivec
//
//  Created by Steven Mulder on 5/8/14.
//
//

#import <Foundation/Foundation.h>

@interface GeneralPurposeParser : NSObject

/*!
 * Initializes the msgpack-c objects.
 */
- (id)initWithData:(NSData *)data;

/*!
 * Reads the next object from the packed message. The result is automatically converted into 
 * NSNumber, NSString, NSDictionary, NSArray or nil.
 *
 * @return The object that was read, or nil.
 */
- (id)readNext;

/*! Reads the next raw byte array in the message, if it exists.
 */
- (NSData *)readNextRaw;

/*!
 * Reads the next string in the message, if it exists.
 */
- (NSString *)readNextString;

/*! 
 * Reads the next number in the message, if it exists.
 */
- (NSNumber *)readNextNumber;

@end
