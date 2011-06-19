//
//
// CDXCardDeckDictionarySerializerTests.m
//
//
// Copyright (c) 2009-2011 Arne Harren <ah@0xc0.de>
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
#import "CDXCardDeckDictionarySerializer.h"


@interface CDXCardDeckDictionarySerializerTests : SenTestCase {
    
}

@end


@implementation CDXCardDeckDictionarySerializerTests

- (NSDictionary *)dictionaryFromFile:(NSString *)file {
    NSString *path = [[NSBundle bundleForClass:[CDXCardDeckDictionarySerializerTests class]] pathForResource:file ofType:nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    STAssertNotNil(dictionary, nil);
    return dictionary;
}

- (void)testCardDeckFromVersion1Dictionary {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck1.CardDeck.plist"];
    
    CDXCardDeck *deck = [CDXCardDeckDictionarySerializer cardDeckFromVersion1Dictionary:dictionary];
    STAssertEqualObjects([deck name], @"Yes, No, Perhaps", nil);
    STAssertEqualObjects([deck file], @"YesNoPerhaps.CardDeck", nil);
    
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects(defaults.textColor, [CDXColor colorWithRed:255 green:255 blue:255 alpha:255], nil);
    STAssertEqualObjects(defaults.backgroundColor, [CDXColor colorWithRed:0 green:0 blue:0 alpha:255], nil);
    
    STAssertEquals([deck cardsCount], (NSUInteger)3, nil);
    
    CDXCard *card;
    card = [deck cardAtIndex:0];
    STAssertEqualObjects(card.text, @"YES", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRed:0 green:255 blue:0 alpha:255], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRed:16 green:16 blue:16 alpha:255], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationUp, nil);
    
    card = [deck cardAtIndex:1];
    STAssertEqualObjects(card.text, @"NO", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRed:255 green:0 blue:0 alpha:255], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRed:0 green:0 blue:0 alpha:255], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationUp, nil);
    
    card = [deck cardAtIndex:2];
    STAssertEqualObjects(card.text, @"PERHAPS", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRed:255 green:255 blue:0 alpha:255], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRed:0 green:0 blue:0 alpha:255], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationLeft, nil);
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
    
    CDXCard *card;
    card = [deck cardWithDefaults];
    card.text = @"Card1:Text";
    card.textColor = [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil];
    card.backgroundColor = [CDXColor colorWithRGBAString:@"22345678" defaultsTo:nil];
    card.orientation = CDXCardOrientationUp;
    card.cornerStyle = CDXCardCornerStyleRounded;
    card.fontSize = 1;
    [deck addCard:card];
    
    card = [deck cardWithDefaults];
    card.text = @"Card2:Text";
    card.textColor = [CDXColor colorWithRGBAString:@"32345678" defaultsTo:nil];
    card.backgroundColor = [CDXColor colorWithRGBAString:@"42345678" defaultsTo:nil];
    card.orientation = CDXCardOrientationLeft;
    card.cornerStyle = CDXCardCornerStyleRounded;
    card.fontSize = 2;
    [deck addCard:card];
    
    card = [deck cardDefaults];
    card.text = @"Defaults:Text";
    card.textColor = [CDXColor colorWithRGBAString:@"52345678" defaultsTo:nil];
    card.backgroundColor = [CDXColor colorWithRGBAString:@"62345678" defaultsTo:nil];
    card.orientation = CDXCardOrientationDown;
    card.cornerStyle = CDXCardCornerStyleCornered;
    card.fontSize = 3;
    
    NSDictionary *dictionary = [CDXCardDeckDictionarySerializer version2DictionaryFromCardDeck:deck];
    NSDictionary *expected = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2b1.CardDeck.plist"];
    STAssertTrue([expected isEqualToDictionary:dictionary], nil);
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
    [deck addCard:card];
    
    card = [deck cardWithDefaults];
    card.text = @"Card2:TextReverse";
    card.textColor = [CDXColor colorWithRGBAString:@"32345678" defaultsTo:nil];
    card.backgroundColor = [CDXColor colorWithRGBAString:@"42345678" defaultsTo:nil];
    card.orientation = CDXCardOrientationLeft;
    card.cornerStyle = CDXCardCornerStyleRounded;
    card.fontSize = 2;
    [deck addCard:card];
    
    card = [deck cardDefaults];
    card.text = @"Defaults:TextReverse";
    card.textColor = [CDXColor colorWithRGBAString:@"52345678" defaultsTo:nil];
    card.backgroundColor = [CDXColor colorWithRGBAString:@"62345678" defaultsTo:nil];
    card.orientation = CDXCardOrientationDown;
    card.cornerStyle = CDXCardCornerStyleCornered;
    card.fontSize = 3;
    
    NSDictionary *dictionary = [CDXCardDeckDictionarySerializer version2DictionaryFromCardDeck:deck];
    NSDictionary *expected = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2b2.CardDeck.plist"];
    STAssertTrue([expected isEqualToDictionary:dictionary], nil);
}

