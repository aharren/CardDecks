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

+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary forKey:(NSString *)key defaultsTo:(NSString *)defaultValue {
    NSObject *object = [dictionary objectForKey:key];
    if (object == nil || ![object isKindOfClass:[NSString class]]) {
        return defaultValue;
    } else {
        return (NSString *)object;
    }
}

+ (BOOL)boolFromDictionary:(NSDictionary *)dictionary forKey:(NSString *)key defaultsTo:(BOOL)defaultValue {
    NSObject *object = [dictionary objectForKey:key];
    if (object == nil || ![object isKindOfClass:[NSNumber class]]) {
        return defaultValue;
    } else {
        return [(NSNumber *)object boolValue] ? YES : NO;
    }
}

+ (NSUInteger)unsignedIntegerFromDictionary:(NSDictionary *)dictionary forKey:(NSString *)key defaultsTo:(NSUInteger)defaultValue {
    NSObject *object = [dictionary objectForKey:key];
    if (object == nil || ![object isKindOfClass:[NSNumber class]]) {
        return defaultValue;
    } else {
        return [(NSNumber *)object unsignedIntegerValue];
    }
}

+ (NSDictionary *)dictionaryFromDictionary:(NSDictionary *)dictionary forKey:(NSString *)key defaultsTo:(NSDictionary *)defaultValue {
    NSObject *object = [dictionary objectForKey:key];
    if (object == nil || ![object isKindOfClass:[NSDictionary class]]) {
        return defaultValue;
    } else {
        return (NSDictionary *)object;
    }
}

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

+ (CDXCard *)cardFromVersion2Dictionary:(NSDictionary *)dictionary cardDeck:(CDXCardDeck*)cardDeck {
    CDXCard *card = [cardDeck cardWithDefaults];
    
    card.text = [CDXCardDeckDictionarySerializer stringFromDictionary:dictionary forKey:@"text" defaultsTo:@""];
    NSString *textColor = [CDXCardDeckDictionarySerializer stringFromDictionary:dictionary forKey:@"textColor" defaultsTo:nil];
    if (textColor != nil) {
        card.textColor = [CDXColor colorWithRGBAString:textColor defaulsTo:card.textColor];
    }
    NSString *backgroundColor = [CDXCardDeckDictionarySerializer stringFromDictionary:dictionary forKey:@"backgroundColor" defaultsTo:nil];
    if (textColor != nil) {
        card.backgroundColor = [CDXColor colorWithRGBAString:backgroundColor defaulsTo:card.backgroundColor];
    }
    card.orientation = [CDXCardDeckDictionarySerializer unsignedIntegerFromDictionary:dictionary forKey:@"orientation" defaultsTo:card.orientation]; 
    card.cornerStyle = [CDXCardDeckDictionarySerializer unsignedIntegerFromDictionary:dictionary forKey:@"cornerStyle" defaultsTo:card.cornerStyle]; 
    card.fontSize = (CGFloat)[CDXCardDeckDictionarySerializer unsignedIntegerFromDictionary:dictionary forKey:@"fontSize" defaultsTo:(NSUInteger)card.fontSize]; 
    
    return card;
}

