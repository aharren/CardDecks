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

@synthesize name;
@synthesize defaultCardTextColor;
@synthesize defaultCardBackgroundColor;
@synthesize defaultCardOrientation;
@synthesize displayStyle;
@synthesize showPageControl;
@synthesize autoRotate;
@synthesize cornerStyle;
@synthesize fontSize;

- (id)init {
    if ((self = [super init])) {
        ivar_assign_and_copy(name, @"");
        ivar_assign_and_retain(defaultCardTextColor, [CDXColor colorWhite]);
        ivar_assign_and_retain(defaultCardBackgroundColor, [CDXColor colorBlack]);
        ivar_assign(cards, [[NSMutableArray alloc] init]);
        displayStyle = CDXCardDeckDisplayStyleDefault;
        showPageControl = NO;
        autoRotate = YES;
        cornerStyle = CDXCardCornerStyleRounded;
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(name);
    ivar_release_and_clear(defaultCardTextColor);
    ivar_release_and_clear(defaultCardBackgroundColor);
    ivar_release_and_clear(cards);
    [super dealloc];
}

- (NSUInteger)cardsCount {
    return [cards count];
}

- (CDXCard *)cardAtIndex:(NSUInteger)index {
    return (CDXCard *)[cards objectAtIndex:index];
}

- (void)addCard:(CDXCard *)card {
    card.cornerStyle = cornerStyle;
    [cards addObject:card];
}

- (void)insertCard:(CDXCard *)card atIndex:(NSUInteger)index {
    card.cornerStyle = cornerStyle;
    if (index >= [cards count]) {
        [cards addObject:card];
    } else {
        [cards insertObject:card atIndex:index];
    }
}

- (void)removeCardAtIndex:(NSUInteger)index {
    [cards removeObjectAtIndex:index];
}

- (CDXCard *)cardWithDefaults {
    CDXCard *card = [[[CDXCard alloc] init] autorelease];
    if (card) {
        card.textColor = defaultCardTextColor;
        card.backgroundColor = defaultCardBackgroundColor;
        card.orientation = defaultCardOrientation;
        card.cornerStyle = cornerStyle;
    }
    return card;
}

- (void)setCornerStyle:(CDXCardCornerStyle)aCornerStyle {
    cornerStyle = aCornerStyle;
    for (CDXCard *card in cards) {
        card.cornerStyle = aCornerStyle;
    }
}

- (void)setFontSize:(CGFloat)aFontSize {
    fontSize = aFontSize;
    for (CDXCard *card in cards) {
        card.fontSize = aFontSize;
    }
}

@end

