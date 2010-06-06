//
//
// CDXCardDeckDictionarySerializerTests.m
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
#import "CDXCardDeckDictionarySerializer.h"


@interface CDXCardDeckDictionarySerializerTests : SenTestCase {
    
}

@end


@implementation CDXCardDeckDictionarySerializerTests

- (void)testCardDeckFromVersion1Dictionary {
    NSString *path = [[NSBundle bundleForClass:[CDXCardDeckDictionarySerializerTests class]] pathForResource:@"CDXCardDeckDictionarySerializerTestsDeck1.CardDeck" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    STAssertNotNil(dictionary, nil);
    
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

@end

