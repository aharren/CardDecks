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

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize pageJumpLeftButton = _pageJumpLeftButton;
@synthesize pageJumpRightButton = _pageJumpRightButton;

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
    
    self.scrollView = nil;
    self.pageControl = nil;
    
    self.pageJumpLeftButton = nil;
    self.pageJumpRightButton = nil;
    
    for (int i = 0; i < 5; i++) {
        [_cardViewControllers[i] release];
        _cardViewControllers[i] = nil;
    }
    
    [super dealloc];
}

- (void)viewDidLoad {
    LogInvocation();
    
    [super viewDidLoad];
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = _cardDeck.name;
    
    _pageCount = [_cardDeck cardsCount];
    _pageWidth = _scrollView.frame.size.width;
    _pageHeight = _scrollView.frame.size.height;
    
    _baseBounds = self.view.bounds;
    _baseBounds.size.width = _pageWidth;
    _baseBounds.size.height = _pageHeight;    
    
    _scrollView.contentSize = CGSizeMake(_pageWidth * _pageCount, _pageHeight);
    
    _pageControl.numberOfPages = _pageCount;
    
    _cardViewControllersMax = MIN(5, _pageCount);
    for (NSUInteger i = 0; i < _cardViewControllersMax; i++) {
        CDXCardViewController *cardViewController = [CDXCardViewController cardViewController];
        _cardViewControllers[i] = [cardViewController retain];
    }    
}

- (void)viewDidUnload {
    LogInvocation();
    
    self.scrollView = nil;
    self.pageControl = nil;
    
    self.pageJumpLeftButton = nil;
    self.pageJumpRightButton = nil;
    
    for (int i = 0; i < 5; i++) {
        [_cardViewControllers[i] release];
        _cardViewControllers[i] = nil;
    }
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    LogInvocation();
    
    [super viewWillAppear:animated];

    // create the rendering data for all cards
    UIFont *font = [UIFont boldSystemFontOfSize:400];
    for (NSUInteger i = 0; i < _pageCount; i++) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        CDXCard *card = [_cardDeck cardAtIndex:i];
        NSArray *textLines = [card.text componentsSeparatedByString:@"\n"];
        [card renderingContextPortraitForFont:font width:320 height:440 text:textLines cached:YES standard:YES];
        [card renderingContextLandscapeForFont:font width:440 height:320 text:textLines cached:YES standard:YES];
        [pool release];
    }
    
    // add the views of the card view controllers
    _lastScrollPage = 0;
    _currentPage = 0;
    for (NSUInteger i = _cardViewControllersMax; i > 0; i--) {
        LogDebug(@"controller %d", i-1);
        CDXCardViewController *cardViewController = (CDXCardViewController *)_cardViewControllers[i-1];
        [_scrollView addSubview:cardViewController.view];
    }
    
    // configure the card view controllers with visible cards
    for (NSUInteger i = 0; i < MIN(3, _cardViewControllersMax); i++) {
        [self configureCardViewControllerAtIndex:i page:i];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    LogInvocation();
    
    [super viewDidAppear:animated];
    
    // automatically hide the navigation bar after some time
    [self performSelector:@selector(hideNavigationBarYes) withObject:nil afterDelay:1];
    
    // register for change events for device orientation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    LogInvocation();
    
    _hideNavigationBarYesCanceled = YES;
    
    [super viewWillDisappear:animated];
    
    // unregister for change events for device orientation
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    LogInvocation();
    
    _hideNavigationBarYesCanceled = YES;
    
    [super viewDidAppear:animated];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    LogInvocation();
    
    // reconfigure all card view controllers with new orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    for (int i = 0; i < 5; i++) {
        CDXCardViewController *cardViewController = (CDXCardViewController *)_cardViewControllers[i];
        [cardViewController setOrientation:orientation];
    }
}

- (void)configureCardViewControllerAtIndex:(NSUInteger)index page:(NSUInteger)page {
    LogInvocation();
    
    index += _cardViewControllersMax;
    index %= _cardViewControllersMax;
    
    // page already configured?
    if (_cardViewControllersPage[index] == page+1) {
        return;
    }
    
    // invalid page?
    if (!(page >= 0 && page < _pageCount)) {
        return;
    }
    
    // assign the page
    _cardViewControllersPage[index] = page+1;
    
    // configure the controller
    CDXCardViewController *cardViewController = (CDXCardViewController *)_cardViewControllers[index];
    [cardViewController configureWithCard:[_cardDeck cardAtIndex:page]];
    
    // configure the view
    CGRect frame = cardViewController.view.frame;
    frame.origin.x = _pageWidth * page;
    frame.origin.y = 0;
    frame.size.width = _pageWidth;
    frame.size.height = _pageHeight;
    cardViewController.view.frame = frame;
    
    [cardViewController viewWillAppear:YES];
}

- (void)showCardViewControllersForPage:(NSUInteger)page {
    LogInvocation();

#   if CDXLoggingIsAvailable
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
    for (NSUInteger i = 0; i < _cardViewControllersMax; i++) {
        [self configureCardViewControllerAtIndex:index-2 page:page-2+i];
        index++;
    }
    
#   if CDXLoggingIsAvailable
    for (NSUInteger i = 0; i < _cardViewControllersMax; i++) {
        LogDebug(@"1 [%d] %@", _cardViewControllersPage[i], ((CDXCardViewController *)_cardViewControllers[i]).card.text);
    }
#   endif
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    LogInvocation();
    
    NSUInteger newPage = floor((_scrollView.contentOffset.x - _pageWidth / 2) / _pageWidth) + 1;
    
    // invalid page?
    if (!(newPage >= 0 && newPage < _pageCount))
        return;
    
    // configure visible pages
    if (_lastScrollPage != newPage) {
        [self showCardViewControllersForPage:newPage];
    }
    _lastScrollPage = newPage;
    _currentPage = newPage;
    _pageControl.currentPage = _currentPage;
}

- (void)scrollViewToPage:(NSUInteger)page {
    LogInvocation();
    
    // nothing has changed?
    if (page == _currentPage) {
        return;
    }
    
    // configure visible pages
    [self showCardViewControllersForPage:page];
    _currentPage = page;
    _lastScrollPage = page;
    _pageControl.currentPage = page;
    
    // scroll view to new page
    CGRect frame = _scrollView.frame;
    frame.origin.x = _pageWidth * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:NO];
}

- (void)hideNavigationBar:(BOOL)hidden {
    LogInvocation();
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [[[self navigationController] navigationBar] setAlpha:hidden ? 0.0 : 1];
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
    
    [self scrollViewToPage:newPage];
}

- (IBAction)backButtonPressed {
    LogInvocation();
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)pageJumpLeftButtonPressed {
    LogInvocation();
    
    if (_currentPage > 4) {
        [self scrollViewToPage:_currentPage-4];
    } else {
        [self scrollViewToPage:0];
    }
}

- (IBAction)pageJumpRightButtonPressed {
    LogInvocation();
    
    if (_currentPage+4 < _pageCount) {
        [self scrollViewToPage:_currentPage+4];
    } else if (_pageCount > 0) {
        [self scrollViewToPage:_pageCount-1];
    }
}

+ (CDXCardDeckViewController *)cardDeckViewControllerWithCardDeck:(CDXCardDeck *)cardDeck {
    LogInvocation();

    CDXCardDeckViewController *controller = [[[CDXCardDeckViewController alloc] initWithNibName:@"CDXCardDeckView" bundle:nil] autorelease];
    controller.cardDeck = cardDeck;
    
    return controller;
}

@end

