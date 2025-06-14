//
//
// CDXCardDeckCardEditViewController.m
//
//
// Copyright (c) 2009-2025 Arne Harren <ah@0xc0.de>
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
#import "CDXDevice.h"
#import "CDXKeyboardExtensions.h"

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
    ivar_release_and_clear(upButton);
    ivar_release_and_clear(downButton);
    ivar_release_and_clear(viewButtons);
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
        self.view.backgroundColor = text.backgroundColor;
    }
    [cardView setCard:[self currentCard] size:cardViewSize deviceOrientation:UIDeviceOrientationPortrait preview:cardViewUsePreview];
    cardViewScrollView.contentSize = cardViewSize;
}

- (void)showCardAtIndex:(NSUInteger)cardIndex {
    cardDeckViewContext.currentCardIndex = cardIndex;
    CDXCard *card = [self currentCard];
    text.text = card.text;
    if (!editingDefaults) {
        upButton.enabled = (cardIndex != 0);
        downButton.enabled = (cardIndex < ([cardDeck cardsCount] - 1));
        
        self.navigationItem.title = [NSString stringWithFormat:@"%lu of %lu", (unsigned long)cardIndex+1, (unsigned long)[cardDeck cardsCount]];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem = nil;
    if (!editingDefaults) {
        UIBarButtonItem *buttons = [[[UIBarButtonItem alloc] initWithCustomView:viewButtons] autorelease];
        self.navigationItem.rightBarButtonItems = @[ buttons ];
    }
    
    NSArray *extensions = @[[CDXSymbolsKeyboardExtension sharedSymbolsKeyboardExtension],
                            [CDXColorKeyboardExtension sharedColorKeyboardExtension],
                            [CDXTextKeyboardExtension sharedtextKeyboardExtension],
                            [CDXTimerKeyboardExtension sharedTimerKeyboardExtension]];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setResponder:self keyboardExtensions:extensions];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setEnabled:YES];

    [self showCardAtIndex:cardDeckViewContext.currentCardIndex];
    [text becomeFirstResponder];
    [self showCardView:NO];

    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;

    // register for keyboard...Show events
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    cardViewScrollView.contentInset = text.contentInset;
    cardViewScrollView.scrollIndicatorInsets = text.scrollIndicatorInsets;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self finishCardModification];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] removeResponder];
    [super viewWillDisappear:animated];

    // deregister all events
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    qltrace();

    // get animation information for the keyboard
    double keyboardAnimationDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardAnimationDuration];
    UIViewAnimationCurve keyboardAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardAnimationCurve];
    CGRect keyboardAnimationEndFrame;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardAnimationEndFrame];
    
    [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:[CDXKeyboardExtensions animationOptionsWithCurve:keyboardAnimationCurve] animations:^{
        CGRect toolbarFrame = [CDXKeyboardExtensions sharedKeyboardExtensions].toolbarFrame;
        
        CGRect textFrame = text.frame;
        text.frame = CGRectMake(textFrame.origin.x, textFrame.origin.y, textFrame.size.width, keyboardAnimationEndFrame.origin.y - toolbarFrame.size.height - textFrame.origin.y);
        CGRect cardViewScrollViewFrame = cardViewScrollView.frame;
        cardViewScrollView.frame = CGRectMake(cardViewScrollViewFrame.origin.x, cardViewScrollViewFrame.origin.y, cardViewScrollViewFrame.size.width, keyboardAnimationEndFrame.origin.y - toolbarFrame.size.height - cardViewScrollViewFrame.origin.y);
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    qltrace();
}

- (void)keyboardWillHide:(NSNotification *)notification {
    qltrace();

    // get animation information for the keyboard
    double keyboardAnimationDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardAnimationDuration];
    UIViewAnimationCurve keyboardAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardAnimationCurve];
    CGRect keyboardAnimationEndFrame;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardAnimationEndFrame];
    
    [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:[CDXKeyboardExtensions animationOptionsWithCurve:keyboardAnimationCurve] animations:^{
        CGRect textFrame = text.frame;
        text.frame = CGRectMake(textFrame.origin.x, textFrame.origin.y, textFrame.size.width, keyboardAnimationEndFrame.origin.y - textFrame.origin.y);
        CGRect cardViewScrollViewFrame = cardViewScrollView.frame;
        cardViewScrollView.frame = CGRectMake(cardViewScrollViewFrame.origin.x, cardViewScrollViewFrame.origin.y, cardViewScrollViewFrame.size.width, keyboardAnimationEndFrame.origin.y - cardViewScrollViewFrame.origin.y);
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    qltrace();
}

- (void)setUserInteractionEnabled:(BOOL)enabled {
}

- (void)deviceOrientationDidChange:(UIDeviceOrientation)orientation {
}

- (void)menuControllerWillHideMenu {
}

- (IBAction)upButtonPressed {
    [self finishCardModification];
    [self showCardAtIndex:cardDeckViewContext.currentCardIndex - 1];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] refreshKeyboardExtensions];
}

