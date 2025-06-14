//
//
// CDXCardDeckDictionarySerializerTests.m
//
//
// Copyright (c) 2009-2025 Arne Harren <ah@0xc0.de>
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
#import "CDXCardDeckDictionarySerializer.h"


@interface CDXCardDeckDictionarySerializerTests : XCTestCase {
    
}

@end


@implementation CDXCardDeckDictionarySerializerTests

- (NSDictionary *)dictionaryFromFile:(NSString *)file {
    NSString *path = [[NSBundle bundleForClass:[CDXCardDeckDictionarySerializerTests class]] pathForResource:file ofType:nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    XCTAssertNotNil(dictionary);
    return dictionary;
}

- (void)testCardDeckFromVersion1Dictionary {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck1.CardDeck.plist"];
    
    CDXCardDeck *deck = [CDXCardDeckDictionarySerializer cardDeckFromVersion1Dictionary:dictionary];
    XCTAssertEqualObjects([deck name], @"Yes, No, Perhaps");
    XCTAssertEqualObjects([deck file], @"YesNoPerhaps.CardDeck");
    
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects(defaults.textColor, [CDXColor colorWithRed:255 green:255 blue:255 alpha:255]);
    XCTAssertEqualObjects(defaults.backgroundColor, [CDXColor colorWithRed:0 green:0 blue:0 alpha:255]);
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)3);
    
    CDXCard *card;
    card = [deck cardAtIndex:0];
    XCTAssertEqualObjects(card.text, @"YES");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRed:0 green:255 blue:0 alpha:255]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRed:16 green:16 blue:16 alpha:255]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationUp);
    
    card = [deck cardAtIndex:1];
    XCTAssertEqualObjects(card.text, @"NO");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRed:255 green:0 blue:0 alpha:255]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRed:0 green:0 blue:0 alpha:255]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationUp);
    
    card = [deck cardAtIndex:2];
    XCTAssertEqualObjects(card.text, @"PERHAPS");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRed:255 green:255 blue:0 alpha:255]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRed:0 green:0 blue:0 alpha:255]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationLeft);
}

- (void)testVersion2bDictionaryFromCardDeck {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    deck.name = @"Deck:Name";
    deck.file = @"Deck:File";
    
    deck.wantsPageControl = NO;
    deck.wantsPageJumps = NO;
    deck.wantsAutoRotate = YES;
    deck.shakeAction = CDXCardDeckShakeActionShuffle;
    deck.groupSize = 0;
    
    deck.displayStyle = CDXCardDeckDisplayStyleSideBySide;
    deck.cornerStyle = CDXCardCornerStyleCornered;
    
    deck.autoPlay = CDXCardDeckAutoPlayPlay;
    
    CDXCard *card;
    card = [deck cardWithDefaults];
    card.text = @"Card1:Text";
    card.textColor = [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil];
    card.backgroundColor = [CDXColor colorWithRGBAString:@"22345678" defaultsTo:nil];
    card.orientation = CDXCardOrientationUp;
    card.cornerStyle = CDXCardCornerStyleRounded;
    card.fontSize = 1;
    card.timerInterval = 1;
    [deck addCard:card];
    
    card = [deck cardWithDefaults];
    card.text = @"Card2:Text";
    card.textColor = [CDXColor colorWithRGBAString:@"32345678" defaultsTo:nil];
    card.backgroundColor = [CDXColor colorWithRGBAString:@"42345678" defaultsTo:nil];
    card.orientation = CDXCardOrientationLeft;
    card.cornerStyle = CDXCardCornerStyleRounded;
    card.fontSize = 2;
    card.timerInterval = 2;
    [deck addCard:card];
    
    card = [deck cardDefaults];
    card.text = @"Defaults:Text";
    card.textColor = [CDXColor colorWithRGBAString:@"52345678" defaultsTo:nil];
    card.backgroundColor = [CDXColor colorWithRGBAString:@"62345678" defaultsTo:nil];
    card.orientation = CDXCardOrientationDown;
    card.cornerStyle = CDXCardCornerStyleCornered;
    card.fontSize = 3;
    card.timerInterval = 10;
    
    NSDictionary *dictionary = [CDXCardDeckDictionarySerializer version2DictionaryFromCardDeck:deck];
    NSDictionary *expected = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2b1.CardDeck.plist"];
    XCTAssertTrue([expected isEqualToDictionary:dictionary]);
}

