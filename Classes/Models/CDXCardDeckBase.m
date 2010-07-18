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
#import "CDXCardDeck.h"
#import "CDXStorage.h"

#undef ql_component
#define ql_component lcl_cModel


@implementation CDXCardDeckBase

@synthesize base;
@synthesize cardDeck;
@synthesize name;
@synthesize description;
@synthesize file;
@synthesize thumbnailColor;
@synthesize cardsCount;

- (id)init {
    qltrace();
    if ((self = [super init])) {
        base = nil;
        cardDeck = nil;
        ivar_assign_and_copy(name, @"");
        ivar_assign_and_copy(description, @"");
        ivar_assign_and_copy(file, @"");
    }
    return self;
}

- (id)initWithCardDeck:(CDXCardDeck *)aCardDeck {
    qltrace();
    if ((self = [super init])) {
        base = nil;
        cardDeck = aCardDeck;
        ivar_assign_and_copy(name, @"");
        ivar_assign_and_copy(description, @"");
        ivar_assign_and_copy(file, @"");
        
        [cardDeck linkBase:self];
    }
    return self;
}

- (void)dealloc {
    qltrace();
    [cardDeck unlinkBase];
    cardDeck = nil; // unlinkCardDeck
    ivar_release_and_clear(name);
    ivar_release_and_clear(description);
    ivar_release_and_clear(file);
    ivar_release_and_clear(thumbnailColor);
    [super dealloc];
}

- (void)setName:(NSString *)aName {
    if (!aName) {
        aName = @"";
    }
    ivar_assign_and_copy(name, aName);
}

- (void)setDescription:(NSString *)aDescription {
    if (!aDescription) {
        aDescription = @"";
    }
    ivar_assign_and_copy(description, aDescription);
}

- (void)setFile:(NSString *)aFile {
    if (!aFile) {
        aFile = @"";
    }
    ivar_assign_and_copy(file, aFile);
}

- (NSUInteger)cardsCount {
    return cardsCount;
}

- (void)linkBase:(CDXCardDeckBase *)aBase {
    qltrace();
    base = aBase;
}

- (void)unlinkBase {
    qltrace();
    base = nil;
}

- (void)unlinkCardDeck {
    qltrace();
    cardDeck = nil;
}

- (CDXCardDeck *)cardDeck {
    qltrace();
    if (cardDeck == nil) {
        cardDeck = [CDXCardDeck cardDeckFromStorageObjectNamed:file];
        [cardDeck linkBase:self];
    }
    return cardDeck;
}

@end

