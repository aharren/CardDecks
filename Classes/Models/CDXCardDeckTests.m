//
//
// CDXCardDeckTests.m
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

#import <SenTestingKit/SenTestingKit.h>
#import "CDXCardDeck.h"


@interface CDXCardDeckTests : SenTestCase {
    
}

@end


@implementation CDXCardDeckTests

- (void)testInitWithDefaults {
    CDXCardDeck *deck = [[CDXCardDeck alloc] init];
    STAssertEqualObjects([deck name], @"New Card Deck", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects([defaults textColor], [CDXColor colorBlack], nil);
    STAssertEqualObjects([defaults backgroundColor], [CDXColor colorWhite], nil);
    STAssertEquals((int)[defaults orientation], (int)CDXCardOrientationUp, nil);
    
    STAssertEquals(deck.wantsPageControl, YES, nil);
    STAssertEquals(deck.wantsPageJumps, YES, nil);
    STAssertEquals(deck.wantsAutoRotate, YES, nil);
    STAssertEquals(deck.shakeAction, CDXCardDeckShakeActionDefault, nil);
    STAssertEquals(deck.groupSize, CDXCardDeckGroupSizeDefault, nil);
    STAssertEquals(deck.displayStyle, CDXCardDeckDisplayStyleDefault, nil);
    STAssertEquals(deck.cornerStyle, CDXCardCornerStyleDefault, nil);
    STAssertEquals(deck.pageControlStyle, CDXCardDeckPageControlStyleDefault, nil);
    STAssertEquals(deck.autoPlay, CDXCardDeckAutoPlayDefault, nil);
    
    [deck release];
}

- (void)testCopy {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    STAssertEquals([deck cardsCount], (NSUInteger)0, nil);
    
    CDXCard *card;
    card = [[[CDXCard alloc] init] autorelease];
    card.text = @"Text1";
    [deck addCard:card];
    card = [[[CDXCard alloc] init] autorelease];
    card.text = @"Text2";
    [deck addCard:card];
    
    STAssertEquals([deck cardsCount], (NSUInteger)2, nil);
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text1", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text2", nil);
    
    STAssertEquals(deck.wantsPageControl, YES, nil);
    deck.wantsPageControl = NO;
    STAssertEquals(deck.wantsPageJumps, YES, nil);
    deck.wantsPageJumps = NO;
    STAssertEquals(deck.wantsAutoRotate, YES, nil);
    deck.wantsAutoRotate = NO;
    STAssertEquals(deck.shakeAction, CDXCardDeckShakeActionShuffle, nil);
    deck.shakeAction = CDXCardDeckShakeActionRandom;
    STAssertEquals(deck.groupSize, CDXCardDeckGroupSizeNoGroups, nil);
    deck.groupSize = CDXCardDeckGroupSizeMax;
    STAssertEquals(deck.displayStyle, CDXCardDeckDisplayStyleSideBySide, nil);
    deck.displayStyle = CDXCardDeckDisplayStyleStack;
    STAssertEquals(deck.cornerStyle, CDXCardCornerStyleRounded, nil);
    deck.cornerStyle = CDXCardCornerStyleCornered;
    STAssertEquals(deck.pageControlStyle, CDXCardDeckPageControlStyleLight, nil);
    deck.pageControlStyle = CDXCardDeckPageControlStyleDark;
    STAssertEquals(deck.autoPlay, CDXCardDeckAutoPlayOff, nil);
    deck.autoPlay = CDXCardDeckAutoPlayPlay;
    
    CDXCardDeck *newdeck = [[deck copy] autorelease];
    STAssertEquals([newdeck cardsCount], (NSUInteger)2, nil);
    
    [[deck cardAtIndex:0] setText:@"NewText1"];
    [[deck cardAtIndex:1] setText:@"NewText2"];
    STAssertEquals([deck cardsCount], (NSUInteger)2, nil);
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"NewText1", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"NewText2", nil);
    
    STAssertEquals([newdeck cardsCount], (NSUInteger)2, nil);
    STAssertEqualObjects([[newdeck cardAtIndex:0] text], @"Text1", nil);
    STAssertEqualObjects([[newdeck cardAtIndex:1] text], @"Text2", nil);
    
    STAssertEquals(newdeck.wantsPageControl, NO, nil);
    STAssertEquals(newdeck.wantsPageJumps, NO, nil);
    STAssertEquals(newdeck.wantsAutoRotate, NO, nil);
    STAssertEquals(newdeck.shakeAction, CDXCardDeckShakeActionRandom, nil);
    STAssertEquals(newdeck.groupSize, CDXCardDeckGroupSizeMax, nil);
    STAssertEquals(newdeck.displayStyle, CDXCardDeckDisplayStyleStack, nil);
    STAssertEquals(newdeck.cornerStyle, CDXCardCornerStyleCornered, nil);
    STAssertEquals(newdeck.pageControlStyle, CDXCardDeckPageControlStyleDark, nil);
    STAssertEquals(newdeck.autoPlay, CDXCardDeckAutoPlayPlay, nil);
}

