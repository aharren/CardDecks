//
//
// CDXCardDeckURLSerializerTests.m
//
//
// Copyright (c) 2009-2020 Arne Harren <ah@0xc0.de>
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
#import "CDXCardDeckURLSerializer.h"


@interface CDXCardDeckURLSerializerTests : XCTestCase {
    
}

@end


@implementation CDXCardDeckURLSerializerTests

- (void)testCardDeckFromVersion1StringNames {
    NSString *string = @""
    "card%20deck"
    "&card%201"
    "&card%202";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects(defaults.textColor, [CDXColor colorWhite]);
    XCTAssertEqualObjects(defaults.backgroundColor, [CDXColor colorBlack]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual(defaults.timerInterval, CDXCardTimerIntervalDefault);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([deck cardAtIndex:0].textColor, [CDXColor colorWhite]);
    XCTAssertEqualObjects([deck cardAtIndex:0].backgroundColor, [CDXColor colorBlack]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual([deck cardAtIndex:0].timerInterval, CDXCardTimerIntervalDefault);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([deck cardAtIndex:1].textColor, [CDXColor colorWhite]);
    XCTAssertEqualObjects([deck cardAtIndex:1].backgroundColor, [CDXColor colorBlack]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual([deck cardAtIndex:1].timerInterval, CDXCardTimerIntervalDefault);
}

- (void)testCardDeckFromVersion1StringDefaultCardColors {
    NSString *string = @""
    "card%20deck,010203,040506"
    "&card%201"
    "&card%202";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
}

- (void)testCardDeckFromVersion1StringDefaultCardColorsComma {
    NSString *string = @""
    "card%20deck,010203,040506"
    "&card%201,"
    "&card%202,";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
}

- (void)testCardDeckFromVersion1StringDefaultCardColorsCommaComma {
    NSString *string = @""
    "card%20deck,010203,040506"
    "&card%201,,"
    "&card%202,,";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
}

- (void)testCardDeckFromVersion1StringBadCardColors {
    NSString *string = @""
    "card%20deck,010203,040506"
    "&card%201,bad,color"
    "&card%202,bad,color";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
}

- (void)testCardDeckFromVersion1StringDefaultCardBackgroundColorRGB {
    NSString *string = @""
    "card%20deck,331122,000000"
    "&card%201,111214"
    "&card%202,102141";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x33 green:0x11 blue:0x22 alpha:0xff]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x11 green:0x12 blue:0x14 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x10 green:0x21 blue:0x41 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
}

- (void)testCardDeckFromVersion1StringDefaultCardBackgroundColorRGBA {
    NSString *string = @""
    "card%20deck,33112244,00000055"
    "&card%201,11121466"
    "&card%202,10214177";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x33 green:0x11 blue:0x22 alpha:0x44]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0x55]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x11 green:0x12 blue:0x14 alpha:0x66]);
    XCTAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0x55]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x10 green:0x21 blue:0x41 alpha:0x77]);
    XCTAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0x55]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
}

- (void)testCardDeckFromVersion1StringDefaultCardBackgroundColorRGBComma {
    NSString *string = @""
    "card%20deck,331122,000000"
    "&card%201,111214,"
    "&card%202,102141,";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x33 green:0x11 blue:0x22 alpha:0xff]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x11 green:0x12 blue:0x14 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x10 green:0x21 blue:0x41 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
}

- (void)testCardDeckFromVersion1StringDefaultCardTextColorRGB {
    NSString *string = @""
    "card%20deck,010101,112233"
    "&card%201,,88898a"
    "&card%202,,556575";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x01 green:0x01 blue:0x01 alpha:0xff]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x11 green:0x22 blue:0x33 alpha:0xff]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x01 green:0x01 blue:0x01 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x88 green:0x89 blue:0x8a alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x01 green:0x01 blue:0x01 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x55 green:0x65 blue:0x75 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
}

- (void)testCardDeckFromVersion1StringDefaultCardTextColorRGBA {
    NSString *string = @""
    "card%20deck,010101,112233"
    "&card%201,,88898a32"
    "&card%202,,55657512";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x01 green:0x01 blue:0x01 alpha:0xff]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x11 green:0x22 blue:0x33 alpha:0xff]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x01 green:0x01 blue:0x01 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x88 green:0x89 blue:0x8a alpha:0x32]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x01 green:0x01 blue:0x01 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x55 green:0x65 blue:0x75 alpha:0x12]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
}

