//
//
// CDXColor.m
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

#import "CDXColor.h"


@implementation CDXColor

static CDXColor *cdxColorWhite = nil;
static CDXColor *cdxColorBlack = nil;

@synthesize red;
@synthesize green;
@synthesize blue;
@synthesize alpha;

+ (void)initialize {
    if (self != [CDXColor class]) {
        return;
    }
    
    cdxColorWhite = [[CDXColor alloc] init];
    cdxColorWhite->red = 255;
    cdxColorWhite->green = 255;
    cdxColorWhite->blue = 255;
    cdxColorWhite->alpha = 255;
    
    cdxColorBlack = [[CDXColor alloc] init];
    cdxColorBlack->alpha = 255;
}

- (NSString *)rgbaString {
    return [NSString stringWithFormat:@"%02x%02x%02x%02x", red, green, blue, alpha] ;
}

- (BOOL)isEqual:(id)anObject {
    if (![anObject isMemberOfClass:[CDXColor class]]) {
        return NO;
    }
    
    CDXColor *other = (CDXColor *)anObject;
    return red == other.red && green == other.green && blue == other.blue && alpha == other.alpha;
}

+ (CDXColor *)cdxColorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue alpha:(uint8_t)alpha {
    CDXColor *color = [[[CDXColor alloc] init] autorelease];
    if (color) {
        color->red = red;
        color->green = green;
        color->blue = blue;
        color->alpha = alpha;
    }
    return color;
}

+ (CDXColor *)cdxColorWithRGBAString:(NSString *)string defaulsTo:(CDXColor *)defaultColor {
    if (string == nil) {
        return [[defaultColor retain] autorelease];
    }
    
    const NSUInteger stringLength = [string length];
    if (stringLength < 6) {
        return [[defaultColor retain] autorelease];
    }
    
    unsigned int nibbles[8];
    nibbles[6] = 0xf;
    nibbles[7] = 0xf;
    const NSUInteger iMax = stringLength < 8 ? 6 : 8;
    for (NSUInteger i = 0; i < iMax; i++) {
        unichar character = [string characterAtIndex:i];
        if (character >= '0' && character <= '9') {
            nibbles[i] = (unsigned int)character - '0';
        } else if (character >= 'a' && character <= 'f') {
            nibbles[i] = (unsigned int)character - 'a' + 10; 
        } else if (character >= 'A' && character <= 'F') {
            nibbles[i] = (unsigned int)character - 'A' + 10;
        } else {
            return [[defaultColor retain] autorelease];
        }
    }
    
    return [CDXColor cdxColorWithRed:(nibbles[0] << 4) | nibbles[1]
                               green:(nibbles[2] << 4) | nibbles[3]
                                blue:(nibbles[4] << 4) | nibbles[5]
                               alpha:(nibbles[6] << 4) | nibbles[7]];
}

+ (CDXColor *)cdxColorWhite {
    return cdxColorWhite;
}

+ (CDXColor *)cdxColorBlack {
    return cdxColorBlack;
}

@end

