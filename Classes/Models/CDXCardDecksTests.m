//
//
// CDXCardDecksTests.m
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
#import "CDXCardDecks.h"


@interface CDXCardDecksTests : SenTestCase {
    
}

@end


@implementation CDXCardDecksTests

- (void)testAddDeck {
    CDXCardDecks *decks = [[[CDXCardDecks alloc] init] autorelease];
    STAssertEquals([decks decksCount], (NSUInteger)0, nil);
    
    CDXCardDeck *deck = [[CDXCardDeck alloc] init];
    deck.name = @"Text";
    [decks addDeck:deck];
    [deck release];
    
    STAssertEquals([decks decksCount], (NSUInteger)1, nil);
    STAssertEqualObjects([[decks deckAtIndex:0] name], @"Text", nil);
}

- (void)testInsertDeck {
    CDXCardDecks *decks = [[[CDXCardDecks alloc] init] autorelease];
    STAssertEquals([decks decksCount], (NSUInteger)0, nil);
    
    CDXCardDeck *deck1 = [[CDXCardDeck alloc] init];
    deck1.name = @"Text 1";
    [decks insertDeck:deck1 atIndex:10];
    [deck1 release];
    
    STAssertEquals([decks decksCount], (NSUInteger)1, nil);
    STAssertEqualObjects([[decks deckAtIndex:0] name], @"Text 1", nil);
    
    CDXCardDeck *deck2 = [[CDXCardDeck alloc] init];
    deck2.name = @"Text 2";
    [decks insertDeck:deck2 atIndex:0];
    [deck2 release];
    
    STAssertEquals([decks decksCount], (NSUInteger)2, nil);
    STAssertEqualObjects([[decks deckAtIndex:0] name], @"Text 2", nil);
    STAssertEqualObjects([[decks deckAtIndex:1] name], @"Text 1", nil);
}

- (void)testRemoveDeck {
    CDXCardDecks *decks = [[[CDXCardDecks alloc] init] autorelease];
    STAssertEquals([decks decksCount], (NSUInteger)0, nil);
    
    CDXCardDeck *deck1 = [[CDXCardDeck alloc] init];
    deck1.name = @"Text 1";
    [decks addDeck:deck1];
    [deck1 release];
    
    CDXCardDeck *deck2 = [[CDXCardDeck alloc] init];
    deck2.name = @"Text 2";
    [decks addDeck:deck2];
    [deck2 release];
    
    CDXCardDeck *deck3 = [[CDXCardDeck alloc] init];
    deck3.name = @"Text 3";
    [decks addDeck:deck3];
    [deck3 release];
    
    STAssertEquals([decks decksCount], (NSUInteger)3, nil);
    STAssertEqualObjects([[decks deckAtIndex:0] name], @"Text 1", nil);
    STAssertEqualObjects([[decks deckAtIndex:1] name], @"Text 2", nil);
    STAssertEqualObjects([[decks deckAtIndex:2] name], @"Text 3", nil);
    
    [decks removeDeckAtIndex:1];
    STAssertEquals([decks decksCount], (NSUInteger)2, nil);
    STAssertEqualObjects([[decks deckAtIndex:0] name], @"Text 1", nil);
    STAssertEqualObjects([[decks deckAtIndex:1] name], @"Text 3", nil);
}

@end

