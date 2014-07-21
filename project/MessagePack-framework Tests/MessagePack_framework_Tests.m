//
//  MessagePack_framework_Tests.m
//  MessagePack-framework Tests
//
//  Created by Charles Francoise on 21/07/14.
//  Copyright (c) 2014 Charles Francoise. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <MessagePack/MessagePack.h>

@interface MessagePack_framework_Tests : XCTestCase

@end

@implementation MessagePack_framework_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testArray
{
    NSArray* arr = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9];
    
    NSData* packedArr = [arr messagePack];
    XCTAssert(packedArr != nil, @"Could not pack test array. (Test array = %@)", arr);
    static const unsigned char arrData[] = {0x9a, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09};
    XCTAssert(memcmp(arrData, packedArr.bytes, packedArr.length) == 0,
              @"Packed array is not equal to expected data. (Packed data = %@, Expected data = %@)", packedArr, [NSData dataWithBytesNoCopy:arrData length:11]);
    
    NSArray* arr2 = [packedArr messagePackParse];
    XCTAssert(arr2 != nil, @"Could not parse packed data. (Packed data = %@)", packedArr);
    
    XCTAssert([arr2 isKindOfClass:[NSArray class]], @"Unpacked object is not an array. (Unpacked object = %@)", arr2);
    XCTAssert([arr isEqualToArray:arr2], @"Test array is different from unpacked array. (Test array = %@, Unpacked array = %@)", arr, arr2);
}

- (void)testDictionary
{
    NSDictionary* arr = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9];
    
    NSData* packedArr = [arr messagePack];
    XCTAssert(packedArr != nil, @"Could not pack test array. (Test array = %@)", arr);
    static const unsigned char arrData[] = {0x9a, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09};
    XCTAssert(memcmp(arrData, packedArr.bytes, packedArr.length) == 0,
              @"Packed array is not equal to expected data. (Packed data = %@, Expected data = %@)", packedArr, [NSData dataWithBytesNoCopy:arrData length:11]);
    
    NSArray* arr2 = [packedArr messagePackParse];
    XCTAssert(arr2 != nil, @"Could not parse packed data. (Packed data = %@)", packedArr);
    
    XCTAssert([arr2 isKindOfClass:[NSArray class]], @"Unpacked object is not an array. (Unpacked object = %@)", arr2);
    XCTAssert([arr isEqualToArray:arr2], @"Test array is different from unpacked array. (Test array = %@, Unpacked array = %@)", arr, arr2);
}

@end
