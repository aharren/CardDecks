//
//
// CDXCardDeckTests.m
//
//
// Copyright (c) 2009-2014 Arne Harren <ah@0xc0.de>
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

#import <XCTest/XCTest.h>
#import "CDXCardDeck.h"


@interface CDXCardDeckTests : XCTestCase {
    
}

@end


@implementation CDXCardDeckTests

- (void)testInitWithDefaults {
    CDXCardDeck *deck = [[CDXCardDeck alloc] init];
    XCTAssertEqualObjects([deck name], @"New Card Deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorBlack]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWhite]);
    XCTAssertEqual((int)[defaults orientation], (int)CDXCardOrientationUp);
    
    XCTAssertEqual(deck.wantsPageControl, YES);
    XCTAssertEqual(deck.wantsPageJumps, YES);
    XCTAssertEqual(deck.wantsAutoRotate, YES);
    XCTAssertEqual(deck.shakeAction, CDXCardDeckShakeActionDefault);
    XCTAssertEqual(deck.groupSize, CDXCardDeckGroupSizeDefault);
    XCTAssertEqual(deck.displayStyle, CDXCardDeckDisplayStyleDefault);
    XCTAssertEqual(deck.cornerStyle, CDXCardCornerStyleDefault);
    XCTAssertEqual(deck.pageControlStyle, CDXCardDeckPageControlStyleDefault);
    XCTAssertEqual(deck.autoPlay, CDXCardDeckAutoPlayDefault);
    
    [deck release];
}

- (void)testCopy {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    XCTAssertEqual([deck cardsCount], (NSUInteger)0);
    
    CDXCard *card;
    card = [[[CDXCard alloc] init] autorelease];
    card.text = @"Text1";
    [deck addCard:card];
    card = [[[CDXCard alloc] init] autorelease];
    card.text = @"Text2";
    [deck addCard:card];
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)2);
    XCTAssertEqualObjects([[deck cardAtIndex:0] text], @"Text1");
    XCTAssertEqualObjects([[deck cardAtIndex:1] text], @"Text2");
    
    XCTAssertEqual(deck.wantsPageControl, YES);
    deck.wantsPageControl = NO;
    XCTAssertEqual(deck.wantsPageJumps, YES);
    deck.wantsPageJumps = NO;
    XCTAssertEqual(deck.wantsAutoRotate, YES);
    deck.wantsAutoRotate = NO;
    XCTAssertEqual(deck.shakeAction, CDXCardDeckShakeActionShuffle);
    deck.shakeAction = CDXCardDeckShakeActionRandom;
    XCTAssertEqual(deck.groupSize, CDXCardDeckGroupSizeNoGroups);
    deck.groupSize = CDXCardDeckGroupSizeMax;
    XCTAssertEqual(deck.displayStyle, CDXCardDeckDisplayStyleSideBySide);
    deck.displayStyle = CDXCardDeckDisplayStyleStack;
    XCTAssertEqual(deck.cornerStyle, CDXCardCornerStyleRounded);
    deck.cornerStyle = CDXCardCornerStyleCornered;
    XCTAssertEqual(deck.pageControlStyle, CDXCardDeckPageControlStyleLight);
    deck.pageControlStyle = CDXCardDeckPageControlStyleDark;
    XCTAssertEqual(deck.autoPlay, CDXCardDeckAutoPlayOff);
    deck.autoPlay = CDXCardDeckAutoPlayPlay;
    
    CDXCardDeck *newdeck = [[deck copy] autorelease];
    XCTAssertEqual([newdeck cardsCount], (NSUInteger)2);
    
    [[deck cardAtIndex:0] setText:@"NewText1"];
    [[deck cardAtIndex:1] setText:@"NewText2"];
    XCTAssertEqual([deck cardsCount], (NSUInteger)2);
    XCTAssertEqualObjects([[deck cardAtIndex:0] text], @"NewText1");
    XCTAssertEqualObjects([[deck cardAtIndex:1] text], @"NewText2");
    
    XCTAssertEqual([newdeck cardsCount], (NSUInteger)2);
    XCTAssertEqualObjects([[newdeck cardAtIndex:0] text], @"Text1");
    XCTAssertEqualObjects([[newdeck cardAtIndex:1] text], @"Text2");
    
    XCTAssertEqual(newdeck.wantsPageControl, NO);
    XCTAssertEqual(newdeck.wantsPageJumps, NO);
    XCTAssertEqual(newdeck.wantsAutoRotate, NO);
    XCTAssertEqual(newdeck.shakeAction, CDXCardDeckShakeActionRandom);
    XCTAssertEqual(newdeck.groupSize, CDXCardDeckGroupSizeMax);
    XCTAssertEqual(newdeck.displayStyle, CDXCardDeckDisplayStyleStack);
    XCTAssertEqual(newdeck.cornerStyle, CDXCardCornerStyleCornered);
    XCTAssertEqual(newdeck.pageControlStyle, CDXCardDeckPageControlStyleDark);
    XCTAssertEqual(newdeck.autoPlay, CDXCardDeckAutoPlayPlay);
}

