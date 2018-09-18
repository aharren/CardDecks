//
//
// CDXObjectCacheTest.m
//
//
// Copyright (c) 2009-2018 Arne Harren <ah@0xc0.de>
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
#import "CDXObjectCache.h"


@interface CDXObjectCacheTest : XCTestCase {
    
}

@end


@implementation CDXObjectCacheTest

- (void)testAddObjectAndCountSize3 {
    CDXObjectCache *cache = [[[CDXObjectCache alloc] initWithSize:3] autorelease];
    
    NSObject *object1 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object1 withKey:1];
    XCTAssertEqual((NSUInteger)1, [cache count]);
    
    NSObject *object2 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object2 withKey:2];
    XCTAssertEqual((NSUInteger)2, [cache count]);
    
    NSObject *object3 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object3 withKey:3];
    XCTAssertEqual((NSUInteger)3, [cache count]);
    
    NSObject *object4 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object4 withKey:4];
    XCTAssertEqual((NSUInteger)3, [cache count]);
    
    XCTAssertNil([cache objectWithKey:4]);
    XCTAssertEqual(object3, [cache objectWithKey:3]);
    XCTAssertEqual(object2, [cache objectWithKey:2]);
    XCTAssertEqual(object1, [cache objectWithKey:1]);
}

- (void)testAddObjectSize7 {
    CDXObjectCache *cache = [[[CDXObjectCache alloc] initWithSize:7] autorelease];
    
    NSObject *object1 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object1 withKey:1];
    XCTAssertEqual((NSUInteger)1, [cache count]);
    
    NSObject *object2 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object2 withKey:2];
    XCTAssertEqual((NSUInteger)2, [cache count]);
    
    NSObject *object3 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object3 withKey:3];
    XCTAssertEqual((NSUInteger)3, [cache count]);
    
    NSObject *object4 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object4 withKey:4];
    XCTAssertEqual((NSUInteger)4, [cache count]);
    
    NSObject *object5 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object5 withKey:5];
    XCTAssertEqual((NSUInteger)5, [cache count]);
    
    NSObject *object6 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object6 withKey:6];
    XCTAssertEqual((NSUInteger)5, [cache count]);
    
    XCTAssertNil([cache objectWithKey:6]);
    XCTAssertEqual(object5, [cache objectWithKey:5]);
    XCTAssertEqual(object4, [cache objectWithKey:4]);
    XCTAssertEqual(object3, [cache objectWithKey:3]);
    XCTAssertEqual(object2, [cache objectWithKey:2]);
    XCTAssertEqual(object1, [cache objectWithKey:1]);
}

- (void)testAddObjectBad {
    CDXObjectCache *cache = [[[CDXObjectCache alloc] initWithSize:3] autorelease];
    
    [cache addObject:nil withKey:1];
    XCTAssertEqual((NSUInteger)0, [cache count]);
    
    NSObject *object0 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object0 withKey:-1];
    XCTAssertEqual((NSUInteger)0, [cache count]);
}    

- (void)testDeallocObjects {
    CDXObjectCache *cache = [[CDXObjectCache alloc] initWithSize:3];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSObject *object1 = [[NSObject alloc] init];
    [cache addObject:object1 withKey:1];
    XCTAssertEqual((NSUInteger)1, [cache count]);
    XCTAssertEqual((NSUInteger)2, [object1 retainCount]);
    
    [pool release];
    
    XCTAssertEqual((NSUInteger)2, [object1 retainCount]);
    
    [cache release];
    
    XCTAssertEqual((NSUInteger)1, [object1 retainCount]);
    
    [object1 release];
}

- (void)testClear {
    CDXObjectCache *cache = [[[CDXObjectCache alloc] initWithSize:3] autorelease];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSObject *object1 = [[NSObject alloc] init];
    [cache addObject:object1 withKey:1];
    XCTAssertEqual((NSUInteger)1, [cache count]);
    XCTAssertEqual((NSUInteger)2, [object1 retainCount]);
    
    XCTAssertNotNil([cache objectWithKey:1]);
    XCTAssertEqual((NSUInteger)3, [object1 retainCount]);
    
    [pool release];
    
    XCTAssertEqual((NSUInteger)2, [object1 retainCount]);
    
    [cache clear];
    
    XCTAssertEqual((NSUInteger)1, [object1 retainCount]);
    XCTAssertNil([cache objectWithKey:1]);
    
    [object1 release];
}

@end


