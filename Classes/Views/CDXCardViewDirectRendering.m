//
//
// CDXCardViewDirectRendering.m
//
//
// Copyright (c) 2009-2012 Arne Harren <ah@0xc0.de>
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

#import "CDXCardViewDirectRendering.h"
#import "CDXCardView.h"

#undef ql_component
#define ql_component lcl_cView


@implementation CDXCardViewDirectRendering

- (id)initWithSize:(NSUInteger)size  {
    qltrace();
    if ((self = [super init])) {
        ivar_assign(directViews, [[NSMutableArray alloc] initWithCapacity:size]);
        for (NSUInteger i = 0; i < size; i++) {
            [directViews addObject:[[[CDXCardView alloc] initWithFrame:CGRectMake(0,0,1,1)] autorelease]];
        }
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(directViews);
    [super dealloc];
}

- (UIView *)viewAtIndex:(NSUInteger)index {
    qltrace();
    return (UIView *)[directViews objectAtIndex:index];
}

- (UIView *)configureViewAtIndex:(NSUInteger)index viewSize:(CGSize)viewSize cardIndex:(NSUInteger)cardIndex card:(CDXCard *)card deviceOrientation:(UIDeviceOrientation)deviceOrientation {
    qltrace();
    CDXCardView *view = [directViews objectAtIndex:index];
    [view setCard:card size:viewSize deviceOrientation:deviceOrientation preview:NO];
    return view;
}

- (void)invalidateCaches {
    qltrace();
}

- (void)cacheViewAtIndex:(NSUInteger)index cardIndex:(NSUInteger)cardIndex {
    qltrace();
}


@end
