//
//  NSData+MessagePack.h
//  Fetch TV Remote
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessagePackParser.h"

// Adds MessagePack parsing to NSData
@interface NSData (NSData_MessagePack)

// **Packs** the receiver's data into message pack data
- (NSData*)messagePack;

// Parses the receiver's data into a message pack array or dictionary,
// decoding raw bytes into utf8 strings
- (id)messagePackParse;

// Parses the receiver's data into a message pack array or dictionary,
// without decoding raw bytes into utf8 strings
- (id)messagePackParseWith:(MPRawHandling)rawHandling;

@end
