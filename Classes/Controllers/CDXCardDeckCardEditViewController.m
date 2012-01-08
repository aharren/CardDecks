//
//
// CDXCardDeckCardEditViewController.m
//
//
// Copyright (c) 2009-2012 Arne Harren <ah@0xc0.de>
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

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)aCardDeckViewContext editDefaults:(BOOL)editDefaults nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        ivar_assign_and_retain(cardDeckViewContext, aCardDeckViewContext);
        ivar_assign_and_retain(cardDeck, cardDeckViewContext.cardDeck);
        self.hidesBottomBarWhenPushed = YES;
        cardViewUsePreview = YES;
        textUpdateColors = YES;
        editingDefaults = editDefaults;
    }
    return self;
}

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)aCardDeckViewContext editDefaults:(BOOL)editDefaults {
    return [self initWithCardDeckViewContext:aCardDeckViewContext editDefaults:editDefaults nibName:@"CDXCardDeckCardEditView" bundle:nil];
}

- (void)dealloc {
    ivar_release_and_clear(text);
    ivar_release_and_clear(cardViewScrollView);
    ivar_release_and_clear(cardView);
    ivar_release_and_clear(viewButtonsUpDownBarButtonItem);
    ivar_release_and_clear(viewButtonsUpDown);
    ivar_release_and_clear(cardDeckViewContext);
    ivar_release_and_clear(cardDeck);
    ivar_release_and_clear(activeActionSheet);
    [super dealloc];
}

- (CDXCard *)currentCard {
    if (editingDefaults) {
        return cardDeck.cardDefaults;
    } else {
        return [cardDeck cardAtIndex:cardDeckViewContext.currentCardIndex];
    }
}

- (void)updateCardPreview {
    if (textUpdateColors) {
        CDXCard *card = [self currentCard];
        text.textColor = [card.textColor uiColor];
        text.backgroundColor = [card.backgroundColor uiColor];
    }
    [cardView setCard:[self currentCard] size:cardViewSize deviceOrientation:UIDeviceOrientationPortrait preview:cardViewUsePreview];
    cardViewScrollView.contentSize = cardViewSize;
}

- (void)showCardAtIndex:(NSUInteger)cardIndex {
    cardDeckViewContext.currentCardIndex = cardIndex;
    CDXCard *card = [self currentCard];
    text.text = card.text;
    if (!editingDefaults) {
        [viewButtonsUpDown setEnabled:(cardIndex != 0) forSegmentAtIndex:0];
        [viewButtonsUpDown setEnabled:(cardIndex < ([cardDeck cardsCount] - 1)) forSegmentAtIndex:1];
        
        self.navigationItem.title = [NSString stringWithFormat:@"%d of %d", cardIndex+1, [cardDeck cardsCount]];
    } else {
        self.navigationItem.title = @"Defaults";
    }
    [self updateCardPreview];
    cardViewScrollView.contentOffset = CGPointMake(0, MAX(0, (cardViewSize.height - cardViewScrollView.frame.size.height) / 2));
}

- (void)showCardView:(BOOL)show {
    if (!cardViewScrollView.hidden == show) {
        cardViewScrollView.contentOffset = CGPointMake(0, MAX(0, (cardViewSize.height - cardViewScrollView.frame.size.height) / 2));
        return;
    }
    if (show) {
        text.hidden = YES;
        cardViewScrollView.hidden = NO;
        NSString *cardText = text.text;
        if (cardText == nil || [cardText length] == 0) {
            cardText = @"TEXT";
        }
        [self currentCard].text = cardText;
        [self updateCardPreview];
    } else {
        text.hidden = NO;
        cardViewScrollView.hidden = YES;
    }
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
    cardViewSize = [[UIScreen mainScreen] bounds].size;
}

- (void)viewDidUnload {
    ivar_release_and_clear(text);
    ivar_release_and_clear(cardViewScrollView);
    ivar_release_and_clear(cardView);
    ivar_release_and_clear(viewButtonsUpDownBarButtonItem);
    ivar_release_and_clear(viewButtonsUpDown);
    ivar_release_and_clear(activeActionSheet);
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem = editingDefaults ? nil : viewButtonsUpDownBarButtonItem;
    
    [self showCardAtIndex:cardDeckViewContext.currentCardIndex];
    [text becomeFirstResponder];
    [self showCardView:NO];
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

- (void)dismissActionSheet {
    if (activeActionSheet != nil) {
        [activeActionSheet dismissWithClickedButtonIndex:[activeActionSheet cancelButtonIndex] animated:NO];
        ivar_release_and_clear(activeActionSheet);
    }
}

- (void)keyboardExtensionResponderExtensionBecameActiveAtIndex:(NSUInteger)index {
    [self showCardView:(index == 1 || index == 2)];
    [self dismissActionSheet];
}

- (BOOL)keyboardExtensionResponderHasActionsForExtensionAtIndex:(NSUInteger)index {
    return index == 1 || index == 2;
}

- (void)keyboardExtensionResponderRunActionsForExtensionAtIndex:(NSUInteger)index barButtonItem:(UIBarButtonItem *)barButtonItem {
    qltrace();
    if (activeActionSheet != nil) {
        [self dismissActionSheet];
        // don't open a new sheet, just closed the same one
        return;
    }
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
        [[CDXAppWindowManager sharedAppWindowManager] showActionSheet:sheet fromBarButtonItem:barButtonItem];
        ivar_assign_and_retain(activeActionSheet, sheet);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    qltrace();
    ivar_release_and_clear(activeActionSheet);
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
    [self updateCardPreview];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] refreshKeyboardExtensions];
}

- (CDXColor *)colorKeyboardExtensionTextColor {
    return [self currentCard].textColor;
}

- (void)colorKeyboardExtensionSetTextColor:(CDXColor *)color {
    [self currentCard].textColor = color;
    [self updateCardPreview];
}

- (CDXColor *)colorKeyboardExtensionBackgroundColor {
    return [self currentCard].backgroundColor;
}

- (void)colorKeyboardExtensionSetBackgroundColor:(CDXColor *)color {
    [self currentCard].backgroundColor = color;
    [self updateCardPreview];
}

- (CDXCardOrientation)textKeyboardExtensionCardOrientation {
    return [self currentCard].orientation;
}

- (void)textKeyboardExtensionSetCardOrientation:(CDXCardOrientation)cardOrientation {
    [self currentCard].orientation = cardOrientation;
    [self updateCardPreview];
}

- (CGFloat)textKeyboardExtensionFontSize {
    return [self currentCard].fontSize;
}

- (void)textKeyboardExtensionSetFontSize:(CGFloat)fontSize {
    [self currentCard].fontSize = fontSize;
    [self updateCardPreview];
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

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    qltrace();
    [super dismissModalViewControllerAnimated:animated];
    [self dismissActionSheet];
}

@end

