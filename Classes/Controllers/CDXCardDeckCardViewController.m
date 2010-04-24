//
//
// CDXCardDeckCardViewController.m
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

#import "CDXCardDeckCardViewController.h"
#import "CDXCardsSideBySideView.h"
#import "CDXCardsStackView.h"


@implementation CDXCardDeckCardViewController

#undef ql_component
#define ql_component lcl_cCDXCardDeckCardViewController

- (id)initWithCardDeck:(CDXCardDeck *)deck atIndex:(NSUInteger)index {
    qltrace();
    if ((self = [super initWithNibName:@"CDXCardDeckCardView" bundle:nil])) {
        ivar_assign_and_retain(cardDeck, deck);
        initialCardIndex = index;
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(cardDeck);
    [super dealloc];
}

- (void)viewDidLoad {
    qltrace();
    [super viewDidLoad];
    UIView<CDXCardsViewView> *v;
    switch (cardDeck.displayStyle) {
        default:
        case CDXCardDeckDisplayStyleSideBySide:
            v = [[[CDXCardsSideBySideView alloc] initWithFrame:self.view.frame] autorelease];
            break;
        case CDXCardDeckDisplayStyleStack:
            v = [[[CDXCardsStackView alloc] initWithFrame:self.view.frame] autorelease];
            break;
    }
    [v setViewDelegate:self];
    [v setViewDataSource:self];
    [self.view insertSubview:v atIndex:0];
}

- (NSUInteger)cardsViewDataSourceCardsCount {
    return [cardDeck cardsCount];
}

- (CDXCard *)cardsViewDataSourceCardAtIndex:(NSUInteger)index {
    return [cardDeck cardAtIndex:index];
}

- (NSUInteger)cardsViewDataSourceInitialCardIndex {
    return initialCardIndex;
}

- (void)cardsViewDelegateTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    qltrace();
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 1) {
        [[CDXAppWindowManager sharedAppWindowManager] popViewControllerAnimated:YES];
    }
}

- (void)cardsViewCurrentCardIndexHasChangedTo:(NSUInteger)index {
}

@end

