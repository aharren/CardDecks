//
//
// CDXCardDeckCardEditViewController.h
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

#import "CDXCardDeck.h"
#import "CDXCardDeckViewContext.h"
#import "CDXAppWindowProtocols.h"
#import "CDXColorKeyboardExtension.h"
#import "CDXTextKeyboardExtension.h"
#import "CDXSymbolsKeyboardExtension.h"
#import "CDXTimerKeyboardExtension.h"
#import "CDXCardView.h"
#import "CDXActionSheet.h"


@interface CDXCardDeckCardEditViewController : UIViewController<CDXAppWindowViewController, UIActionSheetDelegate, CDXKeyboardExtensionResponder, CDXKeyboardExtensionResponderWithActions, CDXColorKeyboardExtensionResponder, CDXTextKeyboardExtensionResponder, CDXTimerKeyboardExtensionResponder, CDXActionSheetDelegate> {
    
@protected
    IBOutlet UITextView *text;
    IBOutlet UIScrollView *cardViewScrollView;
    IBOutlet CDXCardView *cardView;
    CGSize cardViewSize;
    BOOL cardViewUsePreview;
    BOOL textUpdateColors;
    
    IBOutlet UIButton *upButton;
    IBOutlet UIButton *downButton;
    IBOutlet UIView *viewButtons;
    
    CDXCardDeckViewContext *cardDeckViewContext;
    CDXCardDeck *cardDeck;
    
    BOOL editingDefaults;
    
    CDXActionSheet *activeActionSheet;
}

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)cardDeckViewContext editDefaults:(BOOL)editDefaults nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)cardDeckViewContext editDefaults:(BOOL)editDefaults;

- (CDXCard *)currentCard;
- (void)updateCardPreview;

- (IBAction)upButtonPressed;
- (IBAction)downButtonPressed;

- (CDXCardOrientation)textKeyboardExtensionCardOrientation;
- (void)textKeyboardExtensionSetCardOrientation:(CDXCardOrientation)cardOrientation;

- (void)insertText:(NSString *)text;

@end

