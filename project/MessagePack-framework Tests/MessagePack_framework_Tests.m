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

- (void)testNull
{
    NSData* packedNull = [[NSNull null] messagePack];
    XCTAssert(packedNull != nil, @"Could not pack nil.");
    static const unsigned char nullData[] = {0xc0};
    XCTAssert(memcmp(nullData, packedNull.bytes, packedNull.length) == 0,
              @"Packed array is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNull, [NSData dataWithBytesNoCopy:nullData length:11 freeWhenDone:NO]);
    
    NSNull* null2 = [packedNull messagePackParse];
    XCTAssert(null2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNull);
    
    XCTAssert([null2 isKindOfClass:[NSNull class]], @"Unpacked object is not nil. (Unpacked object = %@)", null2);
    XCTAssert(null2 == [NSNull null], @"nil is different from unpacked value. (Unpacked value = %@)", null2);
}

- (void)testPositiveFixint
{
    NSNumber* num = @42;
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0x2a};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:11 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not an number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testNegativeFixint
{
    NSNumber* num = @(-18);
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0xee};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:11 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not an number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}



- (void)testData
{
    static const unsigned char testData[] = {0xde, 0xad, 0xbe, 0xef};
    
    NSData* data = [NSData dataWithBytesNoCopy:testData length:4 freeWhenDone:NO];
    
    NSData* packedData = [data messagePack];
    XCTAssert(packedData != nil, @"Could not pack test data. (Test data = %@)", data);
    static const unsigned char dataData[] = {0xc4, 0x04, 0xde, 0xad, 0xbe, 0xef};
    XCTAssert(memcmp(dataData, packedData.bytes, packedData.length) == 0,
              @"Packed data is not equal to expected data. (Packed data = %@, Expected data = %@)", packedData, [NSData dataWithBytesNoCopy:dataData length:11 freeWhenDone:NO]);
    
    NSData* data2 = [packedData messagePackParse];
    XCTAssert(data2 != nil, @"Could not parse packed data. (Packed data = %@)", packedData);
    
    XCTAssert([data2 isKindOfClass:[NSData class]], @"Unpacked object is not an data. (Unpacked object = %@)", data2);
    XCTAssert([data isEqualToData:data2], @"Test data is different from unpacked data. (Test data = %@, Unpacked data = %@)", data, data2);
}

- (void)testArray
{
    NSArray* arr = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9];
    
    NSData* packedArr = [arr messagePack];
    XCTAssert(packedArr != nil, @"Could not pack test array. (Test array = %@)", arr);
    static const unsigned char arrData[] = {0x9a, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09};
    XCTAssert(memcmp(arrData, packedArr.bytes, packedArr.length) == 0,
              @"Packed array is not equal to expected data. (Packed data = %@, Expected data = %@)", packedArr, [NSData dataWithBytesNoCopy:arrData length:11 freeWhenDone:NO]);
    
    NSArray* arr2 = [packedArr messagePackParse];
    XCTAssert(arr2 != nil, @"Could not parse packed data. (Packed data = %@)", packedArr);
    
    XCTAssert([arr2 isKindOfClass:[NSArray class]], @"Unpacked object is not an array. (Unpacked object = %@)", arr2);
    XCTAssert([arr isEqualToArray:arr2], @"Test array is different from unpacked array. (Test array = %@, Unpacked array = %@)", arr, arr2);
}

- (void)testDictionary
{
    NSDictionary* dict = @{@"one" : @1, @"two" : @2, @"three" : @3};
    
    NSData* packedDict = [dict messagePack];
    XCTAssert(packedDict != nil, @"Could not pack test dictionary. (Test dictionary = %@)", dict);
    static const unsigned char dictData[] = {0x83, 0xa3, 0x6f, 0x6e, 0x65, 0x01, 0xa3, 0x74, 0x77, 0x6f, 0x02, 0xa5, 0x74, 0x68, 0x72, 0x65, 0x65, 0x03};
    XCTAssert(memcmp(dictData, packedDict.bytes, packedDict.length) == 0,
              @"Packed dictionary is not equal to expected data. (Packed data = %@, Expected data = %@)", packedDict, [NSData dataWithBytesNoCopy:dictData length:11 freeWhenDone:NO]);
    
    NSDictionary* dict2 = [packedDict messagePackParse];
    XCTAssert(dict2 != nil, @"Could not parse packed data. (Packed data = %@)", packedDict);
    
    XCTAssert([dict2 isKindOfClass:[NSDictionary class]], @"Unpacked object is not an dictionary. (Unpacked object = %@)", dict2);
    XCTAssert([dict isEqualToDictionary:dict2], @"Test dictionary is different from unpacked dictionary. (Test dictionary = %@, Unpacked dictionary = %@)", dict, dict2);
}

@end
