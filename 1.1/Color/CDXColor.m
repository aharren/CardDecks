//
//
// CDXColor.m
//
//
// Copyright (c) 2009 Arne Harren <ah@0xc0.de>
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

#import "CDXColor.h"


@implementation CDXColor

static CDXColor *_cdxColorBlack = nil;
static CDXColor *_cdxColorWhite = nil;

@synthesize red = _red;
@synthesize green = _green;
@synthesize blue = _blue;

+ (void)initialize {
    // perform initialization only once
    if (self != [CDXColor class]) {
        return;
    }
    
    // create black
    _cdxColorBlack = [[CDXColor alloc] init];
    _cdxColorBlack->_red = 0;
    _cdxColorBlack->_green = 0;
    _cdxColorBlack->_blue = 0;
    
    // create white
    _cdxColorWhite = [[CDXColor alloc] init];
    _cdxColorWhite->_red = 255;
    _cdxColorWhite->_green = 255;
    _cdxColorWhite->_blue = 255;
}

- (void)dealloc {
    [super dealloc];
}

- (UIColor *)uiColor {
    return [UIColor colorWithRed:(_red & 0xff) / 255.f
                           green:(_green & 0xff) / 255.f
                            blue:(_blue & 0xff) / 255.f
                           alpha:1.0f];
}

- (NSString *)rgbString {
    return [NSString stringWithFormat:@"%02x%02x%02x", 
            _red & 0xff,
            _green & 0xff,
            _blue & 0xff];
}

+ (CDXColor *)cdxColorWithRed:(unsigned int)red green:(unsigned int)green blue:(unsigned int)blue {
    CDXColor *c = [[[CDXColor alloc] init] autorelease];
    c->_red = red;
    c->_green = green;
    c->_blue = blue;
    return c;
}

+ (CDXColor *)cdxColorWithRGBString:(NSString *)string defaulsTo:(CDXColor *)defaultColor {
    if (string == nil) {
        return [[defaultColor retain] autorelease];
    }
    
    if ([string length] != 6) {
        return [[defaultColor retain] autorelease];
    }
    
    unsigned int colorParts[6];
    for (NSUInteger i = 0;i < 6; i++) {
        unichar character = [string characterAtIndex:i];
        if (character >= '0' && character <= '9') {
            colorParts[i] = (unsigned int)character - '0';
        } else if (character >= 'a' && character <= 'f') {
            colorParts[i] = (unsigned int)character - 'a' + 10; 
        } else if (character >= 'A' && character <= 'F') {
            colorParts[i] = (unsigned int)character - 'A' + 10;
        } else {
            return [[defaultColor retain] autorelease];
        }
    }
    
    return [CDXColor cdxColorWithRed:(colorParts[0] << 4) | colorParts[1]
                               green:(colorParts[2] << 4) | colorParts[3]
                                blue:(colorParts[4] << 4) | colorParts[5]];
}

+ (CDXColor *)blackColor {
    return _cdxColorBlack;
}

+ (CDXColor *)whiteColor {
    return _cdxColorWhite;
}

- (BOOL)isEqual:(id)anObject {
    if (![anObject isMemberOfClass:[CDXColor class]]) {
        return NO;
    }
    
    CDXColor *anColorObject = (CDXColor *)anObject;
    return _red == anColorObject.red && _green == anColorObject.green && _blue == anColorObject.blue;
}

@end

