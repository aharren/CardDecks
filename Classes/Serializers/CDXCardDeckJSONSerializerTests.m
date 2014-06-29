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
    XCTAssertEqual(CDXCardDeckAutoPlayOff, deck.autoPlay);
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
    XCTAssertEqual(CDXCardDeckAutoPlayPlay, deck.autoPlay);
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

- (void)testBoolToOnOffString {
    XCTAssertEqualObjects(@"on", [CDXCardDeckJSONSerializer stringOnOffFromBool:YES]);
    XCTAssertEqualObjects(@"off", [CDXCardDeckJSONSerializer stringOnOffFromBool:NO]);
}

- (void)testBootToFromOnOffString {
    XCTAssertEqual(YES, [CDXCardDeckJSONSerializer boolFromOnOffString:[CDXCardDeckJSONSerializer stringOnOffFromBool:YES] defaultsTo:NO]);
    XCTAssertEqual(NO, [CDXCardDeckJSONSerializer boolFromOnOffString:[CDXCardDeckJSONSerializer stringOnOffFromBool:NO] defaultsTo:YES]);
}

- (void)testCardOrientationFromString {
    XCTAssertEqual(CDXCardOrientationUp, [CDXCardDeckJSONSerializer cardOrientationFromString:@"up" defaultsTo:CDXCardOrientationDown]);
    XCTAssertEqual(CDXCardOrientationDown, [CDXCardDeckJSONSerializer cardOrientationFromString:@"down" defaultsTo:CDXCardOrientationUp]);
    XCTAssertEqual(CDXCardOrientationLeft, [CDXCardDeckJSONSerializer cardOrientationFromString:@"left" defaultsTo:CDXCardOrientationRight]);
    XCTAssertEqual(CDXCardOrientationRight, [CDXCardDeckJSONSerializer cardOrientationFromString:@"right" defaultsTo:CDXCardOrientationLeft]);
    XCTAssertEqual(4, CDXCardOrientationCount);
    XCTAssertEqual(CDXCardOrientationUp, [CDXCardDeckJSONSerializer cardOrientationFromString:@"?" defaultsTo:CDXCardOrientationUp]);
    XCTAssertEqual(CDXCardOrientationDown, [CDXCardDeckJSONSerializer cardOrientationFromString:@"?" defaultsTo:CDXCardOrientationDown]);
}

- (void)testCardOrientationToString {
    XCTAssertEqualObjects(@"up", [CDXCardDeckJSONSerializer stringFromCardOrientation:CDXCardOrientationUp]);
    XCTAssertEqualObjects(@"down", [CDXCardDeckJSONSerializer stringFromCardOrientation:CDXCardOrientationDown]);
    XCTAssertEqualObjects(@"left", [CDXCardDeckJSONSerializer stringFromCardOrientation:CDXCardOrientationLeft]);
    XCTAssertEqualObjects(@"right", [CDXCardDeckJSONSerializer stringFromCardOrientation:CDXCardOrientationRight]);
    XCTAssertEqualObjects(@"up", [CDXCardDeckJSONSerializer stringFromCardOrientation:CDXCardOrientationCount]);
}

- (void)testCardOrientationToFromString {
    for (CDXCardOrientation i = (CDXCardOrientation) 0; i < CDXCardOrientationCount; ++i) {
        XCTAssertEqual(i, [CDXCardDeckJSONSerializer cardOrientationFromString:[CDXCardDeckJSONSerializer stringFromCardOrientation:i] defaultsTo:(CDXCardOrientation) 0]);
        XCTAssertEqual(i, [CDXCardDeckJSONSerializer cardOrientationFromString:[CDXCardDeckJSONSerializer stringFromCardOrientation:i] defaultsTo:(CDXCardOrientation) 1]);
    }
    XCTAssertEqual(CDXCardOrientationDefault, [CDXCardDeckJSONSerializer cardOrientationFromString:[CDXCardDeckJSONSerializer stringFromCardOrientation:CDXCardOrientationCount] defaultsTo:(CDXCardOrientation) 0]);
    XCTAssertEqual(CDXCardOrientationDefault, [CDXCardDeckJSONSerializer cardOrientationFromString:[CDXCardDeckJSONSerializer stringFromCardOrientation:CDXCardOrientationCount] defaultsTo:(CDXCardOrientation) 1]);
}

