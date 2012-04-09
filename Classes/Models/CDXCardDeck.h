//
//
// CDXCardDeck.h
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

#import "CDXCard.h"
#import "CDXCardDeckBase.h"
#import "CDXStorage.h"


typedef enum {
    CDXCardDeckShakeActionNone = 0,
    CDXCardDeckShakeActionShuffle,
    CDXCardDeckShakeActionRandom,
    CDXCardDeckShakeActionCount,
    CDXCardDeckShakeActionDefault = CDXCardDeckShakeActionShuffle
} CDXCardDeckShakeAction;


typedef enum {
    CDXCardDeckDisplayStyleSideBySide = 0,
    CDXCardDeckDisplayStyleStack,
    CDXCardDeckDisplayStyleSwipeStack,
    CDXCardDeckDisplayStyleCount,
    CDXCardDeckDisplayStyleDefault = CDXCardDeckDisplayStyleSideBySide
} CDXCardDeckDisplayStyle;


typedef enum {
    CDXCardDeckGroupSizeNoGroups = 0,
    CDXCardDeckGroupSizeMax = 12,
    CDXCardDeckGroupSizeCount,
    CDXCardDeckGroupSizeDefault = CDXCardDeckGroupSizeNoGroups
} CDXCardDeckGroupSize;


typedef enum {
    CDXCardDeckPageControlStyleLight = 0,
    CDXCardDeckPageControlStyleDark = 1,
    CDXCardDeckPageControlStyleCount,
    CDXCardDeckPageControlStyleDefault = CDXCardDeckPageControlStyleLight
} CDXCardDeckPageControlStyle;

typedef enum {
    CDXCardDeckAutoPlayOff = 0,
    CDXCardDeckAutoPlayPlay,
    CDXCardDeckAutoPlayPlay2,
    CDXCardDeckAutoPlayCount,
    CDXCardDeckAutoPlayDefault = CDXCardDeckAutoPlayOff
} CDXCardDeckAutoPlay;


#define CDXCardDeckUpdateNotification @"CDXCardDeckUpdateNotification"


@interface CDXCardDeck : CDXCardDeckBase<NSCopying, CDXStorageObject> {
    
@protected
    CDXCard *cardDefaults;
    
    NSMutableArray *cards;
    
    BOOL wantsPageControl;
    BOOL wantsPageJumps;
    BOOL wantsAutoRotate;
    CDXCardDeckShakeAction shakeAction;
    CDXCardDeckAutoPlay autoPlay;
    CDXCardDeckGroupSize groupSize;
    
    CDXCardDeckDisplayStyle displayStyle;
    CDXCardCornerStyle cornerStyle;
    CDXCardDeckPageControlStyle pageControlStyle;
    
    BOOL isShuffled;
    NSMutableArray *shuffleIndexes;
}

@property (nonatomic, retain) CDXCard *cardDefaults;

- (NSUInteger)cardsIndex:(NSUInteger)index;
- (CDXCard *)cardAtCardsIndex:(NSUInteger)cardsIndex;

- (CDXCard *)cardAtIndex:(NSUInteger)index;
- (CDXCard *)cardAtIndex:(NSUInteger)index orCard:(CDXCard *)card;
- (void)addCard:(CDXCard *)card;
- (void)addCardsFromCardDeck:(CDXCardDeck *)cardDeck;
- (void)removeCardAtIndex:(NSUInteger)index;
- (void)replaceCardAtIndex:(NSUInteger)index withCard:(CDXCard *)card;
- (void)moveCardAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@property (nonatomic, assign) BOOL wantsPageControl;
@property (nonatomic, assign) BOOL wantsPageJumps;
@property (nonatomic, assign) BOOL wantsAutoRotate;
@property (nonatomic, assign) CDXCardDeckShakeAction shakeAction;
@property (nonatomic, assign) CDXCardDeckGroupSize groupSize;

@property (nonatomic, assign) CDXCardDeckDisplayStyle displayStyle;
@property (nonatomic, assign) CDXCardCornerStyle cornerStyle;
@property (nonatomic, assign) CDXCardDeckPageControlStyle pageControlStyle;
@property (nonatomic, assign) CDXCardDeckAutoPlay autoPlay;

- (void)setFontSize:(CGFloat)fontSize;
- (void)setOrientation:(CDXCardOrientation)orientation;
- (void)setTextColor:(CDXColor *)textColor;
- (void)setBackgroundColor:(CDXColor *)backgroundColor;
- (void)setTimerInterval:(NSTimeInterval)timerInterval;

@property (nonatomic, readonly) BOOL isShuffled;
@property (nonatomic, copy) NSMutableArray *shuffleIndexes;
- (void)shuffle;
- (void)sort;

- (CDXCard *)cardWithDefaults;

+ (CDXCardDeck *)cardDeckFromStorageObjectNamed:(NSString *)file;
- (void)updateStorageObjectDeferred:(BOOL)deferred;

@end

