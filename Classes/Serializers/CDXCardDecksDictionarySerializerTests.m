//
//
// CDXCardDecksDictionarySerializerTests.m
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
#import "CDXCardDecksDictionarySerializer.h"
#import "CDXCardDeckURLSerializer.h"


@interface CDXCardDecksDictionarySerializerTests : XCTestCase {
    
}

@end


@implementation CDXCardDecksDictionarySerializerTests

- (NSDictionary *)dictionaryFromFile:(NSString *)file {
    NSString *path = [[NSBundle bundleForClass:[CDXCardDecksDictionarySerializerTests class]] pathForResource:file ofType:nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    XCTAssertNotNil(dictionary);
    return dictionary;
}

- (void)testCardDecksFromVersion1Dictionary {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDecksDictionarySerializerTestsDecks1.CardDeckList.plist"];
    
    CDXCardDecks *decks = [CDXCardDecksDictionarySerializer cardDecksFromVersion1Dictionary:dictionary];
    XCTAssertEqual([decks cardDecksCount], (NSUInteger)5);
    
    CDXCardDeckBase *deck;
    
    deck = [decks cardDeckAtIndex:0];
    XCTAssertEqualObjects(deck.name, @"Yes, No, Perhaps");
    XCTAssertEqualObjects(deck.file, @"YesNoPerhaps.CardDeck");
    
    deck = [decks cardDeckAtIndex:1];
    XCTAssertEqualObjects(deck.name, @"Red, Yellow, Green");
    XCTAssertEqualObjects(deck.file, @"RedYellowGreen.CardDeck");
    
    deck = [decks cardDeckAtIndex:2];
    XCTAssertEqualObjects(deck.name, @"60, 45, 30, 15, 10, 5, 0");
    XCTAssertEqualObjects(deck.file, @"60-0.CardDeck");
    
    deck = [decks cardDeckAtIndex:3];
    XCTAssertEqualObjects(deck.name, @"15, 10, 5, 0");
    XCTAssertEqualObjects(deck.file, @"15-0.CardDeck");
    
    deck = [decks cardDeckAtIndex:4];
    XCTAssertEqualObjects(deck.name, @"0, ..., 10");
    XCTAssertEqualObjects(deck.file, @"0-10.CardDeck");
}

- (void)testCardDecksFromVersion2Dictionary {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDecksDictionarySerializerTestsDecks2.CardDeckList.plist"];
    
    CDXCardDecks *decks = [CDXCardDecksDictionarySerializer cardDecksFromVersion2Dictionary:dictionary];
    XCTAssertEqual([decks cardDecksCount], (NSUInteger)3);
    
    CDXCardDeckBase *deck;
    
    deck = [decks cardDeckAtIndex:0];
    XCTAssertEqualObjects(deck.name, @"0, ..., 10");
    XCTAssertEqualObjects(deck.description, @"0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10");
    XCTAssertEqualObjects(deck.file, @"File1");
    XCTAssertNil(deck.thumbnailColor);
    XCTAssertEqual(deck.cardsCount, (NSUInteger)11);
    
    deck = [decks cardDeckAtIndex:1];
    XCTAssertEqualObjects(deck.name, @"Estimation 1");
    XCTAssertEqualObjects(deck.description, @"0, 1, 2, 4, 8, 16, 32, 64");
    XCTAssertEqualObjects(deck.file, @"File2");
    XCTAssertEqualObjects([deck.thumbnailColor rgbaString], @"f0f0f0ff");
    XCTAssertEqual(deck.cardsCount, (NSUInteger)8);
    
    deck = [decks cardDeckAtIndex:2];
    XCTAssertEqualObjects(deck.name, @"Estimation 2");
    XCTAssertEqualObjects(deck.description, @"XXS, XS, S, M, L, XL, XXL");
    XCTAssertEqualObjects(deck.file, @"File3");
    XCTAssertEqualObjects([deck.thumbnailColor rgbaString], @"ffffffff");
    XCTAssertEqual(deck.cardsCount, (NSUInteger)7);
    
    deck = [decks cardDeckDefaults];
    XCTAssertEqualObjects(deck.name, @"*NEW CARD DECK*");
}

- (void)testVersion2DictionaryFromCardDecks {
    CDXCardDecks *decks = [[[CDXCardDecks alloc] init] autorelease];
    {
        CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"0%2C%20...%2C%2010,ffffff,000000&0&1&2&3&4&5&6&7&8&9&10"];
        deck.file = @"File1";
        deck.thumbnailColor = nil;
        [decks addCardDeck:[CDXCardDeckHolder cardDeckHolderWithCardDeck:deck]];
    }
    {
        CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Estimation%201,000000,f0f0f0&0&1&2&4&8&16&32&64"];
        deck.file = @"File2";
        [decks addCardDeck:[CDXCardDeckHolder cardDeckHolderWithCardDeck:deck]];
    }
    {
        CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Estimation%202,000044,ffffff&XXS&XS&S&M&L&XL&XXL"];
        deck.file = @"File3";
        [decks addCardDeck:[CDXCardDeckHolder cardDeckHolderWithCardDeck:deck]];
    }
    
    decks.cardDeckDefaults.name = @"*NEW CARD DECK*";
    decks.cardDeckDefaults.file = @"FileDefault";
    
    XCTAssertEqual([decks cardDecksCount], (NSUInteger)3);
    
    NSDictionary *dictionary = [CDXCardDecksDictionarySerializer version2DictionaryFromCardDecks:decks];
    [dictionary writeToFile:@"/tmp/dict" atomically:NO];
    NSDictionary *expected = [self dictionaryFromFile:@"CDXCardDecksDictionarySerializerTestsDecks2.CardDeckList.plist"];
    XCTAssertTrue([expected isEqualToDictionary:dictionary]);
}


- (void)testCardDecksFromDictionary {
    NSDictionary *dictionary;
    CDXCardDecks *decks;
    CDXCardDeckBase *deck;
    
    dictionary = [self dictionaryFromFile:@"CDXCardDecksDictionarySerializerTestsDecks1.CardDeckList.plist"];
    decks = [CDXCardDecksDictionarySerializer cardDecksFromDictionary:dictionary];
    XCTAssertEqual([decks cardDecksCount], (NSUInteger)5);
    deck = [decks cardDeckAtIndex:0];
    XCTAssertEqualObjects(deck.name, @"Yes, No, Perhaps");
    
    dictionary = [self dictionaryFromFile:@"CDXCardDecksDictionarySerializerTestsDecks2.CardDeckList.plist"];
    decks = [CDXCardDecksDictionarySerializer cardDecksFromDictionary:dictionary];
    XCTAssertEqual([decks cardDecksCount], (NSUInteger)3);
    deck = [decks cardDeckAtIndex:0];
    XCTAssertEqualObjects(deck.name, @"0, ..., 10");
}

- (void)testDictionaryFromCardDeck {
    CDXCardDecks *decks = [[[CDXCardDecks alloc] init] autorelease];
    {
        CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"0%2C%20...%2C%2010,ffffff,000000&0&1&2&3&4&5&6&7&8&9&10"];
        [decks addCardDeck:[CDXCardDeckHolder cardDeckHolderWithCardDeck:deck]];
    }
    
    NSDictionary *dictionary = [CDXCardDecksDictionarySerializer dictionaryFromCardDecks:decks];
    XCTAssertEqualObjects([[dictionary valueForKey:@"VERSION"] description], @"2");
}

@end

