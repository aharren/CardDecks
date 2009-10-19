//
//
// CDXCardDeck.m
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

#import "CDXCardDeck.h"


@implementation CDXCardDeck

#define LogFileComponent lcl_cCDXCardDeck

@synthesize name = _name;

@synthesize defaultTextColor = _defaultTextColor;
@synthesize defaultBackgroundColor = _defaultBackgroundColor;

@synthesize cards = _cards;

@synthesize committed = _committed;
@synthesize dirty = _dirty;

@synthesize file = _file;

- (id)init {
    LogInvocation();
    
    if ((self = [super init])) {
        _cards = [[NSMutableArray alloc] init];
        self.defaultTextColor = [CDXColor whiteColor];
        self.defaultBackgroundColor = [CDXColor blackColor];
    }
    return self;
}

- (id)initWithContentsOfDictionary:(NSDictionary *)dictionary cards:(BOOL)cards colors:(BOOL)colors {
    LogInvocation();
    
    if ((self = [super init])) {
        LogDebug(@"dictionary %@", dictionary);
        
        self.name = (NSString *)[dictionary objectForKey:@"Name"];
        
        if (colors) {
            self.defaultTextColor = [CDXColor cdxColorWithRGBString:(NSString *)[dictionary objectForKey:@"DefaultTextColor"] defaulsTo:[CDXColor whiteColor]];
            self.defaultBackgroundColor = [CDXColor cdxColorWithRGBString:(NSString *)[dictionary objectForKey:@"DefaultBackgroundColor"] defaulsTo:[CDXColor blackColor]];
        }
        
        if (cards) {
            NSArray *array = (NSArray *)[dictionary objectForKey:@"Cards"];
            if (array != nil) {
                NSUInteger numberOfItems = [array count];
                _cards = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
                
                for (NSUInteger i=0; i<numberOfItems; i++) {
                    [_cards addObject:[CDXCard cardWithContentsOfDictionary:(NSDictionary *)[array objectAtIndex:i]]];
                }
            }
        }
        
        self.file = (NSString *)[dictionary objectForKey:@"File"];
        
        _committed = YES;
        _dirty = NO;
    }
    return self;
}

- (void)dealloc {
    LogInvocation();
    
    [_name release];
    [_defaultTextColor release];
    [_defaultBackgroundColor release];
    [_cards release];
    [_file release];
    [super dealloc];
}

- (NSUInteger)cardsCount {
    LogInvocation();
    
    return [_cards count];
}

- (CDXCard *)cardAtIndex:(NSUInteger)index {
    LogInvocation();
    
    return (CDXCard *)[_cards objectAtIndex:index];
}

- (NSUInteger)indexOfCard:(CDXCard *)card {
    LogInvocation();
    
    return [_cards indexOfObject:card];
}

- (void)addCard:(CDXCard *)card {
    LogInvocation();
    
    [_cards addObject:card];
}

- (void)insertCard:(CDXCard *)card atIndex:(NSUInteger)index {
    LogInvocation();
    
    if (index >= [_cards count]) {
        [_cards addObject:card];
    } else {
        [_cards insertObject:card atIndex:index];
    }
}

- (void)removeCardAtIndex:(NSUInteger)index {
    LogInvocation();
    
    [_cards removeObjectAtIndex:index];
}

- (NSString *)storageName {
    LogInvocation();
    
    return self.file;
}

- (NSDictionary *)stateAsDictionary {
    LogInvocation();
    
    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    if (_name != nil) {
        [dictionary setValue:self.name forKey:@"Name"];
    }
    
    if (_file != nil) {
        [dictionary setValue:self.file forKey:@"File"];
    }
    
    if (_defaultTextColor != nil) {
        [dictionary setValue:[_defaultTextColor rgbString] forKey:@"DefaultTextColor"];
    }
    
    if (_defaultBackgroundColor != nil) {
        [dictionary setValue:[_defaultBackgroundColor rgbString] forKey:@"DefaultBackgroundColor"];
    }
    
    if (_cards != nil) {
        NSUInteger numberOfItems = [_cards count];
        NSMutableArray *cards = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
        for (NSUInteger i=0; i<numberOfItems; i++) {
            CDXCardDeck *cardDeck = (CDXCardDeck *)[_cards objectAtIndex:i];
            if (cardDeck.committed) {
                [cards addObject:[cardDeck stateAsDictionary]];
            }
        }
        [dictionary setValue:cards forKey:@"Cards"];
        [cards release];
    }
    
    return dictionary;
}

+ (CDXCardDeck *)cardDeckWithContentsOfDictionary:(NSDictionary *)dictionary cards:(BOOL)cards colors:(BOOL)colors {
    LogInvocation();
    
    return [[[CDXCardDeck alloc] initWithContentsOfDictionary:dictionary cards:cards colors:colors] autorelease]; 
}

