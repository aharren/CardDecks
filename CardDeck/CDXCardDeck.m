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

@synthesize committed = _committed;
@synthesize dirty = _dirty;

@synthesize file = _file;

- (id)init {
    LogInvocation();
    
    if ((self = [super init])) {
        _cards = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithContentsOfDictionary:(NSDictionary *)dictionary {
    LogInvocation();
    
    if ((self = [super init])) {
        LogDebug(@"dictionary %@", dictionary);
        
        self.name = (NSString *)[dictionary objectForKey:@"Name"];
        
        self.defaultTextColor = [CDXColor cdxColorWithRGBString:(NSString *)[dictionary objectForKey:@"DefaultTextColor"] defaulsTo:[CDXColor blackColor]];
        self.defaultBackgroundColor = [CDXColor cdxColorWithRGBString:(NSString *)[dictionary objectForKey:@"DefaultBackgroundColor"] defaulsTo:[CDXColor whiteColor]];
        
        NSArray *array = (NSArray *)[dictionary objectForKey:@"Cards"];
        if (array != nil) {
            NSUInteger numberOfItems = [array count];
            _cards = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
            
            for (NSUInteger i=0; i<numberOfItems; i++) {
                [_cards addObject:[CDXCard cardWithContentsOfDictionary:(NSDictionary *)[array objectAtIndex:i]]];
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
    [_file release];
    [_cards release];
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

+ (CDXCardDeck *)cardDeckWithContentsOfDictionary:(NSDictionary *)dictionary {
    LogInvocation();
    
    return [[[CDXCardDeck alloc] initWithContentsOfDictionary:dictionary] autorelease]; 
}

@end

