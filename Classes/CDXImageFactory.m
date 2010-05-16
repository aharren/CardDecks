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

- (UIImage *)imageForCard:(CDXCard *)card size:(CGSize)size deviceOrientation:(UIDeviceOrientation)deviceOrientation {
    if (!cardView) {
        [[NSBundle mainBundle] loadNibNamed:@"CDXCardView" owner:self options:nil];
    }
    [cardView initWithCard:card size:(CGSize)size deviceOrientation:deviceOrientation];
    return [self imageForView:cardView size:size];
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

