//
//
// CDXCardDeck.h
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

#import "CDXCard.h"


// A card deck consists of a name, some default values, and a list of cards.
@interface CDXCardDeck : NSObject <CDXStorageable> {
    
@protected
    // the real data
    NSString *_name;
    CDXColor *_defaultTextColor;
    CDXColor *_defaultBackgroundColor;
    NSMutableArray *_cards;
    
    // editing state
    BOOL _committed;
    BOOL _dirty;
    
    // storage data
    NSString *_file;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) CDXColor *defaultTextColor;
@property (nonatomic, retain) CDXColor *defaultBackgroundColor;
@property (nonatomic, retain) NSMutableArray *cards;

@property (nonatomic, assign) BOOL committed;
@property (nonatomic, assign) BOOL dirty;

@property (nonatomic, retain) NSString *file;

- (id)init;
- (id)initWithContentsOfDictionary:(NSDictionary *)dictionary cards:(BOOL)cards colors:(BOOL)colors;

- (NSUInteger)cardsCount;
- (CDXCard *)cardAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfCard:(CDXCard *)card;
- (void)addCard:(CDXCard *)card;
- (void)insertCard:(CDXCard *)card atIndex:(NSUInteger)index;
- (void)removeCardAtIndex:(NSUInteger)index;

- (void)removeUncommittedCards;

- (NSString *)storageName;
- (NSDictionary *)stateAsDictionary;

+ (CDXCardDeck *)cardDeckWithContentsOfDictionary:(NSDictionary *)dictionary cards:(BOOL)cards colors:(BOOL)colors;

- (NSArray *)stateAsURLComponents;
+ (CDXCardDeck *)cardDeckWithContentsOfURLComponents:(NSArray *)urlComponents;

@end