- (void)testCardDeckFromVersion2aDictionary {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2a1.CardDeck.plist"];
    
    CDXCardDeck *deck = [CDXCardDeckDictionarySerializer cardDeckFromVersion2Dictionary:dictionary];
    STAssertEqualObjects([deck name], @"Deck:Name", nil);
    STAssertEqualObjects([deck file], @"Deck:File", nil);
    STAssertEquals(deck.wantsPageControl, NO, nil);
    STAssertEquals(deck.wantsPageJumps, NO, nil);
    STAssertEquals(deck.wantsAutoRotate, YES, nil);
    STAssertEquals(deck.shakeAction, 1, nil);
    STAssertEquals(deck.groupSize, 0, nil);
    
    STAssertEquals(deck.displayStyle, CDXCardDeckDisplayStyleSideBySide, nil);
    STAssertEquals(deck.cornerStyle, CDXCardCornerStyleCornered, nil);
    
    STAssertEquals([deck cardsCount], (NSUInteger)2, nil);
    
    CDXCard *card;
    card = [deck cardAtCardsIndex:0];
    STAssertEqualObjects(card.text, @"Card1:Text", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"22345678" defaultsTo:nil], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationUp, nil);
    STAssertEquals((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleCornered, nil);
    STAssertEquals(card.fontSize, (CGFloat)1, nil);
    
    card = [deck cardAtCardsIndex:1];
    STAssertEqualObjects(card.text, @"Card2:Text", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"32345678" defaultsTo:nil], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"42345678" defaultsTo:nil], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationLeft, nil);
    STAssertEquals((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleCornered, nil);
    STAssertEquals(card.fontSize, (CGFloat)2, nil);
    
    card = [deck cardDefaults];
    STAssertEqualObjects(card.text, @"Defaults:Text", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"52345678" defaultsTo:nil], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"62345678" defaultsTo:nil], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationDown, nil);
    STAssertEquals((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleCornered, nil);
    STAssertEquals(card.fontSize, (CGFloat)3, nil);
}

- (void)testCardDeckFromVersion2aDictionaryReverse {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2a2.CardDeck.plist"];
    
    CDXCardDeck *deck = [CDXCardDeckDictionarySerializer cardDeckFromVersion2Dictionary:dictionary];
    STAssertEqualObjects([deck name], @"Deck:NameReverse", nil);
    STAssertEqualObjects([deck file], @"Deck:FileReverse", nil);
    STAssertEquals(deck.wantsPageControl, YES, nil);
    STAssertEquals(deck.wantsPageJumps, YES, nil);
    STAssertEquals(deck.wantsAutoRotate, NO, nil);
    STAssertEquals(deck.shakeAction, 0, nil);
    STAssertEquals(deck.groupSize, 4, nil);
    
    STAssertEquals(deck.displayStyle, CDXCardDeckDisplayStyleStack, nil);
    STAssertEquals(deck.cornerStyle, CDXCardCornerStyleRounded, nil);
    
    STAssertEquals([deck cardsCount], (NSUInteger)2, nil);
    
    CDXCard *card;
    card = [deck cardAtCardsIndex:0];
    STAssertEqualObjects(card.text, @"Card1:TextReverse", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"22345678" defaultsTo:nil], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationUp, nil);
    STAssertEquals((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleRounded, nil);
    STAssertEquals(card.fontSize, (CGFloat)1, nil);
    
    card = [deck cardAtCardsIndex:1];
    STAssertEqualObjects(card.text, @"Card2:TextReverse", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"32345678" defaultsTo:nil], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"42345678" defaultsTo:nil], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationLeft, nil);
    STAssertEquals((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleRounded, nil);
    STAssertEquals(card.fontSize, (CGFloat)2, nil);
    
    card = [deck cardDefaults];
    STAssertEqualObjects(card.text, @"Defaults:TextReverse", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"52345678" defaultsTo:nil], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"62345678" defaultsTo:nil], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationDown, nil);
    STAssertEquals((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleRounded, nil);
    STAssertEquals(card.fontSize, (CGFloat)3, nil);
}

