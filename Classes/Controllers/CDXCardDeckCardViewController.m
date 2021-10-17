//
//
// CDXCardDeckCardViewController.m
//
//
// Copyright (c) 2009-2021 Arne Harren <ah@0xc0.de>
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
#import "CDXDevice.h"

#undef ql_component
#define ql_component lcl_cController


@interface CDXCardDeckCardViewControllerTimer : NSObject {
    
@protected
    NSUInteger cardIndex;
    NSTimeInterval timerStart;
    NSTimeInterval timerExpiration;
    unsigned int timerType;
}

@property (readonly, nonatomic) NSUInteger cardIndex;
@property (readonly, nonatomic) unsigned int timerType;

@end


@implementation CDXCardDeckCardViewControllerTimer

@synthesize cardIndex;
@synthesize timerType;

- (id)initWithCardIndex:(NSUInteger)index timerInterval:(NSTimeInterval)interval timerType:(unsigned int)type {
    qltrace();
    if ((self = [super init])) {
        double timerFactor = (type == 0) ? 1.0 : (1.0/5.0);
        cardIndex = index;
        timerStart = [NSDate timeIntervalSinceReferenceDate];
        timerExpiration = timerStart + (interval * timerFactor);
        timerType = type;
    }
    return self;
}

- (void)dealloc {
    qltrace();
    [super dealloc];
}

- (BOOL)isExpired {
    return [NSDate timeIntervalSinceReferenceDate] > timerExpiration;
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
    ivar_release_and_clear(initialView);
    ivar_release_and_clear(actionsViewShuffleButton);
    ivar_release_and_clear(actionsViewSortButton);
    ivar_release_and_clear(actionsViewPlayButton);
    ivar_release_and_clear(actionsViewPlay2Button);
    ivar_release_and_clear(actionsViewStopButton);
    ivar_release_and_clear(actionsViewButtonsView);
    ivar_release_and_clear(timerSignalView);
    [super dealloc];
}

- (BOOL)prefersStatusBarHidden {
    qltrace();
    return YES;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    qltrace();
    return YES;
}

- (void)setActionsViewHidden:(BOOL)hidden animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        actionsView.alpha = hidden ? 0 : 1;
    }];
}

- (void)configureActionsViewAnimated:(BOOL)animated {
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        CGAffineTransform transform = [CDXAppWindowManager transformForDeviceOrientation:deviceOrientation];
        actionsViewShuffleButton.transform = transform;
        actionsViewSortButton.transform = transform;
        actionsViewPlayButton.transform = transform;
        actionsViewPlay2Button.transform = transform;
        actionsViewStopButton.transform = transform;
    }];
}

- (void)configureView {
    [self setActionsViewHidden:YES animated:NO];
    
    [cardsView removeFromSuperview];
    ivar_release_and_clear(cardsView);
    
    [initialView removeFromSuperview];
    ivar_release_and_clear(initialView);
    
    deviceOrientation = [[CDXAppWindowManager sharedAppWindowManager] deviceOrientation];
    UIDeviceOrientation orientation = cardDeck.wantsAutoRotate ? deviceOrientation : UIDeviceOrientationPortrait;
    
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
        [v setDeviceOrientation:orientation];
        [self.view insertSubview:v atIndex:0];
        
        // receive shake events as first responder
        [self becomeFirstResponder];
        
        // show that the deck is shuffled
        if ([cardDeck isShuffled]) {
            [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Shuffle" text:@"shuffle" timeInterval:0.4 orientation:deviceOrientation view:self.view];
        }
    } else {
        qltrace(@"initial");
        
        [self resignFirstResponder];
        CDXCard *card = [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex orCard:nil];
        if (card != nil) {
            CGRect frame = [[CDXAppWindowManager sharedAppWindowManager] frameWithMaxSafeAreaInsets:self.view.frame];
            if ([[CDXDevice sharedDevice] useImageBasedRendering]) {
                UIImage *image = [[CDXImageFactory sharedImageFactory]
                                  imageForCard:card
                                  size:frame.size
                                  deviceOrientation:orientation];
                ivar_assign(initialView, [[UIImageView alloc] initWithImage:image]);
            } else {
                CDXCardView *cardView = [[CDXCardView alloc] initWithFrame:CGRectMake(0,0, 1,1)];
                [cardView setCard:card size:frame.size deviceOrientation:orientation preview:NO];
                ivar_assign(initialView, cardView);
            }
            initialView.frame = frame;
            [self.view insertSubview:initialView atIndex:0];
        }
    }

    // configure the action buttons bar
    CGRect frame = actionsViewButtonsView.frame;
    if ([[CDXAppSettings sharedAppSettings] actionButtonsOnLeftSide]) {
        frame.origin = CGPointMake(0, 0);
    } else {
        frame.origin = CGPointMake(self.view.frame.size.width - frame.size.width, 0);
    }
    actionsViewButtonsView.frame = frame;
    [self configureActionsViewAnimated:NO];
}