- (void)testCardDeckFromVersion1StringOrientationNoDefaultOrientation {
    NSString *string = @""
    "card%20deck,010203,040506"
    "&card%201"
    "&card%202,020202,,u"
    "&card%203,030303,,r"
    "&card%204,040404,,d"
    "&card%205,050505,,l"
    "&card%206,020202,060606,u"
    "&card%207,030303,070707,r"
    "&card%208,040404,080808,d"
    "&card%209,050505,090909,l"
    "&card%20a,,,l"
    "&card%20b,,,x"
    "&card%20a,,,";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    XCTAssertEqual([deck cardsCount], (NSUInteger)12);
    
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:2].orientation, (int)CDXCardOrientationRight);
    XCTAssertEqual((int)[deck cardAtIndex:3].orientation, (int)CDXCardOrientationDown);
    XCTAssertEqual((int)[deck cardAtIndex:4].orientation, (int)CDXCardOrientationLeft);
    XCTAssertEqual((int)[deck cardAtIndex:5].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:6].orientation, (int)CDXCardOrientationRight);
    XCTAssertEqual((int)[deck cardAtIndex:7].orientation, (int)CDXCardOrientationDown);
    XCTAssertEqual((int)[deck cardAtIndex:8].orientation, (int)CDXCardOrientationLeft);
    XCTAssertEqual((int)[deck cardAtIndex:9].orientation, (int)CDXCardOrientationLeft);
    XCTAssertEqual((int)[deck cardAtIndex:10].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:11].orientation, (int)CDXCardOrientationUp);
}

- (void)testCardDeckFromVersion1StringOrientationDefaultOrientationDown {
    NSString *string = @""
    "card%20deck,010203,040506,d"
    "&card%201"
    "&card%202,020202,,u"
    "&card%203,030303,,r"
    "&card%204,040404,,d"
    "&card%205,050505,,l"
    "&card%206,020202,060606,u"
    "&card%207,030303,070707,r"
    "&card%208,040404,080808,d"
    "&card%209,050505,090909,l"
    "&card%20a,,,l"
    "&card%20b,,,x"
    "&card%20a,,,";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    XCTAssertEqual([deck cardsCount], (NSUInteger)12);
    
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationDown);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationDown);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:2].orientation, (int)CDXCardOrientationRight);
    XCTAssertEqual((int)[deck cardAtIndex:3].orientation, (int)CDXCardOrientationDown);
    XCTAssertEqual((int)[deck cardAtIndex:4].orientation, (int)CDXCardOrientationLeft);
    XCTAssertEqual((int)[deck cardAtIndex:5].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:6].orientation, (int)CDXCardOrientationRight);
    XCTAssertEqual((int)[deck cardAtIndex:7].orientation, (int)CDXCardOrientationDown);
    XCTAssertEqual((int)[deck cardAtIndex:8].orientation, (int)CDXCardOrientationLeft);
    XCTAssertEqual((int)[deck cardAtIndex:9].orientation, (int)CDXCardOrientationLeft);
    XCTAssertEqual((int)[deck cardAtIndex:10].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:11].orientation, (int)CDXCardOrientationDown);
}

- (void)testCardDeckFromVersion2StringCards {
    NSString *string = @""
    "card%20deck"
    "&defaults,331122,000000"
    "&card%201,111214"
    "&card%202,102141,65644432,,5";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects(defaults.text, @"defaults");
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x33 green:0x11 blue:0x22 alpha:0xff]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)defaults.fontSize, (int)0);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x11 green:0x12 blue:0x14 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:0].fontSize, (int)0);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x10 green:0x21 blue:0x41 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x65 green:0x64 blue:0x44 alpha:0x32]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:1].fontSize, (int)5);
}

