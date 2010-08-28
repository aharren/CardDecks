//
//
// CDXCardsStackSwipeView.m
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

#import "CDXCardsStackSwipeView.h"
#import "CDXImageFactory.h"

#undef ql_component
#define ql_component lcl_cView


@implementation CDXCardsStackSwipeView

- (id)initWithFrame:(CGRect)rect {
    qltrace();
    if ((self = [super initWithFrame:rect])) {
        ivar_assign(cardImages, [[CDXObjectCache alloc] initWithSize:CDXCardsStackSwipeViewCardImagesSize]);
        ivar_array_assign(cardViewsView, CDXCardsStackSwipeViewCardViewsSize, [[UIImageView alloc] initWithImage:nil]);
        [self addSubview:cardViewsView[CDXCardsStackSwipeViewCardViewsBottom]];
        [self addSubview:cardViewsView[CDXCardsStackSwipeViewCardViewsMiddle]];
        [self addSubview:cardViewsView[CDXCardsStackSwipeViewCardViewsTopLeft]];
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(cardImages);
    ivar_array_release_and_clear(cardViewsView, CDXCardsStackSwipeViewCardViewsSize);
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
                 deviceOrientation:deviceOrientation];
        qltrace(@": X> %d", cardIndex);
    }
    view.image = image;
    view.hidden = NO;
}

- (void)invalidateDataSourceCaches {
    [cardImages clear];
}

- (void)showCardAtIndex:(NSUInteger)cardIndex tellDelegate:(BOOL)tellDelegate {
    [self configureCardViewsViewAtIndex:CDXCardsStackSwipeViewCardViewsTopLeft cardIndex:cardIndex-1];
    [self configureCardViewsViewAtIndex:CDXCardsStackSwipeViewCardViewsMiddle cardIndex:cardIndex];
    [self configureCardViewsViewAtIndex:CDXCardsStackSwipeViewCardViewsBottom cardIndex:cardIndex+1];
    
    CGRect frame = self.frame;
    frame.origin.x = -cardViewsSize.width;
    cardViewsView[CDXCardsStackSwipeViewCardViewsTopLeft].frame = frame;
    cardViewsView[CDXCardsStackSwipeViewCardViewsMiddle].frame = self.frame;
    cardViewsView[CDXCardsStackSwipeViewCardViewsBottom].frame = self.frame;
    
    [cardImages clear];
    [cardImages addObject:cardViewsView[CDXCardsStackSwipeViewCardViewsTopLeft].image withKey:cardIndex-1];
    [cardImages addObject:cardViewsView[CDXCardsStackSwipeViewCardViewsMiddle].image withKey:cardIndex];
    [cardImages addObject:cardViewsView[CDXCardsStackSwipeViewCardViewsBottom].image withKey:cardIndex+1];
    
    currentCardIndex = cardIndex;
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

- (void)deviceOrientationDidChange:(UIDeviceOrientation)orientation {
    qltrace();
    deviceOrientation = orientation;
    if (self.superview == nil) {
        return;
    }

    [cardImages clear];
    [self showCardAtIndex:currentCardIndex tellDelegate:NO];
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
        cardViewsView[i].frame = frame;
    }
    
    [self showCardAtIndex:currentCardIndex tellDelegate:NO];
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
    
    // animate if the move was at least 30 pixels wide
    if (fabsf(deltax) >= 30) {
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
                CGRect frame = self.frame;
                CGFloat y = -deltay/deltax * frame.size.height;
                frame.origin.x = -cardViewsSize.width;
                frame.origin.y = y;
                cardViewsView[CDXCardsStackSwipeViewCardViewsMiddle].frame = self.frame;
                cardViewsView[CDXCardsStackSwipeViewCardViewsMiddle].frame = frame;
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
                CGRect frame = self.frame;
                CGFloat y = -deltay/deltax * frame.size.height;
                frame.origin.x = -cardViewsSize.width;
                frame.origin.y = y;
                cardViewsView[CDXCardsStackSwipeViewCardViewsTopLeft].frame = frame;
                cardViewsView[CDXCardsStackSwipeViewCardViewsTopLeft].frame = self.frame;
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

