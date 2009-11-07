//
//
// CDXCardOrientation.m
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

#import "CDXCardOrientation.h"


@implementation CDXCardOrientationHelper

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

+ (CDXCardOrientation)cardOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
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

+ (CGAffineTransform)transformFromCardOrientation:(CDXCardOrientation)cardOrientation {
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

@end