- (void)performTimerCallbackDelayed {
    [self performSelector:@selector(timerCallback:) withObject:currentTimer afterDelay:0.01];
    NSTimeInterval blinkFactor = (currentTimer.timerType == 0) ? 2.0 : 4.0;
    timerSignalView.hidden = (int)(fmod([NSDate timeIntervalSinceReferenceDate] * blinkFactor, 2.0)) == 0;
}

- (void)uninstallTimer {
    qltrace();
    timerSignalView.hidden = YES;
    ivar_release_and_clear(currentTimer);
}

- (void)installTimerWithCardIndex:(NSUInteger)cardIndex timerType:(unsigned int)timerType {
    qltrace();
    CDXCard* card = [cardDeck cardAtIndex:cardIndex];
    if (card.timerInterval != CDXCardTimerIntervalOff) {
        UIEdgeInsets maxSafeAreaInsets = [[CDXAppWindowManager sharedAppWindowManager] maxSafeAreaInsets];
        
        if (maxSafeAreaInsets.bottom != 0) {
            timerSignalView.backgroundColor = [UIColor whiteColor];
        } else {
            timerSignalView.backgroundColor = [[card textColor] uiColor];
        }
        ivar_assign(currentTimer, [[CDXCardDeckCardViewControllerTimer alloc] initWithCardIndex:cardIndex timerInterval:card.timerInterval timerType:timerType]);
        [self performTimerCallbackDelayed];
    } else {
        [self stopButtonPressed];
        [[CDXDevice sharedDevice] vibrate];
    }
}

- (void)viewDidLoad {
    qltrace();
    [super viewDidLoad];
    CGRect frame = [UIScreen mainScreen].bounds;
    self.view.frame = frame;
    [self configureView];
    [self configureIndexDotsViewAndButtons];
    timerSignalView.hidden = YES;

    UIEdgeInsets maxSafeAreaInsets = [[CDXAppWindowManager sharedAppWindowManager] maxSafeAreaInsets];

    if (maxSafeAreaInsets.bottom != 0) {
        // configure the index dots view based on screen layout
        CGRect indexDotsViewFrame = indexDotsView.frame;
        indexDotsViewFrame.origin.y -= maxSafeAreaInsets.bottom / 2;
        indexDotsView.frame = indexDotsViewFrame;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    cardsViewShowsFirstCard = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:![[CDXAppSettings sharedAppSettings] enableIdleTimer]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self resignFirstResponder];
    [self uninstallTimer];
    [super viewWillDisappear:animated];
}

- (void)setUserInteractionEnabled:(BOOL)enabled {
    userInteractionEnabled = enabled;
    if (self.view.superview != nil) {
        [self configureView];
    }
}

- (void)applicationWillEnterForeground {
    if (currentTimer) {
        // signal to the user that the current timer is no longer active
        [self stopButtonPressed];
    }
}

- (void)applicationDidEnterBackground {
    if (currentTimer) {
        // install a new timer object to make current timer invalid, e.g. to
        // avoid unexpected card changes when we come back
        ivar_assign(currentTimer, [[CDXCardDeckCardViewControllerTimer alloc] initWithCardIndex:0 timerInterval:0 timerType:0]);
    }
}

- (BOOL)requiresFullScreenLayout {
    return YES;
}

- (void)deviceOrientationDidChange:(UIDeviceOrientation)orientation {
    deviceOrientation = orientation;
    
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

    [self configureActionsViewAnimated:YES];
}

- (void)menuControllerWillHideMenu {
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
        CGPoint location = [touch locationInView:[CDXAppWindowManager sharedAppWindowManager].window];
        [[CDXAppWindowManager sharedAppWindowManager] popViewControllerAnimated:YES withTouchLocation:location];
    }
}