- (void)testAddCard {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    XCTAssertEqual([deck cardsCount], (NSUInteger)0);
    
    CDXCard *card = [[CDXCard alloc] init];
    card.text = @"Text";
    [deck addCard:card];
    [card release];
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)1);
    XCTAssertEqualObjects([[deck cardAtIndex:0] text], @"Text");
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
    
    XCTAssertEqual([cards count], (NSUInteger)2);
    XCTAssertEqualObjects([[cards objectAtIndex:0] text], @"Text1");
    XCTAssertEqualObjects([[cards objectAtIndex:1] text], @"Text2");
    
    CDXCardDeck *newdeck = [[[CDXCardDeck alloc] init] autorelease];
    XCTAssertEqual([newdeck cardsCount], (NSUInteger)0);
    [newdeck addCards:cards];
    
    [cards[0] setText:@"NewText1"];
    [cards[1] setText:@"NewText2"];
    XCTAssertEqual([cards count], (NSUInteger)2);
    XCTAssertEqualObjects([[cards objectAtIndex:0] text], @"NewText1");
    XCTAssertEqualObjects([[cards objectAtIndex:1] text], @"NewText2");
    
    XCTAssertEqual([newdeck cardsCount], (NSUInteger)2);
    XCTAssertEqualObjects([[newdeck cardAtIndex:0] text], @"NewText1");
    XCTAssertEqualObjects([[newdeck cardAtIndex:1] text], @"NewText2");
}

- (void)testRemoveCard {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    XCTAssertEqual([deck cardsCount], (NSUInteger)0);
    
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
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)3);
    XCTAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 1");
    XCTAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 2");
    XCTAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 3");
    
    [deck removeCardAtIndex:1];
    XCTAssertEqual([deck cardsCount], (NSUInteger)2);
    XCTAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 1");
    XCTAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 3");
}

- (void)testRemoveCards {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    XCTAssertEqual([deck cardsCount], (NSUInteger)0);
    
    CDXCard *card;
    card = [[[CDXCard alloc] init] autorelease];
    card.text = @"Text1";
    [deck addCard:card];
    card = [[[CDXCard alloc] init] autorelease];
    card.text = @"Text2";
    [deck addCard:card];
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)2);
    XCTAssertEqualObjects([[deck cardAtIndex:0] text], @"Text1");
    XCTAssertEqualObjects([[deck cardAtIndex:1] text], @"Text2");
    
    NSMutableArray *cards = [deck removeCards];
    XCTAssertEqual([cards count], (NSUInteger)2);
    XCTAssertEqualObjects([[cards objectAtIndex:0] text], @"Text1");
    XCTAssertEqualObjects([[cards objectAtIndex:1] text], @"Text2");
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)0);
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
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)3);
    XCTAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 1");
    XCTAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 2");
    XCTAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 3");
    
    [deck moveCardAtIndex:0 toIndex:2];
    XCTAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 3");
    XCTAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 1");
    
    [deck moveCardAtIndex:1 toIndex:2];
    XCTAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 1");
    XCTAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 3");
    
    [deck moveCardAtIndex:2 toIndex:0];
    XCTAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 3");
    XCTAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 2");
    XCTAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 1");
    
    [deck moveCardAtIndex:2 toIndex:2];
    XCTAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 3");
    XCTAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 2");
    XCTAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 1");
    
    [deck moveCardAtIndex:1 toIndex:0];
    XCTAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 3");
    XCTAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 1");
}

