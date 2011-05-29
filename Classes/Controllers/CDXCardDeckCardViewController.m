//
//
// CDXCardDeckCardViewController.m
//
//
// Copyright (c) 2009-2011 Arne Harren <ah@0xc0.de>
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


@interface CDXCardDeckCardViewControllerTimer : NSObject {
    
@protected
    unsigned int timerId;
    unsigned int timerType;
    NSTimeInterval timerInterval;
}

@property (readonly, nonatomic) unsigned int timerId;
@property (readonly, nonatomic) unsigned int timerType;
@property (readonly, nonatomic) NSTimeInterval timerInterval;

@end


@implementation CDXCardDeckCardViewControllerTimer

@synthesize timerId;
@synthesize timerType;
@synthesize timerInterval;

- (id)initWithTimerId:(unsigned int)tid timerType:(unsigned int)ttype {
    qltrace();
    if ((self = [super init])) {
        timerId = tid;
        timerType = ttype;
        switch (timerType) {
            case 1:
                timerInterval = 5;
                break;
            case 2:
                timerInterval = 1;
                break;
            default:
                timerInterval = 0.1;
        }
    }
    return self;
}

@end


@interface CDXCardDeckCardViewController (indexDotsView)

- (void)configureIndexDotsViewAndButtons;

@end


@implementation CDXCardDeckCardViewController

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)aCardDeckViewContext {
    qltrace();
    if ((self = [super initWithNibName:@"CDXCardDeckCardView" bundle:nil])) {
        ivar_assign_and_retain(cardDeckViewContext, aCardDeckViewContext);
        ivar_assign_and_retain(cardDeck, cardDeckViewContext.cardDeck);
        self.wantsFullScreenLayout = YES;
        closeTapCount = [[CDXAppSettings sharedAppSettings] closeTapCount];
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(cardDeckViewContext);
    ivar_release_and_clear(cardDeck);
    ivar_release_and_clear(indexDotsView);
    ivar_release_and_clear(cardsView);
    ivar_release_and_clear(imageView);
    ivar_release_and_clear(actionsViewShuffleButton);
    ivar_release_and_clear(actionsViewSortButton);
    ivar_release_and_clear(actionsViewPlayButton);
    ivar_release_and_clear(actionsViewPlay2Button);
    ivar_release_and_clear(actionsViewStopButton);
    [super dealloc];
}

- (void)setActionsViewHidden:(BOOL)hidden animated:(BOOL)animated {
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    }
    actionsView.alpha = hidden ? 0 : 1;
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)configureActionsView:(UIDeviceOrientation)orientation {
    CGAffineTransform transform = [CDXAppWindowManager transformForDeviceOrientation:orientation];
    actionsViewShuffleButton.transform = transform;
    actionsViewSortButton.transform = transform;
    actionsViewPlayButton.transform = transform;
    actionsViewPlay2Button.transform = transform;
}

