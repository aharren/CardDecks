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
    
    XCTAssertEqual(2, deck.groupSize);
    XCTAssertEqual(CDXCardDeckDisplayStyleSideBySide, deck.displayStyle);
    XCTAssertEqual(CDXCardCornerStyleRounded, deck.cornerStyle);
    XCTAssertEqual(NO, deck.wantsPageControl);
    XCTAssertEqual(CDXCardDeckPageControlStyleLight, deck.pageControlStyle);
    XCTAssertEqual(NO, deck.wantsPageJumps);
    XCTAssertEqual(NO, deck.wantsAutoRotate);
    XCTAssertEqual(CDXCardDeckShakeActionNone, deck.shakeAction);
}

- (void)testCardDecksFromVersion2JSONSettings2 {
    NSString *string = [self stringFromFile:@"CDXCardDeckJSONSerializerTestsDeck3.carddeck.json"];
    CDXCardDeck *deck = [CDXCardDeckJSONSerializer cardDeckFromVersion2String:string];
    
    XCTAssertNotNil(deck);
    XCTAssertEqualObjects(@"settings2", deck.name);
    XCTAssertEqual(0, deck.cardsCount);
    
    XCTAssertEqual(0, deck.groupSize);
    XCTAssertEqual(CDXCardDeckDisplayStyleStack, deck.displayStyle);
    XCTAssertEqual(CDXCardCornerStyleCornered, deck.cornerStyle);
    XCTAssertEqual(YES, deck.wantsPageControl);
    XCTAssertEqual(CDXCardDeckPageControlStyleDark, deck.pageControlStyle);
    XCTAssertEqual(YES, deck.wantsPageJumps);
    XCTAssertEqual(YES, deck.wantsAutoRotate);
    XCTAssertEqual(CDXCardDeckShakeActionRandom, deck.shakeAction);
}

- (void)testIntFromDouble {
    XCTAssertEqual(INT_MIN, [CDXCardDeckJSONSerializer intFromDouble:-2e+32]);
    XCTAssertEqual(INT_MIN, [CDXCardDeckJSONSerializer intFromDouble:(double)INT_MIN]);
    XCTAssertEqual(-1, [CDXCardDeckJSONSerializer intFromDouble:(double)-1]);
    XCTAssertEqual(0, [CDXCardDeckJSONSerializer intFromDouble:(double)0]);
    XCTAssertEqual(1, [CDXCardDeckJSONSerializer intFromDouble:(double)1]);
    XCTAssertEqual(INT_MAX, [CDXCardDeckJSONSerializer intFromDouble:(double)INT_MAX]);
    XCTAssertEqual(INT_MAX, [CDXCardDeckJSONSerializer intFromDouble:2e+32]);
}

- (void)testBoolFromOnOffString {
    XCTAssertEqual(YES, [CDXCardDeckJSONSerializer boolFromOnOffString:@"on" defaultsTo:YES]);
    XCTAssertEqual(NO, [CDXCardDeckJSONSerializer boolFromOnOffString:@"off" defaultsTo:NO]);
    XCTAssertEqual(YES, [CDXCardDeckJSONSerializer boolFromOnOffString:@"?" defaultsTo:YES]);
    XCTAssertEqual(NO, [CDXCardDeckJSONSerializer boolFromOnOffString:@"?" defaultsTo:NO]);
}

- (void)testCardOrientationFromString {
    XCTAssertEqual(CDXCardOrientationUp, [CDXCardDeckJSONSerializer cardOrientationFromString:@"up" defaultsTo:CDXCardOrientationDown]);
    XCTAssertEqual(CDXCardOrientationDown, [CDXCardDeckJSONSerializer cardOrientationFromString:@"down" defaultsTo:CDXCardOrientationUp]);
    XCTAssertEqual(CDXCardOrientationLeft, [CDXCardDeckJSONSerializer cardOrientationFromString:@"left" defaultsTo:CDXCardOrientationRight]);
    XCTAssertEqual(CDXCardOrientationRight, [CDXCardDeckJSONSerializer cardOrientationFromString:@"right" defaultsTo:CDXCardOrientationLeft]);
    XCTAssertEqual(CDXCardOrientationUp, [CDXCardDeckJSONSerializer cardOrientationFromString:@"?" defaultsTo:CDXCardOrientationUp]);
    XCTAssertEqual(CDXCardOrientationDown, [CDXCardDeckJSONSerializer cardOrientationFromString:@"?" defaultsTo:CDXCardOrientationDown]);
}