- (void)testVersion2bDictionaryFromCardDeckReverse {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    deck.name = @"Deck:NameReverse";
    deck.file = @"Deck:FileReverse";
    
    deck.wantsPageControl = YES;
    deck.wantsPageJumps = YES;
    deck.wantsAutoRotate = NO;
    deck.shakeAction = CDXCardDeckShakeActionNone;
    deck.groupSize = 4;
    
    deck.displayStyle = CDXCardDeckDisplayStyleStack;
    deck.cornerStyle = CDXCardCornerStyleRounded;
    deck.pageControlStyle = CDXCardDeckPageControlStyleDark;
    
    CDXCard *card;
    card = [deck cardWithDefaults];
    card.text = @"Card1:TextReverse";
    card.textColor = [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil];
    card.backgroundColor = [CDXColor colorWithRGBAString:@"22345678" defaultsTo:nil];
    card.orientation = CDXCardOrientationUp;
    card.cornerStyle = CDXCardCornerStyleCornered;
    card.fontSize = 1;
    card.timerInterval = 1;
    [deck addCard:card];
    
    card = [deck cardWithDefaults];
    card.text = @"Card2:TextReverse";
    card.textColor = [CDXColor colorWithRGBAString:@"32345678" defaultsTo:nil];
    card.backgroundColor = [CDXColor colorWithRGBAString:@"42345678" defaultsTo:nil];
    card.orientation = CDXCardOrientationLeft;
    card.cornerStyle = CDXCardCornerStyleRounded;
    card.fontSize = 2;
    card.timerInterval = 2;
    [deck addCard:card];
    
    card = [deck cardDefaults];
    card.text = @"Defaults:TextReverse";
    card.textColor = [CDXColor colorWithRGBAString:@"52345678" defaultsTo:nil];
    card.backgroundColor = [CDXColor colorWithRGBAString:@"62345678" defaultsTo:nil];
    card.orientation = CDXCardOrientationDown;
    card.cornerStyle = CDXCardCornerStyleCornered;
    card.fontSize = 3;
    card.timerInterval = 10;
    
    NSDictionary *dictionary = [CDXCardDeckDictionarySerializer version2DictionaryFromCardDeck:deck];
    NSDictionary *expected = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2b2.CardDeck.plist"];
    XCTAssertTrue([expected isEqualToDictionary:dictionary]);
}

- (void)testCardDeckFromVersion2aDictionary {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2a1.CardDeck.plist"];
    
    CDXCardDeck *deck = [CDXCardDeckDictionarySerializer cardDeckFromVersion2Dictionary:dictionary];
    XCTAssertEqualObjects([deck name], @"Deck:Name");
    XCTAssertEqualObjects([deck file], @"Deck:File");
    XCTAssertEqual(deck.wantsPageControl, NO);
    XCTAssertEqual(deck.wantsPageJumps, NO);
    XCTAssertEqual(deck.wantsAutoRotate, YES);
    XCTAssertEqual(deck.shakeAction, 1);
    XCTAssertEqual(deck.groupSize, 0);
    
    XCTAssertEqual(deck.displayStyle, CDXCardDeckDisplayStyleSideBySide);
    XCTAssertEqual(deck.cornerStyle, CDXCardCornerStyleCornered);
    
    XCTAssertEqual(deck.autoPlay, CDXCardDeckAutoPlayOff);
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)2);
    
    CDXCard *card;
    card = [deck cardAtCardsIndex:0];
    XCTAssertEqualObjects(card.text, @"Card1:Text");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"22345678" defaultsTo:nil]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationUp);
    XCTAssertEqual((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleCornered);
    XCTAssertEqual(card.fontSize, (CGFloat)1);
    XCTAssertEqual(card.timerInterval, (NSTimeInterval)5);
    
    card = [deck cardAtCardsIndex:1];
    XCTAssertEqualObjects(card.text, @"Card2:Text");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"32345678" defaultsTo:nil]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"42345678" defaultsTo:nil]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationLeft);
    XCTAssertEqual((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleCornered);
    XCTAssertEqual(card.fontSize, (CGFloat)2);
    XCTAssertEqual(card.timerInterval, (NSTimeInterval)5);
    
    card = [deck cardDefaults];
    XCTAssertEqualObjects(card.text, @"Defaults:Text");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"52345678" defaultsTo:nil]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"62345678" defaultsTo:nil]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationDown);
    XCTAssertEqual((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleCornered);
    XCTAssertEqual(card.fontSize, (CGFloat)3);
    XCTAssertEqual(card.timerInterval, (NSTimeInterval)5);
}

