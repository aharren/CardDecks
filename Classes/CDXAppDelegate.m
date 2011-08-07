//
//
// CDXAppDelegate.m
//
//
// Copyright (c) 2009-2011 Arne Harren <ah@0xc0.de>
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
#import "CDXCardDecksListPadViewController.h"
#import "CDXCardDeckListPadViewController.h"
#import "CDXKeyboardExtensions.h"
#import "CDXDictionarySerializerUtils.h"
#import "CDXCardDecks.h"
#import "CDXDevice.h"

#undef ql_component
#define ql_component lcl_cApplication


@implementation CDXAppDelegate

- (void)addDefaultCardDecks:(CDXCardDecks *)decks {
    CDXCardDeckHolder *holder;
    CDXCardDeck *deck;
    
    deck = decks.cardDeckDefaults.cardDeck;
    [deck updateStorageObjectDeferred:NO];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Weather,000000,ffff00&%e2%98%80,ff0000&%e2%98%81,ffffff,0000ff&%e2%98%82,000000,aaaaaa&%e2%98%83,000000,ffffff"];
    deck.displayStyle = CDXCardDeckDisplayStyleSideBySide;
    deck.wantsAutoRotate = NO;
    deck.shakeAction = CDXCardDeckShakeActionRandom;
    deck.wantsPageJumps = NO;
    deck.wantsPageControl = NO;
    deck.pageControlStyle = CDXCardDeckPageControlStyleDark;
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Dice,ffffff,000000&%e2%91%a0&%e2%91%a1&%e2%91%a2&%e2%91%a3&%e2%91%a4&%e2%91%a5"];
    deck.displayStyle = CDXCardDeckDisplayStyleSideBySide;
    [deck setFontSize:280.0/5.0];
    deck.cardDefaults.fontSize = 280.0/5.0;
    deck.wantsAutoRotate = NO;
    deck.shakeAction = CDXCardDeckShakeActionRandom;
    deck.wantsPageJumps = NO;
    deck.wantsPageControl = NO;
    deck.pageControlStyle = CDXCardDeckPageControlStyleLight;
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Colors,ffffff,000000&Red,ff0000,ff0000&Yellow,ffff00,ffff00&Green,00ff00,00ff00&Blue,0000ff,0000ff"];
    deck.displayStyle = CDXCardDeckDisplayStyleSideBySide;
    [deck setFontSize:100.0/5.0];
    deck.cardDefaults.fontSize = 100.0/5.0;
    deck.wantsAutoRotate = NO;
    deck.shakeAction = CDXCardDeckShakeActionRandom;
    deck.wantsPageJumps = YES;
    deck.wantsPageControl = NO;
    deck.pageControlStyle = CDXCardDeckPageControlStyleDark;
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Faces,00ff00,000000&%e2%98%ba&%e2%98%b9,ff0000"];
    deck.displayStyle = CDXCardDeckDisplayStyleSideBySide;
    deck.wantsAutoRotate = YES;
    deck.shakeAction = CDXCardDeckShakeActionRandom;
    deck.wantsPageJumps = NO;
    deck.wantsPageControl = NO;
    deck.pageControlStyle = CDXCardDeckPageControlStyleLight;
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Answers,ffffff,000000&YES,00ff00&NO,ff0000&PERHAPS,ffff00"];
    deck.displayStyle = CDXCardDeckDisplayStyleSideBySide;
    [deck cardAtIndex:0].fontSize = 150.0/5.0;
    [deck cardAtIndex:1].fontSize = 150.0/5.0;
    deck.wantsAutoRotate = YES;
    deck.shakeAction = CDXCardDeckShakeActionRandom;
    deck.wantsPageJumps = YES;
    deck.pageControlStyle = CDXCardDeckPageControlStyleLight;
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"60%20Minutes,ffffff,000000&60,000000,00ff00&50,000000,00ff00&40,000000,00ff00&30,000000,ffff00&20,000000,ffff00&15,000000,ff0000&10,000000,ff0000&5,000000,ff0000&0,ff0000"];
    deck.displayStyle = CDXCardDeckDisplayStyleSwipeStack;
    [deck setFontSize:240.0/5.0];
    deck.cardDefaults.fontSize = 240.0/5.0;
    deck.wantsAutoRotate = NO;
    deck.shakeAction = CDXCardDeckShakeActionNone;
    deck.wantsPageJumps = NO;
    deck.pageControlStyle = CDXCardDeckPageControlStyleLight;
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"15%20Minutes,ffffff,000000&15,000000,00ff00&10,000000,ffff00&5,000000,ff0000&0,ff0000"];
    deck.displayStyle = CDXCardDeckDisplayStyleSwipeStack;
    [deck setFontSize:240.0/5.0];
    deck.cardDefaults.fontSize = 240.0/5.0;
    deck.wantsAutoRotate = NO;
    deck.shakeAction = CDXCardDeckShakeActionNone;
    deck.wantsPageJumps = NO;
    deck.pageControlStyle = CDXCardDeckPageControlStyleDark;
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Estimation%20Sizes,000000,ffffff&XXS&XS&S&M&L&XL&XXL&%e2%88%9e&NEED%0aCOFFEE"];
    deck.displayStyle = CDXCardDeckDisplayStyleStack;
    [deck setFontSize:165.0/5.0];
    deck.cardDefaults.fontSize = 165.0/5.0;
    [deck cardAtIndex:[deck cardsCount]-1].fontSize = 114.0/5.0;
    [deck cardAtIndex:[deck cardsCount]-1].orientation = CDXCardOrientationLeft;
    deck.wantsAutoRotate = NO;
    deck.shakeAction = CDXCardDeckShakeActionNone;
    deck.pageControlStyle = CDXCardDeckPageControlStyleDark;
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Estimation%20Numbers,000000,ffffff&0&%c2%bd&1&2&4&8&16&32&64&%e2%88%9e&NEED%0aCOFFEE"];
    deck.displayStyle = CDXCardDeckDisplayStyleStack;
    [deck setFontSize:200.0/5.0];
    deck.cardDefaults.fontSize = 200.0/5.0;
    [deck cardAtIndex:1].fontSize = 190.0/5.0;
    [deck cardAtIndex:[deck cardsCount]-1].fontSize = 114.0/5.0;
    [deck cardAtIndex:[deck cardsCount]-1].orientation = CDXCardOrientationLeft;
    deck.wantsAutoRotate = NO;
    deck.shakeAction = CDXCardDeckShakeActionNone;
    deck.pageControlStyle = CDXCardDeckPageControlStyleDark;
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"0%2c%20...%2c%2010,ffffff,000000&0&1&2&3&4&5&6&7&8&9&10"];
    deck.displayStyle = CDXCardDeckDisplayStyleSideBySide;
    [deck setFontSize:300.0/5.0];
    deck.cardDefaults.fontSize = 300.0/5.0;
    deck.wantsPageControl = YES;
    deck.wantsAutoRotate = YES;
    deck.shakeAction = CDXCardDeckShakeActionNone;
    deck.cornerStyle = CDXCardCornerStyleCornered;
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
}

