//
//
// CDXCardTests.m
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
#import "CDXCard.h"


@interface CDXCardTests : SenTestCase {
    
}

@end


@implementation CDXCardTests

- (void)testInitWithDefaults {
    CDXCard *card = [[CDXCard alloc] init];
    STAssertEqualObjects([card text], @"", nil);
    STAssertEquals([card textColor], [CDXColor colorWhite], nil);
    STAssertEquals([card backgroundColor], [CDXColor colorBlack], nil);
    STAssertEquals((int)[card orientation], (int)CDXCardOrientationUp, nil);
    STAssertEquals([card fontSize], CDXCardFontSizeAutomatic, nil);
    STAssertEquals([card timerInterval], CDXCardTimerIntervalDefault, nil);
    [card release];
}

- (void)testTextCanonicalizedLinebreaks {
    CDXCard *card = [[CDXCard alloc] init];
    card.text = @"1 2 \r 3 4 \n 5 6";
    STAssertEqualObjects([card text], @"1 2 \n 3 4 \n 5 6", nil);
    [card release];
}

- (void)testFontSize {
    CDXCard *card = [[CDXCard alloc] init];
    card.fontSize = -10.0;
    STAssertEquals([card fontSize], (CGFloat)10.0, nil);
    card.fontSize = 10.0;
    STAssertEquals([card fontSize], (CGFloat)10.0, nil);
    card.fontSize = -1.0;
    STAssertEquals([card fontSize], (CGFloat)1.0, nil);
    card.fontSize = 1.0;
    STAssertEquals([card fontSize], (CGFloat)1.0, nil);
    card.fontSize = -0.1;
    STAssertEquals([card fontSize], (CGFloat)0.0, nil);
    card.fontSize = 0.1;
    STAssertEquals([card fontSize], (CGFloat)0.0, nil);
    card.fontSize = -0.0;
    STAssertEquals([card fontSize], (CGFloat)0.0, nil);
    card.fontSize = 0.0;
    STAssertEquals([card fontSize], (CGFloat)0.0, nil);
    card.fontSize = 1000.0;
    STAssertEquals([card fontSize], (CGFloat)100.0, nil);
    card.fontSize = 101.0;
    STAssertEquals([card fontSize], (CGFloat)100.0, nil);
    card.fontSize = 99.5;
    STAssertEquals([card fontSize], (CGFloat)99.0, nil);
    [card release];
}

- (void)testCornerStyle {
    CDXCard *card = [[CDXCard alloc] init];
    
    STAssertEquals(card.cornerStyle, CDXCardCornerStyleDefault, nil);
    card.cornerStyle = -1;
    STAssertEquals(card.cornerStyle, CDXCardCornerStyleDefault, nil);
    card.cornerStyle = 0;
    STAssertEquals(card.cornerStyle, CDXCardCornerStyleDefault, nil);
    card.cornerStyle = 1;
    STAssertEquals(card.cornerStyle, CDXCardCornerStyleCount-1, nil);
    card.cornerStyle = 2;
    STAssertEquals(card.cornerStyle, CDXCardCornerStyleDefault, nil);
}

- (void)testOrientation {
    CDXCard *card = [[CDXCard alloc] init];
    
    STAssertEquals(card.orientation, CDXCardOrientationDefault, nil);
    card.orientation = -1;
    STAssertEquals(card.orientation, CDXCardOrientationDefault, nil);
    card.orientation = 0;
    STAssertEquals(card.orientation, CDXCardOrientationDefault, nil);
    card.orientation = 1;
    STAssertEquals(card.orientation, 1, nil);
    card.orientation = 2;
    STAssertEquals(card.orientation, 2, nil);
    card.orientation = 3;
    STAssertEquals(card.orientation, CDXCardOrientationCount-1, nil);
    card.orientation = 4;
    STAssertEquals(card.orientation, CDXCardOrientationDefault, nil);
}

- (void)testTimerInterval {
    CDXCard *card = [[CDXCard alloc] init];
    card.timerInterval = -10.0;
    STAssertEquals([card timerInterval], CDXCardTimerIntervalMin, nil);
    card.timerInterval = 0.0;
    STAssertEquals([card timerInterval], CDXCardTimerIntervalOff, nil);
    card.timerInterval = 0.5;
    STAssertEquals([card timerInterval], CDXCardTimerIntervalMin, nil);
    card.timerInterval = 1.0;
    STAssertEquals([card timerInterval], (NSTimeInterval)1, nil);
    card.timerInterval = 10.0;
    STAssertEquals([card timerInterval], (NSTimeInterval)10, nil);
    card.timerInterval = 3599.0;
    STAssertEquals([card timerInterval], (NSTimeInterval)3599, nil);
    card.timerInterval = 3600.0;
    STAssertEquals([card timerInterval], CDXCardTimerIntervalMax, nil);
    card.timerInterval = 3601.0;
    STAssertEquals([card timerInterval], CDXCardTimerIntervalMax, nil);
    [card release];
}

@end