- (void)testCardWithDefaults {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    CDXCard *card1 = [deck cardWithDefaults];
    XCTAssertEqualObjects([card1 text], @"");
    XCTAssertEqualObjects([card1 textColor], [CDXColor colorBlack]);
    XCTAssertEqualObjects([card1 backgroundColor], [CDXColor colorWhite]);
    XCTAssertEqual((int)[card1 orientation], (int)CDXCardOrientationUp);
    
    CDXCard *defaults = deck.cardDefaults;
    defaults.textColor = [CDXColor colorWithRed:0x10 green:0x10 blue:0x10 alpha:0x10];
    defaults.backgroundColor =  [CDXColor colorWithRed:0x20 green:0x20 blue:0x20 alpha:0x20];
    defaults.orientation = CDXCardOrientationDown;
    CDXCard *card2 = [deck cardWithDefaults];
    XCTAssertEqualObjects([card2 text], @"");
    XCTAssertEqualObjects([card2 textColor], [CDXColor colorWithRed:0x10 green:0x10 blue:0x10 alpha:0x10]);
    XCTAssertEqualObjects([card2 backgroundColor], [CDXColor colorWithRed:0x20 green:0x20 blue:0x20 alpha:0x20]);
    XCTAssertEqual((int)[card2 orientation], (int)CDXCardOrientationDown);
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
    XCTAssertEqual((NSUInteger)8, [deck cardsCount]);
    
    [deck sort];
    XCTAssertEqual((NSUInteger)8, [deck cardsCount]);
    XCTAssertEqual([deck cardAtIndex:0], card1);
    XCTAssertEqual([deck cardAtIndex:1], card2);
    XCTAssertEqual([deck cardAtIndex:2], card3);
    XCTAssertEqual([deck cardAtIndex:3], card4);
    XCTAssertEqual([deck cardAtIndex:4], card5);
    XCTAssertEqual([deck cardAtIndex:5], card6);
    XCTAssertEqual([deck cardAtIndex:6], card7);
    XCTAssertEqual([deck cardAtIndex:7], card8);
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
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)3);
    
    [deck shuffle];
    CDXCard *card1s = [deck cardAtIndex:0];
    CDXCard *card2s = [deck cardAtIndex:1];
    CDXCard *card3s = [deck cardAtIndex:2];
    
    XCTAssertEqualObjects([deck cardAtCardsIndex:0], card1);
    XCTAssertEqualObjects([deck cardAtCardsIndex:1], card2);
    XCTAssertEqualObjects([deck cardAtCardsIndex:2], card3);
    XCTAssertEqualObjects([deck cardAtIndex:0], card1s);
    XCTAssertEqualObjects([deck cardAtIndex:1], card2s);
    XCTAssertEqualObjects([deck cardAtIndex:2], card3s);
    
    [deck moveCardAtIndex:0 toIndex:2];
    XCTAssertEqualObjects([deck cardAtCardsIndex:0], card1);
    XCTAssertEqualObjects([deck cardAtCardsIndex:1], card2);
    XCTAssertEqualObjects([deck cardAtCardsIndex:2], card3);
    XCTAssertEqualObjects([deck cardAtIndex:0], card2s);
    XCTAssertEqualObjects([deck cardAtIndex:1], card3s);
    XCTAssertEqualObjects([deck cardAtIndex:2], card1s);
    
    [deck moveCardAtIndex:1 toIndex:1];
    XCTAssertEqualObjects([deck cardAtCardsIndex:0], card1);
    XCTAssertEqualObjects([deck cardAtCardsIndex:1], card2);
    XCTAssertEqualObjects([deck cardAtCardsIndex:2], card3);
    XCTAssertEqualObjects([deck cardAtIndex:0], card2s);
    XCTAssertEqualObjects([deck cardAtIndex:1], card3s);
    XCTAssertEqualObjects([deck cardAtIndex:2], card1s);
    
    [deck moveCardAtIndex:1 toIndex:0];
    XCTAssertEqualObjects([deck cardAtCardsIndex:0], card1);
    XCTAssertEqualObjects([deck cardAtCardsIndex:1], card2);
    XCTAssertEqualObjects([deck cardAtCardsIndex:2], card3);
    XCTAssertEqualObjects([deck cardAtIndex:0], card3s);
    XCTAssertEqualObjects([deck cardAtIndex:1], card2s);
    XCTAssertEqualObjects([deck cardAtIndex:2], card1s);
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
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)3);
    
    [deck shuffle];
    CDXCard *card1s = [deck cardAtIndex:0];
    CDXCard *card2s = [deck cardAtIndex:1];
    CDXCard *card3s = [deck cardAtIndex:2];
    
    XCTAssertEqualObjects([deck cardAtCardsIndex:0], card1);
    XCTAssertEqualObjects([deck cardAtCardsIndex:1], card2);
    XCTAssertEqualObjects([deck cardAtCardsIndex:2], card3);
    XCTAssertEqualObjects([deck cardAtIndex:0], card1s);
    XCTAssertEqualObjects([deck cardAtIndex:1], card2s);
    XCTAssertEqualObjects([deck cardAtIndex:2], card3s);
    
    CDXCard *card4 = [[[CDXCard alloc] init] autorelease];
    card3.text = @"Text 4";
    [deck addCard:card4];
    
    XCTAssertEqualObjects([deck cardAtCardsIndex:0], card1);
    XCTAssertEqualObjects([deck cardAtCardsIndex:1], card2);
    XCTAssertEqualObjects([deck cardAtCardsIndex:2], card3);
    XCTAssertEqualObjects([deck cardAtCardsIndex:3], card4);
    XCTAssertEqualObjects([deck cardAtIndex:0], card1s);
    XCTAssertEqualObjects([deck cardAtIndex:1], card2s);
    XCTAssertEqualObjects([deck cardAtIndex:2], card3s);
    XCTAssertEqualObjects([deck cardAtIndex:3], card4);
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
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)3);
    
    [deck shuffle];
    CDXCard *card1s = [deck cardAtIndex:0];
    CDXCard *card2s = [deck cardAtIndex:1];
    CDXCard *card3s = [deck cardAtIndex:2];
    
    XCTAssertEqualObjects([deck cardAtCardsIndex:0], card1);
    XCTAssertEqualObjects([deck cardAtCardsIndex:1], card2);
    XCTAssertEqualObjects([deck cardAtCardsIndex:2], card3);
    XCTAssertEqualObjects([deck cardAtIndex:0], card1s);
    XCTAssertEqualObjects([deck cardAtIndex:1], card2s);
    XCTAssertEqualObjects([deck cardAtIndex:2], card3s);
    
    NSUInteger cardsIndex = [deck cardsIndex:1];
    [deck removeCardAtIndex:1];
    XCTAssertEqual([deck cardsCount], (NSUInteger)2);
    switch (cardsIndex) {
        case 0:
            XCTAssertEqualObjects([deck cardAtCardsIndex:0], card2);
            XCTAssertEqualObjects([deck cardAtCardsIndex:1], card3);
            break;
        case 1:
            XCTAssertEqualObjects([deck cardAtCardsIndex:0], card1);
            XCTAssertEqualObjects([deck cardAtCardsIndex:1], card3);
            break;
        case 2:
            XCTAssertEqualObjects([deck cardAtCardsIndex:0], card1);
            XCTAssertEqualObjects([deck cardAtCardsIndex:1], card2);
            break;
        default:
            XCTFail();
    }
    XCTAssertEqualObjects([deck cardAtIndex:0], card1s);
    XCTAssertEqualObjects([deck cardAtIndex:1], card3s);
}