- (void)testAddCard {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    STAssertEquals([deck cardsCount], (NSUInteger)0, nil);
    
    CDXCard *card = [[CDXCard alloc] init];
    card.text = @"Text";
    [deck addCard:card];
    [card release];
    
    STAssertEquals([deck cardsCount], (NSUInteger)1, nil);
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text", nil);
}

- (void)testAddCards {
    NSMutableArray *cards = [NSMutableArray arrayWithCapacity:0];
    
    CDXCard *card;
    card = [[[CDXCard alloc] init] autorelease];
    card.text = @"Text1";
    [cards addObject:card];
    card = [[[CDXCard alloc] init] autorelease];
    card.text = @"Text2";
    [cards addObject:card];
    
    STAssertEquals([cards count], (NSUInteger)2, nil);
    STAssertEqualObjects([[cards objectAtIndex:0] text], @"Text1", nil);
    STAssertEqualObjects([[cards objectAtIndex:1] text], @"Text2", nil);
    
    CDXCardDeck *newdeck = [[[CDXCardDeck alloc] init] autorelease];
    STAssertEquals([newdeck cardsCount], (NSUInteger)0, nil);
    [newdeck addCards:cards];
    
    [[cards objectAtIndex:0] setText:@"NewText1"];
    [[cards objectAtIndex:1] setText:@"NewText2"];
    STAssertEquals([cards count], (NSUInteger)2, nil);
    STAssertEqualObjects([[cards objectAtIndex:0] text], @"NewText1", nil);
    STAssertEqualObjects([[cards objectAtIndex:1] text], @"NewText2", nil);
    
    STAssertEquals([newdeck cardsCount], (NSUInteger)2, nil);
    STAssertEqualObjects([[newdeck cardAtIndex:0] text], @"NewText1", nil);
    STAssertEqualObjects([[newdeck cardAtIndex:1] text], @"NewText2", nil);
}

- (void)testRemoveCard {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    STAssertEquals([deck cardsCount], (NSUInteger)0, nil);
    
    CDXCard *card1 = [[CDXCard alloc] init];
    card1.text = @"Text 1";
    [deck addCard:card1];
    [card1 release];
    
    CDXCard *card2 = [[CDXCard alloc] init];
    card2.text = @"Text 2";
    [deck addCard:card2];
    [card2 release];
    
    CDXCard *card3 = [[CDXCard alloc] init];
    card3.text = @"Text 3";
    [deck addCard:card3];
    [card3 release];
    
    STAssertEquals([deck cardsCount], (NSUInteger)3, nil);
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 3", nil);
    
    [deck removeCardAtIndex:1];
    STAssertEquals([deck cardsCount], (NSUInteger)2, nil);
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 3", nil);
}

- (void)testRemoveCards {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    STAssertEquals([deck cardsCount], (NSUInteger)0, nil);
    
    CDXCard *card;
    card = [[[CDXCard alloc] init] autorelease];
    card.text = @"Text1";
    [deck addCard:card];
    card = [[[CDXCard alloc] init] autorelease];
    card.text = @"Text2";
    [deck addCard:card];
    
    STAssertEquals([deck cardsCount], (NSUInteger)2, nil);
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text1", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text2", nil);
    
    NSMutableArray *cards = [deck removeCards];
    STAssertEquals([cards count], (NSUInteger)2, nil);
    STAssertEqualObjects([[cards objectAtIndex:0] text], @"Text1", nil);
    STAssertEqualObjects([[cards objectAtIndex:1] text], @"Text2", nil);
    
    STAssertEquals([deck cardsCount], (NSUInteger)0, nil);
}