- (void)testCornerStyleFromString {
    XCTAssertEqual(CDXCardCornerStyleCornered, [CDXCardDeckJSONSerializer cornerStyleFromString:@"cornered" defaultsTo:CDXCardCornerStyleRounded]);
    XCTAssertEqual(CDXCardCornerStyleRounded, [CDXCardDeckJSONSerializer cornerStyleFromString:@"rounded" defaultsTo:CDXCardCornerStyleCornered]);
    XCTAssertEqual(2, CDXCardCornerStyleCount);
    XCTAssertEqual(CDXCardCornerStyleCornered, [CDXCardDeckJSONSerializer cornerStyleFromString:@"?" defaultsTo:CDXCardCornerStyleCornered]);
    XCTAssertEqual(CDXCardCornerStyleRounded, [CDXCardDeckJSONSerializer cornerStyleFromString:@"?" defaultsTo:CDXCardCornerStyleRounded]);
}

- (void)testCornerStyleToString {
    XCTAssertEqualObjects(@"cornered", [CDXCardDeckJSONSerializer stringFromCornerStyle:CDXCardCornerStyleCornered]);
    XCTAssertEqualObjects(@"rounded", [CDXCardDeckJSONSerializer stringFromCornerStyle:CDXCardCornerStyleRounded]);
    XCTAssertEqualObjects(@"rounded", [CDXCardDeckJSONSerializer stringFromCornerStyle:CDXCardCornerStyleCount]);
}

- (void)testCornerStyleToFromString {
    for (CDXCardCornerStyle i = (CDXCardCornerStyle) 0; i < CDXCardCornerStyleCount; ++i) {
        XCTAssertEqual(i, [CDXCardDeckJSONSerializer cornerStyleFromString:[CDXCardDeckJSONSerializer stringFromCornerStyle:i] defaultsTo:(CDXCardCornerStyle) 0]);
        XCTAssertEqual(i, [CDXCardDeckJSONSerializer cornerStyleFromString:[CDXCardDeckJSONSerializer stringFromCornerStyle:i] defaultsTo:(CDXCardCornerStyle) 1]);
    }
    XCTAssertEqual(CDXCardCornerStyleDefault, [CDXCardDeckJSONSerializer cornerStyleFromString:[CDXCardDeckJSONSerializer stringFromCornerStyle:CDXCardCornerStyleCount] defaultsTo:(CDXCardCornerStyle) 0]);
    XCTAssertEqual(CDXCardCornerStyleDefault, [CDXCardDeckJSONSerializer cornerStyleFromString:[CDXCardDeckJSONSerializer stringFromCornerStyle:CDXCardCornerStyleCount] defaultsTo:(CDXCardCornerStyle) 1]);
}

- (void)testDisplayStyleFromString {
    XCTAssertEqual(CDXCardDeckDisplayStyleSideBySide, [CDXCardDeckJSONSerializer displayStyleFromString:@"side-by-side,scroll" defaultsTo:CDXCardDeckDisplayStyleStack]);
    XCTAssertEqual(CDXCardDeckDisplayStyleStack, [CDXCardDeckJSONSerializer displayStyleFromString:@"stacked,scroll" defaultsTo:CDXCardDeckDisplayStyleSideBySide]);
    XCTAssertEqual(CDXCardDeckDisplayStyleSwipeStack, [CDXCardDeckJSONSerializer displayStyleFromString:@"stacked,swipe" defaultsTo:CDXCardDeckDisplayStyleSideBySide]);
    XCTAssertEqual(3, CDXCardDeckDisplayStyleCount);
    XCTAssertEqual(CDXCardDeckDisplayStyleSideBySide, [CDXCardDeckJSONSerializer displayStyleFromString:@"?" defaultsTo:CDXCardDeckDisplayStyleSideBySide]);
    XCTAssertEqual(CDXCardDeckDisplayStyleSwipeStack, [CDXCardDeckJSONSerializer displayStyleFromString:@"?" defaultsTo:CDXCardDeckDisplayStyleSwipeStack]);
}

- (void)testDisplayStyleToString {
    XCTAssertEqualObjects(@"side-by-side,scroll", [CDXCardDeckJSONSerializer stringFromDisplayStyle:CDXCardDeckDisplayStyleSideBySide]);
    XCTAssertEqualObjects(@"stacked,scroll", [CDXCardDeckJSONSerializer stringFromDisplayStyle:CDXCardDeckDisplayStyleStack]);
    XCTAssertEqualObjects(@"stacked,swipe", [CDXCardDeckJSONSerializer stringFromDisplayStyle:CDXCardDeckDisplayStyleSwipeStack]);
    XCTAssertEqualObjects(@"side-by-side,scroll", [CDXCardDeckJSONSerializer stringFromDisplayStyle:CDXCardDeckDisplayStyleCount]);
}