- (void)configureView {
    [self setActionsViewHidden:YES animated:NO];
    
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
        
        // show that the deck is shuffled
        if ([cardDeck isShuffled]) {
            [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Shuffle.png" text:@"shuffle" timeInterval:0.4 orientation:UIDeviceOrientationFaceUp];
        }
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
    
    [self configureActionsView:[[CDXAppWindowManager sharedAppWindowManager] deviceOrientation]];
}

- (void)viewDidLoad {
    qltrace();
    [super viewDidLoad];
    [self configureView];
    [self configureIndexDotsViewAndButtons];
}

- (void)viewDidUnload {
    qltrace();
    ivar_release_and_clear(indexDotsView);
    ivar_release_and_clear(cardsView);
    ivar_release_and_clear(imageView);
    ivar_release_and_clear(actionsView);
    ivar_release_and_clear(actionsViewShuffleButton);
    ivar_release_and_clear(actionsViewSortButton);
    ivar_release_and_clear(actionsViewPlayButton);
    ivar_release_and_clear(actionsViewPlay2Button);
    ivar_release_and_clear(actionsViewStopButton);
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
    [self configureActionsView:orientation];
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
    if ([touch tapCount] == closeTapCount) {
        [[CDXAppWindowManager sharedAppWindowManager] popViewControllerAnimated:YES];
    }
}

- (void)cardsViewDelegateCurrentCardIndexHasChangedTo:(NSUInteger)index {
    cardDeckViewContext.currentCardIndex = index;
    [indexDotsView setCurrentPage:index animated:YES];
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
    if (event.type == UIEventSubtypeMotionShake) {
        switch (cardDeck.shakeAction) {
            case CDXCardDeckShakeActionShuffle:
                [self shuffleButtonPressed];
                break;
            case CDXCardDeckShakeActionRandom:
                [self randomButtonPressed];
                break;
            default:
                break;
        }
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
    [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Shuffle.png" text:@"shuffle" timeInterval:0.4 orientation:[cardsView deviceOrientation]];
}

- (IBAction)randomButtonPressed {
    NSUInteger newIndex = (((double)arc4random() / 0x100000000) * [cardDeck cardsCount]);
    [cardsView showCardAtIndex:newIndex];
    [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Shuffle.png" text:@"random" timeInterval:0.4 orientation:[cardsView deviceOrientation]];
}

- (IBAction)sortButtonPressed {
    [cardDeck sort];
    [cardDeck updateStorageObjectDeferred:YES];
    
    [cardsView invalidateDataSourceCaches];
    [cardsView showCardAtIndex:0];
    [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Sort.png" text:@"sort" timeInterval:0.4 orientation:[cardsView deviceOrientation]];
}

- (void)configureIndexDotsViewAndButtons {
    const NSUInteger pageCount = [cardDeck cardsCount];
    
    indexDotsView.userInteractionEnabled = NO;
    indexDotsView.invisibleByDefault = !cardDeck.wantsPageControl;
    indexDotsView.style = (CDXIndexDotsViewStyle)cardDeck.pageControlStyle;
    indexDotsView.numberOfPages = pageCount;
    [indexDotsView setCurrentPage:cardDeckViewContext.currentCardIndex animated:NO];
    
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

- (IBAction)toggleActionsViewButtonPressed {
    [self setActionsViewHidden:(actionsView.alpha == 0 ? NO : YES) animated:YES];
}

- (IBAction)dismissActionsViewButtonPressed {
    [self setActionsViewHidden:YES animated:YES];
}

- (void)timerAction:(id)object {
    qltrace();
    CDXCardDeckCardViewControllerTimer *timer = (CDXCardDeckCardViewControllerTimer *)object;
    if (timer.timerId == currentTimerId && [self.view superview] != nil) {
        NSUInteger currentCardIndex = [cardsView currentCardIndex];
        switch (timer.timerType) {
            case 1:
                currentCardIndex = (currentCardIndex + 1) % [cardDeck cardsCount];
                [cardsView showCardAtIndex:currentCardIndex];
                [self performSelector:@selector(timerAction:) withObject:timer afterDelay:timer.timerInterval];
                break;
            case 2:
                currentCardIndex = (currentCardIndex + 1) % [cardDeck cardsCount];
                [cardsView showCardAtIndex:currentCardIndex];
                [self performSelector:@selector(timerAction:) withObject:timer afterDelay:timer.timerInterval];
                break;
            default:
                break;
        }
    }
}

- (IBAction)playButtonPressed {
    currentTimerId++;
    CDXCardDeckCardViewControllerTimer *timer = [[[CDXCardDeckCardViewControllerTimer alloc] initWithTimerId:currentTimerId timerType:1] autorelease];
    [self performSelector:@selector(timerAction:) withObject:timer afterDelay:timer.timerInterval];
}

- (IBAction)play2ButtonPressed {
    currentTimerId++;
    CDXCardDeckCardViewControllerTimer *timer = [[[CDXCardDeckCardViewControllerTimer alloc] initWithTimerId:currentTimerId timerType:2] autorelease];
    [self performSelector:@selector(timerAction:) withObject:timer afterDelay:timer.timerInterval];
}

- (IBAction)stopButtonPressed {
    currentTimerId++;
}

@end