- (void)testCornerStyleFromString {
    XCTAssertEqual(CDXCardCornerStyleCornered, [CDXCardDeckJSONSerializer cornerStyleFromString:@"cornered" defaultsTo:CDXCardCornerStyleRounded]);
    XCTAssertEqual(CDXCardCornerStyleRounded, [CDXCardDeckJSONSerializer cornerStyleFromString:@"rounded" defaultsTo:CDXCardCornerStyleCornered]);
    XCTAssertEqual(CDXCardCornerStyleCornered, [CDXCardDeckJSONSerializer cornerStyleFromString:@"?" defaultsTo:CDXCardCornerStyleCornered]);
    XCTAssertEqual(CDXCardCornerStyleRounded, [CDXCardDeckJSONSerializer cornerStyleFromString:@"?" defaultsTo:CDXCardCornerStyleRounded]);
}

- (void)testDisplayStyleFromString {
    XCTAssertEqual(CDXCardDeckDisplayStyleSideBySide, [CDXCardDeckJSONSerializer displayStyleFromString:@"side-by-side,scroll" defaultsTo:CDXCardDeckDisplayStyleStack]);
    XCTAssertEqual(CDXCardDeckDisplayStyleStack, [CDXCardDeckJSONSerializer displayStyleFromString:@"stacked,scroll" defaultsTo:CDXCardDeckDisplayStyleSideBySide]);
    XCTAssertEqual(CDXCardDeckDisplayStyleSwipeStack, [CDXCardDeckJSONSerializer displayStyleFromString:@"stacked,swipe" defaultsTo:CDXCardDeckDisplayStyleSideBySide]);
    XCTAssertEqual(CDXCardDeckDisplayStyleSideBySide, [CDXCardDeckJSONSerializer displayStyleFromString:@"?" defaultsTo:CDXCardDeckDisplayStyleSideBySide]);
    XCTAssertEqual(CDXCardDeckDisplayStyleSwipeStack, [CDXCardDeckJSONSerializer displayStyleFromString:@"?" defaultsTo:CDXCardDeckDisplayStyleSwipeStack]);
}

- (void)testPageControlStyleFromString {
    XCTAssertEqual(CDXCardDeckPageControlStyleLight, [CDXCardDeckJSONSerializer pageControlStyleFromString:@"light" defaultsTo:CDXCardDeckPageControlStyleDark]);
    XCTAssertEqual(CDXCardDeckPageControlStyleDark, [CDXCardDeckJSONSerializer pageControlStyleFromString:@"dark" defaultsTo:CDXCardDeckPageControlStyleLight]);
    XCTAssertEqual(CDXCardDeckPageControlStyleDark, [CDXCardDeckJSONSerializer pageControlStyleFromString:@"?" defaultsTo:CDXCardDeckPageControlStyleDark]);
    XCTAssertEqual(CDXCardDeckPageControlStyleLight, [CDXCardDeckJSONSerializer pageControlStyleFromString:@"?" defaultsTo:CDXCardDeckPageControlStyleLight]);
}

- (void)testShakeActionFromString {
    XCTAssertEqual(CDXCardDeckShakeActionNone, [CDXCardDeckJSONSerializer shakeActionFromString:@"off" defaultsTo:CDXCardDeckShakeActionRandom]);
    XCTAssertEqual(CDXCardDeckShakeActionRandom, [CDXCardDeckJSONSerializer shakeActionFromString:@"random" defaultsTo:CDXCardDeckShakeActionNone]);
    XCTAssertEqual(CDXCardDeckShakeActionShuffle, [CDXCardDeckJSONSerializer shakeActionFromString:@"shuffle" defaultsTo:CDXCardDeckShakeActionNone]);
    XCTAssertEqual(CDXCardDeckShakeActionNone, [CDXCardDeckJSONSerializer shakeActionFromString:@"?" defaultsTo:CDXCardDeckShakeActionNone]);
    XCTAssertEqual(CDXCardDeckShakeActionRandom, [CDXCardDeckJSONSerializer shakeActionFromString:@"?" defaultsTo:CDXCardDeckShakeActionRandom]);
}

@end