+ (CDXCardDeck *)cardDeckFromVersion2Dictionary:(NSDictionary *)dictionary {
    CDXCardDeck *dDeck = [[[CDXCardDeck alloc] init] autorelease];
    
    NSDictionary *cardDefaultsDictionary = [CDXCardDeckDictionarySerializer dictionaryFromDictionary:dictionary forKey:@"cardDefaults" defaultsTo:nil];
    if (cardDefaultsDictionary != nil) {
        CDXCard *dCardDefaults = [CDXCardDeckDictionarySerializer cardFromVersion2Dictionary:cardDefaultsDictionary cardDeck:dDeck];
        dDeck.cardDefaults = dCardDefaults;
    }
    
    dDeck.name = [CDXCardDeckDictionarySerializer stringFromDictionary:dictionary forKey:@"name" defaultsTo:@""];
    dDeck.file = [CDXCardDeckDictionarySerializer stringFromDictionary:dictionary forKey:@"file" defaultsTo:nil];
    
    dDeck.wantsPageControl = [CDXCardDeckDictionarySerializer boolFromDictionary:dictionary forKey:@"wantsPageControl" defaultsTo:dDeck.wantsPageControl];
    dDeck.wantsPageJumps = [CDXCardDeckDictionarySerializer boolFromDictionary:dictionary forKey:@"wantsPageJumps" defaultsTo:dDeck.wantsPageJumps];
    dDeck.wantsAutoRotate = [CDXCardDeckDictionarySerializer boolFromDictionary:dictionary forKey:@"wantsAutoRotate" defaultsTo:dDeck.wantsAutoRotate];
    dDeck.wantsShakeShuffle = [CDXCardDeckDictionarySerializer boolFromDictionary:dictionary forKey:@"wantsShakeShuffle" defaultsTo:dDeck.wantsShakeShuffle];
    
    dDeck.groupSize = [CDXCardDeckDictionarySerializer unsignedIntegerFromDictionary:dictionary forKey:@"groupSize" defaultsTo:dDeck.groupSize]; 
    dDeck.displayStyle = [CDXCardDeckDictionarySerializer unsignedIntegerFromDictionary:dictionary forKey:@"displayStyle" defaultsTo:dDeck.displayStyle]; 
    dDeck.cornerStyle = [CDXCardDeckDictionarySerializer unsignedIntegerFromDictionary:dictionary forKey:@"cornerStyle" defaultsTo:dDeck.cornerStyle]; 
    
    NSArray *cardDictionaries = (NSArray *)[dictionary objectForKey:@"cards"];
    for (NSDictionary *cardDictionary in cardDictionaries) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        CDXCard *dCard = [CDXCardDeckDictionarySerializer cardFromVersion2Dictionary:cardDictionary cardDeck:dDeck];
        [dDeck addCard:dCard];
        
        [pool release];
    }
    
    NSArray *shuffleIndexes = (NSArray *)[dictionary objectForKey:@"shuffleIndexes"];
    if (shuffleIndexes != nil) {
        dDeck.shuffleIndexes = [NSMutableArray arrayWithArray:shuffleIndexes];
    }
    
    return dDeck;
}

+ (NSDictionary *)version2DictionaryFromCard:(CDXCard *)card {
    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dictionary setObject:card.text forKey:@"text"];
    
    [dictionary setObject:[card.textColor rgbaString] forKey:@"textColor"];
    [dictionary setObject:[card.backgroundColor rgbaString] forKey:@"backgroundColor"];
    
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:card.orientation] forKey:@"orientation"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:card.cornerStyle] forKey:@"cornerStyle"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:(NSUInteger)card.fontSize] forKey:@"fontSize"];
    
    return dictionary;
}

+ (NSDictionary *)version2DictionaryFromCardDeck:(CDXCardDeck *)cardDeck {
    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dictionary setObject:[CDXCardDeckDictionarySerializer version2DictionaryFromCard:cardDeck.cardDefaults] forKey:@"cardDefaults"];
    
    [dictionary setObject:cardDeck.name forKey:@"name"];
    [dictionary setObject:cardDeck.file forKey:@"file"];
    
    NSUInteger cardsCount = [cardDeck cardsCount];
    NSMutableArray *cards = [NSMutableArray arrayWithCapacity:cardsCount];
    for (NSUInteger i=0; i < cardsCount; i++) {
        [cards addObject:[CDXCardDeckDictionarySerializer version2DictionaryFromCard:[cardDeck cardAtCardsIndex:i]]];
    }
    [dictionary setObject:cards forKey:@"cards"];
    
    [dictionary setObject:[NSNumber numberWithBool:cardDeck.wantsPageControl] forKey:@"wantsPageControl"];
    [dictionary setObject:[NSNumber numberWithBool:cardDeck.wantsPageJumps] forKey:@"wantsPageJumps"];
    [dictionary setObject:[NSNumber numberWithBool:cardDeck.wantsAutoRotate] forKey:@"wantsAutoRotate"];
    [dictionary setObject:[NSNumber numberWithBool:cardDeck.wantsShakeShuffle] forKey:@"wantsShakeShuffle"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:cardDeck.groupSize] forKey:@"groupSize"];
    
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:cardDeck.displayStyle] forKey:@"displayStyle"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:cardDeck.cornerStyle] forKey:@"cornerStyle"];
    
    [dictionary setObject:[NSNumber numberWithBool:cardDeck.isShuffled] forKey:@"isShuffled"];
    if (cardDeck.isShuffled) {
        [dictionary setObject:[[[cardDeck shuffleIndexes] copy] autorelease] forKey:@"shuffleIndexes"];
    }
    
    return dictionary;
}

@end

