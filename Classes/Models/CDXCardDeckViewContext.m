//
//
// CDXCardDeckViewContext.m
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

#import "CDXCardDeckViewContext.h"


@implementation CDXCardDeckViewContext

@synthesize cardDeck;
@synthesize currentCardIndex;

- (id)initWithCardDeck:(CDXCardDeck *)aCardDeck {
    qltrace();
    if ((self = [super init])) {
        ivar_assign_and_retain(cardDeck, aCardDeck);
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(cardDeck);
    [super dealloc];
}

- (NSUInteger)currentCardIndex {
    NSUInteger count = [cardDeck cardsCount];
    if (currentCardIndex >= count) {
        currentCardIndex = (count == 0) ? 0 : count-1;
    }
    return currentCardIndex;
}

@end

