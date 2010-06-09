//
//
// CDXCardDecks.m
//
//
// Copyright (c) 2009-2010 Arne Harren <ah@0xc0.de>
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

#import "CDXCardDecks.h"


@implementation CDXCardDecks

@synthesize cardDeckDefaults;

- (id)init {
    if ((self = [super init])) {
        ivar_assign(cardDeckDefaults, [[CDXCardDeck alloc] init]);
        ivar_assign(cardDecks, [[NSMutableArray alloc] init]);
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(cardDecks);
    [super dealloc];
}

- (NSUInteger)cardDecksCount {
    return [cardDecks count];
}

- (CDXCardDeckBase *)cardDeckAtIndex:(NSUInteger)index {
    return (CDXCardDeckBase *)[cardDecks objectAtIndex:index];
}

- (void)addCardDeck:(CDXCardDeckBase *)cardDeck {
    [cardDecks addObject:cardDeck];
}

- (void)insertCardDeck:(CDXCardDeckBase *)cardDeck atIndex:(NSUInteger)index {
    if (index >= [cardDecks count]) {
        [cardDecks addObject:cardDeck];
    } else {
        [cardDecks insertObject:cardDeck atIndex:index];
    }
}

- (void)removeCardDeckAtIndex:(NSUInteger)index {
    [cardDecks removeObjectAtIndex:index];
}

- (CDXCardDeck *)cardDeckWithDefaults {
    return [[cardDeckDefaults.cardDeck copy] autorelease];
}

@end

