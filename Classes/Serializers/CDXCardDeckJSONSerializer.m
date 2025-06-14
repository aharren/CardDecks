//
//
// CDXCardDeckJSONSerializer.m
//
//
// Copyright (c) 2009-2025 Arne Harren <ah@0xc0.de>
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
#import "CDXOrderedSerializerDictionary.h"
#import "CDXEnumSerializerUtils.h"


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

+ (NSString *)stringOnOffFromBool:(BOOL)value {
    return value ? @"on" : @"off";
}

static const NSUInteger cardOrientationsCount = (NSUInteger)CDXCardOrientationCount;
static NSString *cardOrientations[cardOrientationsCount] = {
    [CDXCardOrientationUp] = @"up",
    [CDXCardOrientationRight] = @"right",
    [CDXCardOrientationDown] = @"down",
    [CDXCardOrientationLeft] = @"left"
};

+ (CDXCardOrientation)cardOrientationFromString:(NSString *)string defaultsTo:(CDXCardOrientation)defaultOrientation {
    return (CDXCardOrientation) [CDXEnumSerializerUtils array:cardOrientations size:cardOrientationsCount valueFromString:string defaultsTo:(NSUInteger)defaultOrientation];
}

+ (NSString *)stringFromCardOrientation:(CDXCardOrientation)cardOrientation {
    return [CDXEnumSerializerUtils array:cardOrientations size:cardOrientationsCount stringFromValue:(NSUInteger)cardOrientation defaultsTo:cardOrientations[CDXCardOrientationDefault]];
}

static const NSUInteger cornerStylesCount = (NSUInteger)CDXCardCornerStyleCount;
static NSString *cornerStyles[cornerStylesCount] = {
    [CDXCardCornerStyleRounded] = @"rounded",
    [CDXCardCornerStyleCornered] = @"cornered"
};

+ (CDXCardCornerStyle)cornerStyleFromString:(NSString *)string defaultsTo:(CDXCardCornerStyle)defaultStyle {
    return (CDXCardCornerStyle) [CDXEnumSerializerUtils array:cornerStyles size:cornerStylesCount valueFromString:string defaultsTo:(NSUInteger)defaultStyle];
}

+ (NSString *)stringFromCornerStyle:(CDXCardCornerStyle)cornerStyle {
    return [CDXEnumSerializerUtils array:cornerStyles size:cornerStylesCount stringFromValue:(NSUInteger)cornerStyle defaultsTo:cornerStyles[CDXCardCornerStyleDefault]];
}

static const NSUInteger displayStylesCount = (NSUInteger)CDXCardDeckDisplayStyleCount;
static NSString *displayStyles[displayStylesCount] = {
    [CDXCardDeckDisplayStyleSideBySide] = @"side-by-side,scroll",
    [CDXCardDeckDisplayStyleStack] = @"stacked,scroll",
    [CDXCardDeckDisplayStyleSwipeStack] = @"stacked,swipe"
};

+ (CDXCardDeckDisplayStyle)displayStyleFromString:(NSString *)string defaultsTo:(CDXCardDeckDisplayStyle)defaultStyle {
    return (CDXCardDeckDisplayStyle) [CDXEnumSerializerUtils array:displayStyles size:displayStylesCount valueFromString:string defaultsTo:(NSUInteger)defaultStyle];
}

+ (NSString *)stringFromDisplayStyle:(CDXCardDeckDisplayStyle)displayStyle {
    return [CDXEnumSerializerUtils array:displayStyles size:displayStylesCount stringFromValue:(NSUInteger)displayStyle defaultsTo:displayStyles[CDXCardDeckDisplayStyleDefault]];
}

static const NSUInteger pageControlStylesCount = (NSUInteger)CDXCardDeckPageControlStyleCount;
static NSString *pageControlStyles[pageControlStylesCount] = {
    [CDXCardDeckPageControlStyleLight] = @"light",
    [CDXCardDeckPageControlStyleDark] = @"dark"
};

+ (CDXCardDeckPageControlStyle)pageControlStyleFromString:(NSString *)string defaultsTo:(CDXCardDeckPageControlStyle)defaultStyle {
    return (CDXCardDeckPageControlStyle) [CDXEnumSerializerUtils array:pageControlStyles size:pageControlStylesCount valueFromString:string defaultsTo:(NSUInteger)defaultStyle];
}

