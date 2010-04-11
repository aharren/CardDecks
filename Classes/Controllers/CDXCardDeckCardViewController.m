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
#import "CDXImageFactory.h"


@implementation CDXCardDeckCardViewController

#undef ql_component
#define ql_component lcl_cCDXCardDeckCardViewController

- (id)initWithCardDeck:(CDXCardDeck *)deck atIndex:(NSUInteger)index {
    qltrace();
    if ((self = [super initWithNibName:@"CDXCardDeckCardView" bundle:nil])) {
        ivar_assign_and_retain(cardDeck, deck);
        currentCardIndex = index;
        self.wantsFullScreenLayout = YES;
        UIImage *image = [[CDXImageFactory sharedImageFactory]
                          imageForCard:[cardDeck cardAtIndex:currentCardIndex]
                          size:[UIScreen mainScreen].bounds.size
                          deviceOrientation:[[UIDevice currentDevice] orientation]];
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        [self.view addSubview:imageView];
    }
    qltrace();
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(cardDeck);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)close {
    [[CDXAppWindowManager sharedAppWindowManager] popViewControllerAnimated:YES];
}

@end

