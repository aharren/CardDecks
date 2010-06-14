//
//
// CDXImageFactory.m
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

#import "CDXImageFactory.h"
#include <QuartzCore/QuartzCore.h>

#undef ql_component
#define ql_component lcl_cImage


@implementation CDXImageFactory

synthesize_singleton(sharedImageFactory, CDXImageFactory);

static CGImageRef CDXImageFactoryCreateScreenImage(void) {
    extern CGImageRef UIGetScreenImage(void);
    
    return UIGetScreenImage();
}

- (UIImage *)imageForView:(UIView *)view size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)initCardView {
    ivar_release_and_clear(cardView);
    [[NSBundle mainBundle] loadNibNamed:@"CDXCardView" owner:self options:nil];
}

- (UIImage *)imageForCard:(CDXCard *)card size:(CGSize)size deviceOrientation:(UIDeviceOrientation)deviceOrientation {
    if (!cardView) {
        [self initCardView];
    }
    [cardView initWithCard:card size:(CGSize)size deviceOrientation:deviceOrientation];
    return [self imageForView:cardView size:size];
}

- (UIImage *)imageForColor:(CDXColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    // background
    if (color != nil) {
        CGContextSetFillColorWithColor(cgContext, [[color uiColor] CGColor]);
    } else {
        CGContextSetFillColorWithColor(cgContext, [[UIColor whiteColor] CGColor]);
    }
    CGContextFillRect(cgContext, CGRectMake(0, 0, size.width, size.height));
    // border
    CGContextSetStrokeColorWithColor(cgContext, [[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3] CGColor]);
    CGPoint cgPoints[] = {
        CGPointMake(0, 0),
        CGPointMake(size.width, 0),
        CGPointMake(size.width, 1),
        CGPointMake(size.width, size.height-1),
        CGPointMake(size.width, size.height),
        CGPointMake(0, size.height),
        CGPointMake(0, size.height-1),
        CGPointMake(0, 1),
    };
    CGContextStrokeLineSegments(cgContext, cgPoints, 8);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageForScreen {
#if TARGET_IPHONE_SIMULATOR
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIView *window = [CDXAppWindowManager sharedAppWindowManager].window;
    return [self imageForView:window size:bounds.size];
#else
    CGImageRef cgImage = CDXImageFactoryCreateScreenImage();
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
#endif
}

@end