- (void)testCardDeckFromVersion2StringFontSize {
    NSString *string = @""
    "card%20deck"
    "&defaults,331122,000000,u,3"
    "&card%201,111214"
    "&card%202,102141,65644432,d,5"
    "&card%203,102141,65644432,u,,";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects(defaults.text, @"defaults");
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x33 green:0x11 blue:0x22 alpha:0xff]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)defaults.fontSize, (int)3);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x11 green:0x12 blue:0x14 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:0].fontSize, (int)3);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x10 green:0x21 blue:0x41 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x65 green:0x64 blue:0x44 alpha:0x32]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationDown);
    XCTAssertEqual((int)[deck cardAtIndex:1].fontSize, (int)5);
    
    XCTAssertEqualObjects([deck cardAtIndex:2].text, @"card 3");
    XCTAssertEqualObjects([[deck cardAtIndex:2] textColor], [CDXColor colorWithRed:0x10 green:0x21 blue:0x41 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:2] backgroundColor], [CDXColor colorWithRed:0x65 green:0x64 blue:0x44 alpha:0x32]);
    XCTAssertEqual((int)[deck cardAtIndex:2].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:2].fontSize, (int)3);
}

- (void)testCardDeckFromVersion2StringTimerInterval {
    NSString *string = @""
    "card%20deck"
    "&defaults,331122,000000,u,3,30"
    "&card%201,111214"
    "&card%202,102141,65644432,d,5,13"
    "&card%203,102141,65644432,u,,,";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    CDXCard *defaults = deck.cardDefaults;
    XCTAssertEqualObjects(defaults.text, @"defaults");
    XCTAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x33 green:0x11 blue:0x22 alpha:0xff]);
    XCTAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff]);
    XCTAssertEqual((int)defaults.orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)defaults.fontSize, (int)3);
    XCTAssertEqual(defaults.timerInterval, (NSTimeInterval)30);
    
    XCTAssertEqualObjects([deck cardAtIndex:0].text, @"card 1");
    XCTAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x11 green:0x12 blue:0x14 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff]);
    XCTAssertEqual((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:0].fontSize, (int)3);
    XCTAssertEqual([deck cardAtIndex:0].timerInterval, (NSTimeInterval)30);
    
    XCTAssertEqualObjects([deck cardAtIndex:1].text, @"card 2");
    XCTAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x10 green:0x21 blue:0x41 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x65 green:0x64 blue:0x44 alpha:0x32]);
    XCTAssertEqual((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationDown);
    XCTAssertEqual((int)[deck cardAtIndex:1].fontSize, (int)5);
    XCTAssertEqual([deck cardAtIndex:1].timerInterval, (NSTimeInterval)13);
    
    XCTAssertEqualObjects([deck cardAtIndex:2].text, @"card 3");
    XCTAssertEqualObjects([[deck cardAtIndex:2] textColor], [CDXColor colorWithRed:0x10 green:0x21 blue:0x41 alpha:0xff]);
    XCTAssertEqualObjects([[deck cardAtIndex:2] backgroundColor], [CDXColor colorWithRed:0x65 green:0x64 blue:0x44 alpha:0x32]);
    XCTAssertEqual((int)[deck cardAtIndex:2].orientation, (int)CDXCardOrientationUp);
    XCTAssertEqual((int)[deck cardAtIndex:2].fontSize, (int)3);
    XCTAssertEqual([deck cardAtIndex:2].timerInterval, (NSTimeInterval)30);
}

- (void)testCardDeckFromVersion2StringSettings0 {
    NSString *string = @""
    "card%20deck,g0,d0,c0,id0,is0,it0,r0,s0"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    XCTAssertEqual(deck.groupSize, 0);
    XCTAssertEqual(deck.displayStyle, 0);
    XCTAssertEqual(deck.cornerStyle, 0);
    XCTAssertEqual(deck.wantsPageControl, NO);
    XCTAssertEqual(deck.pageControlStyle, 0);
    XCTAssertEqual(deck.wantsPageJumps, NO);
    XCTAssertEqual(deck.wantsAutoRotate, NO);
    XCTAssertEqual(deck.shakeAction, 0);
    XCTAssertEqual(deck.autoPlay, 0);
}

- (void)testCardDeckFromVersion2StringSettings1 {
    NSString *string = @""
    "card%20deck,g1,d1,c1,id1,is1,it1,r1,s1,ap1"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    XCTAssertEqual(deck.groupSize, 1);
    XCTAssertEqual(deck.displayStyle, 1);
    XCTAssertEqual(deck.cornerStyle, 1);
    XCTAssertEqual(deck.wantsPageControl, YES);
    XCTAssertEqual(deck.pageControlStyle, 1);
    XCTAssertEqual(deck.wantsPageJumps, YES);
    XCTAssertEqual(deck.wantsAutoRotate, YES);
    XCTAssertEqual(deck.shakeAction, 1);
    XCTAssertEqual(deck.autoPlay, 1);
}