- (void)testCardDeckFromVersion2aDictionaryReverse {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2a2.CardDeck.plist"];
    
    CDXCardDeck *deck = [CDXCardDeckDictionarySerializer cardDeckFromVersion2Dictionary:dictionary];
    XCTAssertEqualObjects([deck name], @"Deck:NameReverse");
    XCTAssertEqualObjects([deck file], @"Deck:FileReverse");
    XCTAssertEqual(deck.wantsPageControl, YES);
    XCTAssertEqual(deck.wantsPageJumps, YES);
    XCTAssertEqual(deck.wantsAutoRotate, NO);
    XCTAssertEqual(deck.shakeAction, 0);
    XCTAssertEqual(deck.groupSize, 4);
    
    XCTAssertEqual(deck.displayStyle, CDXCardDeckDisplayStyleStack);
    XCTAssertEqual(deck.cornerStyle, CDXCardCornerStyleRounded);
    
    XCTAssertEqual(deck.autoPlay, CDXCardDeckAutoPlayOff);
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)2);
    
    CDXCard *card;
    card = [deck cardAtCardsIndex:0];
    XCTAssertEqualObjects(card.text, @"Card1:TextReverse");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"22345678" defaultsTo:nil]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationUp);
    XCTAssertEqual((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleRounded);
    XCTAssertEqual(card.fontSize, (CGFloat)1);
    XCTAssertEqual(card.timerInterval, (NSTimeInterval)5);
    
    card = [deck cardAtCardsIndex:1];
    XCTAssertEqualObjects(card.text, @"Card2:TextReverse");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"32345678" defaultsTo:nil]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"42345678" defaultsTo:nil]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationLeft);
    XCTAssertEqual((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleRounded);
    XCTAssertEqual(card.fontSize, (CGFloat)2);
    XCTAssertEqual(card.timerInterval, (NSTimeInterval)5);
    
    card = [deck cardDefaults];
    XCTAssertEqualObjects(card.text, @"Defaults:TextReverse");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"52345678" defaultsTo:nil]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"62345678" defaultsTo:nil]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationDown);
    XCTAssertEqual((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleRounded);
    XCTAssertEqual(card.fontSize, (CGFloat)3);
    XCTAssertEqual(card.timerInterval, (NSTimeInterval)5);
}

- (void)testCardDeckFromVersion2bDictionary {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2b1.CardDeck.plist"];
    
    CDXCardDeck *deck = [CDXCardDeckDictionarySerializer cardDeckFromVersion2Dictionary:dictionary];
    XCTAssertEqualObjects([deck name], @"Deck:Name");
    XCTAssertEqualObjects([deck file], @"Deck:File");
    XCTAssertEqual(deck.wantsPageControl, NO);
    XCTAssertEqual(deck.wantsPageJumps, NO);
    XCTAssertEqual(deck.wantsAutoRotate, YES);
    XCTAssertEqual(deck.shakeAction, 1);
    XCTAssertEqual(deck.groupSize, 0);
    
    XCTAssertEqual(deck.displayStyle, CDXCardDeckDisplayStyleSideBySide);
    XCTAssertEqual(deck.cornerStyle, CDXCardCornerStyleCornered);
    
    XCTAssertEqual(deck.autoPlay, CDXCardDeckAutoPlayPlay);
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)2);
    
    CDXCard *card;
    card = [deck cardAtCardsIndex:0];
    XCTAssertEqualObjects(card.text, @"Card1:Text");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"22345678" defaultsTo:nil]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationUp);
    XCTAssertEqual((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleCornered);
    XCTAssertEqual(card.fontSize, (CGFloat)1);
    XCTAssertEqual(card.timerInterval, (NSTimeInterval)1);
    
    card = [deck cardAtCardsIndex:1];
    XCTAssertEqualObjects(card.text, @"Card2:Text");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"32345678" defaultsTo:nil]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"42345678" defaultsTo:nil]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationLeft);
    XCTAssertEqual((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleCornered);
    XCTAssertEqual(card.fontSize, (CGFloat)2);
    XCTAssertEqual(card.timerInterval, (NSTimeInterval)2);
    
    card = [deck cardDefaults];
    XCTAssertEqualObjects(card.text, @"Defaults:Text");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"52345678" defaultsTo:nil]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"62345678" defaultsTo:nil]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationDown);
    XCTAssertEqual((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleCornered);
    XCTAssertEqual(card.fontSize, (CGFloat)3);
    XCTAssertEqual(card.timerInterval, (NSTimeInterval)10);
}

