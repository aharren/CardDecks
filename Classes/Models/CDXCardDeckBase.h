//
//
// CDXCardDeckBase.h
//
//
// Copyright (c) 2009-2014 Arne Harren <ah@0xc0.de>
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

#import "CDXColor.h"


@class CDXCardDeck;
@class CDXCardDecks;


@interface CDXCardDeckBase : NSObject {
    
@protected
    CDXCardDeckBase *base;
    CDXCardDeck *cardDeck;
    
    NSString *name;
    NSString *description;
    
    NSString *file;
    
    CDXColor *thumbnailColor;
    NSUInteger cardsCount;
    
    NSInteger tag;
}

@property (nonatomic, readonly) CDXCardDeckBase *base;
@property (nonatomic, readonly) CDXCardDeck *cardDeck;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *file;

@property (nonatomic, retain) CDXColor *thumbnailColor;
@property (nonatomic, assign) NSUInteger cardsCount;

@property (nonatomic, assign) NSInteger tag;

- (id)init;
- (id)initWithCardDeck:(CDXCardDeck *)cardDeck;

- (void)linkBase:(CDXCardDeckBase *)base;
- (void)unlinkBase;
- (void)linkCardDeck;
- (void)unlinkCardDeck;

@end

