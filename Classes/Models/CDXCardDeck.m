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
@synthesize file;
@synthesize wantsPageControl;
@synthesize wantsPageJumps;
@synthesize wantsAutoRotate;
@synthesize wantsShakeShuffle;
@synthesize groupSize;
@synthesize displayStyle;
@synthesize cornerStyle;
@synthesize isShuffled;

- (id)init {
    qltrace();
    if ((self = [super init])) {
        ivar_assign(cardDefaults, [[CDXCard alloc] init]);
        cardDefaults.textColor = [CDXColor colorWhite];
        cardDefaults.backgroundColor = [CDXColor colorBlack];
        ivar_assign_and_copy(name, @"");
        ivar_assign_and_copy(description, @"");
        file = nil;
        ivar_assign(cards, [[NSMutableArray alloc] init]);
        wantsPageControl = NO;
        wantsPageJumps = YES;
        wantsAutoRotate = YES;
        wantsShakeShuffle = NO;
        groupSize = CDXCardDeckGroupSizeDefault;
        displayStyle = CDXCardDeckDisplayStyleDefault;
        cornerStyle = CDXCardCornerStyleRounded;
        isShuffled = NO;
        shuffleIndexes = nil;
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(cardDefaults);
    ivar_release_and_clear(name);
    ivar_release_and_clear(description);
    ivar_release_and_clear(cards);
    ivar_release_and_clear(shuffleIndexes);
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    CDXCardDeck *copy = [[[self class] allocWithZone:zone] init];
    copy.cardDefaults = [[cardDefaults copyWithZone:zone] autorelease];
    copy.name = name;
    copy.wantsPageControl = wantsPageControl;
    copy.wantsPageJumps = wantsPageJumps;
    copy.wantsAutoRotate = wantsAutoRotate;
    copy.wantsShakeShuffle = wantsShakeShuffle;
    copy.groupSize = groupSize;
    copy.displayStyle = displayStyle;
    copy.cornerStyle = cornerStyle;
    for (CDXCard *card in cards) {
        [copy addCard:[[card copyWithZone:zone] autorelease]];
    }
    return copy;
}

- (NSUInteger)cardsIndex:(NSUInteger)index {
    if (isShuffled) {
        return [(NSNumber *)[shuffleIndexes objectAtIndex:index] unsignedIntegerValue];
    } else {
        return index;
    }
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

- (CDXCard *)cardAtCardsIndex:(NSUInteger)cardsIndex {
    return (CDXCard *)[cards objectAtIndex:cardsIndex];
}

- (CDXCard *)cardAtIndex:(NSUInteger)index {
    NSUInteger cardsIndex = [self cardsIndex:index];
    return (CDXCard *)[cards objectAtIndex:cardsIndex];
}

- (CDXCard *)cardAtIndex:(NSUInteger)index orCard:(CDXCard *)card {
    if ([cards count] <= index) {
        return card;
    }
    NSUInteger cardsIndex = [self cardsIndex:index];
    return (CDXCard *)[cards objectAtIndex:cardsIndex];
}

- (void)addCard:(CDXCard *)card {
    card.cornerStyle = cornerStyle;
    [cards addObject:card];
    if (isShuffled) {
        NSUInteger cardsIndex = [cards count]-1;
        [shuffleIndexes addObject:[NSNumber numberWithUnsignedInteger:cardsIndex]];
    }
    [self updateDescription];
}

- (void)removeCardAtIndex:(NSUInteger)index {
    NSUInteger cardsIndex = [self cardsIndex:index];
    [cards removeObjectAtIndex:cardsIndex];
    if (isShuffled) {
        [shuffleIndexes removeObjectAtIndex:index];
        NSUInteger count = [cards count];
        for (NSUInteger i = 0; i < count; i++) {
            NSUInteger aCardsIndex = [(NSNumber *)[shuffleIndexes objectAtIndex:i] unsignedIntegerValue];
            if (aCardsIndex >= cardsIndex) {
                [shuffleIndexes replaceObjectAtIndex:i withObject:[NSNumber numberWithUnsignedInteger:aCardsIndex-1]];
            }
        }
    }
    [self updateDescription];
    if ([cards count] == 0) {
        [self sort];
    }
}

- (void)replaceCardAtIndex:(NSUInteger)index withCard:(CDXCard *)card {
    [card retain];
    NSUInteger cardsIndex = [self cardsIndex:index];
    [cards removeObjectAtIndex:cardsIndex];
    [cards insertObject:card atIndex:cardsIndex];
    [card release];
    [self updateDescription];
}

- (void)moveCardAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (isShuffled) {
        NSUInteger cardsIndex = [self cardsIndex:fromIndex];
        [shuffleIndexes removeObjectAtIndex:fromIndex];
        [shuffleIndexes insertObject:[NSNumber numberWithUnsignedInteger:cardsIndex] atIndex:toIndex];
    } else {
        CDXCard *card = (CDXCard *)[cards objectAtIndex:fromIndex];
        [card retain];
        [cards removeObjectAtIndex:fromIndex];
        [cards insertObject:card atIndex:toIndex];
        [card release];
        [self updateDescription];
    }
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
    for (CDXCard *card in cards) {
        card.fontSize = aFontSize;
    }
    cardDefaults.fontSize = aFontSize;
}

- (void)shuffle {
    NSUInteger count = [cards count];
    ivar_assign(shuffleIndexes, [[NSMutableArray alloc] initWithCapacity:count]);
    for (NSUInteger i = 0; i < count; i++) {
        [shuffleIndexes addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    for (NSUInteger i = 0; i < count; i++) {
        NSUInteger newIndex = (((double)arc4random() / 0x100000000) * count);
        [shuffleIndexes exchangeObjectAtIndex:newIndex withObjectAtIndex:i];
    }
    isShuffled = YES;
}

- (void)sort {
    isShuffled = NO;
    ivar_release_and_clear(shuffleIndexes);
}

@end

