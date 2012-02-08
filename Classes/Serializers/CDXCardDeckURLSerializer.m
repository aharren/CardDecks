//
//
// CDXCardDeckURLSerializer.m
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

#import "CDXCardDeckURLSerializer.h"
#import "CDXURLSerializerUtils.h"


@implementation CDXCardDeckURLSerializer

+ (CDXCard *)cardFromString:(NSString *)string cardDeck:(CDXCardDeck *)cardDeck version:(NSUInteger)version {
    NSArray *sCardParts = [string componentsSeparatedByString:@","];
    if ([sCardParts count] >= 1) {
        CDXCard *dCard = [cardDeck cardWithDefaults];
        
        // <text>
        dCard.text = [CDXURLSerializerUtils stringByReplacingURLEscapes:(NSString *)[sCardParts objectAtIndex:0]];
        // [,[<text-color>] ...
        if ([sCardParts count] >= 2) {
            dCard.textColor = [CDXColor colorWithRGBAString:(NSString *)[sCardParts objectAtIndex:1]
                                                 defaultsTo:dCard.textColor];
        }
        // [,[<background-color>] ...
        if ([sCardParts count] >= 3) {
            dCard.backgroundColor = [CDXColor colorWithRGBAString:(NSString *)[sCardParts objectAtIndex:2]
                                                       defaultsTo:dCard.backgroundColor];
        }
        // [,[<orientation>] ...
        if ([sCardParts count] >= 4) {
            dCard.orientation = [CDXCard cardOrientationFromString:(NSString *)[sCardParts objectAtIndex:3]];
        }
        // [,[<font-size>] ...
        if ([sCardParts count] >= 5 && version >= 2) {
            dCard.fontSize = (CGFloat)[(NSString *)[sCardParts objectAtIndex:4] intValue];
        }
        // [,[<timer-interval>] ...
        if ([sCardParts count] >= 6 && version >= 2) {
            dCard.timerInterval = (NSTimeInterval)[(NSString *)[sCardParts objectAtIndex:5] intValue];
        }
        
        return dCard;
    }
    return nil;
}

+ (CDXCardDeck *)cardDeckFromVersion1String:(NSString *)string {
    // string := <deck>[&<card>[&<card>[...]]]
    NSArray *sParts = [string componentsSeparatedByString:@"&"];
    if ([sParts count] == 0) {
        // no deck, exit
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
        dCardDefaults.backgroundColor = [CDXColor colorBlack];
        dCardDefaults.textColor = [CDXColor colorWhite];
        
        // <name>
        dDeck.name = [CDXURLSerializerUtils stringByReplacingURLEscapes:(NSString *)[sDeckParts objectAtIndex:0]];
        
        // defaults, parse <deck> as <card> and reset the text to ""
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *sCard = sDeck;
        CDXCard *dCard = [CDXCardDeckURLSerializer cardFromString:sCard cardDeck:dDeck version:1];
        if (dCard != nil) {
            dCard.text = @"";
            [dDeck setCardDefaults:dCard];
        }
        [pool release];
    }
    
    // card := <text>[,[<text-color>][,[<background-color>][,[<orientation>]]]]
    for (NSUInteger i = 1; i < [sParts count]; i++) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *sCard = (NSString *)[sParts objectAtIndex:i];
        CDXCard *dCard = [CDXCardDeckURLSerializer cardFromString:sCard cardDeck:dDeck version:1];
        if (dCard != nil) {
            [dDeck addCard:dCard];
        }
        [pool release];
    }
    
    return dDeck;
}

+ (CDXCardDeck *)cardDeckFromVersion2String:(NSString *)string {
    // string := <deck>&<default-card>[&<card>[...]]
    NSArray *sParts = [string componentsSeparatedByString:@"&"];
    if ([sParts count] <= 1) {
        // no deck, no default card, exit
        return nil;
    }
    
    // deck := <name>[,<setting>[,<setting>[...]]]
    CDXCardDeck *dDeck = nil;
    {
        NSString *sDeck = (NSString *)[sParts objectAtIndex:0];
        NSArray *sDeckParts = [sDeck componentsSeparatedByString:@","];
        if ([sDeckParts count] < 1) {
            // no name, exit
            return nil;
        }
        
        dDeck = [[[CDXCardDeck alloc] init] autorelease];
        // <name>
        dDeck.name = [CDXURLSerializerUtils stringByReplacingURLEscapes:(NSString *)[sDeckParts objectAtIndex:0]];
        
        // <setting>
        for (NSUInteger i = 1; i < [sDeckParts count]; i++) {
            NSString *sSetting = (NSString *)[sDeckParts objectAtIndex:i];
            if ([sSetting hasPrefix:@"g"]) {
                dDeck.groupSize = [[sSetting substringFromIndex:1] intValue];
            } else if ([sSetting hasPrefix:@"d"]) {
                dDeck.displayStyle = [[sSetting substringFromIndex:1] intValue];
            } else if ([sSetting hasPrefix:@"c"]) {
                dDeck.cornerStyle = [[sSetting substringFromIndex:1] intValue];
            } else if ([sSetting hasPrefix:@"id"]) {
                dDeck.wantsPageControl = [[sSetting substringFromIndex:2] intValue] ? YES : NO;
            } else if ([sSetting hasPrefix:@"is"]) {
                dDeck.pageControlStyle = [[sSetting substringFromIndex:2] intValue];
            } else if ([sSetting hasPrefix:@"it"]) {
                dDeck.wantsPageJumps = [[sSetting substringFromIndex:2] intValue] ? YES : NO;
            } else if ([sSetting hasPrefix:@"r"]) {
                dDeck.wantsAutoRotate = [[sSetting substringFromIndex:1] intValue] ? YES : NO;
            } else if ([sSetting hasPrefix:@"s"]) {
                dDeck.shakeAction = [[sSetting substringFromIndex:1] intValue];
            }
        }
    }
    
    // default-card := <text>[,[<text-color>][,[<background-color>][,[<orientation>][,[<font-size>][,[<timer-interval>]]]]]]
    if ([sParts count] >= 1) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *sCard = (NSString *)[sParts objectAtIndex:1];
        CDXCard *dCard = [CDXCardDeckURLSerializer cardFromString:sCard cardDeck:dDeck version:2];
        if (dCard != nil) {
            [dDeck setCardDefaults:dCard];
        }
        [pool release];
    }
    
    // card := <text>[,[<text-color>][,[<background-color>][,[<orientation>][,[<font-size>][,[<timer-interval>]]]]]]
    for (NSUInteger i = 2; i < [sParts count]; i++) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *sCard = (NSString *)[sParts objectAtIndex:i];
        CDXCard *dCard = [CDXCardDeckURLSerializer cardFromString:sCard cardDeck:dDeck version:2];
        if (dCard != nil) {
            [dDeck addCard:dCard];
        }
        [pool release];
    }
    
    return dDeck;
}

