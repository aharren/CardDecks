//
//
// CDXCardDeckCardEditPadViewController.m
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

#import "CDXCardDeckCardEditPadViewController.h"

#undef ql_component
#define ql_component lcl_cController


@implementation CDXCardDeckCardEditPadViewController

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)aCardDeckViewContext editDefaults:(BOOL)editDefaults {
    if ((self = [super initWithCardDeckViewContext:aCardDeckViewContext editDefaults:editDefaults nibName:@"CDXCardDeckCardEditPadView" bundle:nil])) {
        cardViewUsePreview = NO;
        textUpdateColors = NO;
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(navigationItem);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    cardViewSize = CGSizeMake(320, 480);
}

- (void)viewDidUnload {
    ivar_release_and_clear(navigationItem);
    [super viewDidUnload];
}

- (IBAction)closeButtonPressed {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *cardText = text.text;
    [self currentCard].text = cardText;
    [self updateCardPreview];
}

@end