- (void)testGroupSize {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    XCTAssertEqual(deck.groupSize, CDXCardDeckGroupSizeDefault);
    deck.groupSize = -1;
    XCTAssertEqual(deck.groupSize, CDXCardDeckGroupSizeDefault);
    deck.groupSize = 0;
    XCTAssertEqual(deck.groupSize, CDXCardDeckGroupSizeNoGroups);
    deck.groupSize = 3;
    XCTAssertEqual(deck.groupSize, 3);
    deck.groupSize = 12;
    XCTAssertEqual(deck.groupSize, CDXCardDeckGroupSizeMax);
    deck.groupSize = 13;
    XCTAssertEqual(deck.groupSize, CDXCardDeckGroupSizeNoGroups);
}

- (void)testDisplayStyle {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    XCTAssertEqual(deck.displayStyle, CDXCardDeckDisplayStyleDefault);
    deck.displayStyle = -1;
    XCTAssertEqual(deck.displayStyle, CDXCardDeckDisplayStyleDefault);
    deck.displayStyle = 0;
    XCTAssertEqual(deck.displayStyle, CDXCardDeckDisplayStyleDefault);
    deck.displayStyle = 1;
    XCTAssertEqual(deck.displayStyle, 1);
    deck.displayStyle = 2;
    XCTAssertEqual(deck.displayStyle, CDXCardDeckDisplayStyleCount-1);
    deck.displayStyle = 3;
    XCTAssertEqual(deck.displayStyle, CDXCardDeckDisplayStyleDefault);
}

