//
//
// CDXCardDeckJSONSerializer.m
//
//
// Copyright (c) 2009-2014 Arne Harren <ah@0xc0.de>
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

#import "CDXCardDeckJSONSerializer.h"


@implementation CDXCardDeckJSONSerializer

+ (NSString *)dictionary:(NSDictionary *)dictionary stringForKey:(NSString *)key defaultsTo:(NSString *)defaultsTo {
    id object = [dictionary objectForKey:key];
    if (object != nil && [object isKindOfClass:[NSString class]]) {
        return (NSString *)object;
    } else {
        return defaultsTo;
    }
}

+ (NSNumber *)dictionary:(NSDictionary *)dictionary numberForKey:(NSString *)key defaultsTo:(NSNumber *)defaultsTo {
    id object = [dictionary objectForKey:key];
    if (object != nil && [object isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)object;
    } else {
        return defaultsTo;
    }
}

+ (NSArray *)dictionary:(NSDictionary *)dictionary arrayForKey:(NSString *)key defaultsTo:(NSArray *)defaultsTo {
    id object = [dictionary objectForKey:key];
    if (object != nil && [object isKindOfClass:[NSArray class]]) {
        return (NSArray *)object;
    } else {
        return defaultsTo;
    }
}

+ (NSDictionary *)dictionary:(NSDictionary *)dictionary dictionaryForKey:(NSString *)key defaultsTo:(NSDictionary *)defaultsTo {
    id object = [dictionary objectForKey:key];
    if (object != nil && [object isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)object;
    } else {
        return defaultsTo;
    }
}

+ (int)intFromDouble:(double)value {
    if (value < (double)INT_MIN) {
        return INT_MIN;
    } else if (value > (double)INT_MAX) {
        return INT_MAX;
    } else {
        return (int)value;
    }
}

+ (CDXCard *)cardFromDictionary:(NSDictionary *)jcard cardDeck:(CDXCardDeck *)cardDeck {
    NSString *jstring = nil;
    NSNumber *jnumber = nil;
    
    CDXCard *card = [cardDeck cardWithDefaults];
    
    // text
    jstring = [CDXCardDeckJSONSerializer dictionary:jcard stringForKey:@"text" defaultsTo:nil];
    if (jstring != nil) {
        card.text = jstring;
    }
    // text_color
    jstring = [CDXCardDeckJSONSerializer dictionary:jcard stringForKey:@"text_color" defaultsTo:nil];
    if (jstring != nil) {
        card.textColor = [CDXColor colorWithRGBAString:jstring defaultsTo:card.textColor];
    }
    // background_color
    jstring = [CDXCardDeckJSONSerializer dictionary:jcard stringForKey:@"background_color" defaultsTo:nil];
    if (jstring != nil) {
        card.backgroundColor = [CDXColor colorWithRGBAString:jstring defaultsTo:card.backgroundColor];
    }
    // orientation
    jstring = [CDXCardDeckJSONSerializer dictionary:jcard stringForKey:@"orientation" defaultsTo:nil];
    if (jstring != nil) {
        card.orientation = [CDXCard cardOrientationFromString:jstring defaultsTo:card.orientation];
    }
    // font_size
    jnumber = [CDXCardDeckJSONSerializer dictionary:jcard numberForKey:@"font_size" defaultsTo:nil];
    if (jnumber != nil) {
        card.fontSize = (CGFloat)[CDXCardDeckJSONSerializer intFromDouble:[jnumber doubleValue]];
    }
    // timer
    jnumber = [CDXCardDeckJSONSerializer dictionary:jcard numberForKey:@"timer" defaultsTo:nil];
    if (jnumber != nil) {
        card.timerInterval = (NSTimeInterval)[CDXCardDeckJSONSerializer intFromDouble:[jnumber doubleValue]];
    }
    
    return card;
}

+ (CDXCardDeck *)cardDeckFromVersion2String:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jobject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (![jobject isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *jdeck = (NSDictionary *)jobject;
    
    CDXCardDeck *cardDeck = [[[CDXCardDeck alloc] init] autorelease];
    
    // name
    cardDeck.name = [CDXCardDeckJSONSerializer dictionary:jdeck stringForKey:@"name" defaultsTo:@"?"];
    // default_card
    NSDictionary *jdefaultcard = [CDXCardDeckJSONSerializer dictionary:jdeck dictionaryForKey:@"default_card" defaultsTo:nil];
    if (jdefaultcard != nil) {
        CDXCard *card = [CDXCardDeckJSONSerializer cardFromDictionary:(NSDictionary *)jdefaultcard cardDeck:cardDeck];
        cardDeck.cardDefaults = card;
    }
    // cards
    NSArray *jcards = [CDXCardDeckJSONSerializer dictionary:jdeck arrayForKey:@"cards" defaultsTo:@[]];
    for (id jcardsElement in jcards) {
        if (![jcardsElement isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        CDXCard *card = [CDXCardDeckJSONSerializer cardFromDictionary:(NSDictionary *)jcardsElement cardDeck:cardDeck];
        [cardDeck addCard:card];
    }
    
    return cardDeck;
}

+ (NSString *)version2StringFromCardDeck:(CDXCardDeck *)cardDeck {
    // no serialization; only deserialization for now
    return nil;
}

@end

