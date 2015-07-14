//
//
// CDXCard.h
//
//
// Copyright (c) 2009-2015 Arne Harren <ah@0xc0.de>
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

#include "CDXColor.h"


typedef enum {
    CDXCardOrientationUp    = 0,
    CDXCardOrientationRight = 1,
    CDXCardOrientationDown  = 2,
    CDXCardOrientationLeft  = 3,
    CDXCardOrientationCount,
    CDXCardOrientationDefault = CDXCardOrientationUp
} CDXCardOrientation;

#define CDXCardOrientationIsPortrait(o) ((o) == CDXCardOrientationUp || (o) == CDXCardOrientationDown)


typedef enum {
    CDXCardCornerStyleRounded = 0,
    CDXCardCornerStyleCornered,
    CDXCardCornerStyleCount,
    CDXCardCornerStyleDefault = CDXCardCornerStyleRounded
} CDXCardCornerStyle;


#define CDXCardFontSizeAutomatic ((CGFloat) 0.0)
#define CDXCardFontSizeMax       ((CGFloat) 100.0)
#define CDXCardFontSizeDefault   CDXCardFontSizeAutomatic

#define CDXCardFontSizeScale     ((CGFloat) 5)

#define CDXCardFontSizeCacheSize 2

#define CDXCardTimerIntervalOff     ((NSTimeInterval) 0)
#define CDXCardTimerIntervalMin     ((NSTimeInterval) 1)
#define CDXCardTimerIntervalMax     ((NSTimeInterval) 60 * 60)
#define CDXCardTimerIntervalDefault ((NSTimeInterval) 5)

@interface CDXCard : NSObject<NSCopying> {
    
@protected
    NSString *text;
    CDXColor *textColor;
    CDXColor *backgroundColor;
    CDXCardOrientation orientation;
    CDXCardCornerStyle cornerStyle;
    CGFloat fontSize;
    NSTimeInterval timerInterval;
    
    NSUInteger fontSizeCacheNextIndex;
    CGSize fontSizeCacheSize[CDXCardFontSizeCacheSize];
    CGFloat fontSizeCacheFontSize[CDXCardFontSizeCacheSize];

    NSInteger tag;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) CDXColor *textColor;
@property (nonatomic, retain) CDXColor *backgroundColor;
@property (nonatomic, assign) CDXCardOrientation orientation;
@property (nonatomic, assign) CDXCardCornerStyle cornerStyle;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) NSTimeInterval timerInterval;
@property (nonatomic, assign) NSInteger tag;

- (CGFloat)fontSizeConstrainedToSize:(CGSize)size scale:(CGFloat)scale;

+ (CDXCardOrientation)cardOrientationFromString:(NSString *)string;
+ (NSString *)stringFromCardOrientation:(CDXCardOrientation)cardOrientation;

@end