- (void)testPageControlStyle {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    XCTAssertEqual(deck.pageControlStyle, CDXCardDeckPageControlStyleDefault);
    deck.pageControlStyle = -1;
    XCTAssertEqual(deck.pageControlStyle, CDXCardDeckPageControlStyleDefault);
    deck.pageControlStyle = 0;
    XCTAssertEqual(deck.pageControlStyle, CDXCardDeckPageControlStyleDefault);
    deck.pageControlStyle = 1;
    XCTAssertEqual(deck.pageControlStyle, CDXCardDeckPageControlStyleCount-1);
    deck.pageControlStyle = 2;
    XCTAssertEqual(deck.pageControlStyle, CDXCardDeckPageControlStyleDefault);
}

- (void)testAutoPlay {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    
    XCTAssertEqual(deck.autoPlay, CDXCardDeckAutoPlayOff);
    deck.autoPlay = -1;
    XCTAssertEqual(deck.autoPlay, CDXCardDeckAutoPlayOff);
    deck.autoPlay = 0;
    XCTAssertEqual(deck.autoPlay, CDXCardDeckAutoPlayOff);
    deck.autoPlay = 1;
    XCTAssertEqual(deck.autoPlay, CDXCardDeckAutoPlayPlay);
    deck.autoPlay = 2;
    XCTAssertEqual(deck.autoPlay, CDXCardDeckAutoPlayPlay2);
    deck.autoPlay = 3;
    XCTAssertEqual(deck.autoPlay, CDXCardDeckAutoPlayOff);
}

- (void)testDisplayStyleFromString {
    XCTAssertEqual(CDXCardDeckDisplayStyleSideBySide, [CDXCardDeck displayStyleFromString:@"side-by-side,scroll" defaultsTo:CDXCardDeckDisplayStyleStack]);
    XCTAssertEqual(CDXCardDeckDisplayStyleStack, [CDXCardDeck displayStyleFromString:@"stacked,scroll" defaultsTo:CDXCardDeckDisplayStyleSideBySide]);
    XCTAssertEqual(CDXCardDeckDisplayStyleSwipeStack, [CDXCardDeck displayStyleFromString:@"stacked,swipe" defaultsTo:CDXCardDeckDisplayStyleSideBySide]);
    XCTAssertEqual(CDXCardDeckDisplayStyleSideBySide, [CDXCardDeck displayStyleFromString:@"?" defaultsTo:CDXCardDeckDisplayStyleSideBySide]);
    XCTAssertEqual(CDXCardDeckDisplayStyleSwipeStack, [CDXCardDeck displayStyleFromString:@"?" defaultsTo:CDXCardDeckDisplayStyleSwipeStack]);
}

- (void)testPageControlStyleFromString {
    XCTAssertEqual(CDXCardDeckPageControlStyleLight, [CDXCardDeck pageControlStyleFromString:@"light" defaultsTo:CDXCardDeckPageControlStyleDark]);
    XCTAssertEqual(CDXCardDeckPageControlStyleDark, [CDXCardDeck pageControlStyleFromString:@"dark" defaultsTo:CDXCardDeckPageControlStyleLight]);
    XCTAssertEqual(CDXCardDeckPageControlStyleDark, [CDXCardDeck pageControlStyleFromString:@"?" defaultsTo:CDXCardDeckPageControlStyleDark]);
    XCTAssertEqual(CDXCardDeckPageControlStyleLight, [CDXCardDeck pageControlStyleFromString:@"?" defaultsTo:CDXCardDeckPageControlStyleLight]);
}

@end

