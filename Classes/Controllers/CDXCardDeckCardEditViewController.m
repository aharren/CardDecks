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

#undef ql_component
#define ql_component lcl_cController


@implementation CDXCardDeckCardEditViewController

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)aCardDeckViewContext editDefaults:(BOOL)editDefaults {
    if ((self = [super initWithNibName:@"CDXCardDeckCardEditView" bundle:nil])) {
        ivar_assign_and_retain(cardDeckViewContext, aCardDeckViewContext);
        ivar_assign_and_retain(cardDeck, cardDeckViewContext.cardDeck);
        self.hidesBottomBarWhenPushed = YES;
        editingDefaults = editDefaults;
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

- (CDXCard *)currentCard {
    if (editingDefaults) {
        return cardDeck.cardDefaults;
    } else {
        return [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex];
    }
}

- (void)showCardColors {
    CDXCard *card = [self currentCard];
    text.textColor = [card.textColor uiColor];
    text.backgroundColor = [card.backgroundColor uiColor];
}

- (void)showCardAtIndex:(NSUInteger)cardIndex {
    cardDeckViewContext.currentCardIndex = cardIndex;
    CDXCard *card = [self currentCard];
    text.text = card.text;
    if (!editingDefaults) {
        [viewButtonsUpDown setEnabled:(cardIndex != 0) forSegmentAtIndex:0];
        [viewButtonsUpDown setEnabled:(cardIndex < ([cardDeck cardsCount] - 1)) forSegmentAtIndex:1];
        
        self.navigationItem.title = [NSString stringWithFormat:@"%d of %d", cardIndex+1, [cardDeck cardsCount]];
    }
    [self showCardColors];
}

- (void)finishCardModification {
    CDXCard *card = [self currentCard];
    card.text = text.text;
    if (!editingDefaults) {
        [cardDeck replaceCardAtIndex:cardDeckViewContext.currentCardIndex withCard:card];
    }
    
    [cardDeckViewContext updateStorageObjectsDeferred:YES];
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
    self.navigationItem.rightBarButtonItem = editingDefaults ? nil : viewButtonsUpDownBarButtonItem;
    
    [self showCardAtIndex:cardDeckViewContext.currentCardIndex];
    [text becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[CDXSymbolsKeyboardExtension sharedSymbolsKeyboardExtension] reset];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self finishCardModification];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] removeResponder];
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

- (BOOL)keyboardExtensionResponderHasActionsForExtensionAtIndex:(NSUInteger)index {
    return index == 1 || index == 2;
}

- (void)keyboardExtensionResponderRunActionsForExtensionAtIndex:(NSUInteger)index {
    qltrace();
    UIActionSheet *sheet = nil;
    if (editingDefaults) {
        index = -index;
    }
    switch (index) {
        case 1:
            sheet = [[[UIActionSheet alloc] initWithTitle:@"Copy Color Properties"
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Text \u21e2 Defaults", @"Text \u21e0 Defaults", @"Background \u21e2 Defaults", @"Background \u21e0 Defaults", nil] autorelease];
            break;
        case 2:
            sheet = [[[UIActionSheet alloc] initWithTitle:@"Copy Text Properties"
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Layout \u21e2 Defaults", @"Layout \u21e0 Defaults", @"Size \u21e2 Defaults", @"Size \u21e0 Defaults", nil] autorelease];
            break;
        case -1:
            sheet = [[[UIActionSheet alloc] initWithTitle:@"Copy Color Properties"
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Text \u21e2 All Cards", @"Background \u21e2 All Cards", nil] autorelease];
            break;
        case -2:
            sheet = [[[UIActionSheet alloc] initWithTitle:@"Copy Text Properties"
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Layout \u21e2 All Cards", @"Size \u21e2 All Cards", nil] autorelease];
            break;
        default:
            break;
    }
    if (sheet) {
        sheet.tag = index;
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    qltrace();
    CDXCard *card = [self currentCard];
    switch (actionSheet.tag) {
        case 1:
            switch (buttonIndex) {
                case 0:
                    cardDeck.cardDefaults.textColor = card.textColor;
                    break;
                case 1:
                    card.textColor = cardDeck.cardDefaults.textColor;
                    break;
                case 2:
                    cardDeck.cardDefaults.backgroundColor = card.backgroundColor;
                    break;
                case 3:
                    card.backgroundColor = cardDeck.cardDefaults.backgroundColor;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (buttonIndex) {
                case 0:
                    cardDeck.cardDefaults.orientation = card.orientation;
                    break;
                case 1:
                    card.orientation = cardDeck.cardDefaults.orientation;
                    break;
                case 2:
                    cardDeck.cardDefaults.fontSize = card.fontSize;
                    break;
                case 3:
                    card.fontSize = cardDeck.cardDefaults.fontSize;
                    break;
                default:
                    break;
            }
            break;
        case -1:
            switch (buttonIndex) {
                case 0:
                    [cardDeck setTextColor:card.textColor];
                    break;
                case 1:
                    [cardDeck setBackgroundColor:card.backgroundColor];
                    break;
                default:
                    break;
            }
            break;
        case -2:
            switch (buttonIndex) {
                case 0:
                    [cardDeck setOrientation:card.orientation];
                    break;
                case 1:
                    [cardDeck setFontSize:card.fontSize];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    [self showCardColors];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] refreshKeyboardExtensions];
}

- (CDXColor *)colorKeyboardExtensionTextColor {
    return [self currentCard].textColor;
}

- (void)colorKeyboardExtensionSetTextColor:(CDXColor *)color {
    [self currentCard].textColor = color;
    [self showCardColors];
}

- (CDXColor *)colorKeyboardExtensionBackgroundColor {
    return [self currentCard].backgroundColor;
}

- (void)colorKeyboardExtensionSetBackgroundColor:(CDXColor *)color {
    [self currentCard].backgroundColor = color;
    [self showCardColors];
}

- (CDXCardOrientation)textKeyboardExtensionCardOrientation {
    return [self currentCard].orientation;
}

- (void)textKeyboardExtensionSetCardOrientation:(CDXCardOrientation)cardOrientation {
    [self currentCard].orientation = cardOrientation;
}

- (CGFloat)textKeyboardExtensionFontSize {
    return [self currentCard].fontSize;
}

- (void)textKeyboardExtensionSetFontSize:(CGFloat)fontSize {
    [self currentCard].fontSize = fontSize;
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

