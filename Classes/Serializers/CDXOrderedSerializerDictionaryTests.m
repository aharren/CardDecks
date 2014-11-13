//
//
// CDXOrderedSerializerDictionaryTests.m
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
#import "CDXOrderedSerializerDictionary.h"


@interface CDXOrderedSerializerDictionaryTests : XCTestCase {
    
}

@end


@implementation CDXOrderedSerializerDictionaryTests

#define XCTExtAssertEqualObjectsArray(expected, actual) {                      \
    XCTAssertEqual((expected).count, (actual).count);                          \
    NSUInteger max = (expected).count;                                         \
    for (NSUInteger i = 0; i < max; ++i) {                                     \
        XCTAssertEqualObjects((expected)[i], (actual)[i]);                     \
    }                                                                          \
}

- (void)testCount {
    NSMutableDictionary *dict = [[[CDXOrderedSerializerDictionary alloc] init] autorelease];
    XCTAssertEqual(0, dict.count);
    
    [dict setObject:@"value1" forKey:@"key1"];
    XCTAssertEqual(1, dict.count);
    XCTExtAssertEqualObjectsArray((@[@"key1"]), [[dict keyEnumerator] allObjects]);

    [dict setObject:@"value2a" forKey:@"key2"];
    XCTAssertEqual(2, dict.count);
    XCTExtAssertEqualObjectsArray((@[@"key1", @"key2"]), [[dict keyEnumerator] allObjects]);
    
    [dict setObject:@"value2b" forKey:@"key2"];
    XCTAssertEqual(2, dict.count);
    XCTExtAssertEqualObjectsArray((@[@"key1", @"key2"]), [[dict keyEnumerator] allObjects]);
    
    [dict removeObjectForKey:@"key1"];
    XCTAssertEqual(1, dict.count);
    XCTExtAssertEqualObjectsArray((@[@"key2"]), [[dict keyEnumerator] allObjects]);
    
    [dict removeObjectForKey:@"key2"];
    XCTAssertEqual(0, dict.count);
    XCTExtAssertEqualObjectsArray((@[]), [[dict keyEnumerator] allObjects]);
}

- (void)testObjectForKey {
    NSMutableDictionary *dict = [[[CDXOrderedSerializerDictionary alloc] init] autorelease];
    
    [dict setObject:@"value1" forKey:@"key1"];
    [dict setObject:@"value2" forKey:@"key2"];
    XCTExtAssertEqualObjectsArray((@[@"key1", @"key2"]), [[dict keyEnumerator] allObjects]);
    XCTAssertEqualObjects(@"value1", [dict objectForKey:@"key1"]);
    XCTAssertEqualObjects(@"value2", [dict objectForKey:@"key2"]);
    XCTAssertNil([dict objectForKey:@"key3-not-exists"]);
}

- (void)testKeyEnumerator {
    NSMutableDictionary *dict = [[[CDXOrderedSerializerDictionary alloc] init] autorelease];
    
    [dict setObject:@"value1" forKey:@"key1"];
    [dict setObject:@"value2" forKey:@"key2"];
    XCTExtAssertEqualObjectsArray((@[@"key1", @"key2"]), [[dict keyEnumerator] allObjects]);

    [dict setObject:@"value3" forKey:@"key3"];
    [dict setObject:@"value4" forKey:@"key4"];
    XCTExtAssertEqualObjectsArray((@[@"key1", @"key2", @"key3", @"key4"]), [[dict keyEnumerator] allObjects]);

    [dict removeObjectForKey:@"key2"];
    [dict setObject:@"value2" forKey:@"key2"];
    [dict setObject:@"value5" forKey:@"key5"];
    XCTExtAssertEqualObjectsArray((@[@"key1", @"key3", @"key4", @"key2", @"key5"]), [[dict keyEnumerator] allObjects]);
}

