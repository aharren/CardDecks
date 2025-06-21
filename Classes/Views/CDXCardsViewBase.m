//
//
// CDXCardsViewBase.m
//
//
// Copyright (c) 2009-2025 Arne Harren <ah@0xc0.de>
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

#import "CDXCardsViewBase.h"
#import "CDXCardViewDirectRendering.h"
#import "CDXDevice.h"

#undef ql_component
#define ql_component lcl_cView


@implementation CDXCardsViewBase

@synthesize viewDelegate;
@synthesize viewDataSource;
@synthesize deviceOrientation;

- (id)initWithFrame:(CGRect)rect viewCount:(NSUInteger)viewCount {
    qltrace();
    if ((self = [super initWithFrame:rect])) {
        deviceOrientation = UIDeviceOrientationPortrait;
        
        NSObject<CDXCardViewRendering> *viewRendering = nil;
        viewRendering = [[CDXCardViewDirectRendering alloc] initWithSize:viewCount];
        ivar_assign(cardViewRendering, viewRendering);
    }
    return self;
}

- (id)initWithFrame:(CGRect)rect {
    return [self initWithFrame:rect viewCount:0];
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(cardViewRendering);
    [super dealloc];
}

- (void)registerTapGestureRecognizersOnView:(UIView *)view {
    UITapGestureRecognizer *tripleTapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(handleTripleTap:)] autorelease];
    tripleTapRecognizer.numberOfTapsRequired = 3;

    UITapGestureRecognizer *doubleTapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(handleDoubleTap:)] autorelease];
    doubleTapRecognizer.numberOfTapsRequired = 2;

    UITapGestureRecognizer *singleTapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(handleSingleTap:)] autorelease];
    singleTapRecognizer.numberOfTapsRequired = 1;

    [doubleTapRecognizer requireGestureRecognizerToFail:tripleTapRecognizer];
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];

    [view addGestureRecognizer:tripleTapRecognizer];
    [view addGestureRecognizer:doubleTapRecognizer];
    [view addGestureRecognizer:singleTapRecognizer];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    qltrace();
    if ([self tapGestureAllowed]) {
        [viewDelegate cardsViewDelegateTapRecognized:sender tapCount:1];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    qltrace();
    if ([self tapGestureAllowed]) {
        [viewDelegate cardsViewDelegateTapRecognized:sender tapCount:2];
    }
}

- (void)handleTripleTap:(UITapGestureRecognizer *)sender {
    qltrace();
    if ([self tapGestureAllowed]) {
        [viewDelegate cardsViewDelegateTapRecognized:sender tapCount:3];
    }
}

- (BOOL)tapGestureAllowed {
    return NO;
}

- (void)showCardAtIndex:(NSUInteger)index {
    [self showCardAtIndex:index tellDelegate:YES];
}

- (void)showCardAtIndex:(NSUInteger)index tellDelegate:(BOOL)tellDelegate {
    
}

- (void)invalidateDataSourceCaches {
    [cardViewRendering invalidateCaches];
}

- (NSUInteger)currentCardIndex {
    return currentCardIndex;
}

- (void)deviceOrientationDidChange:(UIDeviceOrientation)orientation {
    qltrace();
    deviceOrientation = orientation;
    if (self.superview == nil) {
        return;
    }
    
    [self invalidateDataSourceCaches];
    [self showCardAtIndex:currentCardIndex tellDelegate:NO];
}

@end

