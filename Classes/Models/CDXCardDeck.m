//
//
// CDXCardDeck.m
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

#import "CDXCardDeck.h"
#import "CDXStorage.h"
#import "CDXCardDeckDictionarySerializer.h"

#undef ql_component
#define ql_component lcl_cModel


@implementation CDXCardDeck

@synthesize cardDefaults;
@synthesize wantsPageControl;
@synthesize wantsPageJumps;
@synthesize wantsAutoRotate;
@synthesize shakeAction;
@synthesize groupSize;
@synthesize displayStyle;
@synthesize cornerStyle;
@synthesize pageControlStyle;
@synthesize autoPlay;
@synthesize isShuffled;
@synthesize shuffleIndexes;

- (id)init {
    qltrace();
    if ((self = [super init])) {
        base = nil;
        cardDeck = self;
        ivar_assign_and_copy(name, @"New Card Deck");
        ivar_assign_and_copy(file, [CDXStorage fileWithSuffix:@".CardDeck"]);
        ivar_assign(cardDefaults, [[CDXCard alloc] init]);
        cardDefaults.textColor = [CDXColor colorBlack];
        cardDefaults.backgroundColor = [CDXColor colorWhite];
        ivar_assign(cards, [[NSMutableArray alloc] init]);
        wantsPageControl = YES;
        wantsPageJumps = YES;
        wantsAutoRotate = YES;
        shakeAction = CDXCardDeckShakeActionDefault;
        groupSize = CDXCardDeckGroupSizeDefault;
        displayStyle = CDXCardDeckDisplayStyleDefault;
        cornerStyle = CDXCardCornerStyleDefault;
        pageControlStyle = CDXCardDeckPageControlStyleDefault;
        autoPlay = CDXCardDeckAutoPlayDefault;
        isShuffled = NO;
        shuffleIndexes = nil;
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(cardDefaults);
    ivar_release_and_clear(cards);
    ivar_release_and_clear(shuffleIndexes);
    [base unlinkCardDeck]; // unlinkBase
    base = nil;
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    qltrace();
    CDXCardDeck *copy = [[[self class] allocWithZone:zone] init];
    copy.cardDefaults = [[cardDefaults copyWithZone:zone] autorelease];
    copy.name = name;
    copy.wantsPageControl = wantsPageControl;
    copy.wantsPageJumps = wantsPageJumps;
    copy.wantsAutoRotate = wantsAutoRotate;
    copy.shakeAction = shakeAction;
    copy.groupSize = groupSize;
    copy.displayStyle = displayStyle;
    copy.cornerStyle = cornerStyle;
    copy.pageControlStyle = pageControlStyle;
    copy.autoPlay = autoPlay;
    for (CDXCard *card in cards) {
        [copy addCard:[[card copyWithZone:zone] autorelease]];
    }
    if (isShuffled) {
        copy.shuffleIndexes = shuffleIndexes;
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

- (void)sendUpdateNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:CDXCardDeckUpdateNotification object:self];
}

- (void)updateBase {
    if (!base) {
        return;
    }
    
    base.name = name;
    base.file = file;
    base.description = description;
    base.cardsCount = cardsCount;
    base.thumbnailColor = thumbnailColor;
    
    [self sendUpdateNotification];
}

- (void)linkBase:(CDXCardDeckBase *)aBase {
    [super linkBase:aBase];
    [self updateBase];
}

- (void)updateFields {
    // description
    NSMutableString *d = [[[NSMutableString alloc] initWithCapacity:100] autorelease];
    BOOL first = YES;
    for (CDXCard *card in cards) {
        NSString *text = card.text;
        if (![text isEqualToString:@""]) {
            if (!first) {
                [d appendString:@", "];
            }
            [d appendString:text];
            first = NO;
        }
        if ([d length] >= 60) {
            break;
        }
    }
    ivar_assign_and_copy(description, d);
    
    // cardsCount
    cardsCount = [cards count];
    
    // thumbnailColor
    if (cardsCount != 0) {
        ivar_assign_and_retain(thumbnailColor, ((CDXCard *)[cards objectAtIndex:0]).backgroundColor);
    } else {
        ivar_release_and_clear(thumbnailColor);
    }
    
    [self updateBase];
}

- (void)setName:(NSString *)aName {
    [super setName:aName];
    [self updateBase];
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
    [self updateFields];
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
    [self updateFields];
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
    [self updateFields];
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
        [self updateFields];
    }
}

