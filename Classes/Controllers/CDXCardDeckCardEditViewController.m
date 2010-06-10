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
    ivar_release_and_clear(cardDeckViewContext);
    ivar_release_and_clear(cardDeck);
    [super dealloc];
}

- (void)showCardColors {
    CDXCard *card = [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex];
    text.textColor = [card.textColor uiColor];
    text.backgroundColor = [card.backgroundColor uiColor];
}

- (void)showCardAtIndex:(NSUInteger)cardIndex {
    cardDeckViewContext.currentCardIndex = cardIndex;
    
    CDXCard *card = [cardDeck cardAtIndex:cardIndex];
    text.text = card.text;
    
    [viewButtonsUpDown setEnabled:(cardIndex != 0) forSegmentAtIndex:0];
    [viewButtonsUpDown setEnabled:(cardIndex < ([cardDeck cardsCount] - 1)) forSegmentAtIndex:1];
    
    if ([cardDeck cardsCount] > 1) {
        self.navigationItem.title = [NSString stringWithFormat:@"%d of %d", cardIndex+1, [cardDeck cardsCount]];
    }
    [self showCardColors];
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
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem = ([cardDeck cardsCount] > 1) ? viewButtonsUpDownBarButtonItem : nil;
    
    [self showCardAtIndex:cardDeckViewContext.currentCardIndex];
    [text becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[CDXSymbolsKeyboardExtension sharedSymbolsKeyboardExtension] reset];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self finishCardModification];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setResponder:nil keyboardExtensions:nil];
    [super viewWillDisappear:animated];
}

- (void)setUserInteractionEnabled:(BOOL)enabled {
}

- (void)deviceOrientationDidChange:(UIDeviceOrientation)orientation {
}

- (IBAction)upDownButtonPressed {
    [self finishCardModification];
    [self showCardAtIndex:(cardDeckViewContext.currentCardIndex - 1) + (viewButtonsUpDown.selectedSegmentIndex << 1)];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] refreshKeyboardExtensions];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSArray *extensions = [NSArray arrayWithObjects:
                           [CDXSymbolsKeyboardExtension sharedSymbolsKeyboardExtension],
                           [CDXColorKeyboardExtension sharedColorKeyboardExtension],
                           [CDXTextKeyboardExtension sharedtextKeyboardExtension],
                           nil];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setResponder:self keyboardExtensions:extensions];
}

- (CDXColor *)colorKeyboardExtensionTextColor {
    return [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex].textColor;
}

- (void)colorKeyboardExtensionSetTextColor:(CDXColor *)color {
    [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex].textColor = color;
    [self showCardColors];
}

- (CDXColor *)colorKeyboardExtensionBackgroundColor {
    return [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex].backgroundColor;
}

- (void)colorKeyboardExtensionSetBackgroundColor:(CDXColor *)color {
    [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex].backgroundColor = color;
    [self showCardColors];
}

- (CDXCardOrientation)textKeyboardExtensionCardOrientation {
    return [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex].orientation;
}

- (void)textKeyboardExtensionSetCardOrientation:(CDXCardOrientation)cardOrientation {
    [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex].orientation = cardOrientation;
}

- (CGFloat)textKeyboardExtensionFontSize {
    return [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex].fontSize;
}

- (void)textKeyboardExtensionSetFontSize:(CGFloat)fontSize {
    [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex].fontSize = fontSize;
}

- (void)paste:(id)sender {
    // we want to paste to text, but it doesn't respond to paste directly, so
    // search for the right subview
    for (UIView *view in [text subviews]) {
        if ([view respondsToSelector:@selector(paste:)]) {
            [view paste:nil];
            return;
        }
    }
}

@end

