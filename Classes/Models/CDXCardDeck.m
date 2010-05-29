//
//
// CDXCardDeck.m
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

#import "CDXCardDeck.h"


@implementation CDXCardDeck

@synthesize cardDefaults;
@synthesize name;
@synthesize description;
@synthesize wantsPageControl;
@synthesize wantsPageJumps;
@synthesize wantsAutoRotate;
@synthesize wantsShakeRandom;
@synthesize displayStyle;
@synthesize cornerStyle;
@synthesize fontSize;

- (id)init {
    qltrace();
    if ((self = [super init])) {
        ivar_assign(cardDefaults, [[CDXCard alloc] init]);
        cardDefaults.textColor = [CDXColor colorWhite];
        cardDefaults.backgroundColor = [CDXColor colorBlack];
        ivar_assign_and_copy(name, @"");
        ivar_assign_and_copy(description, @"");
        ivar_assign(cards, [[NSMutableArray alloc] init]);
        wantsPageControl = NO;
        wantsPageJumps = YES;
        wantsAutoRotate = YES;
        wantsShakeRandom = NO;
        displayStyle = CDXCardDeckDisplayStyleDefault;
        cornerStyle = CDXCardCornerStyleRounded;
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(cardDefaults);
    ivar_release_and_clear(name);
    ivar_release_and_clear(description);
    ivar_release_and_clear(cards);
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    CDXCardDeck *copy = [[[self class] allocWithZone:zone] init];
    copy.cardDefaults = [[cardDefaults copyWithZone:zone] autorelease];
    copy.name = name;
    copy.wantsPageControl = wantsPageControl;
    copy.wantsPageJumps = wantsPageJumps;
    copy.wantsAutoRotate = wantsAutoRotate;
    copy.wantsShakeRandom = wantsShakeRandom;
    copy.displayStyle = displayStyle;
    copy.cornerStyle = cornerStyle;
    for (CDXCard *card in cards) {
        [copy addCard:[[card copyWithZone:zone] autorelease]];
    }
    return copy;
}

- (void)updateDescription {
    NSMutableString *d = [[[NSMutableString alloc] initWithCapacity:100] autorelease];
    BOOL first = YES;
    for (CDXCard *card in cards) {
        if (!first) {
            [d appendString:@", "];
        }
        [d appendString:card.text];
        first = NO;
        if ([d length] >= 60) {
            break;
        }
    }
    ivar_assign_and_copy(description, d);
}

- (NSUInteger)cardsCount {
    return [cards count];
}

- (CDXCard *)cardAtIndex:(NSUInteger)index {
    return (CDXCard *)[cards objectAtIndex:index];
}

- (CDXCard *)cardAtIndex:(NSUInteger)index orCard:(CDXCard *)card {
    if ([cards count] <= index) {
        return card;
    }
    return (CDXCard *)[cards objectAtIndex:index];
}

- (void)addCard:(CDXCard *)card {
    card.cornerStyle = cornerStyle;
    [cards addObject:card];
    [self updateDescription];
}

- (void)insertCard:(CDXCard *)card atIndex:(NSUInteger)index {
    card.cornerStyle = cornerStyle;
    if (index >= [cards count]) {
        [cards addObject:card];
    } else {
        [cards insertObject:card atIndex:index];
    }
    [self updateDescription];
}

- (void)removeCardAtIndex:(NSUInteger)index {
    [cards removeObjectAtIndex:index];
    [self updateDescription];
}

- (void)replaceCardAtIndex:(NSUInteger)index withCard:(CDXCard *)card {
    [card retain];
    [cards removeObjectAtIndex:index];
    [cards insertObject:card atIndex:index];
    [card release];
    [self updateDescription];
}

- (CDXCard *)cardWithDefaults {
    return [[cardDefaults copy] autorelease];
}

- (void)setCornerStyle:(CDXCardCornerStyle)aCornerStyle {
    cornerStyle = aCornerStyle;
    for (CDXCard *card in cards) {
        card.cornerStyle = aCornerStyle;
    }
    cardDefaults.cornerStyle = aCornerStyle;
}

- (void)setFontSize:(CGFloat)aFontSize {
    fontSize = aFontSize;
    for (CDXCard *card in cards) {
        card.fontSize = aFontSize;
    }
    cardDefaults.fontSize = aFontSize;
}

@end

