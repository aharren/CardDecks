//
//
// CDXCardDecksDictionarySerializerTests.m
//
//
// Copyright (c) 2009-2012 Arne Harren <ah@0xc0.de>
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
#import "CDXCardDeckURLSerializer.h"


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

- (void)testCardDecksFromVersion2Dictionary {
    NSDictionary *dictionary = [self dictionaryFromFile:@"CDXCardDecksDictionarySerializerTestsDecks2.CardDeckList.plist"];
    
    CDXCardDecks *decks = [CDXCardDecksDictionarySerializer cardDecksFromVersion2Dictionary:dictionary];
    STAssertEquals([decks cardDecksCount], (NSUInteger)3, nil);
    
    CDXCardDeckBase *deck;
    
    deck = [decks cardDeckAtIndex:0];
    STAssertEqualObjects(deck.name, @"0, ..., 10", nil);
    STAssertEqualObjects(deck.description, @"0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10", nil);
    STAssertEqualObjects(deck.file, @"File1", nil);
    STAssertNil(deck.thumbnailColor, nil);
    STAssertEquals(deck.cardsCount, (NSUInteger)11, nil);
    
    deck = [decks cardDeckAtIndex:1];
    STAssertEqualObjects(deck.name, @"Estimation 1", nil);
    STAssertEqualObjects(deck.description, @"0, 1, 2, 4, 8, 16, 32, 64", nil);
    STAssertEqualObjects(deck.file, @"File2", nil);
    STAssertEqualObjects([deck.thumbnailColor rgbaString], @"f0f0f0ff", nil);
    STAssertEquals(deck.cardsCount, (NSUInteger)8, nil);
    
    deck = [decks cardDeckAtIndex:2];
    STAssertEqualObjects(deck.name, @"Estimation 2", nil);
    STAssertEqualObjects(deck.description, @"XXS, XS, S, M, L, XL, XXL", nil);
    STAssertEqualObjects(deck.file, @"File3", nil);
    STAssertEqualObjects([deck.thumbnailColor rgbaString], @"ffffffff", nil);
    STAssertEquals(deck.cardsCount, (NSUInteger)7, nil);
    
    deck = [decks cardDeckDefaults];
    STAssertEqualObjects(deck.name, @"*NEW CARD DECK*", nil);
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
    
    STAssertEquals([decks cardDecksCount], (NSUInteger)3, nil);
    
    NSDictionary *dictionary = [CDXCardDecksDictionarySerializer version2DictionaryFromCardDecks:decks];
    [dictionary writeToFile:@"/tmp/dict" atomically:NO];
    NSDictionary *expected = [self dictionaryFromFile:@"CDXCardDecksDictionarySerializerTestsDecks2.CardDeckList.plist"];
    STAssertTrue([expected isEqualToDictionary:dictionary], nil);
}


- (void)testCardDecksFromDictionary {
    NSDictionary *dictionary;
    CDXCardDecks *decks;
    CDXCardDeckBase *deck;
    
    dictionary = [self dictionaryFromFile:@"CDXCardDecksDictionarySerializerTestsDecks1.CardDeckList.plist"];
    decks = [CDXCardDecksDictionarySerializer cardDecksFromDictionary:dictionary];
    STAssertEquals([decks cardDecksCount], (NSUInteger)5, nil);
    deck = [decks cardDeckAtIndex:0];
    STAssertEqualObjects(deck.name, @"Yes, No, Perhaps", nil);
    
    dictionary = [self dictionaryFromFile:@"CDXCardDecksDictionarySerializerTestsDecks2.CardDeckList.plist"];
    decks = [CDXCardDecksDictionarySerializer cardDecksFromDictionary:dictionary];
    STAssertEquals([decks cardDecksCount], (NSUInteger)3, nil);
    deck = [decks cardDeckAtIndex:0];
    STAssertEqualObjects(deck.name, @"0, ..., 10", nil);
}

- (void)testDictionaryFromCardDeck {
    CDXCardDecks *decks = [[[CDXCardDecks alloc] init] autorelease];
    {
        CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"0%2C%20...%2C%2010,ffffff,000000&0&1&2&3&4&5&6&7&8&9&10"];
        [decks addCardDeck:[CDXCardDeckHolder cardDeckHolderWithCardDeck:deck]];
    }
    
    NSDictionary *dictionary = [CDXCardDecksDictionarySerializer dictionaryFromCardDecks:decks];
    STAssertEqualObjects([[dictionary valueForKey:@"VERSION"] description], @"2", nil);
}

@end