- (void)testMoveCard {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    CDXCard *card1 = [[[CDXCard alloc] init] autorelease];
    card1.text = @"Text 1";
    [deck addCard:card1];
    
    CDXCard *card2 = [[[CDXCard alloc] init] autorelease];
    card2.text = @"Text 2";
    [deck addCard:card2];
    
    CDXCard *card3 = [[[CDXCard alloc] init] autorelease];
    card3.text = @"Text 3";
    [deck addCard:card3];
    
    STAssertEquals([deck cardsCount], (NSUInteger)3, nil);
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 3", nil);
    
    [deck moveCardAtIndex:0 toIndex:2];
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 3", nil);
    STAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 1", nil);
    
    [deck moveCardAtIndex:1 toIndex:2];
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 3", nil);
    
    [deck moveCardAtIndex:2 toIndex:0];
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 3", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 1", nil);
    
    [deck moveCardAtIndex:2 toIndex:2];
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 3", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 1", nil);
    
    [deck moveCardAtIndex:1 toIndex:0];
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 3", nil);
    STAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 1", nil);
}

- (void)testCardWithDefaults {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    CDXCard *card1 = [deck cardWithDefaults];
    STAssertEqualObjects([card1 text], @"", nil);
    STAssertEqualObjects([card1 textColor], [CDXColor colorBlack], nil);
    STAssertEqualObjects([card1 backgroundColor], [CDXColor colorWhite], nil);
    STAssertEquals((int)[card1 orientation], (int)CDXCardOrientationUp, nil);
    
    CDXCard *defaults = deck.cardDefaults;
    defaults.textColor = [CDXColor colorWithRed:0x10 green:0x10 blue:0x10 alpha:0x10];
    defaults.backgroundColor =  [CDXColor colorWithRed:0x20 green:0x20 blue:0x20 alpha:0x20];
    defaults.orientation = CDXCardOrientationDown;
    CDXCard *card2 = [deck cardWithDefaults];
    STAssertEqualObjects([card2 text], @"", nil);
    STAssertEqualObjects([card2 textColor], [CDXColor colorWithRed:0x10 green:0x10 blue:0x10 alpha:0x10], nil);
    STAssertEqualObjects([card2 backgroundColor], [CDXColor colorWithRed:0x20 green:0x20 blue:0x20 alpha:0x20], nil);
    STAssertEquals((int)[card2 orientation], (int)CDXCardOrientationDown, nil);
}

- (void)testShuffleAndSort {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    CDXCard *card1 = [[[CDXCard alloc] init] autorelease];
    card1.text = @"Text 1";
    [deck addCard:card1];
    
    CDXCard *card2 = [[[CDXCard alloc] init] autorelease];
    card2.text = @"Text 2";
    [deck addCard:card2];
    
    CDXCard *card3 = [[[CDXCard alloc] init] autorelease];
    card3.text = @"Text 3";
    [deck addCard:card3];
    
    CDXCard *card4 = [[[CDXCard alloc] init] autorelease];
    card4.text = @"Text 4";
    [deck addCard:card4];
    
    CDXCard *card5 = [[[CDXCard alloc] init] autorelease];
    card5.text = @"Text 5";
    [deck addCard:card5];
    
    CDXCard *card6 = [[[CDXCard alloc] init] autorelease];
    card6.text = @"Text 6";
    [deck addCard:card6];
    
    CDXCard *card7 = [[[CDXCard alloc] init] autorelease];
    card7.text = @"Text 7";
    [deck addCard:card7];
    
    CDXCard *card8 = [[[CDXCard alloc] init] autorelease];
    card8.text = @"Text 8";
    [deck addCard:card8];
    
    [deck shuffle];
    STAssertEquals((NSUInteger)8, [deck cardsCount], nil);
    
    [deck sort];
    STAssertEquals((NSUInteger)8, [deck cardsCount], nil);
    STAssertEquals([deck cardAtIndex:0], card1, nil);
    STAssertEquals([deck cardAtIndex:1], card2, nil);
    STAssertEquals([deck cardAtIndex:2], card3, nil);
    STAssertEquals([deck cardAtIndex:3], card4, nil);
    STAssertEquals([deck cardAtIndex:4], card5, nil);
    STAssertEquals([deck cardAtIndex:5], card6, nil);
    STAssertEquals([deck cardAtIndex:6], card7, nil);
    STAssertEquals([deck cardAtIndex:7], card8, nil);
}

