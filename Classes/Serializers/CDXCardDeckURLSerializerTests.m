//
//
// CDXCardDeckURLSerializerTests.m
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
#import "CDXCardDeckURLSerializer.h"


@interface CDXCardDeckURLSerializerTests : SenTestCase {
    
}

@end


@implementation CDXCardDeckURLSerializerTests

- (void)testCardDeckFromVersion1StringNames {
    NSString *string = @""
    "card%20deck"
    "&card%201"
    "&card%202";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects(defaults.textColor, [CDXColor colorWhite], nil);
    STAssertEqualObjects(defaults.backgroundColor, [CDXColor colorBlack], nil);
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:0].text, @"card 1", nil);
    STAssertEqualObjects([deck cardAtIndex:0].textColor, [CDXColor colorWhite], nil);
    STAssertEqualObjects([deck cardAtIndex:0].backgroundColor, [CDXColor colorBlack], nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:1].text, @"card 2", nil);
    STAssertEqualObjects([deck cardAtIndex:1].textColor, [CDXColor colorWhite], nil);
    STAssertEqualObjects([deck cardAtIndex:1].backgroundColor, [CDXColor colorBlack], nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
}

- (void)testCardDeckFromVersion1StringDefaultCardColors {
    NSString *string = @""
    "card%20deck,010203,040506"
    "&card%201"
    "&card%202";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff], nil);
    STAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff], nil);
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:0].text, @"card 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:1].text, @"card 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
}

- (void)testCardDeckFromVersion1StringDefaultCardColorsComma {
    NSString *string = @""
    "card%20deck,010203,040506"
    "&card%201,"
    "&card%202,";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff], nil);
    STAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff], nil);
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:0].text, @"card 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:1].text, @"card 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
}

- (void)testCardDeckFromVersion1StringDefaultCardColorsCommaComma {
    NSString *string = @""
    "card%20deck,010203,040506"
    "&card%201,,"
    "&card%202,,";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff], nil);
    STAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff], nil);
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:0].text, @"card 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:1].text, @"card 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
}

- (void)testCardDeckFromVersion1StringBadCardColors {
    NSString *string = @""
    "card%20deck,010203,040506"
    "&card%201,bad,color"
    "&card%202,bad,color";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff], nil);
    STAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff], nil);
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:0].text, @"card 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:1].text, @"card 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x01 green:0x02 blue:0x03 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x04 green:0x05 blue:0x06 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
}

- (void)testCardDeckFromVersion1StringDefaultCardBackgroundColorRGB {
    NSString *string = @""
    "card%20deck,331122,000000"
    "&card%201,111214"
    "&card%202,102141";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x33 green:0x11 blue:0x22 alpha:0xff], nil);
    STAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff], nil);
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:0].text, @"card 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x11 green:0x12 blue:0x14 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:1].text, @"card 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x10 green:0x21 blue:0x41 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
}

- (void)testCardDeckFromVersion1StringDefaultCardBackgroundColorRGBA {
    NSString *string = @""
    "card%20deck,33112244,00000055"
    "&card%201,11121466"
    "&card%202,10214177";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x33 green:0x11 blue:0x22 alpha:0x44], nil);
    STAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0x55], nil);
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:0].text, @"card 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x11 green:0x12 blue:0x14 alpha:0x66], nil);
    STAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0x55], nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:1].text, @"card 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x10 green:0x21 blue:0x41 alpha:0x77], nil);
    STAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0x55], nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
}

- (void)testCardDeckFromVersion1StringDefaultCardBackgroundColorRGBComma {
    NSString *string = @""
    "card%20deck,331122,000000"
    "&card%201,111214,"
    "&card%202,102141,";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x33 green:0x11 blue:0x22 alpha:0xff], nil);
    STAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff], nil);
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:0].text, @"card 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x11 green:0x12 blue:0x14 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:1].text, @"card 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x10 green:0x21 blue:0x41 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
}

- (void)testCardDeckFromVersion1StringDefaultCardTextColorRGB {
    NSString *string = @""
    "card%20deck,010101,112233"
    "&card%201,,88898a"
    "&card%202,,556575";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x01 green:0x01 blue:0x01 alpha:0xff], nil);
    STAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x11 green:0x22 blue:0x33 alpha:0xff], nil);
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:0].text, @"card 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x01 green:0x01 blue:0x01 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x88 green:0x89 blue:0x8a alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:1].text, @"card 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x01 green:0x01 blue:0x01 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x55 green:0x65 blue:0x75 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
}