+ (NSString *)stringFromPageControlStyle:(CDXCardDeckPageControlStyle)pageControlStyle {
    return [CDXEnumSerializerUtils array:pageControlStyles size:pageControlStylesCount stringFromValue:(NSUInteger)pageControlStyle defaultsTo:pageControlStyles[CDXCardDeckPageControlStyleDefault]];
}

static const NSUInteger shakeActionsCount = (NSUInteger)CDXCardDeckShakeActionCount;
static NSString *shakeActions[shakeActionsCount] = {
    [CDXCardDeckShakeActionNone] = @"off",
    [CDXCardDeckShakeActionRandom] = @"random",
    [CDXCardDeckShakeActionShuffle] = @"shuffle"
};

+ (CDXCardDeckShakeAction)shakeActionFromString:(NSString *)string defaultsTo:(CDXCardDeckShakeAction)defaultAction {
    return (CDXCardDeckShakeAction) [CDXEnumSerializerUtils array:shakeActions size:shakeActionsCount valueFromString:string defaultsTo:(NSUInteger)defaultAction];
}

+ (NSString *)stringFromShakeAction:(CDXCardDeckShakeAction)shakeAction {
    return [CDXEnumSerializerUtils array:shakeActions size:shakeActionsCount stringFromValue:(NSUInteger)shakeAction defaultsTo:shakeActions[CDXCardDeckShakeActionDefault]];
}

static const NSUInteger autoPlaysCount = (NSUInteger)CDXCardDeckAutoPlayCount;
static NSString *autoPlays[autoPlaysCount] = {
    [CDXCardDeckAutoPlayOff] = @"off",
    [CDXCardDeckAutoPlayPlay] = @"play1x",
    [CDXCardDeckAutoPlayPlay2] = @"play5x"
};

+ (CDXCardDeckAutoPlay)autoPlayFromString:(NSString *)string defaultsTo:(CDXCardDeckAutoPlay)defaultAutoPlay {
    return (CDXCardDeckAutoPlay) [CDXEnumSerializerUtils array:autoPlays size:autoPlaysCount valueFromString:string defaultsTo:(NSUInteger)defaultAutoPlay];
}

