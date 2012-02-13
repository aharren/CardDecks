//
//
// CDXCardDecks.h
//
//
// Copyright (c) 2009-2012 Arne Harren <ah@0xc0.de>
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
#import "CDXStorage.h"


@interface CDXCardDeckHolder : CDXCardDeckBase {
    
}

- (id)init;
- (id)initWithCardDeck:(CDXCardDeck *)cardDeck;

+ (id)cardDeckHolderWithCardDeck:(CDXCardDeck *)cardDeck;

@end


@interface CDXCardDecks : NSObject<CDXStorageObject> {
    
@protected
    NSString *file;
    CDXCardDeckHolder *cardDeckDefaults;
    NSMutableArray *cardDecks;
    
    NSMutableArray *pendingCardDeckAdds;
}

@property (nonatomic, copy) NSString *file;
@property (nonatomic, retain) CDXCardDeckHolder *cardDeckDefaults;

- (NSUInteger)cardDecksCount;
- (CDXCardDeckHolder *)cardDeckAtIndex:(NSUInteger)index;
- (void)addCardDeck:(CDXCardDeckHolder *)cardDeck;
- (void)insertCardDeck:(CDXCardDeckHolder *)cardDeck atIndex:(NSUInteger)index;
- (void)removeCardDeckAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfCardDeck:(CDXCardDeckHolder *)cardDeck;

- (CDXCardDeckHolder *)cardDeckWithDefaults;

- (void)addPendingCardDeckAdd:(CDXCardDeckHolder *)cardDeck;
- (BOOL)hasPendingCardDeckAdds;
- (CDXCardDeckHolder *)popPendingCardDeckAdd;

+ (CDXCardDecks *)cardDecksFromStorageObjectNamed:(NSString *)file version:(NSUInteger *)version;
- (void)updateStorageObjectDeferred:(BOOL)deferred;

@end

