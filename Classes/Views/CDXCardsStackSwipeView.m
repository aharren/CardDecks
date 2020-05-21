//
//
// CDXCardsStackSwipeView.m
//
//
// Copyright (c) 2009-2020 Arne Harren <ah@0xc0.de>
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

#import "CDXCardsStackSwipeView.h"
#import "CDXImageFactory.h"

#undef ql_component
#define ql_component lcl_cView


@implementation CDXCardsStackSwipeView

- (id)initWithFrame:(CGRect)rect {
    qltrace();
    if ((self = [super initWithFrame:rect viewCount:CDXCardsStackSwipeViewCardViewsSize])) {
        [self addSubview:[cardViewRendering viewAtIndex:CDXCardsStackSwipeViewCardViewsBottom]];
        [self addSubview:[cardViewRendering viewAtIndex:CDXCardsStackSwipeViewCardViewsMiddle]];
        [self addSubview:[cardViewRendering viewAtIndex:CDXCardsStackSwipeViewCardViewsTopLeft]];
    }
    return self;
}

- (void)dealloc {
    qltrace();
    [super dealloc];
}

- (void)configureCardViewsViewAtIndex:(NSUInteger)viewIndex cardIndex:(NSUInteger)cardIndex {
    if (cardIndex >= cardsCount) {
        cardIndex += cardsCount;
        cardIndex %= cardsCount;
    }
    
    CGRect frame = CGRectMake(0, 0, cardViewsSize.width, cardViewsSize.height);
    frame = [[CDXAppWindowManager sharedAppWindowManager] frameWithMaxSafeAreaInsets:frame];
    UIView *view = [cardViewRendering configureViewAtIndex:viewIndex viewSize:frame.size cardIndex:cardIndex card:[viewDataSource cardsViewDataSourceCardAtIndex:cardIndex] deviceOrientation:deviceOrientation];
    view.frame = frame;
}

- (void)showCardAtIndex:(NSUInteger)cardIndex tellDelegate:(BOOL)tellDelegate {
    [self configureCardViewsViewAtIndex:CDXCardsStackSwipeViewCardViewsTopLeft cardIndex:(cardIndex+cardsCount-1) % cardsCount];
    [self configureCardViewsViewAtIndex:CDXCardsStackSwipeViewCardViewsMiddle cardIndex:cardIndex];
    [self configureCardViewsViewAtIndex:CDXCardsStackSwipeViewCardViewsBottom cardIndex:(cardIndex+1) % cardsCount];
    
    CGRect cardFrame = [cardViewRendering viewAtIndex:CDXCardsStackSwipeViewCardViewsTopLeft].frame;
    cardFrame.origin.x = -cardViewsSize.width;
    [cardViewRendering viewAtIndex:CDXCardsStackSwipeViewCardViewsTopLeft].frame = cardFrame;
    
    [cardViewRendering invalidateCaches];
    [cardViewRendering cacheViewAtIndex:CDXCardsStackSwipeViewCardViewsTopLeft cardIndex:(cardIndex+cardsCount-1) % cardsCount];
    [cardViewRendering cacheViewAtIndex:CDXCardsStackSwipeViewCardViewsMiddle cardIndex:cardIndex];
    [cardViewRendering cacheViewAtIndex:CDXCardsStackSwipeViewCardViewsBottom cardIndex:(cardIndex+1) % cardsCount];
    
    currentCardIndex = cardIndex;
    if (tellDelegate) {
        [viewDelegate cardsViewDelegateCurrentCardIndexHasChangedTo:currentCardIndex];
    }
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
    for (NSUInteger i = 0; i < CDXCardsStackSwipeViewCardViewsSize; i++) {
        [cardViewRendering viewAtIndex:i].frame = frame;
    }
    
    [self showCardAtIndex:currentCardIndex];
}

- (void)touchAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [self showCardAtIndex:touchAnimationNewCardIndex];
    touchAnimationNewCardIndex = currentCardIndex;
    touchAnimationInProgress = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    touchStartPosition = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // ignore moves if an animation is already in progress
    if (touchAnimationInProgress) {
        return;
    }
    
    // ignore moves if they have the same start position as the last animation
    if (touchAnimationStartPosition.x == touchStartPosition.x &&
        touchAnimationStartPosition.y == touchStartPosition.y) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchCurrentPosition = [touch locationInView:self];
    
    CGFloat deltax = touchCurrentPosition.x - touchStartPosition.x;
    CGFloat deltay = touchCurrentPosition.y - touchStartPosition.y;
    qltrace(@"delta x=%f y=%f", deltax, deltay);
    
    // animate if the move was at least 30 pixels wide
    if (fabs(deltax) >= 30) {
        if (touchCurrentPosition.x < touchStartPosition.x) {
            // move to the left
            if (currentCardIndex+1 < cardsCount) {
                touchAnimationInProgress = YES;
                touchAnimationStartPosition = touchStartPosition;
                touchAnimationNewCardIndex = currentCardIndex+1;
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.25];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(touchAnimationDidStop:finished:context:)];
                CGRect frame = [cardViewRendering viewAtIndex:CDXCardsStackSwipeViewCardViewsMiddle].frame;
                qltrace(@"start %f %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
                [cardViewRendering viewAtIndex:CDXCardsStackSwipeViewCardViewsMiddle].frame = frame;
                CGFloat y = -deltay/deltax * frame.size.height;
                frame.origin.x = -cardViewsSize.width;
                frame.origin.y = y;
                qltrace(@"end %f %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
                [cardViewRendering viewAtIndex:CDXCardsStackSwipeViewCardViewsMiddle].frame = frame;
                [UIView commitAnimations];
            }
        } else {
            // move to the right
            if (currentCardIndex > 0) {
                touchAnimationInProgress = YES;
                touchAnimationStartPosition = touchStartPosition;
                touchAnimationNewCardIndex = currentCardIndex-1;
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.25];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(touchAnimationDidStop:finished:context:)];
                CGRect frame = [cardViewRendering viewAtIndex:CDXCardsStackSwipeViewCardViewsMiddle].frame;
                CGFloat y = -deltay/deltax * frame.size.height;
                frame.origin.x = -cardViewsSize.width;
                frame.origin.y = y;
                qltrace(@"start %f %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
                [cardViewRendering viewAtIndex:CDXCardsStackSwipeViewCardViewsTopLeft].frame = frame;
                frame = [cardViewRendering viewAtIndex:CDXCardsStackSwipeViewCardViewsMiddle].frame;
                qltrace(@"end %f %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
                [cardViewRendering viewAtIndex:CDXCardsStackSwipeViewCardViewsTopLeft].frame = frame;
                [UIView commitAnimations];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // send touch events only if we are not in an animation
    if (!touchAnimationInProgress) {
        [viewDelegate cardsViewDelegateTouchesEnded:touches withEvent:event];
        return;
    }
}

@end

