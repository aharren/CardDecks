//
//
// CDXColorTests.m
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
#import "CDXColor.h"


@interface CDXColorTests : SenTestCase {
    
}

@end


@implementation CDXColorTests

- (void)testRgbaString {
    CDXColor *color = [CDXColor colorWithRed:0x12 green:0x43 blue:0x56 alpha:0x87];
    STAssertEqualObjects([color rgbaString], @"12435687", nil);
}

- (void)testIsEqual {
    CDXColor *color = [CDXColor colorWithRed:0x12 green:0x43 blue:0x56 alpha:0x87];
    STAssertFalse([color isEqual:nil], nil);
    STAssertTrue([color isEqual:[CDXColor colorWithRed:0x12 green:0x43 blue:0x56 alpha:0x87]], nil);
    STAssertFalse([color isEqual:[CDXColor colorWithRed:0x00 green:0x43 blue:0x56 alpha:0x87]], nil);
    STAssertFalse([color isEqual:[CDXColor colorWithRed:0x12 green:0x00 blue:0x56 alpha:0x87]], nil);
    STAssertFalse([color isEqual:[CDXColor colorWithRed:0x12 green:0x43 blue:0x00 alpha:0x87]], nil);
    STAssertFalse([color isEqual:[CDXColor colorWithRed:0x12 green:0x43 blue:0x56 alpha:0x00]], nil);
}

- (void)testColorWithRedGreenBlueAlpha {
    CDXColor *color = [CDXColor colorWithRed:10 green:20 blue:30 alpha:40];
    STAssertEquals((int)[color red], 10, nil);
    STAssertEquals((int)[color green], 20, nil);
    STAssertEquals((int)[color blue], 30, nil);
    STAssertEquals((int)[color alpha], 40, nil);
}

- (void)testColorWithString6Numbers {
    CDXColor *color = [CDXColor colorWithRGBAString:@"123456" defaultsTo:nil];
    STAssertEquals((int)[color red], 0x12, nil);
    STAssertEquals((int)[color green], 0x34, nil);
    STAssertEquals((int)[color blue], 0x56, nil);
    STAssertEquals((int)[color alpha], 0xff, nil);
}

- (void)testColorWithString6LowerCaseCharacters {
    CDXColor *color = [CDXColor colorWithRGBAString:@"fdabcd" defaultsTo:nil];
    STAssertEquals((int)[color red], 0xfd, nil);
    STAssertEquals((int)[color green], 0xab, nil);
    STAssertEquals((int)[color blue], 0xcd, nil);
    STAssertEquals((int)[color alpha], 0xff, nil);
}

- (void)testColorWithString6UpperCaseCharacters {
    CDXColor *color = [CDXColor colorWithRGBAString:@"ABCDEF" defaultsTo:nil];
    STAssertEquals((int)[color red], 0xab, nil);
    STAssertEquals((int)[color green], 0xcd, nil);
    STAssertEquals((int)[color blue], 0xef, nil);
    STAssertEquals((int)[color alpha], 0xff, nil);
}

- (void)testColorWithString8Numbers {
    CDXColor *color = [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil];
    STAssertEquals((int)[color red], 0x12, nil);
    STAssertEquals((int)[color green], 0x34, nil);
    STAssertEquals((int)[color blue], 0x56, nil);
    STAssertEquals((int)[color alpha], 0x78, nil);
}

- (void)testColorWithString8LowerCaseCharacters {
    CDXColor *color = [CDXColor colorWithRGBAString:@"fdabcdef" defaultsTo:nil];
    STAssertEquals((int)[color red], 0xfd, nil);
    STAssertEquals((int)[color green], 0xab, nil);
    STAssertEquals((int)[color blue], 0xcd, nil);
    STAssertEquals((int)[color alpha], 0xef, nil);
}

- (void)testColorWithString8UpperCaseCharacters {
    CDXColor *color = [CDXColor colorWithRGBAString:@"ABCDEFCA" defaultsTo:nil];
    STAssertEquals((int)[color red], 0xab, nil);
    STAssertEquals((int)[color green], 0xcd, nil);
    STAssertEquals((int)[color blue], 0xef, nil);
    STAssertEquals((int)[color alpha], 0xca, nil);
}

- (void)testColorWithStringBadLength5 {
    CDXColor *defaultColor = [CDXColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    CDXColor *color = [CDXColor colorWithRGBAString:@"12345" defaultsTo:defaultColor];
    STAssertEquals(color, defaultColor, nil);
}

- (void)testColorWithStringBadCharacterX {
    CDXColor *defaultColor = [CDXColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    CDXColor *color = [CDXColor colorWithRGBAString:@"12345X" defaultsTo:defaultColor];
    STAssertEquals(color, defaultColor, nil);
}

- (void)testColorWhite {
    CDXColor *color = [CDXColor colorWhite];
    STAssertEquals((int)[color red], 0xff, nil);
    STAssertEquals((int)[color green], 0xff, nil);
    STAssertEquals((int)[color blue], 0xff, nil);
    STAssertEquals((int)[color alpha], 0xff, nil);
}

- (void)testColorBlack {
    CDXColor *color = [CDXColor colorBlack];
    STAssertEquals((int)[color red], 0x00, nil);
    STAssertEquals((int)[color green], 0x00, nil);
    STAssertEquals((int)[color blue], 0x00, nil);
    STAssertEquals((int)[color alpha], 0xff, nil);
}

- (void)testUiColor {
    UIColor *color1 = [[CDXColor colorWhite] uiColor];
    STAssertTrue(CGColorEqualToColor([color1 CGColor], [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor]), nil);
    
    UIColor *color2 = [[CDXColor colorBlack] uiColor];
    STAssertTrue(CGColorEqualToColor([color2 CGColor], [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor]), nil);
}

@end

