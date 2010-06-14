//
//
// CDXCardDeckCardViewController.m
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

#import "CDXCardDeckCardViewController.h"
#import "CDXCardsSideBySideView.h"
#import "CDXCardsStackView.h"
#import "CDXCardsStackSwipeView.h"
#import "CDXImageFactory.h"
#import "CDXAppSettings.h"
#import "CDXStorage.h"

#undef ql_component
#define ql_component lcl_cController


@interface CDXCardDeckCardViewController (PageControl)

#define CDXCardDeckCardViewControllerPageControlAlphaHidden  0
#define CDXCardDeckCardViewControllerPageControlAlphaVisible 0.9

- (void)configurePageControl;
- (void)flashPageControl;

@end


@implementation CDXCardDeckCardViewController

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)aCardDeckViewContext {
    qltrace();
    if ((self = [super initWithNibName:@"CDXCardDeckCardView" bundle:nil])) {
        ivar_assign_and_retain(cardDeckViewContext, aCardDeckViewContext);
        ivar_assign_and_retain(cardDeck, cardDeckViewContext.cardDeck);
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(cardDeckViewContext);
    ivar_release_and_clear(cardDeck);
    ivar_release_and_clear(pageControl);
    ivar_release_and_clear(cardsView);
    ivar_release_and_clear(imageView);
    [super dealloc];
}

- (void)configureView {
    [cardsView removeFromSuperview];
    ivar_release_and_clear(cardsView);
    
    [imageView removeFromSuperview];
    ivar_release_and_clear(imageView);
    
    UIDeviceOrientation deviceOrientation = UIDeviceOrientationPortrait;
    if (cardDeck.wantsAutoRotate) {
        deviceOrientation = [[CDXAppWindowManager sharedAppWindowManager] deviceOrientation];
    }
    
    if (userInteractionEnabled) {
        qltrace(@"card");
        
        UIView<CDXCardsViewView> *v = nil;
        switch (cardDeck.displayStyle) {
            default:
            case CDXCardDeckDisplayStyleSideBySide:
                v = [[[CDXCardsSideBySideView alloc] initWithFrame:self.view.frame] autorelease];
                break;
            case CDXCardDeckDisplayStyleStack:
                v = [[[CDXCardsStackView alloc] initWithFrame:self.view.frame] autorelease];
                break;
            case CDXCardDeckDisplayStyleSwipeStack:
                v = [[[CDXCardsStackSwipeView alloc] initWithFrame:self.view.frame] autorelease];
                break;
        }
        ivar_assign_and_retain(cardsView, v);
        [v setViewDelegate:self];
        [v setViewDataSource:self];
        [v setDeviceOrientation:deviceOrientation];
        [self.view insertSubview:v atIndex:0];
        
        // receive shake events as first responder
        [self becomeFirstResponder];
    } else {
        qltrace(@"image");
        
        [self resignFirstResponder];
        CDXCard *card = [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex orCard:nil];
        if (card != nil) {
            UIImage *image = [[CDXImageFactory sharedImageFactory]
                              imageForCard:card
                              size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
                              deviceOrientation:deviceOrientation];
            ivar_assign(imageView, [[UIImageView alloc] initWithImage:image]);
            [self.view insertSubview:imageView atIndex:0];
        }
    }
}

- (void)viewDidLoad {
    qltrace();
    [super viewDidLoad];
    [self configureView];
    [self configurePageControl];
}

- (void)viewDidUnload {
    qltrace();
    ivar_release_and_clear(pageControl);
    ivar_release_and_clear(cardsView);
    ivar_release_and_clear(imageView);
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setIdleTimerDisabled:![[CDXAppSettings sharedAppSettings] enableIdleTimer]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self resignFirstResponder];
}

- (void)setUserInteractionEnabled:(BOOL)enabled {
    userInteractionEnabled = enabled;
    if (self.view.superview != nil) {
        [self configureView];
    }
}

- (void)deviceOrientationDidChange:(UIDeviceOrientation)orientation {
    if (cardDeck.wantsAutoRotate) {
        switch (orientation) {
            default:
                break;
            case UIDeviceOrientationLandscapeLeft:
            case UIDeviceOrientationLandscapeRight:
            case UIDeviceOrientationPortrait:
            case UIDeviceOrientationPortraitUpsideDown:
                [cardsView deviceOrientationDidChange:orientation];
                break;
        }
    }
}

- (NSUInteger)cardsViewDataSourceCardsCount {
    return [cardDeck cardsCount];
}

- (CDXCard *)cardsViewDataSourceCardAtIndex:(NSUInteger)index {
    return [cardDeck cardAtIndex:index];
}

- (NSUInteger)cardsViewDataSourceInitialCardIndex {
    return cardDeckViewContext.currentCardIndex;
}

- (void)cardsViewDelegateTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    qltrace();
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 2) {
        [[CDXAppWindowManager sharedAppWindowManager] popViewControllerAnimated:YES];
    }
}

