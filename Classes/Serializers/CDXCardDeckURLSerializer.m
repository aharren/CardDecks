//
//
// CDXCardDeckURLSerializer.m
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

#import "CDXCardDeckURLSerializer.h"


@implementation CDXCardDeckURLSerializer

+(id)alloc {
    [CDXCardDeckURLSerializer doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (NSString *)stringByReplacingURLEscapes:(NSString *)string {
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (CDXCardOrientation)cardOrientationFromString:(NSString *)string defaultsTo:(CDXCardOrientation)defaultOrientation {
    // valid orientations are 'u', 'r', 'd', and 'l', everything else maps to
    // the given default orientation
    string = [string lowercaseString];
    if ([@"u" isEqualToString:string]) {
        return CDXCardOrientationUp;
    } else if ([@"r" isEqualToString:string]) {
        return CDXCardOrientationRight;
    } else if ([@"d" isEqualToString:string]) {
        return CDXCardOrientationDown;
    } else if ([@"l" isEqualToString:string]) {
        return CDXCardOrientationLeft;
    } else {
        return defaultOrientation;
    }
}

+ (CDXCardDeck *)cardDeckFromVersion1String:(NSString *)string {
    // string := <deck>[&<card>[&<card>[...]]]
    NSArray *sParts = [string componentsSeparatedByString:@"&"];
    if ([sParts count] == 0) {
        // no deck, no cards, exit
        return nil;
    }
    
    // deck := <name>[,[<text-color>][,[<background-color>][,[<orientation>]]]]
    CDXCardDeck *dDeck = nil;
    {
        NSString *sDeck = (NSString *)[sParts objectAtIndex:0];
        NSArray *sDeckParts = [sDeck componentsSeparatedByString:@","];
        if ([sDeckParts count] < 1) {
            // no name, exit
            return nil;
        }
        
        dDeck = [[[CDXCardDeck alloc] init] autorelease];
        CDXCard *dCardDefaults = dDeck.cardDefaults;
        
        // <name>
        dDeck.name = [CDXCardDeckURLSerializer stringByReplacingURLEscapes:(NSString *)[sDeckParts objectAtIndex:0]];
        // [,[<text-color>] ...
        if ([sDeckParts count] >= 2) {
            dCardDefaults.textColor = [CDXColor colorWithRGBAString:(NSString *)[sDeckParts objectAtIndex:1]
                                                          defaulsTo:[CDXColor colorWhite]];
        }
        //  [,[<background-color>] ...
        if ([sDeckParts count] >= 3) {
            dCardDefaults.backgroundColor = [CDXColor colorWithRGBAString:(NSString *)[sDeckParts objectAtIndex:2]
                                                                defaulsTo:[CDXColor colorBlack]];
        }
        //  [,[<orientation>] ...
        if ([sDeckParts count] >= 4) {
            dCardDefaults.orientation = [CDXCardDeckURLSerializer cardOrientationFromString:(NSString *)[sDeckParts objectAtIndex:3]
                                                                                 defaultsTo:CDXCardOrientationUp];
        }
    }
    
    // card := <text>[,[<text-color>][,[<background-color>][,[<orientation>]]]]
    for (NSUInteger i = 1; i < [sParts count]; i++) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSString *sCard = (NSString *)[sParts objectAtIndex:i];
        NSArray *sCardParts = [sCard componentsSeparatedByString:@","];
        if ([sCardParts count] >= 1) {
            CDXCard *dCard = [dDeck cardWithDefaults];
            
            // <text>
            dCard.text = [CDXCardDeckURLSerializer stringByReplacingURLEscapes:(NSString *)[sCardParts objectAtIndex:0]];
            // [,[<text-color>] ...
            if ([sCardParts count] >= 2) {
                dCard.textColor = [CDXColor colorWithRGBAString:(NSString *)[sCardParts objectAtIndex:1]
                                                      defaulsTo:dCard.textColor];
            }
            // [,[<background-color>] ...
            if ([sCardParts count] >= 3) {
                dCard.backgroundColor = [CDXColor colorWithRGBAString:(NSString *)[sCardParts objectAtIndex:2]
                                                            defaulsTo:dCard.backgroundColor];
            }
            //  [,[<orientation>] ...
            if ([sCardParts count] >= 4) {
                dCard.orientation = [CDXCardDeckURLSerializer cardOrientationFromString:(NSString *)[sCardParts objectAtIndex:3]
                                                                             defaultsTo:dCard.orientation];
            }
            
            [dDeck addCard:dCard];
        }
        
        [pool release];
    }
    
    return dDeck;
}

@end

