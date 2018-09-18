//
//
// CDXCardViewImageRendering.m
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

#import "CDXCardViewImageRendering.h"
#import "CDXImageFactory.h"

#undef ql_component
#define ql_component lcl_cView


@implementation CDXCardViewImageRendering

- (id)initWithSize:(NSUInteger)size  {
    qltrace();
    if ((self = [super init])) {
        ivar_assign(imageCache, [[CDXObjectCache alloc] initWithSize:size]);
        ivar_assign(imageViews, [[NSMutableArray alloc] initWithCapacity:size]);
        for (NSUInteger i = 0; i < size; i++) {
            [imageViews addObject:[[[UIImageView alloc] initWithImage:nil] autorelease]];
        }
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(imageCache);
    ivar_release_and_clear(imageViews);
    [super dealloc];
}

- (UIView *)viewAtIndex:(NSUInteger)index {
    qltrace();
    return (UIView *)imageViews[index];
}

- (UIView *)configureViewAtIndex:(NSUInteger)index viewSize:(CGSize)viewSize cardIndex:(NSUInteger)cardIndex card:(CDXCard *)card deviceOrientation:(UIDeviceOrientation)deviceOrientation {
    qltrace();
    UIImage *image = [imageCache objectWithKey:cardIndex];
    if (image != nil) {
        qltrace(@"%lu => %lu; hit", (unsigned long)index, (unsigned long)cardIndex);
    } else {
        image = [[CDXImageFactory sharedImageFactory] imageForCard:card size:viewSize deviceOrientation:deviceOrientation];
        qltrace(@"%lu => %lu; miss", (unsigned long)index, (unsigned long)cardIndex);
    }
    UIImageView *view = (UIImageView *)imageViews[index];
    view.image = image;
    return view;
}

- (void)invalidateCaches {
    qltrace();
    [imageCache clear];
}

- (void)cacheViewAtIndex:(NSUInteger)index cardIndex:(NSUInteger)cardIndex {
    qltrace(@"%lu => %lu; cache", (unsigned long)index, (unsigned long)cardIndex);
    UIImageView *view = (UIImageView *)imageViews[index];
    [imageCache addObject:view.image withKey:cardIndex];
}


@end