- (void)cardsViewDelegateCurrentCardIndexHasChangedTo:(NSUInteger)index {
    cardDeckViewContext.currentCardIndex = index;
    pageControl.currentPage = index;
    [self flashPageControl];
}

- (BOOL)canBecomeFirstResponder {
    // required for receiving shake events
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (!userInteractionEnabled) {
        return;
    }
    
    // shake event received, shuffle the deck
    if (event.type == UIEventSubtypeMotionShake && cardDeck.wantsShakeShuffle) {
        [self shuffleButtonPressed];
    }
    
    if ([super respondsToSelector:@selector(motionEnded:withEvent:)]) {
        [super motionEnded:motion withEvent:event];
    }
}

- (IBAction)shuffleButtonPressed {
    [cardDeck shuffle];
    [cardDeck updateStorageObjectDeferred:YES];

    [cardsView invalidateDataSourceCaches];
    [cardsView showCardAtIndex:0];
    [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Shuffle.png" timeInterval:0.8];
}

- (void)configurePageControl {
    const NSUInteger pageCount = [cardDeck cardsCount];
    
    pageControl.alpha = cardDeck.wantsPageControl ? CDXCardDeckCardViewControllerPageControlAlphaVisible : CDXCardDeckCardViewControllerPageControlAlphaHidden;
    pageControl.numberOfPages = pageCount;
    pageControl.currentPage = cardDeckViewContext.currentCardIndex;
    pageControl.userInteractionEnabled = NO;
    
    // configure the page jump pages
    if (pageCount <= 1) {
        // no page jump for 1 or less pages
        pageControlJumpPagesCount = 0;
    } else if (pageCount <= 6) {
        // 2 page jumps for up to 6 pages (first, last)
        pageControlJumpPagesCount = 2;
        pageControlJumpPages[0] = 0;
        pageControlJumpPages[1] = pageCount-1;
    } else if (pageCount <= 16) {
        // 3 page jumps for up to 16 pages (first, 1/2, last)
        pageControlJumpPagesCount = 3;
        pageControlJumpPages[0] = 0;
        pageControlJumpPages[1] = MAX(1, round(pageCount / 2 + 0.5)) - 1;
        pageControlJumpPages[2] = MAX(1, pageCount) - 1;
    } else {
        // 5 page jumps for more than 16 pages (first, 1/4, 1/2, last-1/4, last)
        pageControlJumpPagesCount = 5;
        pageControlJumpPages[0] = 0;
        pageControlJumpPages[1] = MAX(1, round(pageCount / 4 + 0.5)) - 1;
        pageControlJumpPages[2] = MAX(1, round(pageCount / 2 + 0.5)) - 1;
        pageControlJumpPages[3] = pageCount - pageControlJumpPages[1] - 1;
        pageControlJumpPages[4] = MAX(1, pageCount) - 1;
    }
}

- (void)flashPageControl {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if (!cardDeck.wantsPageControl) {
        pageControl.alpha = CDXCardDeckCardViewControllerPageControlAlphaVisible;
        pageControl.alpha = CDXCardDeckCardViewControllerPageControlAlphaHidden;
    } else {
        pageControl.alpha = CDXCardDeckCardViewControllerPageControlAlphaHidden;
        pageControl.alpha = CDXCardDeckCardViewControllerPageControlAlphaVisible;
    }
    [UIView commitAnimations];
}

- (IBAction)pageControlLeftButtonPressed {
    if (!cardDeck.wantsPageJumps) {
        return;
    }
    
    NSUInteger currentCardIndex = [cardsView currentCardIndex];
    if (currentCardIndex > 0) {
        [cardsView showCardAtIndex:currentCardIndex-1];
    }
}

- (IBAction)pageControlRightButtonPressed {
    if (!cardDeck.wantsPageJumps) {
        return;
    }
    
    NSUInteger currentCardIndex = [cardsView currentCardIndex];
    if (currentCardIndex < [cardDeck cardsCount]-1) {
        [cardsView showCardAtIndex:currentCardIndex+1];
    }
}

- (IBAction)pageControlJumpLeftButtonPressed {
    if (!cardDeck.wantsPageJumps) {
        return;
    }
    
    NSUInteger currentCardIndex = [cardsView currentCardIndex];
    for (int i = pageControlJumpPagesCount-1; i >= 0; i--) {
        if (currentCardIndex > pageControlJumpPages[i]) {
            [cardsView showCardAtIndex:pageControlJumpPages[i]];
            break;
        }
    }
}

- (IBAction)pageControlJumpRightButtonPressed {
    if (!cardDeck.wantsPageJumps) {
        return;
    }
    
    NSUInteger currentCardIndex = [cardsView currentCardIndex];
    for (int i = 0; i < pageControlJumpPagesCount; i++) {
        if (currentCardIndex < pageControlJumpPages[i]) {
            [cardsView showCardAtIndex:pageControlJumpPages[i]];
            break;
        }
    }
}

@end

