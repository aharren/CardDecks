//
//
// CDXCardsSideBySideView.m
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

#import "CDXCardsSideBySideView.h"
#import "CDXImageFactory.h"

#undef ql_component
#define ql_component lcl_cCDXCardsSideBySideView


@interface CDXCardsSideBySideViewScrollView : UIScrollView {
    
}

@end


@implementation CDXCardsSideBySideViewScrollView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview touchesEnded:touches withEvent:event];
}

- (void)dealloc {
    qltrace();
    [super dealloc];
}

@end


@implementation CDXCardsSideBySideView

@synthesize viewDelegate;
@synthesize viewDataSource;

- (id)initWithFrame:(CGRect)rect {
    qltrace();
    if ((self = [super initWithFrame:rect])) {
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(scrollView);
    [super dealloc];
}

- (void)didMoveToSuperview {
    qltrace(@": %@", self.superview);
    [super didMoveToSuperview];
    if (self.superview == nil) {
        [scrollView removeFromSuperview];
        ivar_release_and_clear(scrollView);
    } else {
        ivar_assign(scrollView, [[CDXCardsSideBySideViewScrollView alloc] initWithFrame:self.frame]);
        [self addSubview:scrollView];
        
        NSUInteger cardsCount = [viewDataSource cardsViewDataSourceCardsCount];
        
        CGRect frame = self.frame;
        const CGFloat gapSize = 10;
        CGFloat frameWidth = frame.size.width;
        CGFloat frameWidthPlusGap = frameWidth + 2 * gapSize;
        CGFloat frameHeight = frame.size.height;
        frame.origin.x -= gapSize;
        frame.size.width = frameWidthPlusGap;
        scrollView.frame = frame;
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.contentSize = CGSizeMake(frameWidthPlusGap * cardsCount, frameHeight);
        scrollView.scrollEnabled = YES;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        
        for (NSUInteger i = 0; i < cardsCount; i++) {
            UIImage *cardImage = [[CDXImageFactory sharedImageFactory]
                                  imageForCard:[viewDataSource cardsViewDataSourceCardAtIndex:i]
                                  size:[UIScreen mainScreen].bounds.size
                                  deviceOrientation:[[UIDevice currentDevice] orientation]];
            UIImageView *cardImageView = [[[UIImageView alloc] initWithImage:cardImage] autorelease];
            [scrollView addSubview:cardImageView];
            cardImageView.frame = CGRectMake(frameWidthPlusGap * i + gapSize, 0, frameWidth, frameHeight);
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [viewDelegate cardsViewDelegateTouchesEnded:touches withEvent:event];
}

@end

