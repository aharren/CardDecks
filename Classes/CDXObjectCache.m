//
//
// CDXObjectCache.m
//
//
// Copyright (c) 2009-2025 Arne Harren <ah@0xc0.de>
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

#import "CDXObjectCache.h"

#undef ql_component
#define ql_component lcl_cCache


@implementation CDXObjectCache

- (id)initWithSize:(NSUInteger)aSize {
    if ((self = [super init])) {
        size = MIN(CDXObjectCacheObjectsBase + aSize, CDXObjectCacheObjectsSize);
        nextIndex = CDXObjectCacheObjectsBase;
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_array_release_and_clear(objects, CDXObjectCacheObjectsSize);
    [super dealloc];
}

- (id)objectWithKey:(NSUInteger)key {
    for (NSUInteger index = CDXObjectCacheObjectsBase; index < nextIndex; index++) {
        if (keys[index] == CDXObjectCacheKeysBase + key) {
            return [[objects[index] retain] autorelease];
        }
    }
    return nil;
}

- (void)addObject:(id)object withKey:(NSUInteger)key {
    if (object == nil || CDXObjectCacheKeysBase + key == 0) {
        return;
    }
    
    NSUInteger index = nextIndex;
    if (index < size) {
        ivar_assign_and_retain(objects[index], object);
        keys[index] = CDXObjectCacheKeysBase + key;
        nextIndex++;
    }
}

- (NSUInteger)count {
    return nextIndex - CDXObjectCacheObjectsBase;
}

- (void)clear {
    qltrace();
    ivar_array_release_and_clear(objects, size);
    ivar_array_set(keys, size, CDXObjectCacheKeysInvalid);
    nextIndex = CDXObjectCacheObjectsBase;
}

@end