- (CDXCardDecks *)cardDecks {
    NSUInteger version = 0;
    CDXCardDecks *decks = [CDXCardDecks cardDecksFromStorageObjectNamed:@"Main.CardDecksList" version:&version];
    if (decks == nil || [decks cardDecksCount] == 0) {
        // main list not found or empty, create a new one
        version = 0;
        decks = [[[CDXCardDecks alloc] init] autorelease];
        decks.file = @"Main.CardDecksList";
    }
    
    if (version < 2) {
        // old version, migrate existing card decks with details
        const NSUInteger decksCount = [decks cardDecksCount];
        for (NSUInteger i = 0; i < decksCount; i++) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            CDXCardDeckHolder *holder = [decks cardDeckAtIndex:i];
            [holder linkCardDeck];
            [pool release];
        }
        // add new default card decks
        [self addDefaultCardDecks:decks];
        // save the list
        [decks updateStorageObjectDeferred:NO];
    }
    
    return decks;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    qltrace();
    
    ivar_assign_and_retain(cardDecks, [self cardDecks]);
    
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setEnabled:YES];
    
    if ([[CDXDevice sharedDevice] deviceUIIdiom] == CDXDeviceUIIdiomPhone) {
        UIViewController<CDXAppWindowViewController> *vc = [[[CDXCardDecksListViewController alloc] initWithCardDecks:cardDecks] autorelease];
        [appWindowManager pushViewController:vc animated:NO];
    } else {
        UIViewController<CDXAppWindowViewController> *vcl = [[[CDXCardDecksListPadViewController alloc] initWithCardDecks:cardDecks] autorelease];
        [appWindowManager pushViewController:vcl animated:NO];
        UIViewController<CDXAppWindowViewController> *vcr = [[[CDXCardDeckListPadViewController alloc] initWithCardDeckViewContext:nil] autorelease];
        [appWindowManager pushViewController:vcr animated:NO];
    }
    
    [appWindowManager makeWindowKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    qltrace();
    if (url == nil) {
        return NO;
    }
    
    NSString *host = [url host];
    if (!(host == nil || [@"" isEqualToString:host])) {
        return NO;
    }
    
    BOOL handled = NO;
    NSString *path = [url path];
    CDXCardDeck *deckToAdd = nil;
    
    if ([@"/add" isEqualToString:path]) {
        deckToAdd = [CDXCardDeckURLSerializer cardDeckFromVersion1String:[url query]];
    } else if ([@"/2/add" isEqualToString:path]) {
        deckToAdd = [CDXCardDeckURLSerializer cardDeckFromVersion2String:[url query]];
    }
    
    if (deckToAdd != nil) {
        handled = YES;
        [deckToAdd updateStorageObjectDeferred:YES];
        CDXCardDeckHolder *holder =  [CDXCardDeckHolder cardDeckHolderWithCardDeck:deckToAdd];
        [cardDecks addPendingCardDeckAdd:holder];
        [appWindowManager popToInitialViewController];
        UIViewController *vc = [appWindowManager visibleViewController];
        if ([vc respondsToSelector:@selector(processPendingCardDeckAddsAtTopDelayed)]) {
            [vc performSelector:@selector(processPendingCardDeckAddsAtTopDelayed)];
        }
    }
    
    return handled;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    qltrace();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    qltrace();
    [CDXStorage drainAllDeferredActions];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    qltrace();
    [appWindowManager dismissModalViewControllerAnimated:NO];
    [CDXStorage drainAllDeferredActions];
}

@end

