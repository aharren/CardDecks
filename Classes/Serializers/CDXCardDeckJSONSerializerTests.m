//
//
// CDXCardDeckJSONSerializerTests.m
//
//
// Copyright (c) 2009-2014 Arne Harren <ah@0xc0.de>
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
#import "CDXCardDeckJSONSerializer.h"
#import "CDXCardDeckURLSerializer.h"


@interface CDXCardDeckJSONSerializerTests : XCTestCase {
    
}

@end


@implementation CDXCardDeckJSONSerializerTests

- (NSString *)stringFromFile:(NSString *)file {
    NSString *path = [[NSBundle bundleForClass:[CDXCardDeckJSONSerializerTests class]] pathForResource:file ofType:nil];
    NSError *error = nil;
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    XCTAssertNotNil(string);
    return string;
}

- (void)testCardDecksFromVersion2JSON {
    NSString *string = [self stringFromFile:@"CDXCardDeckJSONSerializerTestsDeck1.carddeck.json"];
    CDXCardDeck *deck = [CDXCardDeckJSONSerializer cardDeckFromVersion2String:string];
    
    XCTAssertEqualObjects(@"numbers", deck.name);
    
    XCTAssertEqual(3, deck.cardsCount);
    XCTAssertEqualObjects(@"1", [deck cardAtIndex:0].text);
    XCTAssertEqualObjects(@"2", [deck cardAtIndex:1].text);
    XCTAssertEqualObjects(@"3", [deck cardAtIndex:2].text);
}

@end

