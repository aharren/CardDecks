//
//
// CDXAppURL.m
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

#import "CDXAppURL.h"
#import "CDXCardDeckURLSerializer.h"

#undef ql_component
#define ql_component lcl_cApplication


#define CDXAppURLPath_v1_add @"/add"
#define CDXAppURLPath_v2_add @"/2/add"

#define CDXAppURLPrefix_carddecks_v2_add @"carddecks://" CDXAppURLPath_v2_add @"?"
#define CDXAppURLPrefix_http_v2_add @"http://carddecks.protocol.0xc0.de" CDXAppURLPath_v2_add @"?"


@implementation CDXAppURL

+ (BOOL)handleOpenURL:(NSURL *)url cardDecks:(CDXCardDecks *)cardDecks {
    qltrace(@"%@", url);
    CDXCardDeck *deckToAdd = [CDXAppURL cardDeckFromURL:url];
    if (deckToAdd == nil) {
        return NO;
    }
    
    [deckToAdd updateStorageObjectDeferred:YES];
    CDXCardDeckHolder *holder =  [CDXCardDeckHolder cardDeckHolderWithCardDeck:deckToAdd];
    [cardDecks addPendingCardDeckAdd:holder];
    [[CDXAppWindowManager sharedAppWindowManager] popToInitialViewController];
    UIViewController *vc = [[CDXAppWindowManager sharedAppWindowManager] visibleViewController];
    if ([vc respondsToSelector:@selector(processPendingCardDeckAddsAtTopDelayed)]) {
        [vc performSelector:@selector(processPendingCardDeckAddsAtTopDelayed)];
    }
    
    return YES;
}

+ (CDXCardDeck *)cardDeckFromURL:(NSURL *)url {
    qltrace(@"%@", url);
    if (url == nil) {
        return nil;
    }
    
    NSString *host = [url host];
    if (!(host == nil || [@"" isEqualToString:host])) {
        return nil;
    }
    
    NSString *path = [url path];
    if ([CDXAppURLPath_v1_add isEqualToString:path]) {
        return [CDXCardDeckURLSerializer cardDeckFromVersion1String:[url query]];
    } else if ([CDXAppURLPath_v2_add isEqualToString:path]) {
        return [CDXCardDeckURLSerializer cardDeckFromVersion2String:[url query]];
    }
    return nil;
}

+ (NSString *)carddecksURLStringForVersion2AddActionFromCardDeck:(CDXCardDeck *)cardDeck {
    NSString *urlString = [CDXAppURLPrefix_carddecks_v2_add stringByAppendingString:[CDXCardDeckURLSerializer version2StringFromCardDeck:cardDeck]];
    qltrace(@"%@", urlString);
    return urlString;
}

+ (NSString *)httpURLStringForVersion2AddActionFromCardDeck:(CDXCardDeck *)cardDeck {
    NSString *urlString = [CDXAppURLPrefix_http_v2_add stringByAppendingString:[CDXCardDeckURLSerializer version2StringFromCardDeck:cardDeck]];
    qltrace(@"%@", urlString);
    return urlString;
}

@end