- (void)testMoveCardShuffled {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    CDXCard *card1 = [[[CDXCard alloc] init] autorelease];
    card1.text = @"Text 1";
    [deck addCard:card1];
    
    CDXCard *card2 = [[[CDXCard alloc] init] autorelease];
    card2.text = @"Text 2";
    [deck addCard:card2];
    
    CDXCard *card3 = [[[CDXCard alloc] init] autorelease];
    card3.text = @"Text 3";
    [deck addCard:card3];
    
    STAssertEquals([deck cardsCount], (NSUInteger)3, nil);
    
    [deck shuffle];
    CDXCard *card1s = [deck cardAtIndex:0];
    CDXCard *card2s = [deck cardAtIndex:1];
    CDXCard *card3s = [deck cardAtIndex:2];
    
    STAssertEqualObjects([deck cardAtCardsIndex:0], card1, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:1], card2, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:2], card3, nil);
    STAssertEqualObjects([deck cardAtIndex:0], card1s, nil);
    STAssertEqualObjects([deck cardAtIndex:1], card2s, nil);
    STAssertEqualObjects([deck cardAtIndex:2], card3s, nil);
    
    [deck moveCardAtIndex:0 toIndex:2];
    STAssertEqualObjects([deck cardAtCardsIndex:0], card1, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:1], card2, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:2], card3, nil);
    STAssertEqualObjects([deck cardAtIndex:0], card2s, nil);
    STAssertEqualObjects([deck cardAtIndex:1], card3s, nil);
    STAssertEqualObjects([deck cardAtIndex:2], card1s, nil);
    
    [deck moveCardAtIndex:1 toIndex:1];
    STAssertEqualObjects([deck cardAtCardsIndex:0], card1, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:1], card2, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:2], card3, nil);
    STAssertEqualObjects([deck cardAtIndex:0], card2s, nil);
    STAssertEqualObjects([deck cardAtIndex:1], card3s, nil);
    STAssertEqualObjects([deck cardAtIndex:2], card1s, nil);
    
    [deck moveCardAtIndex:1 toIndex:0];
    STAssertEqualObjects([deck cardAtCardsIndex:0], card1, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:1], card2, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:2], card3, nil);
    STAssertEqualObjects([deck cardAtIndex:0], card3s, nil);
    STAssertEqualObjects([deck cardAtIndex:1], card2s, nil);
    STAssertEqualObjects([deck cardAtIndex:2], card1s, nil);
}

- (void)testAddCardShuffled {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    CDXCard *card1 = [[[CDXCard alloc] init] autorelease];
    card1.text = @"Text 1";
    [deck addCard:card1];
    
    CDXCard *card2 = [[[CDXCard alloc] init] autorelease];
    card2.text = @"Text 2";
    [deck addCard:card2];
    
    CDXCard *card3 = [[[CDXCard alloc] init] autorelease];
    card3.text = @"Text 3";
    [deck addCard:card3];
    
    STAssertEquals([deck cardsCount], (NSUInteger)3, nil);
    
    [deck shuffle];
    CDXCard *card1s = [deck cardAtIndex:0];
    CDXCard *card2s = [deck cardAtIndex:1];
    CDXCard *card3s = [deck cardAtIndex:2];
    
    STAssertEqualObjects([deck cardAtCardsIndex:0], card1, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:1], card2, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:2], card3, nil);
    STAssertEqualObjects([deck cardAtIndex:0], card1s, nil);
    STAssertEqualObjects([deck cardAtIndex:1], card2s, nil);
    STAssertEqualObjects([deck cardAtIndex:2], card3s, nil);
    
    CDXCard *card4 = [[[CDXCard alloc] init] autorelease];
    card3.text = @"Text 4";
    [deck addCard:card4];
    
    STAssertEqualObjects([deck cardAtCardsIndex:0], card1, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:1], card2, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:2], card3, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:3], card4, nil);
    STAssertEqualObjects([deck cardAtIndex:0], card1s, nil);
    STAssertEqualObjects([deck cardAtIndex:1], card2s, nil);
    STAssertEqualObjects([deck cardAtIndex:2], card3s, nil);
    STAssertEqualObjects([deck cardAtIndex:3], card4, nil);
}

