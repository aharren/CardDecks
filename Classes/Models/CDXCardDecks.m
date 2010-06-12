//
//
// CDXCardDecks.m
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

#import "CDXCardDecks.h"
#import "CDXCardDecksDictionarySerializer.h"
#import "CDXDictionarySerializerUtils.h"

#undef ql_component
#define ql_component lcl_cCDXModel


@implementation CDXCardDecks

@synthesize file;
@synthesize cardDeckDefaults;

- (id)init {
    if ((self = [super init])) {
        ivar_assign(cardDeckDefaults, [[CDXCardDeck alloc] init]);
        ivar_assign(cardDecks, [[NSMutableArray alloc] init]);
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(cardDecks);
    [super dealloc];
}

- (CDXCardDeckBase *)cardDeckDefaults {
    qltrace();
    CDXCardDeck *deck = cardDeckDefaults.cardDeck;
    if (deck == nil) {
        deck = [[[CDXCardDeck alloc] init] autorelease];
        deck.file = cardDeckDefaults.file;
        [deck updateStorageObjectDeferred:NO];
    }
    return cardDeckDefaults;
}

- (NSUInteger)cardDecksCount {
    return [cardDecks count];
}

- (CDXCardDeckBase *)cardDeckAtIndex:(NSUInteger)index {
    return (CDXCardDeckBase *)[cardDecks objectAtIndex:index];
}

- (void)addCardDeck:(CDXCardDeckBase *)cardDeck {
    [cardDecks addObject:cardDeck];
}

- (void)insertCardDeck:(CDXCardDeckBase *)cardDeck atIndex:(NSUInteger)index {
    if (index >= [cardDecks count]) {
        [cardDecks addObject:cardDeck];
    } else {
        [cardDecks insertObject:cardDeck atIndex:index];
    }
}

- (void)removeCardDeckAtIndex:(NSUInteger)index {
    [cardDecks removeObjectAtIndex:index];
}

- (CDXCardDeckBase *)cardDeckWithDefaults {
    return [[[CDXCardDeckBase alloc] initWithCardDeck:[[cardDeckDefaults.cardDeck copy] autorelease]] autorelease];
}

- (NSString *)storageObjectName {
    return file;
}

- (NSDictionary *)storageObjectAsDictionary {
    return [CDXCardDecksDictionarySerializer dictionaryFromCardDecks:self];
}

+ (CDXCardDecks *)cardDecksFromStorageObjectNamed:(NSString *)file version:(NSUInteger *)version {
    NSDictionary *dictionary = [CDXStorage readDictionaryFromFile:file];
    if (dictionary == nil) {
        return nil;
    }
    if (version) {
        *version = [CDXDictionarySerializerUtils unsignedIntegerFromDictionary:dictionary forKey:@"VERSION" defaultsTo:0];
    }
    
    CDXCardDecks *cardDecks = [CDXCardDecksDictionarySerializer cardDecksFromDictionary:dictionary];
    cardDecks.file = file;
    return cardDecks;
}

- (void)updateStorageObjectDeferred:(BOOL)deferred {
    [CDXStorage updateStorageObject:self deferred:deferred];
}

@end

