//
//
// CDXOrderedSerializerDictionary.m
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

#import "CDXOrderedSerializerDictionary.h"


@implementation CDXOrderedSerializerDictionary

- (instancetype)init {
    if ((self = [super init])) {
        ivar_assign(dictionary, [[NSMutableDictionary alloc] init]);
        ivar_assign(orderedKeys, [[NSMutableArray alloc] init]);
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(dictionary);
    ivar_release_and_clear(orderedKeys);
    [super dealloc];
}

- (NSUInteger)count {
    return [dictionary count];
}

- (id)objectForKey:(id)aKey {
    return [dictionary objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator {
    return [orderedKeys objectEnumerator];
}

- (void)removeObjectForKey:(id)aKey {
    [dictionary removeObjectForKey:aKey];
    [orderedKeys removeObject:aKey];
}

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if ([dictionary objectForKey:aKey] == nil) {
        [orderedKeys addObject:aKey];
    }
    [dictionary setObject:anObject forKey:aKey];
}

@end