- (void)testCardDeckFromVersion1StringDefaultCardTextColorRGBA {
    NSString *string = @""
    "card%20deck,010101,112233"
    "&card%201,,88898a32"
    "&card%202,,55657512";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x01 green:0x01 blue:0x01 alpha:0xff], nil);
    STAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x11 green:0x22 blue:0x33 alpha:0xff], nil);
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:0].text, @"card 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x01 green:0x01 blue:0x01 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x88 green:0x89 blue:0x8a alpha:0x32], nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp, nil);
    
    STAssertEqualObjects([deck cardAtIndex:1].text, @"card 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x01 green:0x01 blue:0x01 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x55 green:0x65 blue:0x75 alpha:0x12], nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
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
    "&card%20b,,,x";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    STAssertEquals([deck cardsCount], (NSUInteger)11, nil);
    
    CDXCard *defaults = deck.cardDefaults;
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationUp, nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp, nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
    STAssertEquals((int)[deck cardAtIndex:2].orientation, (int)CDXCardOrientationRight, nil);
    STAssertEquals((int)[deck cardAtIndex:3].orientation, (int)CDXCardOrientationDown, nil);
    STAssertEquals((int)[deck cardAtIndex:4].orientation, (int)CDXCardOrientationLeft, nil);
    STAssertEquals((int)[deck cardAtIndex:5].orientation, (int)CDXCardOrientationUp, nil);
    STAssertEquals((int)[deck cardAtIndex:6].orientation, (int)CDXCardOrientationRight, nil);
    STAssertEquals((int)[deck cardAtIndex:7].orientation, (int)CDXCardOrientationDown, nil);
    STAssertEquals((int)[deck cardAtIndex:8].orientation, (int)CDXCardOrientationLeft, nil);
    STAssertEquals((int)[deck cardAtIndex:9].orientation, (int)CDXCardOrientationLeft, nil);
    STAssertEquals((int)[deck cardAtIndex:10].orientation, (int)CDXCardOrientationUp, nil);
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
    "&card%20b,,,x";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    STAssertEquals([deck cardsCount], (NSUInteger)11, nil);
    
    CDXCard *defaults = deck.cardDefaults;
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationDown, nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationDown, nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
    STAssertEquals((int)[deck cardAtIndex:2].orientation, (int)CDXCardOrientationRight, nil);
    STAssertEquals((int)[deck cardAtIndex:3].orientation, (int)CDXCardOrientationDown, nil);
    STAssertEquals((int)[deck cardAtIndex:4].orientation, (int)CDXCardOrientationLeft, nil);
    STAssertEquals((int)[deck cardAtIndex:5].orientation, (int)CDXCardOrientationUp, nil);
    STAssertEquals((int)[deck cardAtIndex:6].orientation, (int)CDXCardOrientationRight, nil);
    STAssertEquals((int)[deck cardAtIndex:7].orientation, (int)CDXCardOrientationDown, nil);
    STAssertEquals((int)[deck cardAtIndex:8].orientation, (int)CDXCardOrientationLeft, nil);
    STAssertEquals((int)[deck cardAtIndex:9].orientation, (int)CDXCardOrientationLeft, nil);
    STAssertEquals((int)[deck cardAtIndex:10].orientation, (int)CDXCardOrientationUp, nil);
}

