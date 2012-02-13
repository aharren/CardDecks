//
//
// CDXObjectCacheTest.m
//
//
// Copyright (c) 2009-2012 Arne Harren <ah@0xc0.de>
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

#import <SenTestingKit/SenTestingKit.h>
#import "CDXObjectCache.h"


@interface CDXObjectCacheTest : SenTestCase {
    
}

@end


@implementation CDXObjectCacheTest

- (void)testAddObjectAndCountSize3 {
    CDXObjectCache *cache = [[[CDXObjectCache alloc] initWithSize:3] autorelease];
    
    NSObject *object1 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object1 withKey:1];
    STAssertEquals((NSUInteger)1, [cache count], nil);
    
    NSObject *object2 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object2 withKey:2];
    STAssertEquals((NSUInteger)2, [cache count], nil);
    
    NSObject *object3 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object3 withKey:3];
    STAssertEquals((NSUInteger)3, [cache count], nil);
    
    NSObject *object4 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object4 withKey:4];
    STAssertEquals((NSUInteger)3, [cache count], nil);
    
    STAssertNil(nil, [cache objectWithKey:4], nil);
    STAssertEquals(object3, [cache objectWithKey:3], nil);
    STAssertEquals(object2, [cache objectWithKey:2], nil);
    STAssertEquals(object1, [cache objectWithKey:1], nil);
}

- (void)testAddObjectSize7 {
    CDXObjectCache *cache = [[[CDXObjectCache alloc] initWithSize:7] autorelease];
    
    NSObject *object1 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object1 withKey:1];
    STAssertEquals((NSUInteger)1, [cache count], nil);
    
    NSObject *object2 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object2 withKey:2];
    STAssertEquals((NSUInteger)2, [cache count], nil);
    
    NSObject *object3 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object3 withKey:3];
    STAssertEquals((NSUInteger)3, [cache count], nil);
    
    NSObject *object4 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object4 withKey:4];
    STAssertEquals((NSUInteger)4, [cache count], nil);
    
    NSObject *object5 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object5 withKey:5];
    STAssertEquals((NSUInteger)5, [cache count], nil);
    
    NSObject *object6 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object6 withKey:6];
    STAssertEquals((NSUInteger)5, [cache count], nil);
    
    STAssertNil(nil, [cache objectWithKey:6], nil);
    STAssertEquals(object5, [cache objectWithKey:5], nil);
    STAssertEquals(object4, [cache objectWithKey:4], nil);
    STAssertEquals(object3, [cache objectWithKey:3], nil);
    STAssertEquals(object2, [cache objectWithKey:2], nil);
    STAssertEquals(object1, [cache objectWithKey:1], nil);
}

- (void)testAddObjectBad {
    CDXObjectCache *cache = [[[CDXObjectCache alloc] initWithSize:3] autorelease];
    
    [cache addObject:nil withKey:1];
    STAssertEquals((NSUInteger)0, [cache count], nil);
    
    NSObject *object0 = [[[NSObject alloc] init] autorelease];
    [cache addObject:object0 withKey:-1];
    STAssertEquals((NSUInteger)0, [cache count], nil);
}    

- (void)testDeallocObjects {
    CDXObjectCache *cache = [[CDXObjectCache alloc] initWithSize:3];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSObject *object1 = [[NSObject alloc] init];
    [cache addObject:object1 withKey:1];
    STAssertEquals((NSUInteger)1, [cache count], nil);
    STAssertEquals((NSUInteger)2, [object1 retainCount], nil);
    
    [pool release];
    
    STAssertEquals((NSUInteger)2, [object1 retainCount], nil);
    
    [cache release];
    
    STAssertEquals((NSUInteger)1, [object1 retainCount], nil);
    
    [object1 release];
}

- (void)testClear {
    CDXObjectCache *cache = [[[CDXObjectCache alloc] initWithSize:3] autorelease];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSObject *object1 = [[NSObject alloc] init];
    [cache addObject:object1 withKey:1];
    STAssertEquals((NSUInteger)1, [cache count], nil);
    STAssertEquals((NSUInteger)2, [object1 retainCount], nil);
    
    STAssertNotNil([cache objectWithKey:1], nil);
    STAssertEquals((NSUInteger)3, [object1 retainCount], nil);
    
    [pool release];
    
    STAssertEquals((NSUInteger)2, [object1 retainCount], nil);
    
    [cache clear];
    
    STAssertEquals((NSUInteger)1, [object1 retainCount], nil);
    STAssertNil([cache objectWithKey:1], nil);
    
    [object1 release];
}

@end


