//
//
// CDXCardView.m
//
//
// Copyright (c) 2009-2018 Arne Harren <ah@0xc0.de>
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

#import "CDXCardView.h"
#import <QuartzCore/QuartzCore.h>

#undef ql_component
#define ql_component lcl_cView


@implementation CDXCardView

- (void)dealloc {
    ivar_release_and_clear(cardText);
    [super dealloc];
}

- (CDXCardOrientation)cardOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    // map the given device orientation to a card orientation
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
        default:
            return CDXCardOrientationUp;
        case UIDeviceOrientationLandscapeLeft:
            return CDXCardOrientationRight;
        case UIDeviceOrientationPortraitUpsideDown:
            return CDXCardOrientationDown;
        case UIDeviceOrientationLandscapeRight:
            return CDXCardOrientationLeft;
    }
}

+ (CGAffineTransform)transformForCardOrientation:(CDXCardOrientation)cardOrientation {
    // map the given card orientation to a transform
    CGFloat transformAngle;
    switch (cardOrientation) {
        case CDXCardOrientationUp:
        default:
            transformAngle = 0;
            break;
        case CDXCardOrientationRight:
            transformAngle = M_PI_2;
            break;
        case CDXCardOrientationDown:
            transformAngle = M_PI;
            break;
        case CDXCardOrientationLeft:
            transformAngle = -M_PI_2;
            break;
    }
    
    return CGAffineTransformRotate(CGAffineTransformIdentity, transformAngle);
}

- (CGSize)sizeForCardOrientation:(CDXCardOrientation)cardOrientation size:(CGSize)size {
    // map the given card orientation and size to a size
    switch (cardOrientation) {
        case CDXCardOrientationUp:
        case CDXCardOrientationDown:
        default:
            return size;
            break;
        case CDXCardOrientationRight:
        case CDXCardOrientationLeft:
            return CGSizeMake(size.height, size.width);
            break;
    }
}

- (void)setCard:(CDXCard *)card size:(CGSize)size deviceOrientation:(UIDeviceOrientation)deviceOrientation preview:(BOOL)preview {
    if (!cardText) {
        qltrace();
        ivar_assign(cardText, [[UILabel alloc] init]);
        cardText.numberOfLines = 0;
        cardText.lineBreakMode = NSLineBreakByClipping;
        cardText.textAlignment = NSTextAlignmentCenter;
        cardText.baselineAdjustment = 0;
        cardText.adjustsFontSizeToFitWidth = NO;
        [self addSubview:cardText];
        self.userInteractionEnabled = NO;
    }
    
    // calculate orientation
    const CDXCardOrientation cardOrientation = card.orientation;
    const CDXCardOrientation cardDisplayOrientation = (cardOrientation + [self cardOrientationForDeviceOrientation:deviceOrientation]) % CDXCardOrientationCount;
    
    // get text
    NSString *text = card.text;
    if (text == nil) text = @"";
    // add a single space for the last line if it is empty
    if ([text length] >= 1 && [text characterAtIndex:[text length]-1] == '\n') {
        text = [text stringByAppendingString:@" "];
    }
    
    // scaling
    CGFloat scale = size.height / 480.0;
    
    // set size
    self.frame = CGRectMake(0, 0, size.width, size.height);
    cardText.frame = self.frame;
    
    // update text
    CGFloat fontSize = [card fontSizeConstrainedToSize:[self sizeForCardOrientation:cardDisplayOrientation size:size] scale:scale];
    if (card.fontSize != CDXCardFontSizeAutomatic) {
        if (CDXCardOrientationIsPortrait(cardOrientation) != CDXCardOrientationIsPortrait(cardDisplayOrientation)) {
            fontSize = fontSize * size.width / size.height;
        }
    }
    if (CDXCardOrientationIsPortrait(cardDisplayOrientation)) {
        cardText.bounds = CGRectMake(0, 0, size.width + 100, size.height + 100);
    } else {
        cardText.bounds = CGRectMake(0, 0, size.height + 100, size.width + 100);
    }
    cardText.font = [UIFont systemFontOfSize:fontSize];
    cardText.text = text;
    cardText.textColor = [card.textColor uiColor];
    cardText.transform = [CDXCardView transformForCardOrientation:cardDisplayOrientation];
    
    // update background
    cardText.backgroundColor = [card.backgroundColor uiColor];
    
    // update border
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blackColor];
    CALayer *borderLayer = self.layer;
    borderLayer.borderColor = [[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1] CGColor];
    borderLayer.borderWidth = 1;
    
    borderLayer.cornerRadius = 0;
    if (!preview) {
        switch (card.cornerStyle) {
            default:
            case CDXCardCornerStyleRounded:
                borderLayer.cornerRadius = 20.0 * scale;
                break;
            case CDXCardCornerStyleCornered:
                borderLayer.cornerRadius = 3.0 * scale;
                break;
        }
    }
    
    // set alpha
    self.alpha = 1.0;
}

@end