- (void)testDisplayStyleToFromString {
    for (CDXCardDeckDisplayStyle i = (CDXCardDeckDisplayStyle) 0; i < CDXCardDeckDisplayStyleCount; ++i) {
        XCTAssertEqual(i, [CDXCardDeckJSONSerializer displayStyleFromString:[CDXCardDeckJSONSerializer stringFromDisplayStyle:i] defaultsTo:(CDXCardDeckDisplayStyle) 0]);
        XCTAssertEqual(i, [CDXCardDeckJSONSerializer displayStyleFromString:[CDXCardDeckJSONSerializer stringFromDisplayStyle:i] defaultsTo:(CDXCardDeckDisplayStyle) 1]);
    }
    XCTAssertEqual(CDXCardDeckDisplayStyleDefault, [CDXCardDeckJSONSerializer displayStyleFromString:[CDXCardDeckJSONSerializer stringFromDisplayStyle:CDXCardDeckDisplayStyleCount] defaultsTo:(CDXCardDeckDisplayStyle) 0]);
    XCTAssertEqual(CDXCardDeckDisplayStyleDefault, [CDXCardDeckJSONSerializer displayStyleFromString:[CDXCardDeckJSONSerializer stringFromDisplayStyle:CDXCardDeckDisplayStyleCount] defaultsTo:(CDXCardDeckDisplayStyle) 1]);
}

- (void)testPageControlStyleFromString {
    XCTAssertEqual(CDXCardDeckPageControlStyleLight, [CDXCardDeckJSONSerializer pageControlStyleFromString:@"light" defaultsTo:CDXCardDeckPageControlStyleDark]);
    XCTAssertEqual(CDXCardDeckPageControlStyleDark, [CDXCardDeckJSONSerializer pageControlStyleFromString:@"dark" defaultsTo:CDXCardDeckPageControlStyleLight]);
    XCTAssertEqual(2, CDXCardDeckPageControlStyleCount);
    XCTAssertEqual(CDXCardDeckPageControlStyleDark, [CDXCardDeckJSONSerializer pageControlStyleFromString:@"?" defaultsTo:CDXCardDeckPageControlStyleDark]);
    XCTAssertEqual(CDXCardDeckPageControlStyleLight, [CDXCardDeckJSONSerializer pageControlStyleFromString:@"?" defaultsTo:CDXCardDeckPageControlStyleLight]);
}

- (void)testPageControlStyleToString {
    XCTAssertEqualObjects(@"light", [CDXCardDeckJSONSerializer stringFromPageControlStyle:CDXCardDeckPageControlStyleLight]);
    XCTAssertEqualObjects(@"dark", [CDXCardDeckJSONSerializer stringFromPageControlStyle:CDXCardDeckPageControlStyleDark]);
    XCTAssertEqualObjects(@"light", [CDXCardDeckJSONSerializer stringFromPageControlStyle:CDXCardDeckPageControlStyleCount]);
}

- (void)testPageControlStyleToFromString {
    for (CDXCardDeckPageControlStyle i = (CDXCardDeckPageControlStyle) 0; i < CDXCardDeckPageControlStyleCount; ++i) {
        XCTAssertEqual(i, [CDXCardDeckJSONSerializer pageControlStyleFromString:[CDXCardDeckJSONSerializer stringFromPageControlStyle:i] defaultsTo:(CDXCardDeckPageControlStyle) 0]);
        XCTAssertEqual(i, [CDXCardDeckJSONSerializer pageControlStyleFromString:[CDXCardDeckJSONSerializer stringFromPageControlStyle:i] defaultsTo:(CDXCardDeckPageControlStyle) 1]);
    }
    XCTAssertEqual(CDXCardDeckPageControlStyleDefault, [CDXCardDeckJSONSerializer pageControlStyleFromString:[CDXCardDeckJSONSerializer stringFromPageControlStyle:CDXCardDeckPageControlStyleCount] defaultsTo:(CDXCardDeckPageControlStyle) 0]);
    XCTAssertEqual(CDXCardDeckPageControlStyleDefault, [CDXCardDeckJSONSerializer pageControlStyleFromString:[CDXCardDeckJSONSerializer stringFromPageControlStyle:CDXCardDeckPageControlStyleCount] defaultsTo:(CDXCardDeckPageControlStyle) 1]);
}