- (IBAction)downButtonPressed {
    [self finishCardModification];
    [self showCardAtIndex:cardDeckViewContext.currentCardIndex + 1];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] refreshKeyboardExtensions];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
}

- (void)dismissActionSheet {
    if (activeActionSheet != nil) {
        [activeActionSheet dismissActionSheetAnimated:NO];
        ivar_release_and_clear(activeActionSheet);
    }
}

- (void)keyboardExtensionResponderExtensionBecameActiveAtIndex:(NSUInteger)index {
    [self showCardView:(index == 1 || index == 2 || index == 3)];
    [self dismissActionSheet];
}

- (BOOL)keyboardExtensionResponderHasActionsForExtensionAtIndex:(NSUInteger)index {
    return index == 1 || index == 2 || index == 3;
}

- (void)keyboardExtensionResponderRunActionsForExtensionAtIndex:(NSUInteger)index barButtonItem:(UIBarButtonItem *)barButtonItem {
    qltrace();
    if (activeActionSheet != nil) {
        if (activeActionSheet.tag == index && activeActionSheet.isVisible) {
            [self dismissActionSheet];
            [self buttonClickedActionSheet:activeActionSheet buttonAtIndex:-1];
            // don't open a new sheet, just closed the same one
            return;
        } else {
            [self dismissActionSheet];
        }
    }
    if (editingDefaults) {
        index = -index;
    }
    NSString *title = nil;
    NSArray *buttons = nil;
    switch (index) {
        case 1:
            title = @"Copy Color Properties";
            buttons = @[@"Text \u21e2 Defaults", @"Text \u21e0 Defaults", @"Background \u21e2 Defaults", @"Background \u21e0 Defaults"];
            break;
        case 2:
            title = @"Copy Text Properties";
            buttons = @[@"Layout \u21e2 Defaults", @"Layout \u21e0 Defaults", @"Size \u21e2 Defaults", @"Size \u21e0 Defaults"];
            break;
        case 3:
            title = @"Copy Timer Properties";
            buttons = @[@"Timer \u21e2 Defaults", @"Timer \u21e0 Defaults"];
            break;
        case -1:
            title = @"Copy Color Properties";
            buttons = @[@"Text \u21e2 All Cards", @"Background \u21e2 All Cards"];
            break;
        case -2:
            title = @"Copy Text Properties";
            buttons = @[@"Layout \u21e2 All Cards", @"Size \u21e2 All Cards"];
            break;
        case -3:
            title = @"Copy Timer Properties";
            buttons = @[@"Timer \u21e2 All Cards"];
            break;
        default:
            break;
    }
    if (buttons) {
        CDXActionSheet *sheet = [CDXActionSheet actionSheetWithTitle:title tag:index delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:buttons];
        [[CDXAppWindowManager sharedAppWindowManager] showActionSheet:sheet viewController:self fromBarButtonItem:barButtonItem];
        ivar_assign_and_retain(activeActionSheet, sheet);
    }
}

- (void)buttonClickedActionSheet:(CDXActionSheet *)actionSheet buttonAtIndex:(NSInteger)buttonIndex {
    qltrace(@"tag: %ld index: %ld", (long)actionSheet.tag, (long)buttonIndex);
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
        case 3:
            switch (buttonIndex) {
                case 0:
                    cardDeck.cardDefaults.timerInterval = card.timerInterval;
                    break;
                case 1:
                    card.timerInterval = cardDeck.cardDefaults.timerInterval;
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
        case -3:
            switch (buttonIndex) {
                case 0:
                    [cardDeck setTimerInterval:card.timerInterval];
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
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setInactive:NO animated:YES];
}

- (void)presentActionSheetCompleted:(CDXActionSheet *)actionSheet {
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setInactive:YES animated:YES];
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

- (NSTimeInterval)timerKeyboardExtensionTimerInterval {
    return [self currentCard].timerInterval;
}

- (void)timerKeyboardExtensionSetTimerInterval:(NSTimeInterval)interval {
    [self currentCard].timerInterval = interval;
}

- (void)insertText:(NSString *)textToInsert {
    [text insertText:textToInsert];
}

- (void)dismissViewControllerAnimated:(BOOL)animated completion: (void (^)(void))completion {
    qltrace();
    [super dismissViewControllerAnimated:animated completion:completion];
    [self dismissActionSheet];
}

- (void)applicationDidEnterBackground {
    [[CDXKeyboardExtensions sharedKeyboardExtensions] resetKeyboardExtensions];
}

@end