- (void)testRemoveObjectForKey {
    NSMutableDictionary *dict = [[[CDXOrderedSerializerDictionary alloc] init] autorelease];
    
    [dict setObject:@"value1" forKey:@"key1"];
    [dict setObject:@"value2" forKey:@"key2"];
    XCTAssertEqual(2, dict.count);
    XCTAssertEqualObjects(@"value1", [dict objectForKey:@"key1"]);
    XCTAssertEqualObjects(@"value2", [dict objectForKey:@"key2"]);
    XCTExtAssertEqualObjectsArray((@[@"key1", @"key2"]), [[dict keyEnumerator] allObjects]);
    
    [dict removeObjectForKey:@"key1"];
    XCTAssertEqual(1, dict.count);
    XCTAssertNil([dict objectForKey:@"key1"]);
    XCTAssertEqualObjects(@"value2", [dict objectForKey:@"key2"]);
    XCTExtAssertEqualObjectsArray((@[@"key2"]), [[dict keyEnumerator] allObjects]);
    
    [dict removeObjectForKey:@"key1"];
    XCTAssertEqual(1, dict.count);
    XCTAssertNil([dict objectForKey:@"key1"]);
    XCTAssertEqualObjects(@"value2", [dict objectForKey:@"key2"]);
    XCTExtAssertEqualObjectsArray((@[@"key2"]), [[dict keyEnumerator] allObjects]);
    
    [dict setObject:@"value1" forKey:@"key1"];
    XCTAssertEqual(2, dict.count);
    XCTAssertEqualObjects(@"value1", [dict objectForKey:@"key1"]);
    XCTAssertEqualObjects(@"value2", [dict objectForKey:@"key2"]);
    XCTExtAssertEqualObjectsArray((@[@"key2", @"key1"]), [[dict keyEnumerator] allObjects]);
}

- (void)testSetObjectForKey {
    NSMutableDictionary *dict = [[[CDXOrderedSerializerDictionary alloc] init] autorelease];
    
    [dict setObject:@"value1" forKey:@"key1"];
    [dict setObject:@"value2" forKey:@"key2"];
    XCTAssertEqual(2, dict.count);
    XCTAssertEqualObjects(@"value1", [dict objectForKey:@"key1"]);
    XCTAssertEqualObjects(@"value2", [dict objectForKey:@"key2"]);
    XCTExtAssertEqualObjectsArray((@[@"key1", @"key2"]), [[dict keyEnumerator] allObjects]);
    
    [dict setObject:@"value1" forKey:@"key1"];
    XCTAssertEqual(2, dict.count);
    XCTAssertEqualObjects(@"value1", [dict objectForKey:@"key1"]);
    XCTAssertEqualObjects(@"value2", [dict objectForKey:@"key2"]);
    XCTExtAssertEqualObjectsArray((@[@"key1", @"key2"]), [[dict keyEnumerator] allObjects]);
    
    [dict setObject:@"value2" forKey:@"key2"];
    XCTAssertEqual(2, dict.count);
    XCTAssertEqualObjects(@"value1", [dict objectForKey:@"key1"]);
    XCTAssertEqualObjects(@"value2", [dict objectForKey:@"key2"]);
    XCTExtAssertEqualObjectsArray((@[@"key1", @"key2"]), [[dict keyEnumerator] allObjects]);
    
    [dict setObject:@"value3" forKey:@"key3"];
    XCTAssertEqual(3, dict.count);
    XCTAssertEqualObjects(@"value1", [dict objectForKey:@"key1"]);
    XCTAssertEqualObjects(@"value2", [dict objectForKey:@"key2"]);
    XCTAssertEqualObjects(@"value3", [dict objectForKey:@"key3"]);
    XCTExtAssertEqualObjectsArray((@[@"key1", @"key2", @"key3"]), [[dict keyEnumerator] allObjects]);
    
    [dict setObject:@"value3" forKey:@"key3"];
    XCTAssertEqual(3, dict.count);
    XCTAssertEqualObjects(@"value1", [dict objectForKey:@"key1"]);
    XCTAssertEqualObjects(@"value2", [dict objectForKey:@"key2"]);
    XCTAssertEqualObjects(@"value3", [dict objectForKey:@"key3"]);
    XCTExtAssertEqualObjectsArray((@[@"key1", @"key2", @"key3"]), [[dict keyEnumerator] allObjects]);
}

@end

