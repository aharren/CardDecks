//
//
// CDXCardTests.m
//
//
// Copyright (c) 2009-2020 Arne Harren <ah@0xc0.de>
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
#import "CDXCard.h"


@interface CDXCardTests : XCTestCase {
    
}

@end


@implementation CDXCardTests

- (void)testInitWithDefaults {
    CDXCard *card = [[CDXCard alloc] init];
    XCTAssertEqualObjects([card text], @"");
    XCTAssertEqual([card textColor], [CDXColor colorWhite]);
    XCTAssertEqual([card backgroundColor], [CDXColor colorBlack]);
    XCTAssertEqual((int)[card orientation], (int)CDXCardOrientationUp);
    XCTAssertEqual([card fontSize], CDXCardFontSizeAutomatic);
    XCTAssertEqual([card timerInterval], CDXCardTimerIntervalDefault);
    [card release];
}

- (void)testCopy {
    CDXCard *card = [[CDXCard alloc] init];
    card.text = @"TEXT";
    XCTAssertEqualObjects([card text], @"TEXT");
    card.textColor = [CDXColor colorBlack];
    XCTAssertEqual([card textColor], [CDXColor colorBlack]);
    card.backgroundColor = [CDXColor colorWhite];
    XCTAssertEqual([card backgroundColor], [CDXColor colorWhite]);
    card.orientation = CDXCardOrientationLeft;
    XCTAssertEqual((int)[card orientation], (int)CDXCardOrientationLeft);
    card.fontSize = 3.0;
    XCTAssertEqual([card fontSize], (CGFloat)3.0);
    card.timerInterval = 15.0;
    XCTAssertEqual([card timerInterval], (NSTimeInterval)15.0);

    [card autorelease];
    card = [card copy];
    XCTAssertEqualObjects([card text], @"TEXT");
    XCTAssertEqual([card textColor], [CDXColor colorBlack]);
    XCTAssertEqual([card backgroundColor], [CDXColor colorWhite]);
    XCTAssertEqual((int)[card orientation], (int)CDXCardOrientationLeft);
    XCTAssertEqual([card fontSize], (CGFloat)3.0);
    XCTAssertEqual([card timerInterval], (NSTimeInterval)15.0);
    [card release];
}

- (void)testTextCanonicalizedLinebreaks {
    CDXCard *card = [[CDXCard alloc] init];
    card.text = @"1 2 \r 3 4 \n 5 6";
    XCTAssertEqualObjects([card text], @"1 2 \n 3 4 \n 5 6");
    [card release];
}

- (void)testFontSize {
    CDXCard *card = [[CDXCard alloc] init];
    card.fontSize = -10.0;
    XCTAssertEqual([card fontSize], (CGFloat)10.0);
    card.fontSize = 10.0;
    XCTAssertEqual([card fontSize], (CGFloat)10.0);
    card.fontSize = -1.0;
    XCTAssertEqual([card fontSize], (CGFloat)1.0);
    card.fontSize = 1.0;
    XCTAssertEqual([card fontSize], (CGFloat)1.0);
    card.fontSize = -0.1;
    XCTAssertEqual([card fontSize], (CGFloat)0.0);
    card.fontSize = 0.1;
    XCTAssertEqual([card fontSize], (CGFloat)0.0);
    card.fontSize = -0.0;
    XCTAssertEqual([card fontSize], (CGFloat)0.0);
    card.fontSize = 0.0;
    XCTAssertEqual([card fontSize], (CGFloat)0.0);
    card.fontSize = 1000.0;
    XCTAssertEqual([card fontSize], (CGFloat)100.0);
    card.fontSize = 101.0;
    XCTAssertEqual([card fontSize], (CGFloat)100.0);
    card.fontSize = 99.5;
    XCTAssertEqual([card fontSize], (CGFloat)99.0);
    [card release];
}

