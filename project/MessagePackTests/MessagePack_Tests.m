//
//  MessagePack_Tests.m
//  MessagePack Tests
//
//  Created by Charles Francoise on 21/07/14.
//  Copyright (c) 2014 Charles Francoise. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <MessagePack/MessagePack.h>

@interface MessagePack_Tests : XCTestCase

@end

@implementation MessagePack_Tests

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
              @"Packed array is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNull, [NSData dataWithBytesNoCopy:nullData length:1 freeWhenDone:NO]);
    
    NSNull* null2 = [packedNull messagePackParse];
    XCTAssert(null2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNull);
    
    XCTAssert([null2 isKindOfClass:[NSNull class]], @"Unpacked object is not nil. (Unpacked object = %@)", null2);
    XCTAssert(null2 == [NSNull null], @"nil is different from unpacked value. (Unpacked value = %@)", null2);
}

- (void)testTrue
{
    // Can only test unpacking, since Cocoa has no class for Booleans
    NSNumber* tru = [NSNumber numberWithBool:YES];
    
    static const unsigned char truData[] = {0xc3};
    NSData* packedTru = [NSData dataWithBytesNoCopy:truData length:1 freeWhenDone:NO];
    
    NSNumber* tru2 = [packedTru messagePackParse];
    XCTAssert(tru2 != nil, @"Could not parse packed data. (Packed data = %@)", packedTru);
    
    XCTAssert([tru2 isKindOfClass:[NSNumber class]], @"Unpacked object is not YES. (Unpacked object = %@)", tru2);
    XCTAssert([tru isEqualToNumber:tru2], @"YES is different from unpacked value. (YES = %@, Unpacked value = %@)", tru, tru2);
}

- (void)testFalse
{
    // Can only test unpacking, since Cocoa has no class for Booleans
    NSNumber* fals = [NSNumber numberWithBool:NO];
    
    static const unsigned char falsData[] = {0xc2};
    NSData* packedFals = [NSData dataWithBytesNoCopy:falsData length:1 freeWhenDone:NO];
    
    NSNumber* fals2 = [packedFals messagePackParse];
    XCTAssert(fals2 != nil, @"Could not parse packed data. (Packed data = %@)", packedFals);
    
    XCTAssert([fals2 isKindOfClass:[NSNumber class]], @"Unpacked object is not NO. (Unpacked object = %@)", fals2);
    XCTAssert([fals isEqualToNumber:fals2], @"NO is different from unpacked value. (NO = %@, Unpacked value = %@)", fals, fals2);
}

