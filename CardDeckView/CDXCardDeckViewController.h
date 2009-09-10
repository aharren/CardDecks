//
//
// CDXCardDeckViewController.h
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

#import "CDXCardDeck.h"
#import "CDXCardViewController.h"


@class CDXCardDeckViewController;

// A scroll view for a card deck view controller.
@interface CDXCardDeckViewScrollView : UIScrollView {
    
@protected
    // UI elements and controllers
    CDXCardDeckViewController *_controller;
}

@property (nonatomic, assign) IBOutlet CDXCardDeckViewController *controller;

@end


// A view controller for a card deck and multiple cards.
@interface CDXCardDeckViewController : UIViewController {
    
@protected
    // data objects
    CDXCardDeck *_cardDeck;
    
    // UI elements and controllers
    UIScrollView *_scrollView;
    
    UIPageControl *_pageControl;
    
    UIButton *_pageJumpLeftButton;
    UIButton *_pageJumpRightButton;
    NSUInteger _pageJumpPagesMax;
    NSUInteger _pageJumpPages[5];
    
    NSUInteger _currentPage;
    
    NSUInteger _cardViewControllersMax;
    CDXCardDeckViewController *_cardViewControllers[5];
    NSUInteger _cardViewControllersPage[5];
    
    NSUInteger _pageCount;
    CGFloat _pageWidth;
    CGFloat _pageHeight;
    
    BOOL _hideNavigationBarYesCanceled;
    
    CGRect _baseBounds;
    CGAffineTransform _baseTransform;
    
    NSMutableArray *_cardViewLandscapeRenderingContexts;
    NSMutableArray *_cardViewPortraitRenderingContexts;
}

@property (nonatomic, retain) CDXCardDeck *cardDeck;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

@property (nonatomic, retain) IBOutlet UIButton *pageJumpLeftButton;
@property (nonatomic, retain) IBOutlet UIButton *pageJumpRightButton;

@property (nonatomic, retain) NSMutableArray *cardViewLandscapeRenderingContexts;
@property (nonatomic, retain) NSMutableArray *cardViewPortraitRenderingContexts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void)hideNavigationBar:(BOOL)hidden;
- (void)hideNavigationBarYes;
- (void)singleTapTouchOnView:(UIView *)view;

- (void)deviceOrientationDidChange:(NSNotification *)notification;

- (void)configureCardViewControllerAtIndex:(NSUInteger)index page:(NSUInteger)page;
- (void)configureViewForPage:(NSUInteger)page;

- (IBAction)pageControlValueChanged:(id)sender;
- (IBAction)backButtonPressed;

- (IBAction)pageJumpLeftButtonPressed;
- (IBAction)pageJumpRightButtonPressed;

+ (CDXCardDeckViewController *)cardDeckViewControllerWithCardDeck:(CDXCardDeck *)cardDeck;

@end

