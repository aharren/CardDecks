//
//
// CDXCardsStackView.m
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

#import "CDXCardsStackView.h"
#import "CDXImageFactory.h"

#undef ql_component
#define ql_component lcl_cCDXCardsStackView


@interface CDXCardsStackViewScrollView : UIScrollView {
    
}

@end


@interface CDXCardsStackViewScrollViewDelegate : NSObject<UIScrollViewDelegate> {
    
@protected
    CDXCardsStackView *cardsStackView;
    
}

@property (nonatomic, assign) CDXCardsStackView *cardsStackView;

@end


@implementation CDXCardsStackView

- (id)initWithFrame:(CGRect)rect {
    qltrace();
    if ((self = [super initWithFrame:rect])) {
        ivar_assign(scrollView, [[CDXCardsStackViewScrollView alloc] initWithFrame:self.frame]);
        ivar_assign(scrollViewDelegate, [[CDXCardsStackViewScrollViewDelegate alloc] init]);
        
        scrollView.delegate = scrollViewDelegate;
        scrollViewDelegate.cardsStackView = self;
        
        ivar_assign(cardImages, [[CDXObjectCache alloc] initWithSize:3]);
        ivar_array_assign(cardViewsView, CDXCardsStackViewCardViewsSize, [[UIImageView alloc] initWithImage:nil]);
        
        [self addSubview:cardViewsView[CDXCardsStackViewCardViewsBottom]];
        [self addSubview:cardViewsView[CDXCardsStackViewCardViewsMiddle]];
        [self addSubview:scrollView];
        
        [scrollView addSubview:cardViewsView[CDXCardsStackViewCardViewsTopLeft]];
        [scrollView addSubview:cardViewsView[CDXCardsStackViewCardViewsTopRight]];
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(scrollView);
    ivar_release_and_clear(scrollViewDelegate);
    ivar_release_and_clear(cardImages);
    ivar_array_release_and_clear(cardViewsView, CDXCardsStackViewCardViewsSize);
    [super dealloc];
}

- (void)configureCardViewsViewAtIndex:(NSUInteger)viewIndex cardIndex:(NSUInteger)cardIndex {
    UIImageView *view = cardViewsView[viewIndex];
    
    if (cardIndex >= cardsCount) {
        view.image = nil;
        view.hidden = YES;
        return;
    }
    
    UIImage *image = [cardImages objectWithKey:cardIndex];
    if (image != nil) {
        qltrace(@": => %d", cardIndex);
    } else {
        image = [[CDXImageFactory sharedImageFactory]
                 imageForCard:[viewDataSource cardsViewDataSourceCardAtIndex:cardIndex]
                 size:cardViewsSize
                 deviceOrientation:[[UIDevice currentDevice] orientation]];
        qltrace(@": X> %d", cardIndex);
    }
    view.image = image;
    view.hidden = NO;
}

- (void)showCardAtIndex:(NSUInteger)cardIndex tellDelegate:(BOOL)tellDelegate {
    [self configureCardViewsViewAtIndex:CDXCardsStackViewCardViewsTopLeft cardIndex:cardIndex-1];
    [self configureCardViewsViewAtIndex:CDXCardsStackViewCardViewsTopRight cardIndex:cardIndex];
    [self configureCardViewsViewAtIndex:CDXCardsStackViewCardViewsMiddle cardIndex:cardIndex];
    [self configureCardViewsViewAtIndex:CDXCardsStackViewCardViewsBottom cardIndex:cardIndex+1];
    
    [cardImages clear];
    [cardImages addObject:cardViewsView[CDXCardsStackViewCardViewsTopLeft].image withKey:cardIndex-1];
    [cardImages addObject:cardViewsView[CDXCardsStackViewCardViewsTopRight].image withKey:cardIndex];
    [cardImages addObject:cardViewsView[CDXCardsStackViewCardViewsBottom].image withKey:cardIndex+1];
    
    currentCardIndex = cardIndex;
    scrollView.contentOffset = CGPointMake(scrollViewPageWidth, 0);
    if (tellDelegate) {
        [viewDelegate cardsViewDelegateCurrentCardIndexHasChangedTo:currentCardIndex];
    }
}

- (void)showCardAtIndex:(NSUInteger)cardIndex {
    [self showCardAtIndex:cardIndex tellDelegate:YES];
}

- (NSUInteger)currentCardIndex {
    return currentCardIndex;
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
    cardViewsSize.width = frame.size.width;
    cardViewsSize.height = frame.size.height;
    scrollViewPageWidth = cardViewsSize.width;
    scrollView.frame = frame;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.contentSize = CGSizeMake(scrollViewPageWidth * 3, cardViewsSize.height);
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = nil;
    scrollView.bounces = NO;
    
    for (NSUInteger i = 0; i < CDXCardsStackViewCardViewsSize; i++) {
        cardViewsView[i].frame = CGRectMake(0, 0, cardViewsSize.width, cardViewsSize.height);
    }
    cardViewsView[CDXCardsStackViewCardViewsTopRight].frame = CGRectMake(cardViewsSize.width, 0, cardViewsSize.width, cardViewsSize.height);
    
    [self showCardAtIndex:currentCardIndex];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // send touch events only if the scroll view is not scrolling
    if ((int)scrollView.contentOffset.x % (int)(scrollViewPageWidth) == 0) {
        [viewDelegate cardsViewDelegateTouchesEnded:touches withEvent:event];
    }
}

- (void)scrollViewDidEndScrolling {
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = scrollViewPageWidth;
    qltrace(": %f %d", x, scrollViewDirection);
    
    switch (scrollViewDirection) {
        case CDXCardsStackViewScrollViewDirectionNone:
        default:
            // there was no scroll direction, nothing to do
            break;
        case CDXCardsStackViewScrollViewDirectionRightIn:
            if (x <= 0) {
                // the top left card was completely moved to the right
                [self showCardAtIndex:currentCardIndex - 1];
            } else {
                // scrolling was aborted
                [self showCardAtIndex:currentCardIndex tellDelegate:NO];
            }
            break;
        case CDXCardsStackViewScrollViewDirectionLeftOut:
            if (x >= 2*width) {
                // the top right card was completely moved to the left
                [self showCardAtIndex:currentCardIndex + 1];
            } else {
                // scrolling was aborted
                [self showCardAtIndex:currentCardIndex tellDelegate:NO];
            }
            break;
    }
    
    scrollViewDirection = CDXCardsStackViewScrollViewDirectionNone;
}

- (void)scrollViewDidEndDecelerating {
    qltrace();
    if (scrollViewDirection != CDXCardsStackViewScrollViewDirectionNone) {
        [self performSelector:@selector(scrollViewDidEndScrolling) withObject:nil afterDelay:0.01];
    }
}

- (void)scrollViewDidScroll {
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = scrollViewPageWidth;
    
    if (currentCardIndex == 0 && x <= width) {
        // we can't scroll the topmost card to the right
        scrollView.contentOffset = CGPointMake(width, 0);
        return;
    }
    
    if (currentCardIndex == cardsCount-1 && x >= width) {
        // we can't scroll the bottommost card to the left
        scrollView.contentOffset = CGPointMake(width, 0);
        return;
    }
    
    switch (scrollViewDirection) {
        case CDXCardsStackViewScrollViewDirectionNone:
        default:
            if (x < width) {
                // scroll to the right which moves the top left card in
                scrollViewDirection = CDXCardsStackViewScrollViewDirectionRightIn;
                cardViewsView[CDXCardsStackViewCardViewsTopRight].hidden = YES;
                cardViewsView[CDXCardsStackViewCardViewsMiddle].hidden = NO;
            } else if (x > width) {
                // scroll to the left which moves the top right card out
                scrollViewDirection = CDXCardsStackViewScrollViewDirectionLeftOut;
                cardViewsView[CDXCardsStackViewCardViewsTopRight].hidden = NO;
                cardViewsView[CDXCardsStackViewCardViewsMiddle].hidden = YES;
            }
            break;
        case CDXCardsStackViewScrollViewDirectionRightIn:
            // there are no restrictions when scrolling to the right
            break;
        case CDXCardsStackViewScrollViewDirectionLeftOut:
            if (x <= width) {
                // we can't scroll the top right card to the right
                scrollView.contentOffset = CGPointMake(width, 0);
            }
            break;
    }
}

@end


@implementation CDXCardsStackViewScrollView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview touchesEnded:touches withEvent:event];
}

- (void)dealloc {
    qltrace();
    [super dealloc];
}

@end


@implementation CDXCardsStackViewScrollViewDelegate

@synthesize cardsStackView;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [cardsStackView scrollViewDidEndDecelerating]; 
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [cardsStackView scrollViewDidScroll];
}

- (void)dealloc {
    qltrace();
    [super dealloc];
}

@end