- (void)testCardDeckFromVersion2bDictionary {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2b1.CardDeck.plist"];
    
    CDXCardDeck *deck = [CDXCardDeckDictionarySerializer cardDeckFromVersion2Dictionary:dictionary];
    STAssertEqualObjects([deck name], @"Deck:Name", nil);
    STAssertEqualObjects([deck file], @"Deck:File", nil);
    STAssertEquals(deck.wantsPageControl, NO, nil);
    STAssertEquals(deck.wantsPageJumps, NO, nil);
    STAssertEquals(deck.wantsAutoRotate, YES, nil);
    STAssertEquals(deck.shakeAction, 1, nil);
    STAssertEquals(deck.groupSize, 0, nil);
    
    STAssertEquals(deck.displayStyle, CDXCardDeckDisplayStyleSideBySide, nil);
    STAssertEquals(deck.cornerStyle, CDXCardCornerStyleCornered, nil);
    
    STAssertEquals([deck cardsCount], (NSUInteger)2, nil);
    
    CDXCard *card;
    card = [deck cardAtCardsIndex:0];
    STAssertEqualObjects(card.text, @"Card1:Text", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"22345678" defaultsTo:nil], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationUp, nil);
    STAssertEquals((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleCornered, nil);
    STAssertEquals(card.fontSize, (CGFloat)1, nil);
    
    card = [deck cardAtCardsIndex:1];
    STAssertEqualObjects(card.text, @"Card2:Text", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"32345678" defaultsTo:nil], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"42345678" defaultsTo:nil], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationLeft, nil);
    STAssertEquals((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleCornered, nil);
    STAssertEquals(card.fontSize, (CGFloat)2, nil);
    
    card = [deck cardDefaults];
    STAssertEqualObjects(card.text, @"Defaults:Text", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"52345678" defaultsTo:nil], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"62345678" defaultsTo:nil], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationDown, nil);
    STAssertEquals((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleCornered, nil);
    STAssertEquals(card.fontSize, (CGFloat)3, nil);
}

