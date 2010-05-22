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


typedef enum {
    CDXCardDeckDisplayStyleSideBySide = 0,
    CDXCardDeckDisplayStyleStack,
    CDXCardDeckDisplayStyleSwipeStack,
    CDXCardDeckDisplayStyleCount,
    CDXCardDeckDisplayStyleDefault = 0
} CDXCardDeckDisplayStyle;


@interface CDXCardDeck : NSObject {
    
@protected
    NSString *name;
    NSString *description;
    
    CDXColor *defaultCardTextColor;
    CDXColor *defaultCardBackgroundColor;
    CDXCardOrientation defaultCardOrientation;
    
    NSMutableArray *cards;
    
    BOOL wantsPageControl;
    BOOL wantsAutoRotate;
    BOOL wantsShakeRandom;
    BOOL wantsIdleTimer;
    
    CDXCardDeckDisplayStyle displayStyle;
    CDXCardCornerStyle cornerStyle;
    CGFloat fontSize;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) NSString *description;
@property (nonatomic, retain) CDXColor *defaultCardTextColor;
@property (nonatomic, retain) CDXColor *defaultCardBackgroundColor;
@property (nonatomic, assign) CDXCardOrientation defaultCardOrientation;

- (NSUInteger)cardsCount;
- (CDXCard *)cardAtIndex:(NSUInteger)index;
- (CDXCard *)cardAtIndex:(NSUInteger)index orCard:(CDXCard *)card;
- (void)addCard:(CDXCard *)card;
- (void)insertCard:(CDXCard *)card atIndex:(NSUInteger)index;
- (void)removeCardAtIndex:(NSUInteger)index;

@property (nonatomic, assign) BOOL wantsPageControl;
@property (nonatomic, assign) BOOL wantsAutoRotate;
@property (nonatomic, assign) BOOL wantsShakeRandom;
@property (nonatomic, assign) BOOL wantsIdleTimer;

@property (nonatomic, assign) CDXCardDeckDisplayStyle displayStyle;
@property (nonatomic, assign) CDXCardCornerStyle cornerStyle;
@property (nonatomic, assign) CGFloat fontSize;

- (CDXCard *)cardWithDefaults;

@end

