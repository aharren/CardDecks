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
#define ql_component lcl_cModel


@implementation CDXCardDeckHolder

- (id)init {
    qltrace();
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithCardDeck:(CDXCardDeck *)aCardDeck {
    qltrace();
    if ((self = [super initWithCardDeck:aCardDeck])) {
    }
    return self;
}

- (void)dealloc {
    qltrace();
    [super dealloc];
}

+ (id)cardDeckHolderWithCardDeck:(CDXCardDeck *)cardDeck {
    qltrace();
    return [[[CDXCardDeckHolder alloc] initWithCardDeck:cardDeck] autorelease];
}

@end


@implementation CDXCardDecks

@synthesize file;
@synthesize cardDeckDefaults;

- (id)init {
    qltrace();
    if ((self = [super init])) {
        ivar_assign(cardDeckDefaults, [[CDXCardDeckHolder alloc] init]);
        ivar_assign(cardDecks, [[NSMutableArray alloc] init]);
        ivar_assign(pendingCardDeckAdds, [[NSMutableArray alloc] initWithCapacity:0])
    }
    return self;
}

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(file);
    ivar_release_and_clear(cardDeckDefaults);
    ivar_release_and_clear(cardDecks);
    ivar_release_and_clear(pendingCardDeckAdds);
    [super dealloc];
}

- (CDXCardDeckHolder *)cardDeckDefaults {
    qltrace();
    if (![CDXStorage existsFile:cardDeckDefaults.file]) {
        qltrace(@"recreate defaults file %@", cardDeckDefaults.file);
        CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
        deck.file = cardDeckDefaults.file;
        [deck updateStorageObjectDeferred:NO];
        [self updateStorageObjectDeferred:YES];
    }
    return cardDeckDefaults;
}

- (NSUInteger)cardDecksCount {
    return [cardDecks count];
}

- (CDXCardDeckHolder *)cardDeckAtIndex:(NSUInteger)index {
    return (CDXCardDeckHolder *)[cardDecks objectAtIndex:index];
}

- (void)addCardDeck:(CDXCardDeckHolder *)cardDeck {
    [cardDecks addObject:cardDeck];
}

- (void)insertCardDeck:(CDXCardDeckHolder *)cardDeck atIndex:(NSUInteger)index {
    if (index >= [cardDecks count]) {
        [cardDecks addObject:cardDeck];
    } else {
        [cardDecks insertObject:cardDeck atIndex:index];
    }
}

- (void)removeCardDeckAtIndex:(NSUInteger)index {
    [cardDecks removeObjectAtIndex:index];
}

- (NSUInteger)indexOfCardDeck:(CDXCardDeckHolder *)cardDeck {
    NSUInteger index = [cardDecks indexOfObject:cardDeck];
    if (index != NSNotFound) {
        return index;
    }
    return 0;
}

- (CDXCardDeckHolder *)cardDeckWithDefaults {
    return [[[CDXCardDeckHolder alloc] initWithCardDeck:[[[self cardDeckDefaults].cardDeck copy] autorelease]] autorelease];
}

- (void)addPendingCardDeckAdd:(CDXCardDeckHolder *)aCardDeck {
    [pendingCardDeckAdds addObject:aCardDeck];
}

- (BOOL)hasPendingCardDeckAdds {
    return [pendingCardDeckAdds count] != 0;
}

- (CDXCardDeckHolder *)popPendingCardDeckAdd {
    if (![self hasPendingCardDeckAdds]) {
        return nil;
    } else {
        CDXCardDeckHolder *object = (CDXCardDeckHolder *)[pendingCardDeckAdds objectAtIndex:0];
        [object retain];
        [pendingCardDeckAdds removeObjectAtIndex:0];
        [object autorelease];
        return object;
    }
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