- (void)testCardDeckFromVersion2StringSettings01 {
    NSString *string = @""
    "card%20deck,g0,d1,c0,id1,is0,it1,r0,s1,ap0"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    XCTAssertEqual(deck.groupSize, 0);
    XCTAssertEqual(deck.displayStyle, 1);
    XCTAssertEqual(deck.cornerStyle, 0);
    XCTAssertEqual(deck.wantsPageControl, YES);
    XCTAssertEqual(deck.pageControlStyle, 0);
    XCTAssertEqual(deck.wantsPageJumps, YES);
    XCTAssertEqual(deck.wantsAutoRotate, NO);
    XCTAssertEqual(deck.shakeAction, 1);
    XCTAssertEqual(deck.autoPlay, 0);
}

- (void)testCardDeckFromVersion2StringSettings10 {
    NSString *string = @""
    "card%20deck,g1,d0,c1,id0,is1,it0,r1,s0,ap1"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    XCTAssertEqualObjects(deck.name, @"card deck");
    XCTAssertEqual(deck.groupSize, 1);
    XCTAssertEqual(deck.displayStyle, 0);
    XCTAssertEqual(deck.cornerStyle, 1);
    XCTAssertEqual(deck.wantsPageControl, NO);
    XCTAssertEqual(deck.pageControlStyle, 1);
    XCTAssertEqual(deck.wantsPageJumps, NO);
    XCTAssertEqual(deck.wantsAutoRotate, YES);
    XCTAssertEqual(deck.shakeAction, 0);
    XCTAssertEqual(deck.autoPlay, 1);
}

- (void)testVersion2StringFromCardDeckCards {
    NSString *string = @""
    "card%20deck"
    "&defaults,331122,000000,u,3"
    "&card%201,111214,,,7"
    "&card%202,102141,65644432,r";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
   
    NSString *string2 = [CDXCardDeckURLSerializer version2StringFromCardDeck:deck];
    XCTAssertEqualObjects(string2, @"card%20deck,g0,d0,c0,id1,is0,it1,r1,s1,ap0&defaults,331122ff,000000ff,u,3,5&card%201,111214ff,,,7&card%202,102141ff,65644432,r");
}

- (void)testVersion2StringFromCardDeckSettings0 {
    NSString *string = @""
    "card%20deck,g0,d0,c0,id0,is0,it0,r0,s0,ap0"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    NSString *string2 = [CDXCardDeckURLSerializer version2StringFromCardDeck:deck];
    XCTAssertEqualObjects(string2, @"card%20deck,g0,d0,c0,id0,is0,it0,r0,s0,ap0&,000000ff,ffffffff,u,0,5");
}

- (void)testVersion2StringFromCardDeckSettings1 {
    NSString *string = @""
    "card%21deck,g1,d1,c1,id1,is1,it1,r1,s1,ap1"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    NSString *string2 = [CDXCardDeckURLSerializer version2StringFromCardDeck:deck];
    XCTAssertEqualObjects(string2, @"card%21deck,g1,d1,c1,id1,is1,it1,r1,s1,ap1&,000000ff,ffffffff,u,0,5");
}

- (void)testVersion2StringFromCardDeckSettings01 {
    NSString *string = @""
    "card%21deck,g0,d1,c0,id1,is0,it1,r0,s1,ap0"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    NSString *string2 = [CDXCardDeckURLSerializer version2StringFromCardDeck:deck];
    XCTAssertEqualObjects(string2, @"card%21deck,g0,d1,c0,id1,is0,it1,r0,s1,ap0&,000000ff,ffffffff,u,0,5");
}

- (void)testVersion2StringFromCardDeckSettings10 {
    NSString *string = @""
    "card%21deck,g1,d0,c1,id0,is1,it0,r1,s0,ap1"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    NSString *string2 = [CDXCardDeckURLSerializer version2StringFromCardDeck:deck];
    XCTAssertEqualObjects(string2, @"card%21deck,g1,d0,c1,id0,is1,it0,r1,s0,ap1&,000000ff,ffffffff,u,0,5");
}

@end

