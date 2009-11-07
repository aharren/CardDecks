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
    _navigationController.navigationBar.translucent = YES;
    [_navigationController setViewControllers:[NSArray arrayWithObject:self.cardDeckListViewController]];
    
    // configure the window
    [_window addSubview:[_navigationController view]];
    [[self.cardDeckListViewController view] setAlpha:0.0];
    [_window makeKeyAndVisible];
    
    // animate the card deck list
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [self.cardDeckListViewController.view setAlpha:1.0];
    [UIView commitAnimations];
    
    // enable keyboard extensions
    [[CDXKeyboardExtensions sharedInstance] setEnabled:YES];
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
        NSArray *urlQueryComponents = [[url query] componentsSeparatedByString:@"&"];
        CDXCardDeck *cardDeck = [CDXCardDeck cardDeckWithContentsOfURLComponents:urlQueryComponents];
        if (cardDeck != nil) {
            // store the card deck
            [CDXStorage update:cardDeck deferred:NO];
            
            // add the card deck to the list
            CDXCardDeck *cardDeckInList = [[[CDXCardDeck alloc] init] autorelease];
            cardDeckInList.name = cardDeck.name;
            cardDeckInList.file = cardDeck.file;
            cardDeckInList.committed = YES;
            cardDeckInList.defaultTextColor = nil;
            cardDeckInList.defaultBackgroundColor = nil;
            cardDeckInList.cards = nil;
            [self.cardDeckList insertCardDeck:cardDeckInList atIndex:0];
            [CDXStorage update:self.cardDeckList deferred:NO];
            
            [self.cardDeckListViewController performSelector:@selector(selectRowAtIndexPath:) withObject:[NSIndexPath indexPathForRow:0 inSection:0] afterDelay:0.1];
        }
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

