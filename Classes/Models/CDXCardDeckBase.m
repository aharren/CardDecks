//
//
// CDXCardDeckBase.m
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

#import "CDXCardDeckBase.h"
#import "CDXCardDeckDictionarySerializer.h"


@implementation CDXCardDeckBase

@synthesize name;
@synthesize description;
@synthesize file;
@synthesize thumbnailColor;
@synthesize cardDeck;

- (id)init {
    qltrace();
    if ((self = [super init])) {
        ivar_assign_and_copy(name, @"");
        ivar_assign_and_copy(description, @"");
        ivar_assign_and_copy(file, @"");
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(name);
    ivar_release_and_clear(description);
    ivar_release_and_clear(file);
    ivar_release_and_clear(thumbnailColor);
    cardDeck = nil;
    [super dealloc];
}

- (NSUInteger)cardsCount {
    return cardsCount;
}

- (CDXCardDeck *)cardDeck {
    return cardDeck;
}

@end

