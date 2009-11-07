//
//
// CDXCardEditViewController.m
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

#import "CDXCardEditViewController.h"
#import "CDXTextRenderingContext.h"
#import "CDXColorKeyboardExtension.h"
#import "CDXSymbolsKeyboardExtension.h"
#import "CDXLayoutKeyboardExtension.h"


@implementation CDXCardEditViewController

#define LogFileComponent lcl_cCDXCardEditViewController

@synthesize cardDeck = _cardDeck;
@synthesize cardDeckList = _cardDeckList;
@synthesize cardDeckInList = _cardDeckInList;
@synthesize card = _card;

@synthesize text = _text;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    LogInvocation();
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // nothing to do
    }
    
    return self;
}

- (void)dealloc {
    LogInvocation();
    
    self.card = nil;
    self.cardDeck = nil;
    self.cardDeckList = nil;
    self.cardDeckInList = nil;
    
    self.text = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    LogInvocation();
    
    [super viewDidLoad];
    
    UINavigationItem *navigationItem = [self navigationItem];
    navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                          initWithTitle:@"Done" 
                                          style:UIBarButtonItemStyleDone 
                                          target:self
                                          action:@selector(doneButtonPressed)]
                                         autorelease];    
}

- (void)viewDidUnload {
    LogInvocation();
    
    self.text = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    LogInvocation();
    
    [super viewWillAppear:animated];
    
    [_text becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    LogInvocation();
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    LogInvocation();
    
    [super viewWillDisappear:animated];
    
    if (_card.dirty) {
        _card.committed = YES;
        [CDXStorage update:_cardDeck deferred:YES];
        
        LogInvocation(@"%d", _cardDeckInList.committed);
        if (_cardDeckInList != nil && !_cardDeckInList.committed) {
            _cardDeckInList.committed = YES;
            _cardDeckInList.dirty = YES;
            [CDXStorage update:_cardDeckList deferred:YES];
        }
    }
}


- (void)viewDidDisappear:(BOOL)animated {
    LogInvocation();
    
    [super viewDidDisappear:animated];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    LogInvocation();
    
    [[CDXKeyboardExtensions sharedInstance] setResponder:self 
                                              extensions:[NSArray arrayWithObjects:[CDXSymbolsKeyboardExtension sharedInstance],
                                                          [CDXColorKeyboardExtension sharedInstance],
                                                          [CDXLayoutKeyboardExtension sharedInstance],
                                                          nil]];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    LogInvocation();
    
    if (![@"" isEqualToString:_text.text] || _card.committed) {
        if (![_card.text isEqualToString:_text.text]) {
            _card.text = _text.text;
            _card.dirty = YES;
            _cardDeck.dirty = YES;
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    LogInvocation();
    
}

- (CDXColor *)textCDXColor {
    LogInvocation();
    
    return [[self.card.textColor retain] autorelease];
}

- (void)setTextCDXColor:(CDXColor *)color {
    LogInvocation();
    
    _card.textColor = color;
    _cardDeck.defaultTextColor = color;
    _text.textColor = [color uiColor];
    
    _card.dirty = YES;
    _cardDeck.dirty = YES;
}

- (CDXColor *)backgroundCDXColor {
    LogInvocation();
    
    return [[self.card.backgroundColor retain] autorelease];
}

- (void)setBackgroundCDXColor:(CDXColor *)color {
    LogInvocation();
    
    _card.backgroundColor = color;
    _cardDeck.defaultBackgroundColor = color;
    self.view.backgroundColor = [color uiColor];
    
    _card.dirty = YES;
    _cardDeck.dirty = YES;
}

- (CDXCardOrientation)cardOrientation {
    return _card.orientation;
}

- (void)setCardOrientation:(CDXCardOrientation)cardOrientation {
    LogInvocation();
    
    _card.orientation = cardOrientation;
    
    _card.dirty = YES;
    _cardDeck.dirty = YES;
}

- (void)paste:(id)sender {
    LogInvocation();
    
    // we want to paste to _text, but it doesn't respond to paste directly, so
    // search for the right subview
    for (UIView *view in [_text subviews]) {
        if ([view respondsToSelector:@selector(paste:)]) {
            LogDebug(@"%@", view);
            
            [view paste:nil];
            return;
        }
    }
}

- (void)doneButtonPressed {
    LogInvocation();
    
    [self textViewDidEndEditing:_text];
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    UIViewController *baseViewController = [viewControllers objectAtIndex:[viewControllers count] - 2 - 1];
    if ([baseViewController respondsToSelector:@selector(setEditModeInactive)]) {
        [baseViewController performSelector:@selector(setEditModeInactive)];
    }
    
    [self.navigationController popToViewController:baseViewController animated:YES];
}

- (void)configureWithCard:(CDXCard *)card cardDeck:(CDXCardDeck *)cardDeck cardDeckList:(CDXCardDeckList *)cardDeckList cardDeckInList:(CDXCardDeck *)cardDeckInList {
    LogInvocation();
    
    self.card = card;
    _card.dirty = NO;
    
    LogDebug(@"dirty %d", _card.dirty);
    
    self.cardDeck = cardDeck;
    self.cardDeckList = cardDeckList;
    self.cardDeckInList = cardDeckInList;
    
    NSString *text = card == nil || !card.committed ? @"" : card.text;
    _text.text = text;
    
    UIColor *textColor = card == nil ? [UIColor whiteColor] : [card.textColor uiColor];
    _text.textColor = textColor;
    
    UIColor *backgroundColor = card == nil  ? [UIColor blackColor] : [card.backgroundColor uiColor];
    self.view.backgroundColor = backgroundColor;
}

+ (CDXCardEditViewController *)cardEditViewControllerWithCard:(CDXCard *)card cardDeck:(CDXCardDeck *)cardDeck cardDeckList:(CDXCardDeckList *)cardDeckList cardDeckInList:(CDXCardDeck *)cardDeckInList {
    LogInvocation();
    
    CDXCardEditViewController *controller = [[[CDXCardEditViewController alloc] initWithNibName:@"CDXCardEditView" bundle:nil] autorelease];
    [controller configureWithCard:card cardDeck:cardDeck cardDeckList:cardDeckList cardDeckInList:cardDeckInList];
    return controller;
}

@end

