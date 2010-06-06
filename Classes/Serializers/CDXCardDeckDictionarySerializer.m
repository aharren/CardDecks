//
//
// CDXCardDeckDictionarySerializer.m
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

#import "CDXCardDeckDictionarySerializer.h"


@implementation CDXCardDeckDictionarySerializer

+ (CDXCardDeck *)cardDeckFromVersion1Dictionary:(NSDictionary *)dictionary {
    CDXCardDeck *dDeck = [[[CDXCardDeck alloc] init] autorelease];
    dDeck.name = (NSString *)[dictionary objectForKey:@"Name"];
    dDeck.file = (NSString *)[dictionary objectForKey:@"File"];
    
    CDXCard *dCardDefaults = dDeck.cardDefaults;
    dCardDefaults.textColor = [CDXColor colorWithRGBAString:(NSString *)[dictionary objectForKey:@"DefaultTextColor"] defaulsTo:[CDXColor colorWhite]];
    dCardDefaults.backgroundColor = [CDXColor colorWithRGBAString:(NSString *)[dictionary objectForKey:@"DefaultBackgroundColor"] defaulsTo:[CDXColor colorBlack]];
    
    NSArray *cardDictionaries = (NSArray *)[dictionary objectForKey:@"Cards"];
    for (NSDictionary *cardDictionary in cardDictionaries) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        CDXCard *dCard = [dDeck cardWithDefaults];
        NSObject *object;
        
        object = [cardDictionary objectForKey:@"Text"];
        if (object == nil || ![object isKindOfClass:[NSString class]]) {
            dCard.text = @"";
        } else {
            dCard.text = (NSString *)object;
        }
        
        object = [cardDictionary objectForKey:@"TextColor"];
        if (object == nil || ![object isKindOfClass:[NSString class]]) {
            dCard.textColor = [CDXColor colorWhite];
        } else {
            dCard.textColor = [CDXColor colorWithRGBAString:(NSString *)object defaulsTo:[CDXColor colorWhite]];
        }
        
        object = [cardDictionary objectForKey:@"BackgroundColor"];
        if (object == nil || ![object isKindOfClass:[NSString class]]) {
            dCard.backgroundColor = [CDXColor colorBlack];
        } else {
            dCard.backgroundColor = [CDXColor colorWithRGBAString:(NSString *)object defaulsTo:[CDXColor colorBlack]];
        }
        
        object = [cardDictionary objectForKey:@"Orientation"];
        if (object == nil || ![object isKindOfClass:[NSString class]]) {
            dCard.orientation = CDXCardOrientationUp;
        } else {
            dCard.orientation = [CDXCard cardOrientationFromString:(NSString *)object];
        }
        
        [dDeck addCard:dCard];
        
        [pool release];
    }
    
    return dDeck;
}

@end

