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
    ivar_array_release_and_clear(cardImagesImage, CDXCardsStackViewCardImagesSize);
    [super dealloc];
}

- (void)configureCardViewsViewAtIndex:(NSUInteger)viewIndex cardIndex:(NSUInteger)cardIndex {
    UIImageView *view = cardViewsView[viewIndex];
    
    if (cardIndex >= cardsCount) {
        view.image = nil;
        view.hidden = YES;
        return;
    }
    
    NSUInteger imageIndex = CDXCardsStackViewCardImagesSize;
    for (NSUInteger i = 0; i < CDXCardsStackViewCardImagesSize; i++) {
        if (cardImagesCardIndex[i] == cardIndex+1) {
            imageIndex = i;
            break;
        }
    }
    
    UIImage *image = nil;
    if (imageIndex < CDXCardsStackViewCardImagesSize) {
        image = cardImagesImage[imageIndex];
        qltrace(@": %d => %d", imageIndex, cardIndex);
    } else {
        image = [[CDXImageFactory sharedImageFactory]
                 imageForCard:[viewDataSource cardsViewDataSourceCardAtIndex:cardIndex]
                 size:cardViewsSize
                 deviceOrientation:[[UIDevice currentDevice] orientation]];
        qltrace(@": %d X> %d", imageIndex, cardIndex);
    }
    view.image = image;
    view.hidden = NO;
}

- (void)showCardAtIndex:(NSUInteger)cardIndex tellDelegate:(BOOL)tellDelegate {
    [self configureCardViewsViewAtIndex:CDXCardsStackViewCardViewsTopLeft cardIndex:cardIndex-1];
    [self configureCardViewsViewAtIndex:CDXCardsStackViewCardViewsTopRight cardIndex:cardIndex];
    [self configureCardViewsViewAtIndex:CDXCardsStackViewCardViewsMiddle cardIndex:cardIndex];
    [self configureCardViewsViewAtIndex:CDXCardsStackViewCardViewsBottom cardIndex:cardIndex+1];
    
    ivar_assign_and_retain(cardImagesImage[0], cardViewsView[CDXCardsStackViewCardViewsTopLeft].image);
    cardImagesCardIndex[0] = cardIndex-1+1;
    ivar_assign_and_retain(cardImagesImage[1], cardViewsView[CDXCardsStackViewCardViewsTopRight].image);
    cardImagesCardIndex[1] = cardIndex+1;
    ivar_assign_and_retain(cardImagesImage[2], cardViewsView[CDXCardsStackViewCardViewsBottom].image);
    cardImagesCardIndex[2] = cardIndex+1+1;
    
    currentCardIndex = cardIndex;
    scrollView.contentOffset = CGPointMake(scrollViewPageWidth, 0);
    if (tellDelegate) {
        [viewDelegate cardsViewCurrentCardIndexHasChangedTo:currentCardIndex];
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
        [cardViewsView[CDXCardsStackViewCardViewsTopLeft] removeFromSuperview];
        [cardViewsView[CDXCardsStackViewCardViewsTopRight] removeFromSuperview];
        [cardViewsView[CDXCardsStackViewCardViewsMiddle] removeFromSuperview];
        [cardViewsView[CDXCardsStackViewCardViewsBottom] removeFromSuperview];
        ivar_array_release_and_clear(cardImagesImage, CDXCardsStackViewCardImagesSize);
        [scrollView removeFromSuperview];
        ivar_release_and_clear(scrollView);
        ivar_release_and_clear(scrollViewDelegate);
    } else {
        ivar_assign(scrollView, [[CDXCardsStackViewScrollView alloc] initWithFrame:self.frame]);
        ivar_assign(scrollViewDelegate, [[CDXCardsStackViewScrollViewDelegate alloc] init]);
        scrollView.delegate = scrollViewDelegate;
        scrollViewDelegate.cardsStackView = self;
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
            UIImageView *view = [[[UIImageView alloc] initWithImage:nil] autorelease];
            cardViewsView[i] = view;
            view.frame = CGRectMake(0, 0, cardViewsSize.width, cardViewsSize.height);
        }
        
        for (NSUInteger i = 0; i < CDXCardsStackViewCardImagesSize; i++) {
            cardImagesImage[i] = nil;
            cardImagesCardIndex[i] = 0;
        }
        
        [self addSubview:cardViewsView[CDXCardsStackViewCardViewsBottom]];
        [self addSubview:cardViewsView[CDXCardsStackViewCardViewsMiddle]];
        [self addSubview:scrollView];
        
        [scrollView addSubview:cardViewsView[CDXCardsStackViewCardViewsTopLeft]];
        [scrollView addSubview:cardViewsView[CDXCardsStackViewCardViewsTopRight]];
        cardViewsView[CDXCardsStackViewCardViewsTopRight].frame = CGRectMake(cardViewsSize.width, 0, cardViewsSize.width, cardViewsSize.height);
        
        [self showCardAtIndex:currentCardIndex];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // send touch events only if the scroll view is not scrolling
    if ((int)scrollView.contentOffset.x % (int)(scrollViewPageWidth) == 0) {
        [viewDelegate cardsViewDelegateTouchesEnded:touches withEvent:event];
    }
}

- (void)scrollViewDidEndDecelerating {
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

@end

