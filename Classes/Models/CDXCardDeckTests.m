//
//
// CDXCardDeckTests.m
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

#import <SenTestingKit/SenTestingKit.h>
#import "CDXCardDeck.h"


@interface CDXCardDeckTests : SenTestCase {
    
}

@end


@implementation CDXCardDeckTests

- (void)testInitWithDefaults {
    CDXCardDeck *deck = [[CDXCardDeck alloc] init];
    STAssertEqualObjects([deck name], @"", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEquals([defaults textColor], [CDXColor colorWhite], nil);
    STAssertEquals([defaults backgroundColor], [CDXColor colorBlack], nil);
    STAssertEquals((int)[defaults orientation], (int)CDXCardOrientationUp, nil);
    [deck release];
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
    STAssertEquals([card1 textColor], [CDXColor colorWhite], nil);
    STAssertEquals([card1 backgroundColor], [CDXColor colorBlack], nil);
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

@end

