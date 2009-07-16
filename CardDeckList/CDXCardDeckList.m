//
//
// CDXCardDeckList.m
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

#import "CDXCardDeckList.h"


@implementation CDXCardDeckList

#define LogFileComponent lcl_cCDXCardDeckList

@synthesize file = _file;

- (id)init {
    LogInvocation();
    
    if ((self = [super init])) {
        _cardDecks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithContentsOfDictionary:(NSDictionary *)dictionary {
    LogInvocation();
    
    if ((self = [super init])) {
        LogDebug(@"dictionary %@", dictionary);
        
        NSArray *array = (NSArray *)[dictionary objectForKey:@"CardDecks"];
        
        NSUInteger numberOfItems = [array count];
        _cardDecks = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
        
        for (NSUInteger i=0; i<numberOfItems; i++) {
            CDXCardDeck *cardDeck = [CDXCardDeck cardDeckWithContentsOfDictionary:(NSDictionary *)[array objectAtIndex:i]];
            if (cardDeck.file != nil) {
                [_cardDecks addObject:cardDeck];
            }
        }
    }
    return self;
}

- (NSUInteger)cardDecksCount {
    LogInvocation();
    
    return [_cardDecks count];
}

- (CDXCardDeck *)cardDeckAtIndex:(NSUInteger)index {
    LogInvocation();
    
    return (CDXCardDeck *)[_cardDecks objectAtIndex:index];
}

- (NSUInteger)indexOfCardDeck:(CDXCardDeck *)cardDeck {
    LogInvocation();
    
    return [_cardDecks indexOfObject:cardDeck];
}

- (void)insertCardDeck:(CDXCardDeck *)cardDeck atIndex:(NSUInteger)index {
    LogInvocation(@"%d", index);
    
    if (index >= [_cardDecks count]) {
        [_cardDecks addObject:cardDeck];
    } else {
        [_cardDecks insertObject:cardDeck atIndex:index];
    }
}

- (void)removeCardDeckAtIndex:(NSUInteger)index {
    LogInvocation(@"%d", index);
    
    [_cardDecks removeObjectAtIndex:index];
}

- (NSString *)storageName {
    LogInvocation();
    
    return self.file;
}

- (NSDictionary *)stateAsDictionary {
    LogInvocation();
    
    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSUInteger numberOfItems = [_cardDecks count];
    NSMutableArray *cardDecks = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
    for (NSUInteger i=0; i<numberOfItems; i++) {
        CDXCardDeck *cardDeck = (CDXCardDeck *)[_cardDecks objectAtIndex:i];
        if (cardDeck.committed) {
            [cardDecks addObject:[cardDeck stateAsDictionary]];
        }
    }
    [dictionary setValue:cardDecks forKey:@"CardDecks"];
    [cardDecks release];
    
    return dictionary;
}

+ (CDXCardDeckList *)cardDeckListWithContentsOfDictionary:(NSDictionary *)dictionary {
    LogInvocation();
    
    return [[[CDXCardDeckList alloc] initWithContentsOfDictionary:dictionary] autorelease];     
}

@end

