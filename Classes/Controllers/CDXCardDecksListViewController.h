//
//
// CDXCardDecksListViewController.h
//
//
// Copyright (c) 2009-2014 Arne Harren <ah@0xc0.de>
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

#import "CDXCardDecks.h"
#import "CDXListViewControllerBase.h"


@interface CDXCardDecksListViewController : CDXListViewControllerBase {
    
@protected
    CDXCardDecks *cardDecks;
    NSUInteger lastCardDeckIndex;
    BOOL cardDeckQuickOpen;

    IBOutlet UIBarButtonItem *addButton;
}

- (id)initWithCardDecks:(CDXCardDecks *)cardDecks nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (id)initWithCardDecks:(CDXCardDecks *)cardDecks;

- (void)processSinglePendingCardDeckAdd;
- (void)processPendingCardDeckAdds;
- (void)processPendingCardDeckAddsAtTopDelayed;

- (void)processStartupCallbacks;
- (void)showReleaseNotes;

- (IBAction)addButtonPressed;
- (IBAction)defaultsButtonPressed;
- (IBAction)settingsButtonPressed;

- (void)deleteCardDeckAtIndex:(NSUInteger)index;

@end