- (void)testCardDeckFromVersion2StringCards {
    NSString *string = @""
    "card%20deck"
    "&defaults,331122,000000"
    "&card%201,111214"
    "&card%202,102141,65644432,,5";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    CDXCard *defaults = deck.cardDefaults;
    STAssertEqualObjects(defaults.text, @"defaults", nil);
    STAssertEqualObjects([defaults textColor], [CDXColor colorWithRed:0x33 green:0x11 blue:0x22 alpha:0xff], nil);
    STAssertEqualObjects([defaults backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff], nil);
    STAssertEquals((int)defaults.orientation, (int)CDXCardOrientationUp, nil);
    STAssertEquals((int)defaults.fontSize, (int)0, nil);
    
    STAssertEqualObjects([deck cardAtIndex:0].text, @"card 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:0] textColor], [CDXColor colorWithRed:0x11 green:0x12 blue:0x14 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:0] backgroundColor], [CDXColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0xff], nil);
    STAssertEquals((int)[deck cardAtIndex:0].orientation, (int)CDXCardOrientationUp, nil);
    STAssertEquals((int)[deck cardAtIndex:0].fontSize, (int)0, nil);
    
    STAssertEqualObjects([deck cardAtIndex:1].text, @"card 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] textColor], [CDXColor colorWithRed:0x10 green:0x21 blue:0x41 alpha:0xff], nil);
    STAssertEqualObjects([[deck cardAtIndex:1] backgroundColor], [CDXColor colorWithRed:0x65 green:0x64 blue:0x44 alpha:0x32], nil);
    STAssertEquals((int)[deck cardAtIndex:1].orientation, (int)CDXCardOrientationUp, nil);
    STAssertEquals((int)[deck cardAtIndex:1].fontSize, (int)5, nil);
}

- (void)testCardDeckFromVersion2StringSettings0 {
    NSString *string = @""
    "card%20deck,g0,d0,c0,id0,is0,it0,r0,s0"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    STAssertEquals(deck.groupSize, 0, nil);
    STAssertEquals(deck.displayStyle, 0, nil);
    STAssertEquals(deck.cornerStyle, 0, nil);
    STAssertEquals(deck.wantsPageControl, NO, nil);
    STAssertEquals(deck.pageControlStyle, 0, nil);
    STAssertEquals(deck.wantsPageJumps, NO, nil);
    STAssertEquals(deck.wantsAutoRotate, NO, nil);
    STAssertEquals(deck.wantsShakeShuffle, NO, nil);
}

- (void)testCardDeckFromVersion2StringSettings1 {
    NSString *string = @""
    "card%20deck,g1,d1,c1,id1,is1,it1,r1,s1"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    STAssertEquals(deck.groupSize, 1, nil);
    STAssertEquals(deck.displayStyle, 1, nil);
    STAssertEquals(deck.cornerStyle, 1, nil);
    STAssertEquals(deck.wantsPageControl, YES, nil);
    STAssertEquals(deck.pageControlStyle, 1, nil);
    STAssertEquals(deck.wantsPageJumps, YES, nil);
    STAssertEquals(deck.wantsAutoRotate, YES, nil);
    STAssertEquals(deck.wantsShakeShuffle, YES, nil);
}

- (void)testCardDeckFromVersion2StringSettings01 {
    NSString *string = @""
    "card%20deck,g0,d1,c0,id1,is0,it1,r0,s1"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    STAssertEquals(deck.groupSize, 0, nil);
    STAssertEquals(deck.displayStyle, 1, nil);
    STAssertEquals(deck.cornerStyle, 0, nil);
    STAssertEquals(deck.wantsPageControl, YES, nil);
    STAssertEquals(deck.pageControlStyle, 0, nil);
    STAssertEquals(deck.wantsPageJumps, YES, nil);
    STAssertEquals(deck.wantsAutoRotate, NO, nil);
    STAssertEquals(deck.wantsShakeShuffle, YES, nil);
}

- (void)testCardDeckFromVersion2StringSettings10 {
    NSString *string = @""
    "card%20deck,g1,d0,c1,id0,is1,it0,r1,s0"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    STAssertEqualObjects(deck.name, @"card deck", nil);
    STAssertEquals(deck.groupSize, 1, nil);
    STAssertEquals(deck.displayStyle, 0, nil);
    STAssertEquals(deck.cornerStyle, 1, nil);
    STAssertEquals(deck.wantsPageControl, NO, nil);
    STAssertEquals(deck.pageControlStyle, 1, nil);
    STAssertEquals(deck.wantsPageJumps, NO, nil);
    STAssertEquals(deck.wantsAutoRotate, YES, nil);
    STAssertEquals(deck.wantsShakeShuffle, NO, nil);
}

- (void)testVersion2StringFromCardDeckCards {
    NSString *string = @""
    "card%20deck"
    "&defaults,331122,000000,u,3"
    "&card%201,111214,,,7"
    "&card%202,102141,65644432,r";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
   
    NSString *string2 = [CDXCardDeckURLSerializer version2StringFromCardDeck:deck];
    STAssertEqualObjects(string2, @"card%20deck,g0,d0,c0,id1,is0,it1,r0,s1&defaults,331122ff,000000ff,u,3&card%201,111214ff,,,7&card%202,102141ff,65644432,r", nil);
}

- (void)testVersion2StringFromCardDeckSettings0 {
    NSString *string = @""
    "card%20deck,g0,d0,c0,id0,is0,it0,r0,s0"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    NSString *string2 = [CDXCardDeckURLSerializer version2StringFromCardDeck:deck];
    STAssertEqualObjects(string2, @"card%20deck,g0,d0,c0,id0,is0,it0,r0,s0&,000000ff,ffffffff,u,0", nil);
}

- (void)testVersion2StringFromCardDeckSettings1 {
    NSString *string = @""
    "card%21deck,g1,d1,c1,id1,is1,it1,r1,s1"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    NSString *string2 = [CDXCardDeckURLSerializer version2StringFromCardDeck:deck];
    STAssertEqualObjects(string2, @"card%21deck,g1,d1,c1,id1,is1,it1,r1,s1&,000000ff,ffffffff,u,0", nil);
}

- (void)testVersion2StringFromCardDeckSettings01 {
    NSString *string = @""
    "card%21deck,g0,d1,c0,id1,is0,it1,r0,s1"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    NSString *string2 = [CDXCardDeckURLSerializer version2StringFromCardDeck:deck];
    STAssertEqualObjects(string2, @"card%21deck,g0,d1,c0,id1,is0,it1,r0,s1&,000000ff,ffffffff,u,0", nil);
}

- (void)testVersion2StringFromCardDeckSettings10 {
    NSString *string = @""
    "card%21deck,g1,d0,c1,id0,is1,it0,r1,s0"
    "&";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:string];
    
    NSString *string2 = [CDXCardDeckURLSerializer version2StringFromCardDeck:deck];
    STAssertEqualObjects(string2, @"card%21deck,g1,d0,c1,id0,is1,it0,r1,s0&,000000ff,ffffffff,u,0", nil);
}

@end

