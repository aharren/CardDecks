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


@interface CDXCardsSideBySideViewScrollViewDelegate : NSObject<UIScrollViewDelegate> {
    
@protected
    CDXCardsSideBySideView *cardsSideBySideView;
    
}

@property (nonatomic, assign) CDXCardsSideBySideView *cardsSideBySideView;

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
    ivar_release_and_clear(scrollViewDelegate);
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
                      deviceOrientation:[[UIDevice currentDevice] orientation]];
    view.frame = CGRectMake(cardViewsWidthWithBorder * cardIndex + cardViewsBorder, 0, cardViewsSize.width, cardViewsSize.height);
    view.image = image;
    qltrace(@": %d X> %d", viewIndex, cardIndex);
}

- (void)configureViewWithCardIndex:(NSUInteger)cardIndex {
    NSUInteger viewIndex = 0;
    for (NSUInteger i = 0; i < CDXCardsSideBySideViewCardViewsSize; i++) {
        if (cardViewsCardIndex[i] == cardIndex+1) {
            viewIndex = i;
            break;
        }
    }
    
    qltrace(@": %d %d", cardIndex, viewIndex);
    for (NSUInteger i = 0; i < CDXCardsSideBySideViewCardViewsSize; i++) {
        [self configureCardViewsViewAtIndex:viewIndex-CDXCardsSideBySideViewCardViewsSize/2+i cardIndex:cardIndex-CDXCardsSideBySideViewCardViewsSize/2+i];
    }
    
    currentCardIndex = cardIndex;
}

- (void)scrollToCardIndex:(NSUInteger)cardIndex {
    CGRect frame = scrollView.frame;
    frame.origin.x = cardViewsWidthWithBorder * cardIndex;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:NO];
}

- (void)didMoveToSuperview {
    qltrace(@": %@", self.superview);
    [super didMoveToSuperview];
    if (self.superview == nil) {
        [scrollView removeFromSuperview];
        ivar_release_and_clear(scrollView);
        ivar_release_and_clear(scrollViewDelegate);
    } else {
        ivar_assign(scrollView, [[CDXCardsSideBySideViewScrollView alloc] initWithFrame:self.frame]);
        ivar_assign(scrollViewDelegate, [[CDXCardsSideBySideViewScrollViewDelegate alloc] init]);
        scrollView.delegate = scrollViewDelegate;
        scrollViewDelegate.cardsSideBySideView = self;
        cardsCount = [viewDataSource cardsViewDataSourceCardsCount];
        currentCardIndex = [viewDataSource cardsViewDataSourceInitialCardIndex];
        
        CGRect frame = self.frame;
        cardViewsBorder = 10;
        cardViewsSize.width = frame.size.width;
        cardViewsWidthWithBorder = cardViewsSize.width + 2 * cardViewsBorder;
        cardViewsSize.height = frame.size.height;
        frame.origin.x -= cardViewsBorder;
        frame.size.width = cardViewsWidthWithBorder;
        scrollView.frame = frame;
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.contentSize = CGSizeMake(cardViewsWidthWithBorder * cardsCount, cardViewsSize.height);
        scrollView.scrollEnabled = YES;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        
        for (NSUInteger i = 0; i < CDXCardsSideBySideViewCardViewsSize; i++) {
            UIImageView *view = [[[UIImageView alloc] initWithImage:nil] autorelease];
            [scrollView addSubview:view];
            cardViewsView[i] = view;
            cardViewsCardIndex[i] = 0;
        }
        
        [self addSubview:scrollView];
        
        [self configureViewWithCardIndex:currentCardIndex];
        [self scrollToCardIndex:currentCardIndex];
    }
}

- (void)scrollViewDidEndDecelerating {
    const CGFloat contentOffsetX = scrollView.contentOffset.x;
    const NSUInteger newCardIndex = contentOffsetX / cardViewsWidthWithBorder;
    
    if (currentCardIndex != newCardIndex) {
        [self configureViewWithCardIndex:newCardIndex];
    }
}

- (void)scrollViewDidScroll {
    const CGFloat width = cardViewsWidthWithBorder;
    
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
        [self configureViewWithCardIndex:newCardIndex];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [viewDelegate cardsViewDelegateTouchesEnded:touches withEvent:event];
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

@end