- (CDXCard *)cardWithDefaults {
    return [[cardDefaults copy] autorelease];
}

- (void)setShakeAction:(CDXCardDeckShakeAction)aShakeAction {
    ivar_enum_assign(shakeAction, CDXCardDeckShakeAction, aShakeAction);
}

- (void)setGroupSize:(CDXCardDeckGroupSize)aGroupSize {
    ivar_enum_assign(groupSize, CDXCardDeckGroupSize, aGroupSize);
    [self sendUpdateNotification];
}

- (void)setDisplayStyle:(CDXCardDeckDisplayStyle)aDisplayStyle {
    ivar_enum_assign(displayStyle, CDXCardDeckDisplayStyle, aDisplayStyle);
}

- (void)setPageControlStyle:(CDXCardDeckPageControlStyle)aPageControlStyle {
    ivar_enum_assign(pageControlStyle, CDXCardDeckPageControlStyle, aPageControlStyle);
}

- (void)setAutoPlay:(CDXCardDeckAutoPlay)aAutoPlay {
    ivar_enum_assign(autoPlay, CDXCardDeckAutoPlay, aAutoPlay);
}

- (void)setCornerStyle:(CDXCardCornerStyle)aCornerStyle {
    cornerStyle = aCornerStyle;
    for (CDXCard *card in cards) {
        card.cornerStyle = aCornerStyle;
    }
    cardDefaults.cornerStyle = aCornerStyle;
}

- (void)setFontSize:(CGFloat)fontSize {
    for (CDXCard *card in cards) {
        card.fontSize = fontSize;
    }
    cardDefaults.fontSize = fontSize;
}

- (void)setOrientation:(CDXCardOrientation)orientation {
    for (CDXCard *card in cards) {
        card.orientation = orientation;
    }
    cardDefaults.orientation = orientation;
}

- (void)setTextColor:(CDXColor *)textColor {
    for (CDXCard *card in cards) {
        card.textColor = textColor;
    }
    cardDefaults.textColor = textColor;
}

- (void)setBackgroundColor:(CDXColor *)backgroundColor {
    for (CDXCard *card in cards) {
        card.backgroundColor = backgroundColor;
    }
    cardDefaults.backgroundColor = backgroundColor;
    [self updateFields];
}

- (void)setTimerInterval:(NSTimeInterval)timerInterval {
    for (CDXCard *card in cards) {
        card.timerInterval = timerInterval;
    }
    cardDefaults.timerInterval = timerInterval;
}

- (void)setShuffleIndexes:(NSMutableArray *)indexes {
    ivar_assign(shuffleIndexes, [indexes mutableCopy]); // unchecked
    isShuffled = YES;
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

- (NSString *)storageObjectName {
    return file;
}

- (NSDictionary *)storageObjectAsDictionary {
    return [CDXCardDeckDictionarySerializer dictionaryFromCardDeck:self];
}

+ (CDXCardDeck *)cardDeckFromStorageObjectNamed:(NSString *)file {
    NSDictionary *dictionary = [CDXStorage readDictionaryFromFile:file];
    if (dictionary == nil) {
        return nil;
    }
    CDXCardDeck *cardDeck = [CDXCardDeckDictionarySerializer cardDeckFromDictionary:dictionary];
    return cardDeck;
}

- (void)updateStorageObjectDeferred:(BOOL)deferred {
    [CDXStorage updateStorageObject:self deferred:deferred];
}

@end

