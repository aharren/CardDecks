//
//
// CDXCardDeckJSONSerializerTests.m
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
#import "CDXCardDeckJSONSerializer.h"
#import "CDXCardDeckURLSerializer.h"


@interface CDXCardDeckJSONSerializerTests : XCTestCase {
    
}

@end


@implementation CDXCardDeckJSONSerializerTests

- (NSString *)stringFromFile:(NSString *)file {
    NSString *path = [[NSBundle bundleForClass:[CDXCardDeckJSONSerializerTests class]] pathForResource:file ofType:nil];
    NSError *error = nil;
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    XCTAssertNotNil(string);
    return string;
}

- (void)testCardDecksFromVersion2JSONDefaultCardsAndCards {
    NSString *string = [self stringFromFile:@"CDXCardDeckJSONSerializerTestsDeck1.carddeck.json"];
    CDXCardDeck *deck = [CDXCardDeckJSONSerializer cardDeckFromVersion2String:string];
    
    XCTAssertNotNil(deck);
    XCTAssertEqualObjects(@"numbers", deck.name);
    XCTAssertEqual(5, deck.cardsCount);
    
    CDXCard* card;
    card = deck.cardDefaults;
    XCTAssertEqualObjects(@"default", card.text);
    XCTAssertEqualObjects([CDXColor colorWithRed:0xf8 green:0xf8 blue:0xf8 alpha:0xf8], card.textColor);
    XCTAssertEqualObjects([CDXColor colorWithRed:0x08 green:0x08 blue:0x08 alpha:0x08], card.backgroundColor);
    XCTAssertEqual(CDXCardOrientationUp, card.orientation);
    XCTAssertEqual((CGFloat)1, card.fontSize);
    XCTAssertEqual((NSTimeInterval)2, card.timerInterval);

    int i = 0;
    card = [deck cardAtIndex:i++];
    XCTAssertEqualObjects(@"ok1", card.text);
    XCTAssertEqualObjects([CDXColor colorWithRed:0x12 green:0x34 blue:0x56 alpha:0x78], card.textColor);
    XCTAssertEqualObjects([CDXColor colorWithRed:0x17 green:0x65 blue:0x43 alpha:0x28], card.backgroundColor);
    XCTAssertEqual(CDXCardOrientationLeft, card.orientation);
    XCTAssertEqual((CGFloat)50, card.fontSize);
    XCTAssertEqual((NSTimeInterval)100, card.timerInterval);

    card = [deck cardAtIndex:i++];
    XCTAssertEqualObjects(@"bad1", card.text);
    XCTAssertEqualObjects(deck.cardDefaults.textColor, card.textColor);
    XCTAssertEqualObjects(deck.cardDefaults.backgroundColor, card.backgroundColor);
    XCTAssertEqual(deck.cardDefaults.orientation, card.orientation);
    XCTAssertEqual(CDXCardFontSizeMax, card.fontSize);
    XCTAssertEqual(CDXCardTimerIntervalMin, card.timerInterval);

    card = [deck cardAtIndex:i++];
    XCTAssertEqualObjects(@"default", card.text);
    XCTAssertEqualObjects(deck.cardDefaults.textColor, card.textColor);
    XCTAssertEqualObjects(deck.cardDefaults.backgroundColor, card.backgroundColor);
    XCTAssertEqual(deck.cardDefaults.orientation, card.orientation);
    XCTAssertEqual(deck.cardDefaults.fontSize, card.fontSize);
    XCTAssertEqual(deck.cardDefaults.timerInterval, card.timerInterval);
    
    card = [deck cardAtIndex:i++];
    XCTAssertEqualObjects(@"bad3", card.text);
    XCTAssertEqual(CDXCardFontSizeMax, card.fontSize);
    XCTAssertEqual(CDXCardTimerIntervalMax, card.timerInterval);
    
    card = [deck cardAtIndex:i++];
    XCTAssertEqualObjects(@"default", card.text);
    XCTAssertEqualObjects(deck.cardDefaults.textColor, card.textColor);
    XCTAssertEqualObjects(deck.cardDefaults.backgroundColor, card.backgroundColor);
    XCTAssertEqual(deck.cardDefaults.orientation, card.orientation);
    XCTAssertEqual(deck.cardDefaults.fontSize, card.fontSize);
    XCTAssertEqual(deck.cardDefaults.timerInterval, card.timerInterval);
}

- (void)testCardDecksFromVersion2JSONSettings1 {
    NSString *string = [self stringFromFile:@"CDXCardDeckJSONSerializerTestsDeck2.carddeck.json"];
    CDXCardDeck *deck = [CDXCardDeckJSONSerializer cardDeckFromVersion2String:string];
    
    XCTAssertNotNil(deck);
    XCTAssertEqualObjects(@"settings", deck.name);
    XCTAssertEqual(0, deck.cardsCount);
    
    XCTAssertEqual(CDXCardDeckDisplayStyleSideBySide, deck.displayStyle);
    XCTAssertEqual(CDXCardCornerStyleRounded, deck.cornerStyle);
}

- (void)testCardDecksFromVersion2JSONSettings2 {
    NSString *string = [self stringFromFile:@"CDXCardDeckJSONSerializerTestsDeck3.carddeck.json"];
    CDXCardDeck *deck = [CDXCardDeckJSONSerializer cardDeckFromVersion2String:string];
    
    XCTAssertNotNil(deck);
    XCTAssertEqualObjects(@"settings2", deck.name);
    XCTAssertEqual(0, deck.cardsCount);
    
    XCTAssertEqual(CDXCardDeckDisplayStyleStack, deck.displayStyle);
    XCTAssertEqual(CDXCardCornerStyleCornered, deck.cornerStyle);
}

@end

