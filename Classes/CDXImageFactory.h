//
//
// CDXImageFactory.h
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
#import "CDXCardView.h"


@interface CDXImageFactory : NSObject {
    
@protected
    IBOutlet CDXCardView *cardView;
}

declare_singleton(sharedImageFactory, CDXImageFactory);

- (UIImage *)imageForView:(UIView *)view size:(CGSize)size;

- (UIImage *)imageForCard:(CDXCard *)card size:(CGSize)size deviceOrientation:(UIDeviceOrientation)deviceOrientation;

- (UIImage *)imageForColor:(CDXColor *)color size:(CGSize)size;

- (UIImage *)imageForScreen;

@end