- (void)testCornerStyle {
    CDXCard *card = [[CDXCard alloc] init];
    
    XCTAssertEqual(card.cornerStyle, CDXCardCornerStyleDefault);
    card.cornerStyle = -1;
    XCTAssertEqual(card.cornerStyle, CDXCardCornerStyleDefault);
    card.cornerStyle = 0;
    XCTAssertEqual(card.cornerStyle, CDXCardCornerStyleDefault);
    card.cornerStyle = 1;
    XCTAssertEqual(card.cornerStyle, CDXCardCornerStyleCount-1);
    card.cornerStyle = 2;
    XCTAssertEqual(card.cornerStyle, CDXCardCornerStyleDefault);
}

- (void)testOrientation {
    CDXCard *card = [[CDXCard alloc] init];
    
    XCTAssertEqual(card.orientation, CDXCardOrientationDefault);
    card.orientation = -1;
    XCTAssertEqual(card.orientation, CDXCardOrientationDefault);
    card.orientation = 0;
    XCTAssertEqual(card.orientation, CDXCardOrientationDefault);
    card.orientation = 1;
    XCTAssertEqual(card.orientation, 1);
    card.orientation = 2;
    XCTAssertEqual(card.orientation, 2);
    card.orientation = 3;
    XCTAssertEqual(card.orientation, CDXCardOrientationCount-1);
    card.orientation = 4;
    XCTAssertEqual(card.orientation, CDXCardOrientationDefault);
}

- (void)testTimerInterval {
    CDXCard *card = [[CDXCard alloc] init];
    card.timerInterval = -10.0;
    XCTAssertEqual([card timerInterval], CDXCardTimerIntervalMin);
    card.timerInterval = 0.0;
    XCTAssertEqual([card timerInterval], CDXCardTimerIntervalOff);
    card.timerInterval = 0.5;
    XCTAssertEqual([card timerInterval], CDXCardTimerIntervalMin);
    card.timerInterval = 1.0;
    XCTAssertEqual([card timerInterval], (NSTimeInterval)1);
    card.timerInterval = 10.0;
    XCTAssertEqual([card timerInterval], (NSTimeInterval)10);
    card.timerInterval = 3599.0;
    XCTAssertEqual([card timerInterval], (NSTimeInterval)3599);
    card.timerInterval = 3600.0;
    XCTAssertEqual([card timerInterval], CDXCardTimerIntervalMax);
    card.timerInterval = 3601.0;
    XCTAssertEqual([card timerInterval], CDXCardTimerIntervalMax);
    [card release];
}

- (void)testFontSizeConstrainedToSize {
    CDXCard *card = [[CDXCard alloc] init];
    CGFloat size;

    card.text = @"abcdefgh";
    size = [card fontSizeConstrainedToSize:CGSizeMake(320.0, 480.0) scale:1.0];
    XCTAssertEqual(size, 80.0);

    card.text = @"ABCDEFGH";
    size = [card fontSizeConstrainedToSize:CGSizeMake(320.0, 480.0) scale:1.0];
    XCTAssertEqual(size, 62.0);

    card.text = @"abcdefgh\nABCDEFGH";
    size = [card fontSizeConstrainedToSize:CGSizeMake(320.0, 480.0) scale:1.0];
    XCTAssertEqual(size, 62.0);

    card.text = @"abcdefgh";
    size = [card fontSizeConstrainedToSize:CGSizeMake(640.0, 960.0) scale:1.0];
    XCTAssertEqual(size, 160.0);

    card.text = @"ABCDEFGH";
    size = [card fontSizeConstrainedToSize:CGSizeMake(640.0, 960.0) scale:1.0];
    XCTAssertEqual(size, 125);

    card.text = @"abcdefgh\nABCDEFGH";
    size = [card fontSizeConstrainedToSize:CGSizeMake(640.0, 960.0) scale:1.0];
    XCTAssertEqual(size, 125);
}

@end

