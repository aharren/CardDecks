//
//
// CDXCardDeckTests.m
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
#import "CDXCardDeck.h"


@interface CDXCardDeckTests : SenTestCase {
    
}

@end


@implementation CDXCardDeckTests

- (void)testInitWithDefaults {
    CDXCardDeck *deck = [[CDXCardDeck alloc] init];
    STAssertEqualObjects([deck name], @"", nil);
    STAssertEquals([deck defaultCardTextColor], [CDXColor cdxColorWhite], nil);
    STAssertEquals([deck defaultCardBackgroundColor], [CDXColor cdxColorBlack], nil);
    STAssertEquals((int)[deck defaultCardOrientation], (int)CDXCardOrientationUp, nil);
    [deck release];
}

- (void)testAddCard {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    STAssertEquals([deck cardsCount], (NSUInteger)0, nil);
    
    CDXCard *card = [[CDXCard alloc] init];
    card.text = @"Text";
    [deck addCard:card];
    [card release];
    
    STAssertEquals([deck cardsCount], (NSUInteger)1, nil);
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text", nil);
}

- (void)testInsertCard {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    STAssertEquals([deck cardsCount], (NSUInteger)0, nil);
    
    CDXCard *card1 = [[CDXCard alloc] init];
    card1.text = @"Text 1";
    [deck insertCard:card1 atIndex:10];
    [card1 release];
    
    STAssertEquals([deck cardsCount], (NSUInteger)1, nil);
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 1", nil);
    
    CDXCard *card2 = [[CDXCard alloc] init];
    card2.text = @"Text 2";
    [deck insertCard:card2 atIndex:0];
    [card2 release];
    
    STAssertEquals([deck cardsCount], (NSUInteger)2, nil);
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 1", nil);
}

- (void)testRemoveCard {
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    STAssertEquals([deck cardsCount], (NSUInteger)0, nil);
    
    CDXCard *card1 = [[CDXCard alloc] init];
    card1.text = @"Text 1";
    [deck addCard:card1];
    [card1 release];
    
    CDXCard *card2 = [[CDXCard alloc] init];
    card2.text = @"Text 2";
    [deck addCard:card2];
    [card2 release];
    
    CDXCard *card3 = [[CDXCard alloc] init];
    card3.text = @"Text 3";
    [deck addCard:card3];
    [card3 release];
    
    STAssertEquals([deck cardsCount], (NSUInteger)3, nil);
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 2", nil);
    STAssertEqualObjects([[deck cardAtIndex:2] text], @"Text 3", nil);
    
    [deck removeCardAtIndex:1];
    STAssertEquals([deck cardsCount], (NSUInteger)2, nil);
    STAssertEqualObjects([[deck cardAtIndex:0] text], @"Text 1", nil);
    STAssertEqualObjects([[deck cardAtIndex:1] text], @"Text 3", nil);
}

@end

