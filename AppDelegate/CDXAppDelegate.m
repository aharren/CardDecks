//
//
// CDXAppDelegate.m
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

#import "CDXAppDelegate.h"


@implementation CDXAppDelegate

#define LogFileComponent lcl_cCDXAppDelegate

@synthesize cardDeckList = _cardDeckList;

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize cardDeckListViewController = _cardDeckListViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    LogInvocation();
    
    // retrieve the list of card decks
    NSString *cardDeckListFile = @"Main.CardDecksList"; 
    NSDictionary *dictionary = [CDXStorage readAsDictionary:cardDeckListFile];
    self.cardDeckList = [CDXCardDeckList cardDeckListWithContentsOfDictionary:dictionary];
    self.cardDeckList.file = cardDeckListFile;

    // create the corresponding UI controller
    self.cardDeckListViewController = [CDXCardDeckListViewController cardDeckListViewControllerWithCardDeckList:self.cardDeckList];
    
    // configure the navigation controller
    _navigationController.navigationBar.opaque = YES;
    [_navigationController setViewControllers:[NSArray arrayWithObject:self.cardDeckListViewController]];
    
    // configure the window
    [_window addSubview:[_navigationController view]];
    [[self.cardDeckListViewController view] setAlpha:0.0];
    [_window makeKeyAndVisible];
    
    // animate the card deck list
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [self.cardDeckListViewController.view setAlpha:1.0];
    [UIView commitAnimations];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    LogInvocation();

    [CDXStorage drainDeferred:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    LogInvocation();
    
    if (url == nil) {
        return NO;
    }
    
    NSString *host = [url host];
    if (!(host == nil || [@"" isEqualToString:host])) {
        return NO;
    }
    
    NSString *path = [url path];

    if ([@"/add" isEqualToString:path]) {
        NSArray *query = [[url query] componentsSeparatedByString:@"&"];
        
        NSString *queryCardDeck = nil;
        NSMutableArray *queryCards = [[NSMutableArray alloc] initWithCapacity:[query count]];
        
        for (NSString *q in query) {
            if (queryCardDeck == nil) {
                queryCardDeck = q;
            } else {
                [queryCards addObject:q];
            }   
        }
        
        if (queryCardDeck == nil || [queryCards count] == 0) {
            // handled, but empty
            return YES;
        }
        
        NSArray *queryCardDeckParts = [queryCardDeck componentsSeparatedByString:@","];
        if ([queryCardDeckParts count] < 1) {
            return YES;
        }
        CDXCardDeck *cardDeck = [[[CDXCardDeck alloc] init] autorelease];
        cardDeck.file = [CDXStorage newStorageNameWithSuffix:@".CardDeck"];
        cardDeck.name = [(NSString *)[queryCardDeckParts objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([queryCardDeckParts count] >= 2) {
            cardDeck.defaultTextColor = [CDXColor cdxColorWithRGBString:(NSString *)[queryCardDeckParts objectAtIndex:1] defaulsTo:[CDXColor whiteColor]];
        }
        if ([queryCardDeckParts count] >= 3) {
            cardDeck.defaultBackgroundColor = [CDXColor cdxColorWithRGBString:(NSString *)[queryCardDeckParts objectAtIndex:2] defaulsTo:[CDXColor blackColor]];
        }
        
        for (NSString *qc in queryCards) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            NSArray *queryCardParts = [qc componentsSeparatedByString:@","];
            CDXCard *card = [[[CDXCard alloc] init] autorelease];
            
            if ([queryCardParts count] >= 1) {
                card.text = [(NSString *)[queryCardParts objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                card.textColor = cardDeck.defaultTextColor;
                card.backgroundColor = cardDeck.defaultBackgroundColor;
                
                if ([queryCardParts count] >= 2) {
                    card.textColor = [CDXColor cdxColorWithRGBString:(NSString *)[queryCardParts objectAtIndex:1] defaulsTo:[CDXColor whiteColor]];
                }
                if ([queryCardParts count] >= 3) {
                    card.backgroundColor = [CDXColor cdxColorWithRGBString:(NSString *)[queryCardParts objectAtIndex:2] defaulsTo:[CDXColor blackColor]];
                }
                
                card.committed = YES;
                [cardDeck addCard:card];
            }
            [pool release];
        }
        
        [self.cardDeckList insertCardDeck:cardDeck atIndex:0];
        cardDeck.committed = YES;
        [CDXStorage update:cardDeck deferred:NO];
        [CDXStorage update:self.cardDeckList deferred:NO];
     
        [self.cardDeckListViewController performSelector:@selector(selectRowAtIndexPath:) withObject:[NSIndexPath indexPathForRow:0 inSection:0] afterDelay:0.1];
        return YES;
    }
    
    return NO;    
}

- (void)dealloc {
    LogInvocation();

    [_window release];
    [super dealloc];
}

@end

