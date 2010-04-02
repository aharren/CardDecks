//
//
// CDXCardEditViewController.h
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

#import "CDXCard.h"
#import "CDXCardDeck.h"
#import "CDXCardDeckList.h"
#import "CDXColorKeyboardExtension.h"
#import "CDXLayoutKeyboardExtension.h"


// A controller for editing a single card.
@interface CDXCardEditViewController : UIViewController <CDXColorKeyboardExtensionProtocol, CDXLayoutKeyboardExtensionProtocol> {
    
@protected
    // data objects
    CDXCardDeck *_cardDeck;
    CDXCardDeckList *_cardDeckList;
    CDXCardDeck *_cardDeckInList;
    CDXCard *_card;
    
    // UI elements and controllers
    UITextView *_text;
}

@property (nonatomic, retain) CDXCardDeck *cardDeck;
@property (nonatomic, retain) CDXCardDeckList *cardDeckList;
@property (nonatomic, retain) CDXCardDeck *cardDeckInList;
@property (nonatomic, retain) CDXCard *card;

@property (nonatomic, retain) IBOutlet UITextView *text;

- (CDXColor *)textCDXColor;
- (void)setTextCDXColor:(CDXColor *)color;
- (CDXColor *)backgroundCDXColor;
- (void)setBackgroundCDXColor:(CDXColor *)color;

- (CDXCardOrientation)cardOrientation;
- (void)setCardOrientation:(CDXCardOrientation)cardOrientation;

- (void)paste:(id)sender;

- (void)textViewDidEndEditing:(UITextView *)textView;
- (void)doneButtonPressed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)configureWithCard:(CDXCard *)card cardDeck:(CDXCardDeck *)cardDeck cardDeckList:(CDXCardDeckList *)cardDeckList cardDeckInList:(CDXCardDeck *)cardDeckInList;

+ (CDXCardEditViewController *)cardEditViewControllerWithCard:(CDXCard *)card cardDeck:(CDXCardDeck *)cardDeck cardDeckList:(CDXCardDeckList *)cardDeckList cardDeckInList:(CDXCardDeck *)cardDeckInList;

@end


