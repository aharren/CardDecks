//
//
// CDXCopyPaste.m
//
//
// Copyright (c) 2009-2015 Arne Harren <ah@0xc0.de>
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

#import "CDXCopyPaste.h"
#import "CDXAppURL.h"
#import "CDXCardDeckURLSerializer.h"
#import "CDXCardDeckJSONSerializer.h"

#undef ql_component
#define ql_component lcl_cApplication


@implementation CDXCopyPaste

+ (BOOL)mayBeCardDeck:(NSString *)string {
    if ([CDXAppURL mayBeCardDecksURLString:string]) {
        return YES;
    } else if ([string hasPrefix:@"{"]) {
        return YES;
    }
    return NO;
}

+ (CDXCardDeck *)cardDeckFromString:(NSString *)string allowEmpty:(BOOL)allowEmpty {
    CDXCardDeck *deck = nil;
    
    if ([CDXAppURL mayBeCardDecksURLString:string]) {
        deck = [CDXAppURL cardDeckFromURL:[NSURL URLWithString:string]];
    } else if ([string hasPrefix:@"{"]) {
        deck = [CDXCardDeckJSONSerializer cardDeckFromString:string];
    }
    
    if (deck == nil) {
        [[CDXAppWindowManager sharedAppWindowManager] showErrorMessage:@"Paste failed: invalid document" afterDelay:0.1];
        return nil;
    }
    if (!allowEmpty && deck.cardsCount == 0) {
        [[CDXAppWindowManager sharedAppWindowManager] showErrorMessage:@"Paste failed: no card to paste" afterDelay:0.1];
        return nil;
    }
    
    return deck;
}

@end

