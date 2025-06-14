//
//
// CDXCardDecksTests.m
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
#import "CDXCardDecks.h"


@interface CDXCardDecksTests : XCTestCase {
    
}

@end


@implementation CDXCardDecksTests

- (void)testAddCardDeck {
    CDXCardDecks *cardDecks = [[[CDXCardDecks alloc] init] autorelease];
    XCTAssertEqual([cardDecks cardDecksCount], (NSUInteger)0);
    
    CDXCardDeckHolder *cardDeck = [[CDXCardDeckHolder alloc] init];
    cardDeck.name = @"Text";
    [cardDecks addCardDeck:cardDeck];
    [cardDeck release];
    
    XCTAssertEqual([cardDecks cardDecksCount], (NSUInteger)1);
    XCTAssertEqualObjects([[cardDecks cardDeckAtIndex:0] name], @"Text");
}

- (void)testInsertCardDeck {
    CDXCardDecks *cardDecks = [[[CDXCardDecks alloc] init] autorelease];
    XCTAssertEqual([cardDecks cardDecksCount], (NSUInteger)0);
    
    CDXCardDeckHolder *cardDeck1 = [[CDXCardDeckHolder alloc] init];
    cardDeck1.name = @"Text 1";
    [cardDecks insertCardDeck:cardDeck1 atIndex:10];
    [cardDeck1 release];
    
    XCTAssertEqual([cardDecks cardDecksCount], (NSUInteger)1);
    XCTAssertEqualObjects([[cardDecks cardDeckAtIndex:0] name], @"Text 1");
    
    CDXCardDeckHolder *cardDeck2 = [[CDXCardDeckHolder alloc] init];
    cardDeck2.name = @"Text 2";
    [cardDecks insertCardDeck:cardDeck2 atIndex:0];
    [cardDeck2 release];
    
    XCTAssertEqual([cardDecks cardDecksCount], (NSUInteger)2);
    XCTAssertEqualObjects([[cardDecks cardDeckAtIndex:0] name], @"Text 2");
    XCTAssertEqualObjects([[cardDecks cardDeckAtIndex:1] name], @"Text 1");
}

- (void)testRemoveCardDeck {
    CDXCardDecks *cardDecks = [[[CDXCardDecks alloc] init] autorelease];
    XCTAssertEqual([cardDecks cardDecksCount], (NSUInteger)0);
    
    CDXCardDeckHolder *cardDeck1 = [[CDXCardDeckHolder alloc] init];
    cardDeck1.name = @"Text 1";
    [cardDecks addCardDeck:cardDeck1];
    [cardDeck1 release];
    
    CDXCardDeckHolder *cardDeck2 = [[CDXCardDeckHolder alloc] init];
    cardDeck2.name = @"Text 2";
    [cardDecks addCardDeck:cardDeck2];
    [cardDeck2 release];
    
    CDXCardDeckHolder *cardDeck3 = [[CDXCardDeckHolder alloc] init];
    cardDeck3.name = @"Text 3";
    [cardDecks addCardDeck:cardDeck3];
    [cardDeck3 release];
    
    XCTAssertEqual([cardDecks cardDecksCount], (NSUInteger)3);
    XCTAssertEqualObjects([[cardDecks cardDeckAtIndex:0] name], @"Text 1");
    XCTAssertEqualObjects([[cardDecks cardDeckAtIndex:1] name], @"Text 2");
    XCTAssertEqualObjects([[cardDecks cardDeckAtIndex:2] name], @"Text 3");
    
    [cardDecks removeCardDeckAtIndex:1];
    XCTAssertEqual([cardDecks cardDecksCount], (NSUInteger)2);
    XCTAssertEqualObjects([[cardDecks cardDeckAtIndex:0] name], @"Text 1");
    XCTAssertEqualObjects([[cardDecks cardDeckAtIndex:1] name], @"Text 3");
}

@end

