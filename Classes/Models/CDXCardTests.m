//
//
// CDXCardTests.m
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
    STAssertEquals([card fontSize], (CGFloat)400.0, nil);
    card.fontSize = 401.0;
    STAssertEquals([card fontSize], (CGFloat)400.0, nil);
    card.fontSize = 399.0;
    STAssertEquals([card fontSize], (CGFloat)399.0, nil);
    [card release];
}

@end