- (void)testShakeActionFromString {
    XCTAssertEqual(CDXCardDeckShakeActionNone, [CDXCardDeckJSONSerializer shakeActionFromString:@"off" defaultsTo:CDXCardDeckShakeActionRandom]);
    XCTAssertEqual(CDXCardDeckShakeActionRandom, [CDXCardDeckJSONSerializer shakeActionFromString:@"random" defaultsTo:CDXCardDeckShakeActionNone]);
    XCTAssertEqual(CDXCardDeckShakeActionShuffle, [CDXCardDeckJSONSerializer shakeActionFromString:@"shuffle" defaultsTo:CDXCardDeckShakeActionNone]);
    XCTAssertEqual(3, CDXCardDeckShakeActionCount);
    XCTAssertEqual(CDXCardDeckShakeActionNone, [CDXCardDeckJSONSerializer shakeActionFromString:@"?" defaultsTo:CDXCardDeckShakeActionNone]);
    XCTAssertEqual(CDXCardDeckShakeActionRandom, [CDXCardDeckJSONSerializer shakeActionFromString:@"?" defaultsTo:CDXCardDeckShakeActionRandom]);
}

- (void)testShakeActionToString {
    XCTAssertEqualObjects(@"off", [CDXCardDeckJSONSerializer stringFromShakeAction:CDXCardDeckShakeActionNone]);
    XCTAssertEqualObjects(@"random", [CDXCardDeckJSONSerializer stringFromShakeAction:CDXCardDeckShakeActionRandom]);
    XCTAssertEqualObjects(@"shuffle", [CDXCardDeckJSONSerializer stringFromShakeAction:CDXCardDeckShakeActionShuffle]);
    XCTAssertEqualObjects(@"shuffle", [CDXCardDeckJSONSerializer stringFromShakeAction:CDXCardDeckShakeActionCount]);
}

- (void)testShakeActionToFromString {
    for (CDXCardDeckShakeAction i = (CDXCardDeckShakeAction) 0; i < CDXCardDeckShakeActionCount; ++i) {
        XCTAssertEqual(i, [CDXCardDeckJSONSerializer shakeActionFromString:[CDXCardDeckJSONSerializer stringFromShakeAction:i] defaultsTo:(CDXCardDeckShakeAction) 0]);
        XCTAssertEqual(i, [CDXCardDeckJSONSerializer shakeActionFromString:[CDXCardDeckJSONSerializer stringFromShakeAction:i] defaultsTo:(CDXCardDeckShakeAction) 1]);
    }
    XCTAssertEqual(CDXCardDeckShakeActionDefault, [CDXCardDeckJSONSerializer shakeActionFromString:[CDXCardDeckJSONSerializer stringFromShakeAction:CDXCardDeckShakeActionCount] defaultsTo:(CDXCardDeckShakeAction) 0]);
    XCTAssertEqual(CDXCardDeckShakeActionDefault, [CDXCardDeckJSONSerializer shakeActionFromString:[CDXCardDeckJSONSerializer stringFromShakeAction:CDXCardDeckShakeActionCount] defaultsTo:(CDXCardDeckShakeAction) 1]);
}

- (void)testAutoPlayFromString {
    XCTAssertEqual(CDXCardDeckAutoPlayOff, [CDXCardDeckJSONSerializer autoPlayFromString:@"off" defaultsTo:CDXCardDeckAutoPlayPlay]);
    XCTAssertEqual(CDXCardDeckAutoPlayPlay, [CDXCardDeckJSONSerializer autoPlayFromString:@"play1x" defaultsTo:CDXCardDeckAutoPlayOff]);
    XCTAssertEqual(CDXCardDeckAutoPlayPlay2, [CDXCardDeckJSONSerializer autoPlayFromString:@"play5x" defaultsTo:CDXCardDeckAutoPlayOff]);
    XCTAssertEqual(3, CDXCardDeckAutoPlayCount);
    XCTAssertEqual(CDXCardDeckAutoPlayOff, [CDXCardDeckJSONSerializer autoPlayFromString:@"?" defaultsTo:CDXCardDeckAutoPlayOff]);
    XCTAssertEqual(CDXCardDeckAutoPlayPlay, [CDXCardDeckJSONSerializer autoPlayFromString:@"?" defaultsTo:CDXCardDeckAutoPlayPlay]);
}

