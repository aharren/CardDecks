//
//
// CDXCardDeckBaseTests.m
//
//
// Copyright (c) 2009-2015 Arne Harren <ah@0xc0.de>
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
#import "CDXCardDeck.h"
#import "CDXCardDeckURLSerializer.h"


@interface CDXCardDeckBaseTests : XCTestCase {
    
}

@end


@implementation CDXCardDeckBaseTests

- (void)testInitWithDefaults {
    CDXCardDeckBase *base = [[CDXCardDeckBase alloc] init];
    
    XCTAssertNil(base.base);
    [base release];
}

- (void)testInitWithCardDeck {
    NSString *string = @""
    "card%20deck,ffffff,888888"
    "&card%201"
    "&card%202";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    XCTAssertNil(deck.base);
    deck.file = @"File";
    
    CDXCardDeckBase *base = [[CDXCardDeckBase alloc] initWithCardDeck:deck];
    XCTAssertEqual(deck.base, base);
    XCTAssertEqual(base.cardDeck, deck);
    XCTAssertEqualObjects(base.name, @"card deck");
    XCTAssertEqualObjects(base.file, @"File");
    XCTAssertEqualObjects(base.description, @"card 1, card 2");
    XCTAssertEqualObjects([base.thumbnailColor description], @"888888ff");
    [base release];
}

- (void)testUpdatesFromCardDeck {
    NSString *string = @""
    "card%20deck,ffffff,888888"
    "&card%201"
    "&card%202";
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:string];
    XCTAssertNil(deck.base);
    
    CDXCardDeckBase *base = [[CDXCardDeckBase alloc] initWithCardDeck:deck];
    XCTAssertEqual(deck.base, base);
    XCTAssertEqual(base.cardDeck, deck);
    XCTAssertEqualObjects(base.name, @"card deck");
    XCTAssertEqualObjects(base.description, @"card 1, card 2");
    XCTAssertEqualObjects([base.thumbnailColor description], @"888888ff");
    XCTAssertEqual(base.cardsCount, (NSUInteger)2);
    
    deck.name = @"new card deck";
    XCTAssertEqualObjects(base.name, @"new card deck");
    [deck cardAtIndex:0].text = @"new card 1";
    [deck cardAtIndex:0].backgroundColor = [CDXColor colorWhite];
    [deck replaceCardAtIndex:0 withCard:[deck cardAtIndex:0]];
    XCTAssertEqualObjects(base.description, @"new card 1, card 2");
    XCTAssertEqualObjects([base.thumbnailColor description], @"ffffffff");
    [deck addCard:[[[CDXCard alloc] init] autorelease]];
    XCTAssertEqual(base.cardsCount, (NSUInteger)3);
    
    [base release];
}

- (void)testDeallocBase {
    NSAutoreleasePool *pool1 = [[NSAutoreleasePool alloc] init];
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"card%20deck,ffffff,888888"];
    [deck retain];
    [pool1 release];
    XCTAssertNil(deck.base);
    
    CDXCardDeckBase *base = [[CDXCardDeckBase alloc] initWithCardDeck:deck];
    XCTAssertEqual(deck.base, base);
    XCTAssertEqual(base.cardDeck, deck);
    
    [base release];
    XCTAssertNil(deck.base);
    
    [deck release];
}

- (void)testDeallocCardDeck {
    NSAutoreleasePool *pool1 = [[NSAutoreleasePool alloc] init];
    CDXCardDeck *deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"card%20deck,ffffff,888888"];
    [deck retain];
    [pool1 release];
    XCTAssertNil(deck.base);
    
    CDXCardDeckBase *base = [[CDXCardDeckBase alloc] initWithCardDeck:deck];
    XCTAssertEqual(deck.base, base);
    XCTAssertEqual(base.cardDeck, deck);
    
    base.file = @"";
    [deck release];
    XCTAssertNil(base.cardDeck);
    
    [base release];
}

@end

