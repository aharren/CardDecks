//
//
// CDXCardDeckViewController.m
//
//
// Copyright (c) 2009 Arne Harren <ah@0xc0.de>
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

#import "CDXCardDeckViewController.h"
#import "CDXCardDeckEditViewController.h"
#import "CDXSettingsViewController.h"


@implementation CDXCardDeckViewScrollView

#define LogFileComponent lcl_cCDXCardDeckViewController

@synthesize controller = _controller;

- (void)dealloc {
    LogInvocation();
    
    [super dealloc];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    LogInvocation();
    
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 1) {
        [_controller singleTapTouchOnView:self];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

@end


@implementation CDXCardDeckViewController

@synthesize cardDeck = _cardDeck;
@synthesize cards = _cards;

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize toolbar = _toolbar;

@synthesize pageJumpLeftButton = _pageJumpLeftButton;
@synthesize pageJumpRightButton = _pageJumpRightButton;

@synthesize cardViewLandscapeRenderingContexts = _cardViewLandscapeRenderingContexts;
@synthesize cardViewPortraitRenderingContexts = _cardViewPortraitRenderingContexts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    LogInvocation();
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // nothing to do
    }
    
    return self;
}

- (void)dealloc {
    LogInvocation();
    
    self.cardDeck = nil;
    self.cards = nil;
    
    self.scrollView = nil;
    self.pageControl = nil;
    self.toolbar = nil;
    
    self.pageJumpLeftButton = nil;
    self.pageJumpRightButton = nil;
    
    for (int i = 0; i < 5; i++) {
        [_cardViewControllers[i] release];
        _cardViewControllers[i] = nil;
    }
    
    self.cardViewLandscapeRenderingContexts = nil;
    self.cardViewPortraitRenderingContexts = nil;
    
    [super dealloc];
}

- (void)initializeView {
    // add the views of the card view controllers
    for (NSUInteger j = _cardViewControllersMax; j > 0; j--) {
        NSUInteger i = j-1;
        LogDebug(@"controller %d", i);
        // add the controller
        CDXCardViewController *cardViewController = (CDXCardViewController *)_cardViewControllers[i];
        [_scrollView addSubview:cardViewController.view];
        
        // hide its view until we need it
        cardViewController.view.hidden = YES;
        
        // reset the information about the controller's page
        _cardViewControllersPage[i] = 0;
    }
    
    // create the rendering data for all cards
    self.cardViewLandscapeRenderingContexts = [NSMutableArray arrayWithCapacity:_pageCount];
    self.cardViewPortraitRenderingContexts = [NSMutableArray arrayWithCapacity:_pageCount];
    UIFont *font = [UIFont boldSystemFontOfSize:400];
    for (NSUInteger i = 0; i < _pageCount; i++) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        CDXCard *card = (CDXCard *)[_cards objectAtIndex:i];
        NSArray *textLines = [card.text componentsSeparatedByString:@"\n"];
        LogDebug(@"%@", card.text);
        [_cardViewLandscapeRenderingContexts addObject:[CDXTextRenderingContext contextForText:textLines font:font width:440 height:320]];
        [_cardViewPortraitRenderingContexts addObject:[CDXTextRenderingContext contextForText:textLines font:font width:320 height:440]];        
        [pool release];
    }
    
    // scroll to current page
    if (_currentPage > 0 && _currentPage >= _pageCount) {
        _currentPage = _pageCount-1;
    }
    [self scrollViewToPage:_currentPage cached:NO];    
}

- (void)viewDidLoad {
    LogInvocation();
    
    [super viewDidLoad];
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc]
                                         initWithTitle:@"Back" 
                                         style:UIBarButtonItemStylePlain 
                                         target:nil
                                         action:nil]
                                        autorelease];
    navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                          initWithTitle:@"Edit" 
                                          style:UIBarButtonItemStyleBordered 
                                          target:self
                                          action:@selector(editButtonPressed)]
                                         autorelease];    
    
    _cardViewControllersMax = 5;
    for (NSUInteger i = 0; i < _cardViewControllersMax; i++) {
        CDXCardViewController *cardViewController = [CDXCardViewController cardViewController];
        _cardViewControllers[i] = [cardViewController retain];
    }
}

