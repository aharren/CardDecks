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
#import "CDXKeyboardExtensions.h"
#import "CDXDictionarySerializerUtils.h"
#import "CDXCardDecks.h"

#undef ql_component
#define ql_component lcl_cApplication


@implementation CDXAppDelegate

- (void)addDefaultCardDecks:(CDXCardDecks *)decks {
    CDXCardDeck *base;
    CDXCardDeck *deck;
    
    deck = decks.cardDeckDefaults.cardDeck;
    [deck updateStorageObjectDeferred:NO];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"0%2C%20...%2C%2010,ffffff,000000&0&1&2&3&4&5&6&7&8&9&10"];
    deck.displayStyle = CDXCardDeckDisplayStyleSideBySide;
    [deck setFontSize:300.0];
    deck.wantsPageControl = YES;
    deck.wantsAutoRotate = YES;
    deck.cornerStyle = CDXCardCornerStyleCornered;
    [deck updateStorageObjectDeferred:NO];
    base = [CDXCardDeckBase cardDeckBaseWithCardDeck:deck];
    [decks insertCardDeck:base atIndex:0];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Estimation%201,000000,ffffff&0&1&2&4&8&16&32&64&%E2%88%9E"];
    deck.displayStyle = CDXCardDeckDisplayStyleStack;
    [deck setFontSize:200.0];
    deck.wantsAutoRotate = NO;
    [deck updateStorageObjectDeferred:NO];
    base = [CDXCardDeckBase cardDeckBaseWithCardDeck:deck];
    [decks insertCardDeck:base atIndex:1];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Estimation%202,000044,ffffff&XXS&XS&S&M&L&XL&XXL&%E2%88%9E"];
    deck.displayStyle = CDXCardDeckDisplayStyleSwipeStack;
    [deck setFontSize:180.0];
    deck.wantsAutoRotate = NO;
    [deck updateStorageObjectDeferred:NO];
    base = [CDXCardDeckBase cardDeckBaseWithCardDeck:deck];
    [decks insertCardDeck:base atIndex:2];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Remaining%20Minutes,ffffff,000000&15,000000,00ff00&10,000000,ffff00&5,000000,ff0000&0,ff0000"];
    deck.displayStyle = CDXCardDeckDisplayStyleSwipeStack;
    [deck setFontSize:270.0];
    deck.wantsAutoRotate = NO;
    [deck updateStorageObjectDeferred:NO];
    base = [CDXCardDeckBase cardDeckBaseWithCardDeck:deck];
    [decks insertCardDeck:base atIndex:3];
}

- (CDXCardDecks *)cardDecks {
    NSUInteger version = 0;
    CDXCardDecks *decks = [CDXCardDecks cardDecksFromStorageObjectNamed:@"Main.CardDecksList" version:&version];
    if (decks == nil) {
        version = 0;
        decks = [[[CDXCardDecks alloc] init] autorelease];
        decks.file = @"Main.CardDecksList";
    }
    
    if (version < 2) {
        [self addDefaultCardDecks:decks];
        [decks updateStorageObjectDeferred:NO];
    }
    
    return decks;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    qltrace();
    
    ivar_assign_and_retain(cardDecks, [self cardDecks]);
    
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setEnabled:YES];
    
    CDXCardDecksListViewController *vc = [[[CDXCardDecksListViewController alloc] initWithCardDecks:cardDecks] autorelease];
    
    [appWindowManager pushViewController:vc animated:NO];
    [appWindowManager makeWindowKeyAndVisible];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    qltrace();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    qltrace();
    [CDXStorage drainAllDeferredActions];
}

@end