- (void)testPositiveFixint
{
    NSNumber* num = [NSNumber numberWithUnsignedChar:42];
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0x2a};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:1 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not a number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testNegativeFixint
{
    NSNumber* num = [NSNumber numberWithChar:-18];
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0xee};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:1 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not a number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testUint8
{
    NSNumber* num = [NSNumber numberWithUnsignedChar:0xd8];
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0xcc, 0xd8};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:2 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not a number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testInt8
{
    NSNumber* num = [NSNumber numberWithChar:0xd8];
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0xd0, 0xd8};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:2 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not a number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testUint16
{
    NSNumber* num = [NSNumber numberWithUnsignedShort:0xbeef];
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0xcd, 0xbe, 0xef};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:3 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not a number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testInt16
{
    NSNumber* num = [NSNumber numberWithShort:0xdead];
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0xd1, 0xde, 0xad};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:3 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not a number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testUint32
{
    NSNumber* num = [NSNumber numberWithUnsignedInt:0xbeefdead];
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0xce, 0xbe, 0xef, 0xde, 0xad};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:5 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not a number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testInt32
{
    NSNumber* num = [NSNumber numberWithInt:0xdeadbeef];
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0xd2, 0xde, 0xad, 0xbe, 0xef};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:5 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not a number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testUint64
{
    NSNumber* num = [NSNumber numberWithUnsignedLong:0x00efdeadbeefdead];
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0xcf, 0x00, 0xef, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:9 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not a number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testInt64
{
    NSNumber* num = [NSNumber numberWithLong:0xdeadbeefdeadbeef];
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0xd3, 0xde, 0xad, 0xbe, 0xef, 0xde, 0xad, 0xbe, 0xef};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:9 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not a number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testFloat
{
    NSNumber* num = [NSNumber numberWithFloat:(99.99f)];
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0xca, 0x42, 0xc7, 0xfa, 0xe1};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:5 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not a number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testDouble
{
    NSNumber* num = [NSNumber numberWithDouble:M_PI];
    
    NSData* packedNum = [num messagePack];
    XCTAssert(packedNum != nil, @"Could not pack test number. (Test number = %@)", num);
    static const unsigned char numData[] = {0xcb, 0x40, 0x09, 0x21, 0xfb, 0x54, 0x44, 0x2d, 0x18};
    XCTAssert(memcmp(numData, packedNum.bytes, packedNum.length) == 0,
              @"Packed number is not equal to expected data. (Packed data = %@, Expected data = %@)", packedNum, [NSData dataWithBytesNoCopy:numData length:9 freeWhenDone:NO]);
    
    NSNumber* num2 = [packedNum messagePackParse];
    XCTAssert(num2 != nil, @"Could not parse packed data. (Packed data = %@)", packedNum);
    
    XCTAssert([num2 isKindOfClass:[NSNumber class]], @"Unpacked object is not a number. (Unpacked object = %@)", num2);
    XCTAssert([num isEqualToNumber:num2], @"Test number is different from unpacked number. (Test number = %@, Unpacked number = %@)", num, num2);
}

- (void)testBin8
{
    static const unsigned char testData[] = {0xde, 0xad, 0xbe, 0xef};
    
    NSData* data = [NSData dataWithBytesNoCopy:testData length:4 freeWhenDone:NO];
    
    NSData* packedData = [data messagePack];
    XCTAssert(packedData != nil, @"Could not pack test data. (Test data = %@)", data);
    static const unsigned char dataData[] = {0xc4, 0x04, 0xde, 0xad, 0xbe, 0xef};
    XCTAssert(memcmp(dataData, packedData.bytes, packedData.length) == 0,
              @"Packed data is not equal to expected data. (Packed data = %@, Expected data = %@)", packedData, [NSData dataWithBytesNoCopy:dataData length:6 freeWhenDone:NO]);
    
    NSData* data2 = [packedData messagePackParse];
    XCTAssert(data2 != nil, @"Could not parse packed data. (Packed data = %@)", packedData);
    
    XCTAssert([data2 isKindOfClass:[NSData class]], @"Unpacked object is not an data. (Unpacked object = %@)", data2);
    XCTAssert([data isEqualToData:data2], @"Test data is different from unpacked data. (Test data = %@, Unpacked data = %@)", data, data2);
}

- (void)testBin16
{
    static const unsigned char testDataSample[] = {0xde, 0xad, 0xbe, 0xef};
    static unsigned char testData[500];
    
    for (int i = 0; i < 500;  i += 4)
    {
        memcpy(&testData[i], testDataSample, 4);
    }
    
    NSData* data = [NSData dataWithBytesNoCopy:testData length:500 freeWhenDone:NO];
    
    NSData* packedData = [data messagePack];
    XCTAssert(packedData != nil, @"Could not pack test data. (Test data = %@)", data);
    static unsigned char dataData[503] = {0xc5, 0x01, 0xf4};
    for (int i = 0; i < 500;  i += 4)
    {
        memcpy(&dataData[i+3], testDataSample, 4);
    }
    
    XCTAssert(memcmp(dataData, packedData.bytes, packedData.length) == 0,
              @"Packed data is not equal to expected data. (Packed data = %@, Expected data = %@)", packedData, [NSData dataWithBytesNoCopy:dataData length:503 freeWhenDone:NO]);
    
    NSData* data2 = [packedData messagePackParse];
    XCTAssert(data2 != nil, @"Could not parse packed data. (Packed data = %@)", packedData);
    
    XCTAssert([data2 isKindOfClass:[NSData class]], @"Unpacked object is not an data. (Unpacked object = %@)", data2);
    XCTAssert([data isEqualToData:data2], @"Test data is different from unpacked data. (Test data = %@, Unpacked data = %@)", data, data2);
}

- (void)testBin32
{
    static const unsigned char testDataSample[] = {0xde, 0xad, 0xbe, 0xef};
    static unsigned char testData[100000];
    
    for (int i = 0; i < 100000;  i += 4)
    {
        memcpy(&testData[i], testDataSample, 4);
    }
    
    NSData* data = [NSData dataWithBytesNoCopy:testData length:100000 freeWhenDone:NO];
    
    NSData* packedData = [data messagePack];
    XCTAssert(packedData != nil, @"Could not pack test data. (Test data = %@)", data);
    static unsigned char dataData[100005] = {0xc6, 0x00, 0x01, 0x86, 0xa0};
    for (int i = 0; i < 100000;  i += 4)
    {
        memcpy(&dataData[i+5], testDataSample, 4);
    }

    XCTAssert(memcmp(dataData, packedData.bytes, packedData.length) == 0,
              @"Packed data is not equal to expected data. (Packed data = %@, Expected data = %@)", packedData, [NSData dataWithBytesNoCopy:dataData length:100005 freeWhenDone:NO]);
    
    NSData* data2 = [packedData messagePackParse];
    XCTAssert(data2 != nil, @"Could not parse packed data. (Packed data = %@)", packedData);
    
    XCTAssert([data2 isKindOfClass:[NSData class]], @"Unpacked object is not an data. (Unpacked object = %@)", data2);
    XCTAssert([data isEqualToData:data2], @"Test data is different from unpacked data. (Test data = %@, Unpacked data = %@)", data, data2);
}

#define testStr "Hello World!"

- (void)testFixStr
{
    NSString* str = @testStr;
    
    NSData* packedStr = [str messagePack];
    XCTAssert(packedStr != nil, @"Could not pack test string. (Test string = %@)", str);
    static const unsigned char strData[] = {0xac, 0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x20, 0x57, 0x6f, 0x72, 0x6c, 0x64, 0x21};
    XCTAssert(memcmp(strData, packedStr.bytes, packedStr.length) == 0,
              @"Packed string is not equal to expected data. (Packed data = %@, Expected data = %@)", packedStr, [NSData dataWithBytesNoCopy:strData length:13 freeWhenDone:NO]);
    
    NSString* str2 = [packedStr messagePackParse];
    XCTAssert(str2 != nil, @"Could not parse packed data. (Packed data = %@)", packedStr);
    
    XCTAssert([str2 isKindOfClass:[NSString class]], @"Unpacked object is not an string. (Unpacked object = %@)", str2);
    XCTAssert([str isEqualToString:str2], @"Test string is different from unpacked string. (Test string = %@, Unpacked string = %@)", str, str2);
}

- (void)testStr8
{
    static const unsigned long len = strlen(testStr) * (128 / strlen(testStr));
    NSMutableString* str = [NSMutableString stringWithCapacity:len];
    for (int i = 0; i < len; i += strlen(testStr))
    {
        [str appendString:@testStr];
    }
    
    NSData* packedStr = [str messagePack];
    XCTAssert(packedStr != nil, @"Could not pack test string. (Test string = %@)", str);
    static unsigned char strData[len + 2] = {0xd9, (unsigned char)strlen(testStr)};
    for (int i = 0; i < len; i += strlen(testStr))
    {
        memcpy(&strData[i+2], testStr, strlen(testStr));
    }
    
    XCTAssert(memcmp(strData, packedStr.bytes, packedStr.length) == 0,
              @"Packed string is not equal to expected data. (Packed data = %@, Expected data = %@)", packedStr, [NSData dataWithBytesNoCopy:strData length:len+2 freeWhenDone:NO]);
    
    NSString* str2 = [packedStr messagePackParse];
    XCTAssert(str2 != nil, @"Could not parse packed data. (Packed data = %@)", packedStr);
    
    XCTAssert([str2 isKindOfClass:[NSString class]], @"Unpacked object is not an string. (Unpacked object = %@)", str2);
    XCTAssert([str isEqualToString:str2], @"Test string is different from unpacked string. (Test string = %@, Unpacked string = %@)", str, str2);
}

- (void)testStr16
{
    static const unsigned int len = strlen(testStr) * (1024 / strlen(testStr));
    NSMutableString* str = [NSMutableString stringWithCapacity:len];
    for (int i = 0; i < len; i += strlen(testStr))
    {
        [str appendString:@testStr];
    }
    
    NSData* packedStr = [str messagePack];
    XCTAssert(packedStr != nil, @"Could not pack test string. (Test string = %@)", str);
    static unsigned char strData[len + 3] = {0xda, (unsigned char)((len>>8) & 0xff), (unsigned char)(len & 0xff)};
    for (int i = 0; i < len; i += strlen(testStr))
    {
        memcpy(&strData[i+3], testStr, strlen(testStr));
    }
    
    XCTAssert(memcmp(strData, packedStr.bytes, packedStr.length) == 0,
              @"Packed string is not equal to expected data. (Packed data = %@, Expected data = %@)", packedStr, [NSData dataWithBytesNoCopy:strData length:len+3 freeWhenDone:NO]);
    
    NSString* str2 = [packedStr messagePackParse];
    XCTAssert(str2 != nil, @"Could not parse packed data. (Packed data = %@)", packedStr);
    
    XCTAssert([str2 isKindOfClass:[NSString class]], @"Unpacked object is not an string. (Unpacked object = %@)", str2);
    XCTAssert([str isEqualToString:str2], @"Test string is different from unpacked string. (Test string = %@, Unpacked string = %@)", str, str2);
}

- (void)testStr32
{
    static const unsigned int len = strlen(testStr) * (100000 / strlen(testStr));
    NSMutableString* str = [NSMutableString stringWithCapacity:len];
    for (int i = 0; i < len; i += strlen(testStr))
    {
        [str appendString:@testStr];
    }
    
    NSData* packedStr = [str messagePack];
    XCTAssert(packedStr != nil, @"Could not pack test string. (Test string = %@)", str);
    static unsigned char strData[len + 5] = {0xdb, (unsigned char)((len>>24) & 0xff), (unsigned char)((len>>16) & 0xff), (unsigned char)((len>>8) & 0xff), (unsigned char)(len & 0xff)};
    for (int i = 0; i < len; i += strlen(testStr))
    {
        memcpy(&strData[i+5], testStr, strlen(testStr));
    }
    
    XCTAssert(memcmp(strData, packedStr.bytes, packedStr.length) == 0,
              @"Packed string is not equal to expected data. (Packed data = %@, Expected data = %@)", packedStr, [NSData dataWithBytesNoCopy:strData length:len+5 freeWhenDone:NO]);
    
    NSString* str2 = [packedStr messagePackParse];
    XCTAssert(str2 != nil, @"Could not parse packed data. (Packed data = %@)", packedStr);
    
    XCTAssert([str2 isKindOfClass:[NSString class]], @"Unpacked object is not an string. (Unpacked object = %@)", str2);
    XCTAssert([str isEqualToString:str2], @"Test string is different from unpacked string. (Test string = %@, Unpacked string = %@)", str, str2);
}

#define testArr @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9]

- (void)testFixArray
{
    NSArray* arr = testArr;
    
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


- (void)testArray16
{
    static const unsigned long len = 10 * (1024 / 10);
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:len];
    for (int i = 0; i < len; i += 10)
    {
        [arr addObjectsFromArray:testArr];
    }
    
    NSData* packedArr = [arr messagePack];
    XCTAssert(packedArr != nil, @"Could not pack test array. (Test array = %@)", arr);
    static unsigned char arrData[len+3] = {0xdc, (unsigned char)((len>>8) & 0xff), (unsigned char)(len & 0xff), 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09};
    for (int i = 0; i < len; i += 10)
    {
        memcpy(&arrData[i+3], &arrData[3], 10);
    }
    XCTAssert(memcmp(arrData, packedArr.bytes, packedArr.length) == 0,
              @"Packed array is not equal to expected data. (Packed data = %@, Expected data = %@)", packedArr, [NSData dataWithBytesNoCopy:arrData length:len+3 freeWhenDone:NO]);
    
    NSArray* arr2 = [packedArr messagePackParse];
    XCTAssert(arr2 != nil, @"Could not parse packed data. (Packed data = %@)", packedArr);
    
    XCTAssert([arr2 isKindOfClass:[NSArray class]], @"Unpacked object is not an array. (Unpacked object = %@)", arr2);
    XCTAssert([arr isEqualToArray:arr2], @"Test array is different from unpacked array. (Test array = %@, Unpacked array = %@)", arr, arr2);
}

- (void)testArray32
{
    static const unsigned long len = 10 * (100000 / 10);
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:len];
    for (int i = 0; i < len; i += 10)
    {
        [arr addObjectsFromArray:testArr];
    }
    
    NSData* packedArr = [arr messagePack];
    XCTAssert(packedArr != nil, @"Could not pack test array. (Test array = %@)", arr);
    static unsigned char arrData[len+3] = {0xdd, (unsigned char)((len>>24) & 0xff), (unsigned char)((len>>16) & 0xff), (unsigned char)((len>>8) & 0xff), (unsigned char)(len & 0xff), 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09};
    for (int i = 0; i < len; i += 10)
    {
        memcpy(&arrData[i+5], &arrData[5], 10);
    }
    XCTAssert(memcmp(arrData, packedArr.bytes, packedArr.length) == 0,
              @"Packed array is not equal to expected data. (Packed data = %@, Expected data = %@)", packedArr, [NSData dataWithBytesNoCopy:arrData length:len+5 freeWhenDone:NO]);
    
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
