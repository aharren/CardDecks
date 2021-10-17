//
//
// CDXColorTests.m
//
//
// Copyright (c) 2009-2021 Arne Harren <ah@0xc0.de>
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
#import "CDXColor.h"


@interface CDXColorTests : XCTestCase {
    
}

@end


@implementation CDXColorTests

- (void)testRgbaString {
    CDXColor *color = [CDXColor colorWithRed:0x12 green:0x43 blue:0x56 alpha:0x87];
    XCTAssertEqualObjects([color rgbaString], @"12435687");
}

- (void)testIsEqual {
    CDXColor *color = [CDXColor colorWithRed:0x12 green:0x43 blue:0x56 alpha:0x87];
    XCTAssertFalse([color isEqual:nil]);
    XCTAssertTrue([color isEqual:[CDXColor colorWithRed:0x12 green:0x43 blue:0x56 alpha:0x87]]);
    XCTAssertFalse([color isEqual:[CDXColor colorWithRed:0x00 green:0x43 blue:0x56 alpha:0x87]]);
    XCTAssertFalse([color isEqual:[CDXColor colorWithRed:0x12 green:0x00 blue:0x56 alpha:0x87]]);
    XCTAssertFalse([color isEqual:[CDXColor colorWithRed:0x12 green:0x43 blue:0x00 alpha:0x87]]);
    XCTAssertFalse([color isEqual:[CDXColor colorWithRed:0x12 green:0x43 blue:0x56 alpha:0x00]]);
}

- (void)testColorWithRedGreenBlueAlpha {
    CDXColor *color = [CDXColor colorWithRed:10 green:20 blue:30 alpha:40];
    XCTAssertEqual((int)[color red], 10);
    XCTAssertEqual((int)[color green], 20);
    XCTAssertEqual((int)[color blue], 30);
    XCTAssertEqual((int)[color alpha], 40);
}

- (void)testColorWithString6Numbers {
    CDXColor *color = [CDXColor colorWithRGBAString:@"123456" defaultsTo:nil];
    XCTAssertEqual((int)[color red], 0x12);
    XCTAssertEqual((int)[color green], 0x34);
    XCTAssertEqual((int)[color blue], 0x56);
    XCTAssertEqual((int)[color alpha], 0xff);
}

- (void)testColorWithString6LowerCaseCharacters {
    CDXColor *color = [CDXColor colorWithRGBAString:@"fdabcd" defaultsTo:nil];
    XCTAssertEqual((int)[color red], 0xfd);
    XCTAssertEqual((int)[color green], 0xab);
    XCTAssertEqual((int)[color blue], 0xcd);
    XCTAssertEqual((int)[color alpha], 0xff);
}

- (void)testColorWithString6UpperCaseCharacters {
    CDXColor *color = [CDXColor colorWithRGBAString:@"ABCDEF" defaultsTo:nil];
    XCTAssertEqual((int)[color red], 0xab);
    XCTAssertEqual((int)[color green], 0xcd);
    XCTAssertEqual((int)[color blue], 0xef);
    XCTAssertEqual((int)[color alpha], 0xff);
}

- (void)testColorWithString8Numbers {
    CDXColor *color = [CDXColor colorWithRGBAString:@"12345678" defaultsTo:nil];
    XCTAssertEqual((int)[color red], 0x12);
    XCTAssertEqual((int)[color green], 0x34);
    XCTAssertEqual((int)[color blue], 0x56);
    XCTAssertEqual((int)[color alpha], 0x78);
}

- (void)testColorWithString8LowerCaseCharacters {
    CDXColor *color = [CDXColor colorWithRGBAString:@"fdabcdef" defaultsTo:nil];
    XCTAssertEqual((int)[color red], 0xfd);
    XCTAssertEqual((int)[color green], 0xab);
    XCTAssertEqual((int)[color blue], 0xcd);
    XCTAssertEqual((int)[color alpha], 0xef);
}

- (void)testColorWithString8UpperCaseCharacters {
    CDXColor *color = [CDXColor colorWithRGBAString:@"ABCDEFCA" defaultsTo:nil];
    XCTAssertEqual((int)[color red], 0xab);
    XCTAssertEqual((int)[color green], 0xcd);
    XCTAssertEqual((int)[color blue], 0xef);
    XCTAssertEqual((int)[color alpha], 0xca);
}

- (void)testColorWithStringBadLength5 {
    CDXColor *defaultColor = [CDXColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    CDXColor *color = [CDXColor colorWithRGBAString:@"12345" defaultsTo:defaultColor];
    XCTAssertEqual(color, defaultColor);
}

- (void)testColorWithStringBadCharacterX {
    CDXColor *defaultColor = [CDXColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    CDXColor *color = [CDXColor colorWithRGBAString:@"12345X" defaultsTo:defaultColor];
    XCTAssertEqual(color, defaultColor);
}

- (void)testColorWhite {
    CDXColor *color = [CDXColor colorWhite];
    XCTAssertEqual((int)[color red], 0xff);
    XCTAssertEqual((int)[color green], 0xff);
    XCTAssertEqual((int)[color blue], 0xff);
    XCTAssertEqual((int)[color alpha], 0xff);
}

- (void)testColorBlack {
    CDXColor *color = [CDXColor colorBlack];
    XCTAssertEqual((int)[color red], 0x00);
    XCTAssertEqual((int)[color green], 0x00);
    XCTAssertEqual((int)[color blue], 0x00);
    XCTAssertEqual((int)[color alpha], 0xff);
}

- (void)testUiColor {
    UIColor *color1 = [[CDXColor colorWhite] uiColor];
    XCTAssertTrue(CGColorEqualToColor([color1 CGColor], [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor]));
    
    UIColor *color2 = [[CDXColor colorBlack] uiColor];
    XCTAssertTrue(CGColorEqualToColor([color2 CGColor], [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor]));
}

@end