- (void)viewDidUnload {
    LogInvocation();
    
    self.scrollView = nil;
    self.pageControl = nil;
    self.toolbar = nil;
    
    self.pageJumpLeftButton = nil;
    self.pageJumpRightButton = nil;
    
    for (int i = 0; i < 5; i++) {
        [_cardViewControllers[i] release];
        _cardViewControllers[i] = nil;
    }
    
    self.cardViewLandscapeRenderingContexts = nil;
    self.cardViewPortraitRenderingContexts = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    LogInvocation();
    
    // copy settings
    _showStatusBar = [CDXSettings showStatusBar];
    _showPageControl = [CDXSettings showPageControl];
    _autoRotate = [CDXSettings enableAutoRotate];
    _shakeRandom = [CDXSettings enableShakeRandom];
    
    // fix and commit changes to the card deck
    [_cardDeck removeUncommittedCards];
    if (_cardDeck.dirty) {
        [CDXStorage drainDeferred:nil];
        self.cards = nil;
        _cardDeck.dirty = NO;
    }
    
    // copy the cards
    if (_cards == nil) {
        self.cards = [[_cardDeck cards] mutableCopy];
    }
    
    // initialize card deck data
    _pageCount = [_cards count];
    _pageWidth = _scrollView.frame.size.width;
    _pageHeight = _scrollView.frame.size.height;
    
    _baseBounds = self.view.bounds;
    _baseBounds.size.width = _pageWidth;
    _baseBounds.size.height = _pageHeight;    
    
    _scrollView.contentSize = CGSizeMake(_pageWidth * _pageCount, _pageHeight);
    
    _pageControl.numberOfPages = _pageCount;
    
    // disable idle timer
    [[UIApplication sharedApplication] setIdleTimerDisabled:![CDXSettings enableIdleTimer]];
    
    // update title
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = _cardDeck.name;
    
    // inform super
    [super viewWillAppear:animated];
    
    // configure the page jump pages
    if (_pageCount <= 1) {
        // no page jump for 1 or less pages
        _pageJumpPagesMax = 0;
    } else if (_pageCount <= 6) {
        // 2 page jumps for up to 6 pages (first, last)
        _pageJumpPagesMax = 2;
        _pageJumpPages[0] = 0;
        _pageJumpPages[1] = _pageCount-1;
    } else if (_pageCount <= 16) {
        // 3 page jumps for up to 16 pages (first, 1/2, last)
        _pageJumpPagesMax = 3;
        _pageJumpPages[0] = 0;
        _pageJumpPages[1] = MAX(1, round(_pageCount / 2 + 0.5)) - 1;
        _pageJumpPages[2] = MAX(1, _pageCount) - 1;
    } else {
        // 5 page jumps for more than 16 pages (first, 1/4, 1/2, last-1/4, last)
        _pageJumpPagesMax = 5;
        _pageJumpPages[0] = 0;
        _pageJumpPages[1] = MAX(1, round(_pageCount / 4 + 0.5)) - 1;
        _pageJumpPages[2] = MAX(1, round(_pageCount / 2 + 0.5)) - 1;
        _pageJumpPages[3] = _pageCount - _pageJumpPages[1] - 1;
        _pageJumpPages[4] = MAX(1, _pageCount) - 1;
    }
    
    [self initializeView];
    
    // reset flags
    _hideNavigationBarYesCanceled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    LogInvocation();
    
    [super viewDidAppear:animated];
    
    // automatically hide the navigation bar after some time
    [self performSelector:@selector(hideNavigationBarYes) withObject:nil afterDelay:1];
    
    // register for change events for device orientation
    if (_autoRotate) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    // receive shake events as first responder
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    LogInvocation();
    
    // enable idle timer
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    _hideNavigationBarYesCanceled = YES;
    
    [super viewWillDisappear:animated];
    
    // unregister for change events for device orientation
    if (_autoRotate) {
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    LogInvocation();
    
    _hideNavigationBarYesCanceled = YES;
    
    [super viewDidAppear:animated];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    LogInvocation();
    
    // reconfigure all card view controllers with new orientation
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    CDXCardOrientation cardOrientation = [CDXCardOrientationHelper cardOrientationFromDeviceOrientation:deviceOrientation];
    for (int i = 0; i < 5; i++) {
        CDXCardViewController *cardViewController = (CDXCardViewController *)_cardViewControllers[i];
        [cardViewController setOrientation:cardOrientation];
    }
}

- (void)configureCardViewControllerAtIndex:(NSUInteger)index page:(NSUInteger)page cached:(BOOL)cached {
    LogInvocation();
    
    index += _cardViewControllersMax;
    index %= _cardViewControllersMax;
    
    // page already configured?
    if (cached && _cardViewControllersPage[index] == page+1) {
        LogDebug(@"page %d already configured", page);
        return;
    }
    
    // invalid page?
    if (page >= _pageCount) {
        return;
    }
    
    // assign the page
    _cardViewControllersPage[index] = page+1;
    CGRect frame;
    frame.origin.x = _pageWidth * page;
    frame.origin.y = 0;
    frame.size.width = _pageWidth;
    frame.size.height = _pageHeight;
    LogDebug(@"frame  %8.2f %8.2f %8.2f %8.2f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    // configure the view controller
    CDXCardOrientation cardOrientation = CDXCardOrientationUp;
    if (_autoRotate) {
        UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
        cardOrientation = [CDXCardOrientationHelper cardOrientationFromDeviceOrientation:deviceOrientation];
    }
    CDXCardViewController *cardViewController = (CDXCardViewController *)_cardViewControllers[index];
    [cardViewController configureWithCard:(CDXCard *)[_cards objectAtIndex:page]
                landscapeRenderingContext:(CDXTextRenderingContext *)[_cardViewLandscapeRenderingContexts objectAtIndex:page]
                 portraitRenderingContext:(CDXTextRenderingContext *)[_cardViewPortraitRenderingContexts objectAtIndex:page]
                                    frame:frame
                              orientation:cardOrientation];
    
    // unhide its view
    cardViewController.view.hidden = NO;
    
    // inform the controller
    [cardViewController viewWillAppear:NO];
    [cardViewController viewDidAppear:NO];
}

- (void)configureViewForPage:(NSUInteger)page cached:(BOOL)cached {
    LogInvocation();
    
    // invalid page?
    if (page >= _pageCount) {
        return;
    }
    
#   if CDXLoggingIsAvailable
    // configured pages
    for (NSUInteger i = 0; i < _cardViewControllersMax; i++) {
        LogDebug(@"0 [%d] %@", _cardViewControllersPage[i], ((CDXCardViewController *)_cardViewControllers[i]).card.text);
    }
#   endif
    
    // find index of given page
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < _cardViewControllersMax; i++) {
        if (_cardViewControllersPage[i] == page+1) {
            index = i;
            break;
        }
    }
    
    // configure page +-2
    LogDebug(@"0 <%d>", index);
    for (NSUInteger i = 0; i < _cardViewControllersMax; i++) {
        [self configureCardViewControllerAtIndex:index-2 page:page-2+i cached:cached];
        index++;
    }
    
#   if CDXLoggingIsAvailable
    // configured pages
    for (NSUInteger i = 0; i < _cardViewControllersMax; i++) {
        LogDebug(@"1 [%d] %@", _cardViewControllersPage[i], ((CDXCardViewController *)_cardViewControllers[i]).card.text);
    }
#   endif
    
    // update current page, page control, etc.
    _currentPage = page;
    _pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // show the page control
    if (!_showPageControl && _pageControl.alpha == 0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        [_pageControl setAlpha:0.9];
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    LogInvocation();
    
    const CGFloat contentOffsetX = _scrollView.contentOffset.x;
    const NSUInteger newPage = contentOffsetX / _pageWidth;
    
    // configure visible pages
    if (newPage != _currentPage) {
        [self configureViewForPage:newPage cached:YES];
    }
    
    // hide the page control
    if (!_showPageControl && [[[self navigationController] navigationBar] alpha] == 0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [_pageControl setAlpha:0.0];
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    LogInvocation(@"%8.2f", _scrollView.contentOffset.x);
    
    const CGFloat contentOffsetX = _scrollView.contentOffset.x;
    if (contentOffsetX < 0 || contentOffsetX > _pageWidth * (_pageCount-1)) {
        LogDebug(@"out of scope");
        return;
    }
    
    const CGFloat contentOffsetXCurrentPage = (_currentPage * _pageWidth);
    const CGFloat contentOffsetXDiff = contentOffsetX - contentOffsetXCurrentPage;
    if (abs(contentOffsetXDiff) < _pageWidth + 20) {
        LogDebug(@"update not required");
        return;
    }
    
    LogDebug(@"update required, diff %8.2f", contentOffsetXDiff);
    const NSUInteger newPage = contentOffsetXDiff > 0 ? (contentOffsetX / _pageWidth) : ((contentOffsetX + _pageWidth-1) / _pageWidth);
    
    // configure visible pages
    if (newPage != _currentPage) {
        [self configureViewForPage:newPage cached:YES];
    }
}

- (void)scrollViewToPage:(NSUInteger)page cached:(BOOL)cached {
    LogInvocation();
    
    // change page
    if (page != _currentPage || !cached) {
        // configure visible pages
        [self configureViewForPage:page cached:YES];
        
        // scroll view to new page
        CGRect frame = _scrollView.frame;
        frame.origin.x = _pageWidth * page;
        frame.origin.y = 0;
        [_scrollView scrollRectToVisible:frame animated:NO];
        
        // update page control
        _pageControl.currentPage = page;
    }
    
    // always flash the page control
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if (!_showPageControl && _pageControl.alpha == 0) {
        [_pageControl setAlpha:0.9];
        [_pageControl setAlpha:0.0];
    } else {
        [_pageControl setAlpha:0.0];
        [_pageControl setAlpha:0.9];
    }
    [UIView commitAnimations];
}

- (void)hideNavigationBar:(BOOL)hidden {
    LogInvocation();
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [[[self navigationController] navigationBar] setAlpha:hidden ? 0.0 : 1];
    [_toolbar setAlpha:hidden ? 0.0 : 1];
    if (!_showStatusBar) {
        [[UIApplication sharedApplication] setStatusBarHidden:hidden animated:YES];
    }
    if (!_showPageControl) {
        [_pageControl setAlpha:hidden ? 0.0 : 0.75];
    }
    [UIView commitAnimations];
}

- (void)hideNavigationBarYes {
    LogInvocation();
    
    if (!_hideNavigationBarYesCanceled) {
        [self hideNavigationBar:YES];
    }
}

- (void)singleTapTouchOnView:(UIView *)view {
    LogInvocation();
    
    _hideNavigationBarYesCanceled = YES;
    if ([[[self navigationController] navigationBar] alpha] <= 0) {
        [self hideNavigationBar:NO];
    } else if ([[[self navigationController] navigationBar] alpha] >= 1.0) {
        [self hideNavigationBar:YES];
    } 
}

- (IBAction)pageControlValueChanged:(id)sender {
    LogInvocation(@"page %d", _pageControl.currentPage);
    
    NSUInteger newPage = _pageControl.currentPage;
    if (!(newPage >= 0 && newPage < _pageCount)) {
        _pageControl.currentPage = _currentPage;
        return;
    }
    
    [self scrollViewToPage:newPage cached:YES];
}

- (IBAction)backButtonPressed {
    LogInvocation();
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)pageLeftButtonPressed {
    _pageControl.currentPage -= 1;
    [self pageControlValueChanged:nil];
}

- (IBAction)pageRightButtonPressed {
    _pageControl.currentPage += 1;
    [self pageControlValueChanged:nil];
}

- (IBAction)pageJumpLeftButtonPressed {
    LogInvocation();
    
    for (int i = _pageJumpPagesMax-1; i >= 0; i--) {
        if (_currentPage > _pageJumpPages[i]) {
            [self scrollViewToPage:_pageJumpPages[i] cached:YES];
            break;
        }
    }
}

- (IBAction)pageJumpRightButtonPressed {
    LogInvocation();
    
    for (int i = 0; i < _pageJumpPagesMax; i++) {
        if (_currentPage < _pageJumpPages[i]) {
            [self scrollViewToPage:_pageJumpPages[i] cached:YES];
            break;
        }
    }
}

- (IBAction)editButtonPressed {
    LogInvocation();
    
    _hideNavigationBarYesCanceled = YES;
    _cardDeck.dirty = NO;
    CDXCardDeckEditViewController *cardDeckEditViewController = [CDXCardDeckEditViewController cardDeckEditViewControllerWithCardDeck:_cardDeck cardDeckList:nil cardDeckInList:nil];
    
    CDXCard *currentCard = (CDXCard *)[_cards objectAtIndex:_currentPage];
    NSUInteger editRow = [_cardDeck indexOfCard:currentCard] + 1; 
    cardDeckEditViewController.tableViewDirectEditRowIndexPath = [NSIndexPath indexPathForRow:editRow inSection:0];
    
    [[self navigationController] pushViewController:cardDeckEditViewController animated:YES];
}

- (IBAction)settingsButtonPressed {
    LogInvocation();
    
    // push the settings view
    CDXSettingsViewController *settingsViewController = [CDXSettingsViewController settingsViewController];
    [self presentModalViewController:settingsViewController animated:YES];
}

- (IBAction)randomButtonPressed {
    LogInvocation();
    
    // select a random page
    NSUInteger newPage = (drand48() * _pageCount);
    [self scrollViewToPage:newPage cached:YES];
}

- (IBAction)shuffleButtonPressed {
    LogInvocation();
    
    // shuffle the cards
    for (NSUInteger i = 0; i < _pageCount; i++) {
        NSUInteger newPage = (drand48() * _pageCount);
        [_cards exchangeObjectAtIndex:newPage withObjectAtIndex:i];
    }
    
    // re-initialize the view and show the current page
    [self initializeView];
}

- (BOOL)canBecomeFirstResponder {
    LogInvocation();
    
    // yes, required for receiving shake events
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    LogInvocation();
    
    // shake event received, scroll to random page
    if (_shakeRandom && event.type == UIEventSubtypeMotionShake) {
        [self randomButtonPressed];
    }
    
    // dispatch other events to super
    if ([super respondsToSelector:@selector(motionEnded:withEvent:)]) {
        [super motionEnded:motion withEvent:event];
    }
}

+ (CDXCardDeckViewController *)cardDeckViewControllerWithCardDeck:(CDXCardDeck *)cardDeck {
    LogInvocation();
    
    CDXCardDeckViewController *controller = [[[CDXCardDeckViewController alloc] initWithNibName:@"CDXCardDeckView" bundle:nil] autorelease];
    controller.cardDeck = cardDeck;
    
    return controller;
}

@end

