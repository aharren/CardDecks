//
//
// CDXEnumSerializerUtilsTests.m
//
//
// Copyright (c) 2009-2014 Arne Harren <ah@0xc0.de>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <XCTest/XCTest.h>
#import "CDXEnumSerializerUtils.h"


@interface CDXEnumSerializerUtilsTests : XCTestCase {
    
}

@end


@implementation CDXEnumSerializerUtilsTests

- (void)testValueFromString
{
    NSString *array0[] = { };
    XCTAssertEqual(9, [CDXEnumSerializerUtils array:array0 size:0 valueFromString:@"value4" defaultsTo:9]);
    
    NSString *array1[] = { @"value1" };
    XCTAssertEqual(0, [CDXEnumSerializerUtils array:array1 size:1 valueFromString:@"value1" defaultsTo:9]);
    XCTAssertEqual(9, [CDXEnumSerializerUtils array:array1 size:1 valueFromString:@"value9" defaultsTo:9]);
    
    NSString *array2[] = { @"value1", @"value2" };
    XCTAssertEqual(0, [CDXEnumSerializerUtils array:array2 size:2 valueFromString:@"value1" defaultsTo:9]);
    XCTAssertEqual(1, [CDXEnumSerializerUtils array:array2 size:2 valueFromString:@"value2" defaultsTo:9]);
    XCTAssertEqual(9, [CDXEnumSerializerUtils array:array2 size:2 valueFromString:@"value9" defaultsTo:9]);
    
    NSString *array3[] = { @"value1", @"value2", @"value3" };
    XCTAssertEqual(0, [CDXEnumSerializerUtils array:array3 size:3 valueFromString:@"value1" defaultsTo:9]);
    XCTAssertEqual(1, [CDXEnumSerializerUtils array:array3 size:3 valueFromString:@"value2" defaultsTo:9]);
    XCTAssertEqual(2, [CDXEnumSerializerUtils array:array3 size:3 valueFromString:@"value3" defaultsTo:9]);
    XCTAssertEqual(9, [CDXEnumSerializerUtils array:array3 size:3 valueFromString:@"value9" defaultsTo:9]);
}

- (void)testStringFromValue
{
    NSString *array0[] = { };
    XCTAssertEqualObjects(@"?", [CDXEnumSerializerUtils array:array0 size:0 stringFromValue:0 defaultsTo:@"?"]);
    XCTAssertEqualObjects(@"?", [CDXEnumSerializerUtils array:array0 size:0 stringFromValue:1 defaultsTo:@"?"]);
    XCTAssertEqualObjects(@"?", [CDXEnumSerializerUtils array:array0 size:0 stringFromValue:9 defaultsTo:@"?"]);
    
    NSString *array1[] = { @"value1" };
    XCTAssertEqualObjects(@"value1", [CDXEnumSerializerUtils array:array1 size:1 stringFromValue:0 defaultsTo:@"?"]);
    XCTAssertEqualObjects(@"?", [CDXEnumSerializerUtils array:array1 size:1 stringFromValue:1 defaultsTo:@"?"]);
    XCTAssertEqualObjects(@"?", [CDXEnumSerializerUtils array:array1 size:1 stringFromValue:9 defaultsTo:@"?"]);
    
    NSString *array2[] = { @"value1", @"value2" };
    XCTAssertEqualObjects(@"value1", [CDXEnumSerializerUtils array:array2 size:2 stringFromValue:0 defaultsTo:@"?"]);
    XCTAssertEqualObjects(@"value2", [CDXEnumSerializerUtils array:array2 size:2 stringFromValue:1 defaultsTo:@"?"]);
    XCTAssertEqualObjects(@"?", [CDXEnumSerializerUtils array:array2 size:2 stringFromValue:2 defaultsTo:@"?"]);
    XCTAssertEqualObjects(@"?", [CDXEnumSerializerUtils array:array2 size:2 stringFromValue:9 defaultsTo:@"?"]);
    
    NSString *array3[] = { @"value1", @"value2", @"value3" };
    XCTAssertEqualObjects(@"value1", [CDXEnumSerializerUtils array:array3 size:3 stringFromValue:0 defaultsTo:@"?"]);
    XCTAssertEqualObjects(@"value2", [CDXEnumSerializerUtils array:array3 size:3 stringFromValue:1 defaultsTo:@"?"]);
    XCTAssertEqualObjects(@"value3", [CDXEnumSerializerUtils array:array3 size:3 stringFromValue:2 defaultsTo:@"?"]);
    XCTAssertEqualObjects(@"?", [CDXEnumSerializerUtils array:array3 size:3 stringFromValue:3 defaultsTo:@"?"]);
    XCTAssertEqualObjects(@"?", [CDXEnumSerializerUtils array:array3 size:3 stringFromValue:9 defaultsTo:@"?"]);
}

@end