- (void)testAutoPlayToString {
    XCTAssertEqualObjects(@"off", [CDXCardDeckJSONSerializer stringFromAutoPlay:CDXCardDeckAutoPlayOff]);
    XCTAssertEqualObjects(@"play1x", [CDXCardDeckJSONSerializer stringFromAutoPlay:CDXCardDeckAutoPlayPlay]);
    XCTAssertEqualObjects(@"play5x", [CDXCardDeckJSONSerializer stringFromAutoPlay:CDXCardDeckAutoPlayPlay2]);
    XCTAssertEqualObjects(@"off", [CDXCardDeckJSONSerializer stringFromAutoPlay:CDXCardDeckAutoPlayCount]);
}

- (void)testAutoPlayToFromString {
    for (CDXCardDeckAutoPlay i = (CDXCardDeckAutoPlay) 0; i < CDXCardDeckAutoPlayCount; ++i) {
        XCTAssertEqual(i, [CDXCardDeckJSONSerializer autoPlayFromString:[CDXCardDeckJSONSerializer stringFromAutoPlay:i] defaultsTo:(CDXCardDeckAutoPlay) 0]);
        XCTAssertEqual(i, [CDXCardDeckJSONSerializer autoPlayFromString:[CDXCardDeckJSONSerializer stringFromAutoPlay:i] defaultsTo:(CDXCardDeckAutoPlay) 1]);
    }
    XCTAssertEqual(CDXCardDeckAutoPlayDefault, [CDXCardDeckJSONSerializer autoPlayFromString:[CDXCardDeckJSONSerializer stringFromAutoPlay:CDXCardDeckAutoPlayCount] defaultsTo:(CDXCardDeckAutoPlay) 0]);
    XCTAssertEqual(CDXCardDeckAutoPlayDefault, [CDXCardDeckJSONSerializer autoPlayFromString:[CDXCardDeckJSONSerializer stringFromAutoPlay:CDXCardDeckAutoPlayCount] defaultsTo:(CDXCardDeckAutoPlay) 1]);
}

- (void)testVersion2StringFromCardDeck {
    NSString *string = [self stringFromFile:@"CDXCardDeckJSONSerializerTestsDeck1.carddeck.json"];
    CDXCardDeck *deck = [CDXCardDeckJSONSerializer cardDeckFromVersion2String:string];
    
    NSString *expected = @""
    @"{"
    @"\n  \"name\" : \"numbers\","
    @"\n  \"group_size\" : 1,"
    @"\n  \"deck_style\" : \"stacked,swipe\","
    @"\n  \"corner_style\" : \"rounded\","
    @"\n  \"index_dots\" : \"on\","
    @"\n  \"index_style\" : \"light\","
    @"\n  \"index_touches\" : \"on\","
    @"\n  \"auto_rotate\" : \"on\","
    @"\n  \"shake\" : \"shuffle\","
    @"\n  \"auto_play\" : \"play1x\","
    @"\n  \"default_card\" : {"
    @"\n    \"text\" : \"default\","
    @"\n    \"text_color\" : \"f8f8f8f8\","
    @"\n    \"background_color\" : \"08080808\","
    @"\n    \"orientation\" : \"up\","
    @"\n    \"font_size\" : 1,"
    @"\n    \"timer\" : 2"
    @"\n  },"
    @"\n  \"cards\" : ["
    @"\n    {"
    @"\n      \"text\" : \"ok1\","
    @"\n      \"text_color\" : \"12345678\","
    @"\n      \"background_color\" : \"17654328\","
    @"\n      \"orientation\" : \"left\","
    @"\n      \"font_size\" : 50,"
    @"\n      \"timer\" : 100"
    @"\n    },"
    @"\n    {"
    @"\n      \"text\" : \"bad1\","
    @"\n      \"font_size\" : 100,"
    @"\n      \"timer\" : 1"
    @"\n    },"
    @"\n    {"
    @"\n"
    @"\n    },"
    @"\n    {"
    @"\n      \"text\" : \"bad3\","
    @"\n      \"font_size\" : 100,"
    @"\n      \"timer\" : 3600"
    @"\n    },"
    @"\n    {"
    @"\n"
    @"\n    }"
    @"\n  ]"
    @"\n}";
    
    XCTAssertEqualObjects(expected, [CDXCardDeckJSONSerializer version2StringFromCardDeck:deck]);

    XCTAssertEqualObjects(expected, [CDXCardDeckJSONSerializer version2StringFromCardDeck:[CDXCardDeckJSONSerializer cardDeckFromVersion2String:expected]]);
}

@end

