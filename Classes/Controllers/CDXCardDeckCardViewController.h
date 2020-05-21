//
//
// CDXCardDeckCardViewController.h
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

#import "CDXCardDeck.h"
#import "CDXCardDeckViewContext.h"
#import "CDXCardsViewProtocols.h"
#import "CDXAppWindowProtocols.h"
#import "CDXIndexDotsView.h"


@class CDXCardDeckCardViewControllerTimer;

@interface CDXCardDeckCardViewController : UIViewController<CDXAppWindowViewController, CDXCardsViewDelegate, CDXCardsViewDataSource> {
    
@protected
    CDXCardDeckViewContext *cardDeckViewContext;
    CDXCardDeck *cardDeck;
    
    UIDeviceOrientation deviceOrientation;
    
    UIView<CDXCardsViewView> *cardsView;
    BOOL cardsViewShowsFirstCard;
    
    BOOL userInteractionEnabled;
    UIView *initialView;
    
    IBOutlet CDXIndexDotsView *indexDotsView;
    NSUInteger pageControlJumpPagesCount;
    NSUInteger pageControlJumpPages[5];
    
    IBOutlet UIView *actionsView;
    IBOutlet UIView *actionsViewButtonsView;
    IBOutlet UIButton *actionsViewShuffleButton;
    IBOutlet UIButton *actionsViewSortButton;
    IBOutlet UIButton *actionsViewPlayButton;
    IBOutlet UIButton *actionsViewPlay2Button;
    IBOutlet UIButton *actionsViewStopButton;

    NSUInteger closeTapCount;

    IBOutlet UIView *timerSignalView;
    CDXCardDeckCardViewControllerTimer *currentTimer;
}

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)cardDeckViewContext;

- (BOOL)prefersStatusBarHidden;

- (IBAction)pageControlLeftButtonPressed;
- (IBAction)pageControlRightButtonPressed;
- (IBAction)pageControlJumpLeftButtonPressed;
- (IBAction)pageControlJumpRightButtonPressed;

- (IBAction)shuffleButtonPressed;
- (IBAction)randomButtonPressed;
- (IBAction)sortButtonPressed;

- (IBAction)toggleActionsViewButtonPressed;
- (IBAction)dismissActionsViewButtonPressed;

- (IBAction)playButtonPressed;
- (IBAction)play2ButtonPressed;
- (IBAction)stopButtonPressed;

@end

