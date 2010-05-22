//
//
// CDXCardView.m
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

#import "CDXCardView.h"
#import <QuartzCore/QuartzCore.h>


@implementation CDXCardView

- (CDXCardOrientation)cardOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
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

- (CGAffineTransform)transformFromCardOrientation:(CDXCardOrientation)cardOrientation {
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

- (id)initWithCard:(CDXCard *)card size:(CGSize)size deviceOrientation:(UIDeviceOrientation)deviceOrientation {
    // calculate orientation
    CDXCardOrientation cardOrientation = card.orientation + [self cardOrientationFromDeviceOrientation:deviceOrientation];
    cardOrientation %= CDXCardOrientationCount;
    
    // get text
    NSString *text = card.text;
    if (text == nil) text = @"";
    // add a single space for the last line if it is empty
    if ([text length] >= 1 && [text characterAtIndex:[text length]-1] == '\n') {
        text = [text stringByAppendingString:@" "];
    }
    
    // scaling
    CGFloat scale = MIN(size.width, size.height) / 320.0;
    
    // set size
    self.frame = CGRectMake(0, 0, size.width, size.height);
    
    // update text
    CGFloat fontSize = [card fontSizeConstrainedToSize:[self sizeForCardOrientation:cardOrientation size:size]];
    cardText.bounds = CGRectMake(0, 0, 1024, 1024);
    cardText.numberOfLines = 0;
    cardText.font = [UIFont systemFontOfSize:fontSize];
    cardText.text = text;
    cardText.textColor = [card.textColor uiColor];
    cardText.transform = [self transformFromCardOrientation:cardOrientation];
    
    // update background
    cardText.backgroundColor = [card.backgroundColor uiColor];
    
    // update border
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blackColor];
    CALayer *borderLayer = self.layer;
    borderLayer.borderColor = [[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3] CGColor];
    borderLayer.borderWidth = 1;
    
    switch (card.cornerStyle) {
        default:
        case CDXCardCornerStyleRounded:
            borderLayer.cornerRadius = 20.0 * scale;
            break;
        case CDXCardCornerStyleCornered:
            borderLayer.cornerRadius = 3.0 * scale;
            break;
    }
    
    // set alpha
    self.alpha = 1.0;
    
    return self;
}

- (id)initWithThumbnailCard:(CDXCard *)card size:(CGSize)size {
    // set size
    self.frame = CGRectMake(0, 0, size.width, size.height);
    
    // update text
    cardText.text = @"";
    
    // update background
    cardText.backgroundColor = card ? [card.backgroundColor uiColor] : [UIColor whiteColor];
    
    // update border
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blackColor];
    CALayer *borderLayer = self.layer;
    borderLayer.borderColor = card ? [[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3] CGColor] : nil;
    borderLayer.borderWidth = 1;
    borderLayer.cornerRadius = 0;
    
    // set alpha
    self.alpha = card ? 1.0 : 0.0;
    
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(cardText);
    [super dealloc];
}

@end

