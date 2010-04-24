//
//
// CDXAppDelegate.m
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

#import "CDXAppDelegate.h"
#import "CDXCardDeckURLSerializer.h"
#import "CDXCardDecksListViewController.h"


@implementation CDXAppDelegate

#undef ql_component
#define ql_component lcl_cCDXAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    qltrace();
    CDXCardDecks *decks = [[[CDXCardDecks alloc] init] autorelease];
    [decks addCardDeck:[CDXCardDeckURLSerializer cardDeckFromString:@"0%2C%20...%2C%2010,ffffff,666666&0&1&2&3&4&5&6&7&8&9&10"]];
    [decks cardDeckAtIndex:0].displayStyle = CDXCardDeckDisplayStyleSideBySide;
    [decks cardDeckAtIndex:0].showPageControl = YES;
    [decks addCardDeck:[CDXCardDeckURLSerializer cardDeckFromString:@"0%2C%201%2C%202%2C%204%2C%208%2C%2016%2C%20%E2%88%9E,000000,ffffff&0&1&2&4&8&16&%E2%88%9E"]];
    [decks addCardDeck:[CDXCardDeckURLSerializer cardDeckFromString:@"15%2C%2010%2C%205%2C%200,ffffff,000000&15,000000,00ff00&10,000000,ffff00&5,000000,ff0000&0,ff0000"]];
    
    CDXCardDecksListViewController *vc = [[[CDXCardDecksListViewController alloc] initWithCardDecks:decks] autorelease];
    
    [appWindowManager pushViewController:vc animated:NO];
    [appWindowManager makeWindowKeyAndVisible];
}

@end

