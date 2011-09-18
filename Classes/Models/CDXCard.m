//
//
// CDXCard.m
//
//
// Copyright (c) 2009-2011 Arne Harren <ah@0xc0.de>
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

#import "CDXCard.h"

#undef ql_component
#define ql_component lcl_cModel


@implementation CDXCard

@synthesize text;
@synthesize textColor;
@synthesize backgroundColor;
@synthesize orientation;
@synthesize cornerStyle;
@synthesize fontSize;

- (id)init {
    qltrace();
    if ((self = [super init])) {
        ivar_assign_and_copy(text, @"");
        ivar_assign_and_retain(textColor, [CDXColor colorWhite]);
        ivar_assign_and_retain(backgroundColor, [CDXColor colorBlack]);
        orientation = CDXCardOrientationDefault;
        cornerStyle = CDXCardCornerStyleDefault;
        fontSize = CDXCardFontSizeDefault;
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(text);
    ivar_release_and_clear(textColor);
    ivar_release_and_clear(backgroundColor);
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    CDXCard *copy = [[[self class] allocWithZone:zone] init];
    copy.text = text;
    copy.textColor = textColor;
    copy.backgroundColor = backgroundColor;
    copy.orientation = orientation;
    copy.cornerStyle = cornerStyle;
    copy.fontSize = fontSize;
    return copy;
}

- (void)invalidateFontSizeCache {
    fontSizeCacheNextIndex = 0;
}

- (void)setText:(NSString *)aText {
    [self invalidateFontSizeCache];
    if (!aText) {
        aText = @"";
    }
    // canonicalize linebreaks to \n
    ivar_assign_and_copy(text, [aText stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"]);
}

- (void)setCornerStyle:(CDXCardCornerStyle)aCornerStyle {
    ivar_enum_assign(cornerStyle, CDXCardCornerStyle, aCornerStyle);
}

- (void)setOrientation:(CDXCardOrientation)aOrientation {
    ivar_enum_assign(orientation, CDXCardOrientation, aOrientation);
}

- (void)setFontSize:(CGFloat)aFontSize {
    [self invalidateFontSizeCache];
    fontSize = floor(fabs(aFontSize));
    fontSize = fontSize < CDXCardFontSizeMax ? fontSize : CDXCardFontSizeMax;
}

- (CGFloat)fontSizeConstrainedToSize:(CGSize)size scale:(CGFloat)scale {
    qltrace(@"%3.0f x %3.0f", size.width, size.height);
    if (fontSize != CDXCardFontSizeAutomatic) {
        CGFloat fixedFontSize = floor(fontSize * CDXCardFontSizeScale * scale);
        qltrace(@"fixed: %3.0f", fixedFontSize);
        return fixedFontSize;
    } else {
        for (NSUInteger i = 0; i < fontSizeCacheNextIndex; i++) {
            if (fontSizeCacheSize[i].height == size.height &&
                fontSizeCacheSize[i].width == size.width) {
                CGFloat cachedFontSize = fontSizeCacheFontSize[i];
                qltrace("cached: %3.0f index: %d", cachedFontSize, i);
                return cachedFontSize;
            }
        }
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSArray *textLines = [text componentsSeparatedByString:@"\n"];
        NSUInteger textLinesCount = [textLines count];
        size.height = size.height / textLinesCount;
        
        CGFloat minlineFontSize = CDXCardFontSizeMax * CDXCardFontSizeScale * scale;
        UIFont *font = [UIFont systemFontOfSize:floor(minlineFontSize)];
        
        // calculate the minimal font size based on all text lines
        for (NSString *textLine in textLines) {
            // use a single space for an empty line
            if ([@"" isEqualToString:textLine]) {
                textLine = @" ";
            }
            
            CGFloat lineFontSize;
            {
                UIFont *fontWithMinlineFontSize = [font fontWithSize:floor(minlineFontSize)];
                [textLine sizeWithFont:fontWithMinlineFontSize minFontSize:12 actualFontSize:&lineFontSize forWidth:size.width lineBreakMode:UILineBreakModeClip];
            }
            
            CGSize lineSize;
            {
                UIFont *fontWithlineFontSize = [font fontWithSize:floor(lineFontSize)];
                lineSize = [textLine sizeWithFont:fontWithlineFontSize constrainedToSize:size];
            }
            
            if (lineSize.height > size.height) {
                lineFontSize = lineFontSize / lineSize.height * size.height;
                UIFont *fontWithlineFontSize = [font fontWithSize:floor(lineFontSize)];
                [textLine sizeWithFont:fontWithlineFontSize minFontSize:12 actualFontSize:&lineFontSize forWidth:size.width lineBreakMode:UILineBreakModeClip];
            }
            
            minlineFontSize = MIN(minlineFontSize, lineFontSize);
        }
        minlineFontSize = floor(minlineFontSize);
        [pool release];
        
        if (fontSizeCacheNextIndex < CDXCardFontSizeCacheSize) {
            fontSizeCacheFontSize[fontSizeCacheNextIndex] = minlineFontSize;
            fontSizeCacheSize[fontSizeCacheNextIndex] = size;
            qltrace(@"calculated: %3.0f index: %d", minlineFontSize, fontSizeCacheNextIndex);
            fontSizeCacheNextIndex++;
        } else {
            qltrace(@"calculated: %3.0f", minlineFontSize);
        }
        
        return minlineFontSize;
    }
}

- (NSString *)description {
    return text;
}

+ (CDXCardOrientation)cardOrientationFromString:(NSString *)string {
    // valid orientations are 'u', 'r', 'd', and 'l', everything else maps to 'u'
    string = [string lowercaseString];
    if ([@"r" isEqualToString:string]) {
        return CDXCardOrientationRight;
    } else if ([@"d" isEqualToString:string]) {
        return CDXCardOrientationDown;
    } else if ([@"l" isEqualToString:string]) {
        return CDXCardOrientationLeft;
    } else {
        return CDXCardOrientationUp;
    }
}

+ (NSString *)stringFromCardOrientation:(CDXCardOrientation)cardOrientation {
    // return orientation: 'u', 'r', 'd', or 'l'
    switch (cardOrientation) {
        case CDXCardOrientationUp:
        default:
            return @"u";
        case CDXCardOrientationRight:
            return @"r";
        case CDXCardOrientationDown:
            return @"d";
        case CDXCardOrientationLeft:
            return @"l";
    }
}

@end

