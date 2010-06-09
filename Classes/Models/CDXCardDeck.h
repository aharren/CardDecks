//
//
// CDXCardDeck.h
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

#import "CDXCard.h"
#import "CDXCardDeckBase.h"


typedef enum {
    CDXCardDeckDisplayStyleSideBySide = 0,
    CDXCardDeckDisplayStyleStack,
    CDXCardDeckDisplayStyleSwipeStack,
    CDXCardDeckDisplayStyleCount,
    CDXCardDeckDisplayStyleDefault = 0
} CDXCardDeckDisplayStyle;


typedef enum {
    CDXCardDeckGroupSizeNoGroups = 0,
    CDXCardDeckGroupSizeMax = 12,
    CDXCardDeckGroupSizeCount,
    CDXCardDeckGroupSizeDefault = 0
} CDXCardDeckGroupSize;


@interface CDXCardDeck : CDXCardDeckBase<NSCopying> {
    
@protected
    CDXCard *cardDefaults;

    NSMutableArray *cards;
    
    BOOL wantsPageControl;
    BOOL wantsPageJumps;
    BOOL wantsAutoRotate;
    BOOL wantsShakeShuffle;
    CDXCardDeckGroupSize groupSize;
    
    CDXCardDeckDisplayStyle displayStyle;
    CDXCardCornerStyle cornerStyle;

    BOOL isShuffled;
    NSMutableArray *shuffleIndexes;
}

@property (nonatomic, retain) CDXCard *cardDefaults;

- (NSUInteger)cardsIndex:(NSUInteger)index;
- (CDXCard *)cardAtCardsIndex:(NSUInteger)cardsIndex;

- (CDXCard *)cardAtIndex:(NSUInteger)index;
- (CDXCard *)cardAtIndex:(NSUInteger)index orCard:(CDXCard *)card;
- (void)addCard:(CDXCard *)card;
- (void)removeCardAtIndex:(NSUInteger)index;
- (void)replaceCardAtIndex:(NSUInteger)index withCard:(CDXCard *)card;
- (void)moveCardAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@property (nonatomic, assign) BOOL wantsPageControl;
@property (nonatomic, assign) BOOL wantsPageJumps;
@property (nonatomic, assign) BOOL wantsAutoRotate;
@property (nonatomic, assign) BOOL wantsShakeShuffle;
@property (nonatomic, assign) CDXCardDeckGroupSize groupSize;

@property (nonatomic, assign) CDXCardDeckDisplayStyle displayStyle;
@property (nonatomic, assign) CDXCardCornerStyle cornerStyle;
- (void)setFontSize:(CGFloat)aFontSize;

@property (nonatomic, readonly) BOOL isShuffled;
@property (nonatomic, copy) NSMutableArray *shuffleIndexes;
- (void)shuffle;
- (void)sort;

- (CDXCard *)cardWithDefaults;

@end