- (void)testRemoveCardShuffled {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    CDXCard *card1 = [[[CDXCard alloc] init] autorelease];
    card1.text = @"Text 1";
    [deck addCard:card1];
    
    CDXCard *card2 = [[[CDXCard alloc] init] autorelease];
    card2.text = @"Text 2";
    [deck addCard:card2];
    
    CDXCard *card3 = [[[CDXCard alloc] init] autorelease];
    card3.text = @"Text 3";
    [deck addCard:card3];
    
    STAssertEquals([deck cardsCount], (NSUInteger)3, nil);
    
    [deck shuffle];
    CDXCard *card1s = [deck cardAtIndex:0];
    CDXCard *card2s = [deck cardAtIndex:1];
    CDXCard *card3s = [deck cardAtIndex:2];
    
    STAssertEqualObjects([deck cardAtCardsIndex:0], card1, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:1], card2, nil);
    STAssertEqualObjects([deck cardAtCardsIndex:2], card3, nil);
    STAssertEqualObjects([deck cardAtIndex:0], card1s, nil);
    STAssertEqualObjects([deck cardAtIndex:1], card2s, nil);
    STAssertEqualObjects([deck cardAtIndex:2], card3s, nil);
    
    NSUInteger cardsIndex = [deck cardsIndex:1];
    [deck removeCardAtIndex:1];
    STAssertEquals([deck cardsCount], (NSUInteger)2, nil);
    switch (cardsIndex) {
        case 0:
            STAssertEqualObjects([deck cardAtCardsIndex:0], card2, nil);
            STAssertEqualObjects([deck cardAtCardsIndex:1], card3, nil);
            break;
        case 1:
            STAssertEqualObjects([deck cardAtCardsIndex:0], card1, nil);
            STAssertEqualObjects([deck cardAtCardsIndex:1], card3, nil);
            break;
        case 2:
            STAssertEqualObjects([deck cardAtCardsIndex:0], card1, nil);
            STAssertEqualObjects([deck cardAtCardsIndex:1], card2, nil);
            break;
        default:
            STFail(nil);
    }
    STAssertEqualObjects([deck cardAtIndex:0], card1s, nil);
    STAssertEqualObjects([deck cardAtIndex:1], card3s, nil);
}

- (void)testGroupSize {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    STAssertEquals(deck.groupSize, CDXCardDeckGroupSizeDefault, nil);
    deck.groupSize = -1;
    STAssertEquals(deck.groupSize, CDXCardDeckGroupSizeDefault, nil);
    deck.groupSize = 0;
    STAssertEquals(deck.groupSize, CDXCardDeckGroupSizeNoGroups, nil);
    deck.groupSize = 3;
    STAssertEquals(deck.groupSize, 3, nil);
    deck.groupSize = 12;
    STAssertEquals(deck.groupSize, CDXCardDeckGroupSizeMax, nil);
    deck.groupSize = 13;
    STAssertEquals(deck.groupSize, CDXCardDeckGroupSizeNoGroups, nil);
}

- (void)testDisplayStyle {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    STAssertEquals(deck.displayStyle, CDXCardDeckDisplayStyleDefault, nil);
    deck.displayStyle = -1;
    STAssertEquals(deck.displayStyle, CDXCardDeckDisplayStyleDefault, nil);
    deck.displayStyle = 0;
    STAssertEquals(deck.displayStyle, CDXCardDeckDisplayStyleDefault, nil);
    deck.displayStyle = 1;
    STAssertEquals(deck.displayStyle, 1, nil);
    deck.displayStyle = 2;
    STAssertEquals(deck.displayStyle, CDXCardDeckDisplayStyleCount-1, nil);
    deck.displayStyle = 3;
    STAssertEquals(deck.displayStyle, CDXCardDeckDisplayStyleDefault, nil);
}

- (void)testPageControlStyle {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    STAssertEquals(deck.pageControlStyle, CDXCardDeckPageControlStyleDefault, nil);
    deck.pageControlStyle = -1;
    STAssertEquals(deck.pageControlStyle, CDXCardDeckPageControlStyleDefault, nil);
    deck.pageControlStyle = 0;
    STAssertEquals(deck.pageControlStyle, CDXCardDeckPageControlStyleDefault, nil);
    deck.pageControlStyle = 1;
    STAssertEquals(deck.pageControlStyle, CDXCardDeckPageControlStyleCount-1, nil);
    deck.pageControlStyle = 2;
    STAssertEquals(deck.pageControlStyle, CDXCardDeckPageControlStyleDefault, nil);
}

- (void)testAutoPlay {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    STAssertEquals(deck.autoPlay, CDXCardDeckAutoPlayOff, nil);
    deck.autoPlay = -1;
    STAssertEquals(deck.autoPlay, CDXCardDeckAutoPlayOff, nil);
    deck.autoPlay = 0;
    STAssertEquals(deck.autoPlay, CDXCardDeckAutoPlayOff, nil);
    deck.autoPlay = 1;
    STAssertEquals(deck.autoPlay, CDXCardDeckAutoPlayPlay, nil);
    deck.autoPlay = 2;
    STAssertEquals(deck.autoPlay, CDXCardDeckAutoPlayPlay2, nil);
    deck.autoPlay = 3;
    STAssertEquals(deck.autoPlay, CDXCardDeckAutoPlayOff, nil);
}

@end

