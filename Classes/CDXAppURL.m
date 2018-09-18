//
//
// CDXAppURL.m
//
//
// Copyright (c) 2009-2018 Arne Harren <ah@0xc0.de>
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
#import "CDXCardDeckJSONSerializer.h"
#import "CDXCardDecksListViewController.h"

#undef ql_component
#define ql_component lcl_cApplication


#define CDXAppURLPath_v1_add @"/add"
#define CDXAppURLPath_v2_add @"/2/add"

#define CDXAppURLScheme_file @"file"
#define CDXAppURLScheme_http @"http"
#define CDXAppURLScheme_carddecks @"carddecks"

#define CDXAppURLPrefix_carddecks_v1_add CDXAppURLScheme_carddecks @"://" CDXAppURLPath_v1_add @"?"
#define CDXAppURLPrefix_carddecks_v2_add CDXAppURLScheme_carddecks @"://" CDXAppURLPath_v2_add @"?"
#define CDXAppURLPrefix_http_v2_add @"http://carddecks.protocol.0xc0.de" CDXAppURLPath_v2_add @"?"


@implementation CDXAppURL

+ (BOOL)handleOpenURL:(NSURL *)url cardDecks:(CDXCardDecks *)cardDecks {
    qltrace(@"%@", url);
    CDXCardDeck *deckToAdd = [CDXAppURL cardDeckFromURL:url];
    if (deckToAdd == nil) {
        [[CDXAppWindowManager sharedAppWindowManager] showErrorMessage:@"Import failed: invalid document" afterDelay:0.7];
        return NO;
    }
    
    [deckToAdd updateStorageObjectDeferred:YES];
    CDXCardDeckHolder *holder =  [CDXCardDeckHolder cardDeckHolderWithCardDeck:deckToAdd];
    [cardDecks addPendingCardDeckAdd:holder];
    [[CDXAppWindowManager sharedAppWindowManager] dismissModalViewControllerAnimated:NO];
    [[CDXAppWindowManager sharedAppWindowManager] popToInitialViewController];
    UIViewController *vc = [[CDXAppWindowManager sharedAppWindowManager] visibleViewController];
    if ([vc respondsToSelector:@selector(processPendingCardDeckAddsAtTopDelayed)]) {
        [vc performSelector:@selector(processPendingCardDeckAddsAtTopDelayed) withObject:nil afterDelay:0.01];
    }
    
    return YES;
}

+ (CDXCardDeck *)cardDeckFromURL:(NSURL *)url {
    qltrace(@"%@", url);
    if (url == nil) {
        return nil;
    }
    
    NSString *scheme = [url scheme];
    
    // file URL
    if ([CDXAppURLScheme_file isEqualToString:scheme]) {
        NSError *error = nil;
        NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
        return [CDXCardDeckJSONSerializer cardDeckFromString:string];
    }
    
    // http URL
    if ([CDXAppURLScheme_http isEqualToString:scheme]) {
        NSString *path = [url path];
        if ([CDXAppURLPath_v2_add isEqualToString:path]) {
            return [CDXCardDeckURLSerializer cardDeckFromVersion2String:[url query]];
        } else {
            return nil;
        }
    }
    
    // carddecks URL
    if ([CDXAppURLScheme_carddecks isEqualToString:scheme]) {
        NSString *path = [url path];
        if ([CDXAppURLPath_v1_add isEqualToString:path]) {
            return [CDXCardDeckURLSerializer cardDeckFromVersion1String:[url query]];
        } else if ([CDXAppURLPath_v2_add isEqualToString:path]) {
            return [CDXCardDeckURLSerializer cardDeckFromVersion2String:[url query]];
        } else {
            return nil;
        }
    }
    
    return nil;
}

+ (BOOL)mayBeCardDecksURLString:(NSString *)urlString {
    qltrace(@"%@", urlString);
    if ([urlString hasPrefix:CDXAppURLPrefix_carddecks_v1_add]) {
        return YES;
    } else if ([urlString hasPrefix:CDXAppURLPrefix_carddecks_v2_add]) {
        return YES;
    } else if ([urlString hasPrefix:CDXAppURLPrefix_http_v2_add]) {
        return YES;
    }
    return NO;
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

