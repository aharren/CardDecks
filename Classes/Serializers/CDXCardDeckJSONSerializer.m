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

+ (BOOL)boolFromOnOffString:(NSString *)string defaultsTo:(BOOL)defaultsTo {
    string = [string lowercaseString];
    if ([@"on" isEqualToString:string]) {
        return YES;
    } else if ([@"off" isEqualToString:string]) {
        return NO;
    } else {
        return defaultsTo;
    }
}

+ (CDXCardOrientation)cardOrientationFromString:(NSString *)string defaultsTo:(CDXCardOrientation)defaultOrientation {
    // valid orientations are 'u', 'r', 'd', and 'l', everything else maps to given default orientation
    string = [string lowercaseString];
    if ([@"right" isEqualToString:string]) {
        return CDXCardOrientationRight;
    } else if ([@"down" isEqualToString:string]) {
        return CDXCardOrientationDown;
    } else if ([@"left" isEqualToString:string]) {
        return CDXCardOrientationLeft;
    } else if ([@"up" isEqualToString:string]) {
        return CDXCardOrientationUp;
    } else {
        return defaultOrientation;
    }
}

+ (CDXCardCornerStyle)cornerStyleFromString:(NSString *)string defaultsTo:(CDXCardCornerStyle)defaultStyle {
    string = [string lowercaseString];
    if ([@"cornered" isEqualToString:string]) {
        return CDXCardCornerStyleCornered;
    } else if ([@"rounded" isEqualToString:string]) {
        return CDXCardCornerStyleRounded;
    } else {
        return defaultStyle;
    }
}

+ (CDXCardDeckDisplayStyle)displayStyleFromString:(NSString *)string defaultsTo:(CDXCardDeckDisplayStyle)defaultStyle {
    string = [string lowercaseString];
    if ([@"side-by-side,scroll" isEqualToString:string]) {
        return CDXCardDeckDisplayStyleSideBySide;
    } else if ([@"stacked,scroll" isEqualToString:string]) {
        return CDXCardDeckDisplayStyleStack;
    } else if ([@"stacked,swipe" isEqualToString:string]) {
        return CDXCardDeckDisplayStyleSwipeStack;
    } else {
        return defaultStyle;
    }
}

+ (CDXCardDeckPageControlStyle)pageControlStyleFromString:(NSString *)string defaultsTo:(CDXCardDeckPageControlStyle)defaultStyle {
    string = [string lowercaseString];
    if ([@"dark" isEqualToString:string]) {
        return CDXCardDeckPageControlStyleDark;
    } else if ([@"light" isEqualToString:string]) {
        return CDXCardDeckPageControlStyleLight;
    } else {
        return defaultStyle;
    }
}

+ (CDXCardDeckShakeAction)shakeActionFromString:(NSString *)string defaultsTo:(CDXCardDeckShakeAction)defaultAction {
    string = [string lowercaseString];
    if ([@"off" isEqualToString:string]) {
        return CDXCardDeckShakeActionNone;
    } else if ([@"random" isEqualToString:string]) {
        return CDXCardDeckShakeActionRandom;
    } else if ([@"shuffle" isEqualToString:string]) {
        return CDXCardDeckShakeActionShuffle;
    } else {
        return defaultAction;
    }
}

+ (CDXCardDeckAutoPlay)autoPlayFromString:(NSString *)string defaultsTo:(CDXCardDeckAutoPlay)defaultAutoPlay {
    string = [string lowercaseString];
    if ([@"off" isEqualToString:string]) {
        return CDXCardDeckAutoPlayOff;
    } else if ([@"play1x" isEqualToString:string]) {
        return CDXCardDeckAutoPlayPlay;
    } else if ([@"play5x" isEqualToString:string]) {
        return CDXCardDeckAutoPlayPlay2;
    } else {
        return defaultAutoPlay;
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
        card.orientation = [CDXCardDeckJSONSerializer cardOrientationFromString:jstring defaultsTo:card.orientation];
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
    NSString* jstring = nil;
    NSNumber* jnumber = nil;
    
    // name
    cardDeck.name = [CDXCardDeckJSONSerializer dictionary:jdeck stringForKey:@"name" defaultsTo:@"?"];
    // group_size
    jnumber = [CDXCardDeckJSONSerializer dictionary:jdeck numberForKey:@"group_size" defaultsTo:nil];
    if (jnumber != nil) {
        cardDeck.groupSize = [CDXCardDeckJSONSerializer intFromDouble:[jnumber doubleValue]];
    }
    // deck_style
    jstring = [CDXCardDeckJSONSerializer dictionary:jdeck stringForKey:@"deck_style" defaultsTo:nil];
    if (jstring != nil) {
        cardDeck.displayStyle = [CDXCardDeckJSONSerializer displayStyleFromString:jstring defaultsTo:cardDeck.displayStyle];
    }
    // corner_style
    jstring = [CDXCardDeckJSONSerializer dictionary:jdeck stringForKey:@"corner_style" defaultsTo:nil];
    if (jstring != nil) {
        cardDeck.cornerStyle = [CDXCardDeckJSONSerializer cornerStyleFromString:jstring defaultsTo:cardDeck.cornerStyle];
    }
    // index_dots
    jstring = [CDXCardDeckJSONSerializer dictionary:jdeck stringForKey:@"index_dots" defaultsTo:nil];
    if (jstring != nil) {
        cardDeck.wantsPageControl = [CDXCardDeckJSONSerializer boolFromOnOffString:jstring defaultsTo:cardDeck.wantsPageControl];
    }
    // index_style
    jstring = [CDXCardDeckJSONSerializer dictionary:jdeck stringForKey:@"index_style" defaultsTo:nil];
    if (jstring != nil) {
        cardDeck.pageControlStyle = [CDXCardDeckJSONSerializer pageControlStyleFromString:jstring defaultsTo:cardDeck.pageControlStyle];
    }
    // index_touches
    jstring = [CDXCardDeckJSONSerializer dictionary:jdeck stringForKey:@"index_touches" defaultsTo:nil];
    if (jstring != nil) {
        cardDeck.wantsPageJumps = [CDXCardDeckJSONSerializer boolFromOnOffString:jstring defaultsTo:cardDeck.wantsPageJumps];
    }
    // auto_rotate
    jstring = [CDXCardDeckJSONSerializer dictionary:jdeck stringForKey:@"auto_rotate" defaultsTo:nil];
    if (jstring != nil) {
        cardDeck.wantsAutoRotate = [CDXCardDeckJSONSerializer boolFromOnOffString:jstring defaultsTo:cardDeck.wantsAutoRotate];
    }
    // shake
    jstring = [CDXCardDeckJSONSerializer dictionary:jdeck stringForKey:@"shake" defaultsTo:nil];
    if (jstring != nil) {
        cardDeck.shakeAction = [CDXCardDeckJSONSerializer shakeActionFromString:jstring defaultsTo:cardDeck.shakeAction];
    }
    // auto_play
    jstring = [CDXCardDeckJSONSerializer dictionary:jdeck stringForKey:@"auto_play" defaultsTo:nil];
    if (jstring != nil) {
        cardDeck.autoPlay = [CDXCardDeckJSONSerializer autoPlayFromString:jstring defaultsTo:cardDeck.autoPlay];
    }
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