+ (NSString *)version2StringFromCard:(CDXCard *)card cardDefaults:(CDXCard *)cardDefaults {
    CDXColor *textColor = card.textColor;
    BOOL textColorIsNotDefault = !cardDefaults || ![textColor isEqual:cardDefaults.textColor];
    CDXColor *backgroundColor = card.backgroundColor;
    BOOL backgroundColorIsNotDefault = !cardDefaults || ![backgroundColor isEqual:cardDefaults.backgroundColor];
    CDXCardOrientation orientation = card.orientation;
    BOOL orientationIsNotDefault = !cardDefaults || orientation != cardDefaults.orientation;
    CGFloat fontSize = card.fontSize;
    BOOL fontSizeIsNotDefault = !cardDefaults || fontSize != cardDefaults.fontSize;
    NSTimeInterval timerInterval = card.timerInterval;
    BOOL timerIntervalIsNotDefault = !cardDefaults || timerInterval != cardDefaults.timerInterval;
    NSString *string =  [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",
                         [CDXURLSerializerUtils stringByAddingURLEscapes:card.text],
                         (textColorIsNotDefault || backgroundColorIsNotDefault || orientationIsNotDefault || fontSizeIsNotDefault || timerIntervalIsNotDefault) ? @"," : @"",
                         (textColorIsNotDefault) ? [textColor rgbaString] : @"",
                         (backgroundColorIsNotDefault || orientationIsNotDefault || fontSizeIsNotDefault || timerIntervalIsNotDefault) ? @"," : @"",
                         (backgroundColorIsNotDefault) ? [backgroundColor rgbaString]  : @"",
                         (orientationIsNotDefault || fontSizeIsNotDefault || timerIntervalIsNotDefault) ? @"," : @"",
                         (orientationIsNotDefault) ? [CDXCard stringFromCardOrientation:orientation] : @"",
                         (fontSizeIsNotDefault || timerIntervalIsNotDefault) ? @"," : @"",
                         (fontSizeIsNotDefault) ? [NSString stringWithFormat:@"%d", (NSUInteger)fontSize] : @"",
                         (timerIntervalIsNotDefault) ? @"," : @"",
                         (timerIntervalIsNotDefault) ? [NSString stringWithFormat:@"%d", (NSUInteger)timerInterval] : @""];
    return string;
}

+ (NSString *)version2StringFromCardDeck:(CDXCardDeck *)cardDeck {
    NSMutableArray *parts = [[[NSMutableArray alloc] initWithCapacity:2 + [cardDeck cardsCount]] autorelease];
    
    NSString *deck = [NSString stringWithFormat:@"%@,g%d,d%d,c%d,id%d,is%d,it%d,r%d,s%d",
                      [CDXURLSerializerUtils stringByAddingURLEscapes:cardDeck.name],
                      (NSUInteger)cardDeck.groupSize,
                      (NSUInteger)cardDeck.displayStyle,
                      (NSUInteger)cardDeck.cornerStyle,
                      cardDeck.wantsPageControl ? 1 : 0,
                      (NSUInteger)cardDeck.pageControlStyle,
                      cardDeck.wantsPageJumps ? 1 : 0,
                      cardDeck.wantsAutoRotate ? 1 : 0,
                      // version 2a: s0, s1
                      // version 2b: s0, s1, s2
                      (NSUInteger)cardDeck.shakeAction];
    [parts addObject:deck];
    
    CDXCard *cardDefaults = [cardDeck cardDefaults];
    [parts addObject:[CDXCardDeckURLSerializer version2StringFromCard:cardDefaults cardDefaults:nil]];
    
    NSUInteger cardsCount = [cardDeck cardsCount];
    for (NSUInteger i=0; i < cardsCount; i++) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [parts addObject:[CDXCardDeckURLSerializer version2StringFromCard:[cardDeck cardAtCardsIndex:i] cardDefaults:cardDefaults]];
        [pool release];
    }
    
    NSString *string = [parts componentsJoinedByString:@"&"];
    qltrace(@"%@", string);
    return string;
}

@end