- (void)handleAutoPlayDelayed {
    self.view.userInteractionEnabled = YES;
    switch (cardDeck.autoPlay) {
        case CDXCardDeckAutoPlayPlay:
            [self playButtonPressed];
            break;
        case CDXCardDeckAutoPlayPlay2:
            [self play2ButtonPressed];
            break;
        case CDXCardDeckAutoPlayOff:
        default:
            break;
    }
}

- (void)cardsViewDelegateCurrentCardIndexHasChangedTo:(NSUInteger)index {
    if (cardsViewShowsFirstCard) {
        cardsViewShowsFirstCard = NO;
        
        // handle auto-play
        switch (cardDeck.autoPlay) {
            case CDXCardDeckAutoPlayPlay:
            case CDXCardDeckAutoPlayPlay2:
                self.view.userInteractionEnabled = NO;
                [self performSelector:@selector(handleAutoPlayDelayed) withObject:nil afterDelay:0.3];
                break;
            case CDXCardDeckAutoPlayOff:
            default:
                break;
        }
    }
    
    cardDeckViewContext.currentCardIndex = index;
    [indexDotsView setCurrentPage:index animated:YES];
    if (currentTimer) {
        [self installTimerWithCardIndex:index timerType:currentTimer.timerType];
    }
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

- (void)shuffleButtonPressedDelayed {
    [cardDeck shuffle];
    [cardDeck updateStorageObjectDeferred:YES];
    
    [cardsView invalidateDataSourceCaches];
    [cardsView showCardAtIndex:0];
}

- (IBAction)shuffleButtonPressed {
    [self performSelector:@selector(shuffleButtonPressedDelayed) withObject:nil afterDelay:0.001];
    [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Shuffle" text:@"shuffle" timeInterval:0.4 orientation:deviceOrientation view:self.view];
}

- (void)randomButtonPressedDelayed {
    NSUInteger newIndex = (((double)arc4random() / 0x100000000) * [cardDeck cardsCount]);
    [cardsView showCardAtIndex:newIndex];
}

- (IBAction)randomButtonPressed {
    [self performSelector:@selector(randomButtonPressedDelayed) withObject:nil afterDelay:0.001];
    [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Shuffle" text:@"random" timeInterval:0.4 orientation:deviceOrientation view:self.view];
}

- (void)sortButtonPressedDelayed {
    [cardDeck sort];
    [cardDeck updateStorageObjectDeferred:YES];
    
    [cardsView invalidateDataSourceCaches];
    [cardsView showCardAtIndex:0];
}

- (IBAction)sortButtonPressed {
    [self performSelector:@selector(sortButtonPressedDelayed) withObject:nil afterDelay:0.001];
    [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Sort" text:@"sort" timeInterval:0.4 orientation:deviceOrientation view:self.view];
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
    for (NSUInteger i = pageControlJumpPagesCount; i > 0; i--) {
        if (currentCardIndex > pageControlJumpPages[i-1]) {
            [cardsView showCardAtIndex:pageControlJumpPages[i-1]];
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

- (void)timerCallback:(id)object {
    CDXCardDeckCardViewControllerTimer *timer = (CDXCardDeckCardViewControllerTimer *)object;
    if (timer != currentTimer || timer.cardIndex != [cardsView currentCardIndex] || [self.view superview] == nil) {
        qltrace("invalid timer");
        return;
    }
    
    if (![timer isExpired]) {
        [self performTimerCallbackDelayed];
        return;
    }
    
    qltrace("timer expired");
    NSUInteger newCardIndex = ([cardsView currentCardIndex] + 1) % [cardDeck cardsCount];
    [cardsView showCardAtIndex:newCardIndex];
}

- (IBAction)playButtonPressed {
    [self installTimerWithCardIndex:[cardsView currentCardIndex] timerType:0];
    [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Play" text:@"play 1x" timeInterval:0.4 orientation:deviceOrientation view:self.view];
}

- (IBAction)play2ButtonPressed {
    [self installTimerWithCardIndex:[cardsView currentCardIndex] timerType:1];
    [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Play2" text:@"play 5x" timeInterval:0.4 orientation:deviceOrientation view:self.view];
}

- (IBAction)stopButtonPressed {
    [self uninstallTimer];
    [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Stop" text:@"stop" timeInterval:0.4 orientation:deviceOrientation view:self.view];
}

@end