+ (NSString *)stringByAddingURLEscapes:(NSString *)string {
    NSString *rfc3986ReservedCharacters = @":/?#[]@!$&'()*+,;=";
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                           (CFStringRef)string,
                                                                           NULL,
                                                                           (CFStringRef)rfc3986ReservedCharacters,
                                                                           kCFStringEncodingUTF8);
    return [result autorelease];
}

+ (NSString *)stringByReplacingURLEscapes:(NSString *)string {
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSArray *)stateAsURLComponents {
    NSMutableArray *urlComponents = [[[NSMutableArray alloc] initWithCapacity:1+[_cards count]] autorelease];
    
    NSString *defaultTextColorString = [_defaultTextColor rgbString];
    NSString *defaultBackgroundColorString = [_defaultBackgroundColor rgbString];
    
    // add the card deck
    NSString *cardDeckString = [NSString stringWithFormat:@"%@,%@,%@", 
                                [CDXCardDeck stringByAddingURLEscapes:_name],
                                defaultTextColorString,
                                defaultBackgroundColorString];
    [urlComponents addObject:cardDeckString];
    
    // add the cards
    NSUInteger cardsCount = [_cards count];
    for (NSUInteger cardsIndex = 0; cardsIndex < cardsCount; cardsIndex++) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        CDXCard *card = (CDXCard *)[_cards objectAtIndex:cardsIndex];
        if (card.committed) {
            NSString *textColorString = [card.textColor rgbString];
            NSString *backgroundColorString = [card.backgroundColor rgbString];
            BOOL textColorEqual = textColorString != nil && [textColorString isEqualToString:defaultTextColorString];
            BOOL backgroundColorEqual = backgroundColorString != nil && [backgroundColorString isEqualToString:defaultBackgroundColorString];
            
            NSString *cardString = [NSString stringWithFormat:@"%@%@%@%@%@",
                                    [CDXCardDeck stringByAddingURLEscapes:card.text],
                                    (!textColorEqual || !backgroundColorEqual) ? @"," : @"",
                                    (!textColorEqual) ? textColorString : @"",
                                    (!backgroundColorEqual) ? @"," : @"",
                                    (!backgroundColorEqual) ? backgroundColorString : @""];
            [urlComponents addObject:cardString];
        }
        [pool release];
    }
    
    LogDebug(@"%@", urlComponents);
    return urlComponents;
}

+ (CDXCardDeck *)cardDeckWithContentsOfURLComponents:(NSArray *)urlComponents {
    if ([urlComponents count] == 0) {
        return nil;
    }
    
    // create the card deck
    NSString *encodedCardDeck = (NSString *)[urlComponents objectAtIndex:0];
    NSArray *encodedCardDeckParts = [encodedCardDeck componentsSeparatedByString:@","];
    if ([encodedCardDeckParts count] < 1) {
        return nil;
    }
    
    CDXCardDeck *cardDeck = [[[CDXCardDeck alloc] init] autorelease];
    cardDeck.file = [CDXStorage storageNameWithSuffix:@".CardDeck"];
    cardDeck.name = [CDXCardDeck stringByReplacingURLEscapes:(NSString *)[encodedCardDeckParts objectAtIndex:0]];
    if ([encodedCardDeckParts count] >= 2) {
        cardDeck.defaultTextColor = [CDXColor cdxColorWithRGBString:(NSString *)[encodedCardDeckParts objectAtIndex:1] defaulsTo:[CDXColor whiteColor]];
    }
    if ([encodedCardDeckParts count] >= 3) {
        cardDeck.defaultBackgroundColor = [CDXColor cdxColorWithRGBString:(NSString *)[encodedCardDeckParts objectAtIndex:2] defaulsTo:[CDXColor blackColor]];
    }
    
    // create the cards
    for (NSUInteger i=1; i<[urlComponents count]; i++) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *encodedCard = (NSString *)[urlComponents objectAtIndex:i];
        NSArray *encodedCardParts = [encodedCard componentsSeparatedByString:@","];
        CDXCard *card = [[[CDXCard alloc] init] autorelease];
        
        if ([encodedCardParts count] >= 1) {
            card.text = [CDXCardDeck stringByReplacingURLEscapes:(NSString *)[encodedCardParts objectAtIndex:0]];
            card.textColor = cardDeck.defaultTextColor;
            card.backgroundColor = cardDeck.defaultBackgroundColor;
            
            if ([encodedCardParts count] >= 2) {
                card.textColor = [CDXColor cdxColorWithRGBString:(NSString *)[encodedCardParts objectAtIndex:1] defaulsTo:cardDeck.defaultTextColor];
            }
            if ([encodedCardParts count] >= 3) {
                card.backgroundColor = [CDXColor cdxColorWithRGBString:(NSString *)[encodedCardParts objectAtIndex:2] defaulsTo:cardDeck.defaultBackgroundColor];
            }
            
            card.committed = YES;
            [cardDeck addCard:card];
        }
        [pool release];
    }
    
    cardDeck.committed = YES;
    return cardDeck;
}

@end

