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
#define ql_component lcl_cView


@interface CDXCardsSideBySideViewScrollView : UIScrollView {
    
}

@end


@interface CDXCardsSideBySideViewScrollViewDelegate : NSObject<UIScrollViewDelegate> {
    
@protected
    CDXCardsSideBySideView *cardsSideBySideView;
    
}

@property (nonatomic, assign) CDXCardsSideBySideView *cardsSideBySideView;

@end


@implementation CDXCardsSideBySideView

- (id)initWithFrame:(CGRect)rect {
    qltrace();
    if ((self = [super initWithFrame:rect])) {
        ivar_assign(scrollView, [[CDXCardsSideBySideViewScrollView alloc] initWithFrame:self.frame]);
        ivar_assign(scrollViewDelegate, [[CDXCardsSideBySideViewScrollViewDelegate alloc] init]);

        scrollView.delegate = scrollViewDelegate;
        scrollViewDelegate.cardsSideBySideView = self;

        ivar_array_assign(cardViewsView, CDXCardsSideBySideViewCardViewsSize, [[UIImageView alloc] initWithImage:nil]);
        
        [self addSubview:scrollView];

        for (NSUInteger i = 0; i < CDXCardsSideBySideViewCardViewsSize; i++) {
            [scrollView addSubview:cardViewsView[i]];
        }
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(scrollView);
    ivar_release_and_clear(scrollViewDelegate);
    ivar_array_release_and_clear(cardViewsView, CDXCardsSideBySideViewCardViewsSize);
    [super dealloc];
}

- (void)configureCardViewsViewAtIndex:(NSUInteger)viewIndex cardIndex:(NSUInteger)cardIndex {
    if (cardIndex >= cardsCount) {
        return;
    }
    viewIndex += CDXCardsSideBySideViewCardViewsSize;
    viewIndex %= CDXCardsSideBySideViewCardViewsSize;
    if (cardViewsCardIndex[viewIndex] == cardIndex+1) {
        qltrace(@": %d => %d", viewIndex, cardIndex);
        return;
    }
    cardViewsCardIndex[viewIndex] = cardIndex+1;
    UIImageView *view = cardViewsView[viewIndex];
    UIImage *image = [[CDXImageFactory sharedImageFactory]
                      imageForCard:[viewDataSource cardsViewDataSourceCardAtIndex:cardIndex]
                      size:cardViewsSize
                      deviceOrientation:deviceOrientation];
    view.frame = CGRectMake(scrollViewPageWidth * cardIndex + cardViewsBorder, 0, cardViewsSize.width, cardViewsSize.height);
    view.image = image;
    qltrace(@": %d X> %d", viewIndex, cardIndex);
}

- (void)invalidateDataSourceCaches {
    ivar_array_set(cardViewsCardIndex, CDXCardsSideBySideViewCardViewsSize, 0);
}

- (void)showCardAtIndex:(NSUInteger)cardIndex tellDelegate:(BOOL)tellDelegate cached:(BOOL)cached {
    NSUInteger viewIndex = 0;
    for (NSUInteger i = 0; i < CDXCardsSideBySideViewCardViewsSize; i++) {
        if (cardViewsCardIndex[i] == cardIndex+1) {
            viewIndex = i;
            break;
        }
    }

    if (!cached) {
        ivar_array_set(cardViewsCardIndex, CDXCardsSideBySideViewCardViewsSize, 0);
    }
    
    qltrace(@": %d %d", cardIndex, viewIndex);
    for (NSUInteger i = 0; i < CDXCardsSideBySideViewCardViewsSize; i++) {
        [self configureCardViewsViewAtIndex:viewIndex-CDXCardsSideBySideViewCardViewsSize/2+i cardIndex:cardIndex-CDXCardsSideBySideViewCardViewsSize/2+i];
    }
    
    currentCardIndex = cardIndex;
    scrollView.contentOffset = CGPointMake(scrollViewPageWidth * cardIndex, 0);
    if (tellDelegate) {
        [viewDelegate cardsViewDelegateCurrentCardIndexHasChangedTo:currentCardIndex];
    }
}

- (void)showCardAtIndex:(NSUInteger)cardIndex {
    [self showCardAtIndex:cardIndex tellDelegate:YES cached:YES];
}

- (void)scrollToCardIndex:(NSUInteger)cardIndex {
    CGRect frame = scrollView.frame;
    frame.origin.x = scrollViewPageWidth * cardIndex;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:NO];
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

    [self showCardAtIndex:currentCardIndex tellDelegate:NO cached:NO];
}

- (void)didMoveToSuperview {
    qltrace(@": %@", self.superview);
    [super didMoveToSuperview];
    if (self.superview == nil) {
        return;
    }
    
    cardsCount = [viewDataSource cardsViewDataSourceCardsCount];
    currentCardIndex = [viewDataSource cardsViewDataSourceInitialCardIndex];
    
    CGRect frame = self.frame;
    cardViewsBorder = 10;
    cardViewsSize.width = frame.size.width;
    cardViewsWidthWithBorder = cardViewsSize.width + 2 * cardViewsBorder;
    cardViewsSize.height = frame.size.height;
    frame.origin.x -= cardViewsBorder;
    frame.size.width = cardViewsWidthWithBorder;
    scrollViewPageWidth = cardViewsWidthWithBorder;
    scrollView.frame = frame;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.contentSize = CGSizeMake(scrollViewPageWidth * cardsCount, cardViewsSize.height);
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    for (NSUInteger i = 0; i < CDXCardsSideBySideViewCardViewsSize; i++) {
        cardViewsCardIndex[i] = 0;
    }
    
    [self showCardAtIndex:currentCardIndex];
    [self scrollToCardIndex:currentCardIndex];
}

- (void)scrollViewDidEndDecelerating {
    const CGFloat contentOffsetX = scrollView.contentOffset.x;
    const NSUInteger newCardIndex = contentOffsetX / scrollViewPageWidth;
    
    if (currentCardIndex != newCardIndex) {
        [self showCardAtIndex:newCardIndex];
    }
}

- (void)scrollViewDidScroll {
    const CGFloat width = scrollViewPageWidth;
    
    const CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (contentOffsetX < 0 || contentOffsetX > width * (cardsCount-1)) {
        return;
    }
    
    const CGFloat contentOffsetXCurrentPage = (currentCardIndex * width);
    const CGFloat contentOffsetXDiff = contentOffsetX - contentOffsetXCurrentPage;
    if (abs(contentOffsetXDiff) < width + 20) {
        return;
    }
    
    const NSUInteger newCardIndex = contentOffsetXDiff > 0 ? (contentOffsetX / width) : ((contentOffsetX + width-1) / width);
    
    if (currentCardIndex != newCardIndex) {
        [self showCardAtIndex:newCardIndex];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // send touch events only if the scroll view is not scrolling
    if ((int)scrollView.contentOffset.x % (int)(scrollViewPageWidth) == 0) {
        [viewDelegate cardsViewDelegateTouchesEnded:touches withEvent:event];
    }
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


@implementation CDXCardsSideBySideViewScrollViewDelegate

@synthesize cardsSideBySideView;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [cardsSideBySideView scrollViewDidEndDecelerating];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [cardsSideBySideView scrollViewDidScroll];
}

- (void)dealloc {
    qltrace();
    [super dealloc];
}

@end

