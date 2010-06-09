//
//
// CDXCardDecksDictionarySerializerTests.m
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
#import "CDXCardDecksDictionarySerializer.h"


@interface CDXCardDecksDictionarySerializerTests : SenTestCase {
    
}

@end


@implementation CDXCardDecksDictionarySerializerTests

- (NSDictionary *)dictionaryFromFile:(NSString *)file {
    NSString *path = [[NSBundle bundleForClass:[CDXCardDecksDictionarySerializerTests class]] pathForResource:file ofType:nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    STAssertNotNil(dictionary, nil);
    return dictionary;
}

- (void)testCardDecksFromVersion1Dictionary {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDecksDictionarySerializerTestsDecks1.CardDeckList.plist"];
    
    CDXCardDecks *decks = [CDXCardDecksDictionarySerializer cardDecksFromVersion1Dictionary:dictionary];
    STAssertEquals([decks cardDecksCount], (NSUInteger)5, nil);
    
    CDXCardDeckBase *deck;
    
    deck = [decks cardDeckAtIndex:0];
    STAssertEqualObjects(deck.name, @"Yes, No, Perhaps", nil);
    STAssertEqualObjects(deck.file, @"YesNoPerhaps.CardDeck", nil);
    
    deck = [decks cardDeckAtIndex:1];
    STAssertEqualObjects(deck.name, @"Red, Yellow, Green", nil);
    STAssertEqualObjects(deck.file, @"RedYellowGreen.CardDeck", nil);
    
    deck = [decks cardDeckAtIndex:2];
    STAssertEqualObjects(deck.name, @"60, 45, 30, 15, 10, 5, 0", nil);
    STAssertEqualObjects(deck.file, @"60-0.CardDeck", nil);
    
    deck = [decks cardDeckAtIndex:3];
    STAssertEqualObjects(deck.name, @"15, 10, 5, 0", nil);
    STAssertEqualObjects(deck.file, @"15-0.CardDeck", nil);
    
    deck = [decks cardDeckAtIndex:4];
    STAssertEqualObjects(deck.name, @"0, ..., 10", nil);
    STAssertEqualObjects(deck.file, @"0-10.CardDeck", nil);
}

@end

