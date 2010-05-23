//
//
// CDXCardDeckCardEditViewController.m
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

#import "CDXCardDeckCardEditViewController.h"


@implementation CDXCardDeckCardEditViewController

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)aCardDeckViewContext {
    if ((self = [super initWithNibName:@"CDXCardDeckCardEditView" bundle:nil])) {
        ivar_assign_and_retain(cardDeckViewContext, aCardDeckViewContext);
        ivar_assign_and_retain(cardDeck, cardDeckViewContext.cardDeck);
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(text);
    ivar_release_and_clear(viewButtonsUpDownBarButtonItem);
    ivar_release_and_clear(viewButtonsUpDown);
    ivar_release_and_clear(cardDeck);
    [super dealloc];
}

- (void)showCardAtIndex:(NSUInteger)cardIndex {
    cardDeckViewContext.currentCardIndex = cardIndex;

    CDXCard *card = [cardDeck cardAtIndex:cardIndex];
    text.text = card.text;
    
    [viewButtonsUpDown setEnabled:(cardIndex != 0) forSegmentAtIndex:0];
    [viewButtonsUpDown setEnabled:(cardIndex < ([cardDeck cardsCount] - 1)) forSegmentAtIndex:1];
}

- (void)finishCardModification {
    CDXCard *card = [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex];
    card.text = text.text;
    [cardDeck replaceCardAtIndex:cardDeckViewContext.currentCardIndex withCard:card];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    ivar_release_and_clear(text);
    ivar_release_and_clear(viewButtonsUpDownBarButtonItem);
    ivar_release_and_clear(viewButtonsUpDown);
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = viewButtonsUpDownBarButtonItem;
    
    [self showCardAtIndex:cardDeckViewContext.currentCardIndex];
    [text becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self finishCardModification];
    [super viewWillDisappear:animated];
}

- (void)setUserInteractionEnabled:(BOOL)enabled {
}

- (void)deviceOrientationDidChange:(UIDeviceOrientation)orientation {
}

- (IBAction)upDownButtonPressed {
    [self finishCardModification];
    [self showCardAtIndex:(cardDeckViewContext.currentCardIndex - 1) + (viewButtonsUpDown.selectedSegmentIndex << 1)];
}

@end