- (void)testCardDeckFromVersion2bDictionaryReverse {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2b2.CardDeck.plist"];
    
    CDXCardDeck *deck = [CDXCardDeckDictionarySerializer cardDeckFromVersion2Dictionary:dictionary];
    STAssertEqualObjects([deck name], @"Deck:NameReverse", nil);
    STAssertEqualObjects([deck file], @"Deck:FileReverse", nil);
    STAssertEquals(deck.wantsPageControl, YES, nil);
    STAssertEquals(deck.wantsPageJumps, YES, nil);
    STAssertEquals(deck.wantsAutoRotate, NO, nil);
    STAssertEquals(deck.shakeAction, 0, nil);
    STAssertEquals(deck.groupSize, 4, nil);
    
    STAssertEquals(deck.displayStyle, CDXCardDeckDisplayStyleStack, nil);
    STAssertEquals(deck.cornerStyle, CDXCardCornerStyleRounded, nil);
    
    STAssertEquals([deck cardsCount], (NSUInteger)2, nil);
    
    CDXCard *card;
    card = [deck cardAtCardsIndex:0];
    STAssertEqualObjects(card.text, @"Card1:TextReverse", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"22345678" defaultsTo:nil], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationUp, nil);
    STAssertEquals((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleRounded, nil);
    STAssertEquals(card.fontSize, (CGFloat)1, nil);
    
    card = [deck cardAtCardsIndex:1];
    STAssertEqualObjects(card.text, @"Card2:TextReverse", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"32345678" defaultsTo:nil], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"42345678" defaultsTo:nil], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationLeft, nil);
    STAssertEquals((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleRounded, nil);
    STAssertEquals(card.fontSize, (CGFloat)2, nil);
    
    card = [deck cardDefaults];
    STAssertEqualObjects(card.text, @"Defaults:TextReverse", nil);
    STAssertEqualObjects(card.textColor, [CDXColor colorWithRGBAString:@"52345678" defaultsTo:nil], nil);
    STAssertEqualObjects(card.backgroundColor, [CDXColor colorWithRGBAString:@"62345678" defaultsTo:nil], nil);
    STAssertEquals((NSUInteger)card.orientation, (NSUInteger)CDXCardOrientationDown, nil);
    STAssertEquals((NSUInteger)card.cornerStyle, (NSUInteger)CDXCardCornerStyleRounded, nil);
    STAssertEquals(card.fontSize, (CGFloat)3, nil);
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
    
    STAssertNotNil([deck shuffleIndexes], nil);
    NSDictionary *dictionary = [CDXCardDeckDictionarySerializer version2DictionaryFromCardDeck:deck];
    
    CDXCardDeck *deck2 = [CDXCardDeckDictionarySerializer cardDeckFromVersion2Dictionary:dictionary];
    STAssertEquals([deck2 cardsCount], (NSUInteger)3, nil);
    
    STAssertEquals((NSUInteger)[deck2 isShuffled], (NSUInteger)YES, nil);
    STAssertEqualObjects([[deck2 cardAtCardsIndex:0] description], [card1 description], nil);
    STAssertEqualObjects([[deck2 cardAtCardsIndex:1] description], [card2 description], nil);
    STAssertEqualObjects([[deck2 cardAtCardsIndex:2] description], [card3 description], nil);
    STAssertEqualObjects([[deck2 cardAtIndex:0] description], [card1s description], nil);
    STAssertEqualObjects([[deck2 cardAtIndex:1] description], [card2s description], nil);
    STAssertEqualObjects([[deck2 cardAtIndex:2] description], [card3s description], nil);
    
     // shuffle indexes should be mutable
    [deck2 removeCardAtIndex:1];
    STAssertEqualObjects([[deck2 cardAtIndex:0] description], [card1s description], nil);
    STAssertEqualObjects([[deck2 cardAtIndex:1] description], [card3s description], nil);
}

- (void)testCardDeckFromDictionary {
    NSDictionary *dictionary;
    CDXCardDeck *deck;
    
    dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck1.CardDeck.plist"];
    deck = [CDXCardDeckDictionarySerializer cardDeckFromDictionary:dictionary];
    STAssertEqualObjects([deck name], @"Yes, No, Perhaps", nil);
    
    dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2a1.CardDeck.plist"];
    deck = [CDXCardDeckDictionarySerializer cardDeckFromDictionary:dictionary];
    STAssertEqualObjects([deck name], @"Deck:Name", nil);

    dictionary = [self dictionaryFromFile:@"CDXCardDeckDictionarySerializerTestsDeck2b1.CardDeck.plist"];
    deck = [CDXCardDeckDictionarySerializer cardDeckFromDictionary:dictionary];
    STAssertEqualObjects([deck name], @"Deck:Name", nil);
}

- (void)testDictionaryFromCardDeck {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    deck.name = @"Deck:Name";
    
    NSDictionary *dictionary = [CDXCardDeckDictionarySerializer dictionaryFromCardDeck:deck];
    STAssertEqualObjects([[dictionary valueForKey:@"VERSION"] description], @"2", nil);
    STAssertEqualObjects([[dictionary valueForKey:@"name"] description], @"Deck:Name", nil);
}

@end

