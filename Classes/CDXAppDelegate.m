//
//
// CDXAppDelegate.m
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

#import "CDXAppDelegate.h"
#import "CDXCardDeckURLSerializer.h"
#import "CDXCardDecksListViewController.h"
#import "CDXCardDecksListPadViewController.h"
#import "CDXCardDeckListPadViewController.h"
#import "CDXKeyboardExtensions.h"
#import "CDXDictionarySerializerUtils.h"
#import "CDXCardDecks.h"
#import "CDXDevice.h"
#import "CDXAppSettings.h"
#import "CDXAppURL.h"

#undef ql_component
#define ql_component lcl_cApplication


@implementation CDXAppDelegate

- (void)addDefaultCardDecks:(CDXCardDecks *)decks {
    CDXCardDeckHolder *holder;
    CDXCardDeck *deck;
    
    deck = decks.cardDeckDefaults.cardDeck;
    [deck updateStorageObjectDeferred:NO];
    
    /*
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
    */
    
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
    
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion1String:@"Faces,00ff00,000000&%e2%98%bb&%e2%98%b9,ff0000"];
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

- (void)addDefaultCardDecks1:(CDXCardDecks *)decks {
    CDXCardDeckHolder *holder;
    CDXCardDeck *deck;
    
    // 64 Minutes Timer Hex
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:@"0x40%20Minutes%20Timer,g0,d0,c0,id0,is1,it1,r0,s0,ap1&,000000ff,00ff00ff,l,40,240&0x40&0x3c&0x38&0x34&0x30&0x2c&0x28&0x24&0x20,,ffff00ff&0x1c,,ffff00ff&0x18,,ffff00ff&0x14,,ffff00ff&0x10,,ff0000ff&0x0c,,ff0000ff&0x08,,ff0000ff&0x04,ff0000ff,000000ff,,,60&0x03,ff0000ff,000000ff,,,60&0x02,ff0000ff,000000ff,,,60&0x01,ff0000ff,000000ff,,,60&0x00,ff0000ff,000000ff,,,0"];
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
    
    // 16 Minutes Timer Hex
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:@"0x10%20Minutes%20Timer,g0,d0,c0,id0,is1,it1,r0,s0,ap1&,000000ff,00ff00ff,l,40,60&0x10&0x0f&0x0e&0x0d&0x0c&0x0b&0x0a&0x09&0x08&0x07&0x06&0x05,,ffff00ff&0x04,,ffff00ff&0x03,,ffff00ff&0x02,,ff0000ff&0x01,,ff0000ff&0x00,ff0000ff,000000ff,,,0"];
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
    
    // 60 Minutes Timer
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:@"60%20Minutes%20Timer,g0,d0,c0,id0,is1,it1,r0,s0,ap1&,000000ff,00ff00ff,l,60,300&60&55&50&45&40&35&30,,ffff00ff&25,,ffff00ff&20,,ffff00ff&15,,ff0000ff&10,,ff0000ff&5,ff0000ff,000000ff,,,60&4,ff0000ff,000000ff,,,60&3,ff0000ff,000000ff,,,60&2,ff0000ff,000000ff,,,60&1,ff0000ff,000000ff,,,60&0,ff0000ff,000000ff,,,0"];
    [deck updateStorageObjectDeferred:NO];
    holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [decks addPendingCardDeckAdd:holder];
    
    // 15 Minutes Timer
    deck = [CDXCardDeckURLSerializer cardDeckFromVersion2String:@"15%20Minutes%20Timer,g0,d0,c0,id0,is1,it1,r0,s0,ap1&,000000ff,00ff00ff,l,60,60&15&14&13&12&11&10&9&8&7&6&5,,ffff00ff&4,,ffff00ff&3,,ffff00ff&2,,ff0000ff&1,,ff0000ff&0,ff0000ff,000000ff,,,0"];
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
    
    if ([[CDXAppSettings sharedAppSettings] migrationState] < 1) {
        // add some new default card decks
        [self addDefaultCardDecks1:decks];
        // save the list
        [decks updateStorageObjectDeferred:NO];
        
        [[CDXAppSettings sharedAppSettings] setMigrationState:1];
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
    return [CDXAppURL handleOpenURL:url cardDecks:cardDecks];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    qltrace();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    qltrace();
    [CDXStorage drainAllDeferredActions];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    qltrace();
    [appWindowManager applicationWillEnterForeground];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    qltrace();
    [appWindowManager dismissModalViewControllerAnimated:NO];
    [appWindowManager applicationDidEnterBackground];
    [CDXStorage drainAllDeferredActions];
}

@end