+ (NSString *)stringFromAutoPlay:(CDXCardDeckAutoPlay)autoPlay {
    return [CDXEnumSerializerUtils array:autoPlays size:autoPlaysCount stringFromValue:(NSUInteger)autoPlay defaultsTo:autoPlays[CDXCardDeckAutoPlayDefault]];
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
        card.textColor = [CDXColor colorWithRGBAString:jstring defaultsTo:card.textColor prefix:@"#"];
    }
    // background_color
    jstring = [CDXCardDeckJSONSerializer dictionary:jcard stringForKey:@"background_color" defaultsTo:nil];
    if (jstring != nil) {
        card.backgroundColor = [CDXColor colorWithRGBAString:jstring defaultsTo:card.backgroundColor prefix:@"#"];
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

+ (CDXCardDeck *)cardDeckFromVersion2Dictionary:(NSDictionary *)jdeck {
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
    NSDictionary *jcardDefaults = [CDXCardDeckJSONSerializer dictionary:jdeck dictionaryForKey:@"default_card" defaultsTo:nil];
    if (jcardDefaults != nil) {
        CDXCard *card = [CDXCardDeckJSONSerializer cardFromDictionary:(NSDictionary *)jcardDefaults cardDeck:cardDeck];
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

+ (CDXCardDeck *)cardDeckFromString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jobject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (![jobject isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *jdeck = (NSDictionary *)jobject;
    NSNumber* jnumber = nil;
    
    jnumber = [CDXCardDeckJSONSerializer dictionary:jdeck numberForKey:@"version" defaultsTo:nil];
    if (jnumber == nil) {
        return nil;
    }
    int version = [CDXCardDeckJSONSerializer intFromDouble:[jnumber doubleValue]];

    if (version == 2) {
        return [CDXCardDeckJSONSerializer cardDeckFromVersion2Dictionary:jdeck];
    }
    return nil;
}

+ (NSDictionary *)version2DictionaryFromCard:(CDXCard *)card cardDefaults:(CDXCard *)cardDefaults {
    NSMutableDictionary *dictionary = [[[CDXOrderedSerializerDictionary alloc] init] autorelease];
    // text
    if (!cardDefaults || ![card.text isEqualToString:cardDefaults.text]) {
        [dictionary setObject:card.text forKey:@"text"];
    }
    // text_color
    if (!cardDefaults || ![card.textColor isEqual:cardDefaults.textColor]) {
        [dictionary setObject:[card.textColor rgbaStringWithPrefix:@"#"] forKey:@"text_color"];
    }
    // background_color
    if (!cardDefaults || ![card.backgroundColor isEqual:cardDefaults.backgroundColor]) {
        [dictionary setObject:[card.backgroundColor rgbaStringWithPrefix:@"#"] forKey:@"background_color"];
    }
    // orientation
    if (!cardDefaults || card.orientation != cardDefaults.orientation) {
        [dictionary setObject:[CDXCardDeckJSONSerializer stringFromCardOrientation:card.orientation] forKey:@"orientation"];
    }
    // font_size
    if (!cardDefaults || card.fontSize != cardDefaults.fontSize) {
        [dictionary setObject:@((NSUInteger)card.fontSize) forKey:@"font_size"];
    }
    // timer
    if (!cardDefaults || card.timerInterval != cardDefaults.timerInterval) {
        [dictionary setObject:@((NSUInteger)card.timerInterval) forKey:@"timer"];
    }
    
    return dictionary;
}

+ (NSDictionary *)version2DictionaryFromCardDeck:(CDXCardDeck *)cardDeck {
    NSMutableDictionary *dictionary = [[[CDXOrderedSerializerDictionary alloc] init] autorelease];
    
    // version
    [dictionary setObject:@(2) forKey:@"version"];
    // name
    [dictionary setObject:cardDeck.name forKey:@"name"];
    // group_size
    [dictionary setObject:@(cardDeck.groupSize) forKey:@"group_size"];
    // deck_style
    [dictionary setObject:[CDXCardDeckJSONSerializer stringFromDisplayStyle:cardDeck.displayStyle] forKey:@"deck_style"];
    // corner_style
    [dictionary setObject:[CDXCardDeckJSONSerializer stringFromCornerStyle:cardDeck.cornerStyle] forKey:@"corner_style"];
    // index_dots
    [dictionary setObject:[CDXCardDeckJSONSerializer stringOnOffFromBool:cardDeck.wantsPageControl] forKey:@"index_dots"];
    // index_style
    [dictionary setObject:[CDXCardDeckJSONSerializer stringFromPageControlStyle:cardDeck.pageControlStyle] forKey:@"index_style"];
    // index_touches
    [dictionary setObject:[CDXCardDeckJSONSerializer stringOnOffFromBool:cardDeck.wantsPageJumps] forKey:@"index_touches"];
    // auto_rotate
    [dictionary setObject:[CDXCardDeckJSONSerializer stringOnOffFromBool:cardDeck.wantsAutoRotate] forKey:@"auto_rotate"];
    // shake
    [dictionary setObject:[CDXCardDeckJSONSerializer stringFromShakeAction:cardDeck.shakeAction] forKey:@"shake"];
    // auto_play
    [dictionary setObject:[CDXCardDeckJSONSerializer stringFromAutoPlay:cardDeck.autoPlay] forKey:@"auto_play"];
    
    // default_card
    CDXCard *cardDefaults = cardDeck.cardDefaults;
    [dictionary setObject:[CDXCardDeckJSONSerializer version2DictionaryFromCard:cardDefaults cardDefaults:nil] forKey:@"default_card"];
    
    // cards
    NSUInteger cardsCount = [cardDeck cardsCount];
    NSMutableArray *cards = [NSMutableArray arrayWithCapacity:cardsCount];
    for (NSUInteger i=0; i < cardsCount; i++) {
        [cards addObject:[CDXCardDeckJSONSerializer version2DictionaryFromCard:[cardDeck cardAtCardsIndex:i] cardDefaults:cardDefaults]];
    }
    [dictionary setObject:cards forKey:@"cards"];
    
    return dictionary;
}

+ (NSString *)version2StringFromCardDeck:(CDXCardDeck *)cardDeck {
    NSDictionary *dictionary = [CDXCardDeckJSONSerializer version2DictionaryFromCardDeck:cardDeck];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

@end

