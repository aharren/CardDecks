//
//
// CDXCardDecksDictionarySerializer.m
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

#import "CDXCardDecksDictionarySerializer.h"
#import "CDXDictionarySerializerUtils.h"


@implementation CDXCardDecksDictionarySerializer


+ (CDXCardDecks *)cardDecksFromDictionary:(NSDictionary *)dictionary {
    NSUInteger version = [CDXDictionarySerializerUtils unsignedIntegerFromDictionary:dictionary forKey:@"VERSION" defaultsTo:1];
    switch (version) {
        default:
            return [CDXCardDecksDictionarySerializer cardDecksFromVersion1Dictionary:dictionary];
            break;
        case 2:
            return [CDXCardDecksDictionarySerializer cardDecksFromVersion2Dictionary:dictionary];
            break;
    }
}

+ (CDXCardDecks *)cardDecksFromVersion1Dictionary:(NSDictionary *)dictionary {
    CDXCardDecks *dDecks = [[[CDXCardDecks alloc] init] autorelease];
    
    NSArray *deckDictionaries = (NSArray *)[dictionary objectForKey:@"CardDecks"];
    for (NSDictionary *deckDictionary in deckDictionaries) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        CDXCardDeckBase *dDeck = [[[CDXCardDeckBase alloc] init] autorelease];
        
        dDeck.name = [CDXDictionarySerializerUtils stringFromDictionary:deckDictionary forKey:@"Name" defaultsTo:@""];
        dDeck.file = [CDXDictionarySerializerUtils stringFromDictionary:deckDictionary forKey:@"File" defaultsTo:@""];
        
        [dDecks addCardDeck:dDeck];
        
        [pool release];
    }
    
    return dDecks;
}

+ (CDXCardDecks *)cardDecksFromVersion2Dictionary:(NSDictionary *)dictionary {
    return nil;
}

+ (NSDictionary *)dictionaryFromCardDecks:(CDXCardDecks *)cardDecks {
    return [CDXCardDecksDictionarySerializer version2DictionaryFromCardDecks:cardDecks];
}

+ (NSDictionary *)version2DictionaryFromCardDecks:(CDXCardDecks *)cardDecks {
    return nil;
}

@end