- (void)testCardDeckFromVersion2bDictionaryReverse {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2b2.CardDeck.plist"];
    
    CDXCardDeck *deck = [CDXCardDeckDictionarySerializer cardDeckFromVersion2Dictionary:dictionary];
    XCTAssertEqualObjects([deck name], @"Deck:NameReverse");
    XCTAssertEqualObjects([deck file], @"Deck:FileReverse");
    XCTAssertEqual(deck.wantsPageControl, YES);
    XCTAssertEqual(deck.wantsPageJumps, YES);
    XCTAssertEqual(deck.wantsAutoRotate, NO);
    XCTAssertEqual(deck.shakeAction, 0);
    XCTAssertEqual(deck.groupSize, 4);
    
    XCTAssertEqual(deck.displayStyle, CDXCardDeckDisplayStyleStack);
    XCTAssertEqual(deck.cornerStyle, CDXCardCornerStyleRounded);
    
    XCTAssertEqual(deck.autoPlay, CDXCardDeckAutoPlayOff);
    
    XCTAssertEqual([deck cardsCount], (NSUInteger)2);
    
    CDXCard *card;
    card = [deck cardAtCardsIndex:0];
    XCTAssertEqualObjects(card.text, @"Card1:TextReverse");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"22345678" defaultsTo:nil]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationUp);
    XCTAssertEqual((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleRounded);
    XCTAssertEqual(card.fontSize, (CGFloat)1);
    XCTAssertEqual(card.timerInterval, (NSTimeInterval)1);
    
    card = [deck cardAtCardsIndex:1];
    XCTAssertEqualObjects(card.text, @"Card2:TextReverse");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"32345678" defaultsTo:nil]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"42345678" defaultsTo:nil]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationLeft);
    XCTAssertEqual((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleRounded);
    XCTAssertEqual(card.fontSize, (CGFloat)2);
    XCTAssertEqual(card.timerInterval, (NSTimeInterval)2);
    
    card = [deck cardDefaults];
    XCTAssertEqualObjects(card.text, @"Defaults:TextReverse");
    XCTAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"52345678" defaultsTo:nil]);
    XCTAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"62345678" defaultsTo:nil]);
    XCTAssertEqual((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationDown);
    XCTAssertEqual((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleRounded);
    XCTAssertEqual(card.fontSize, (CGFloat)3);
    XCTAssertEqual(card.timerInterval, (NSTimeInterval)10);
}

- (void)testVersion2DictionaryShuffleIndexes {
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
    
    XCTAssertNotNil([deck shuffleIndexes]);
    NSDictionary *dictionary = [CDXCardDeckDictionarySerializer version2DictionaryFromCardDeck:deck];
    
    CDXCardDeck *deck2 = [CDXCardDeckDictionarySerializer cardDeckFromVersion2Dictionary:dictionary];
    XCTAssertEqual([deck2 cardsCount], (NSUInteger)3);
    
    XCTAssertEqual((NSUInteger)[deck2 isShuffled], (NSUInteger)YES);
    XCTAssertEqualObjects([[deck2 cardAtCardsIndex:0] description], [card1 description]);
    XCTAssertEqualObjects([[deck2 cardAtCardsIndex:1] description], [card2 description]);
    XCTAssertEqualObjects([[deck2 cardAtCardsIndex:2] description], [card3 description]);
    XCTAssertEqualObjects([[deck2 cardAtIndex:0] description], [card1s description]);
    XCTAssertEqualObjects([[deck2 cardAtIndex:1] description], [card2s description]);
    XCTAssertEqualObjects([[deck2 cardAtIndex:2] description], [card3s description]);
    
    // shuffle indexes should be mutable
    [deck2 removeCardAtIndex:1];
    XCTAssertEqualObjects([[deck2 cardAtIndex:0] description], [card1s description]);
    XCTAssertEqualObjects([[deck2 cardAtIndex:1] description], [card3s description]);
}

- (void)testCardDeckFromDictionary {
    NSDictionary *dictionary;
    CDXCardDeck *deck;
    
    dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck1.CardDeck.plist"];
    deck = [CDXCardDeckDictionarySerializer cardDeckFromDictionary:dictionary];
    XCTAssertEqualObjects([deck name], @"Yes, No, Perhaps");
    
    dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2a1.CardDeck.plist"];
    deck = [CDXCardDeckDictionarySerializer cardDeckFromDictionary:dictionary];
    XCTAssertEqualObjects([deck name], @"Deck:Name");
    
    dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2b1.CardDeck.plist"];
    deck = [CDXCardDeckDictionarySerializer cardDeckFromDictionary:dictionary];
    XCTAssertEqualObjects([deck name], @"Deck:Name");
}

- (void)testDictionaryFromCardDeck {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    deck.name = @"Deck:Name";
    
    NSDictionary *dictionary = [CDXCardDeckDictionarySerializer dictionaryFromCardDeck:deck];
    XCTAssertEqualObjects([[dictionary valueForKey:@"VERSION"] description], @"2");
    XCTAssertEqualObjects([[dictionary valueForKey:@"name"] description], @"Deck:Name");
}

@end

