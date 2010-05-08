//
//
// CDXCardsStackView.h
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

#import "CDXCardDeck.h"
#import "CDXCardsViewProtocols.h"
#import "CDXObjectCache.h"


@class CDXCardsStackViewScrollView;
@class CDXCardsStackViewScrollViewDelegate;

enum {
    CDXCardsStackViewCardImagesSize = 3
};

enum {
    CDXCardsStackViewCardViewsTopLeft = 0,
    CDXCardsStackViewCardViewsTopRight,
    CDXCardsStackViewCardViewsMiddle,
    CDXCardsStackViewCardViewsBottom,
    CDXCardsStackViewCardViewsSize
};

enum {
    CDXCardsStackViewScrollViewDirectionNone = 0,
    CDXCardsStackViewScrollViewDirectionRightIn,
    CDXCardsStackViewScrollViewDirectionLeftOut
};

@interface CDXCardsStackView : UIView<CDXCardsViewView> {
    
@protected
    CDXCardsStackViewScrollView *scrollView;
    CDXCardsStackViewScrollViewDelegate *scrollViewDelegate;
    CGFloat scrollViewPageWidth;
    NSUInteger scrollViewDirection;
    
    CDXObjectCache *cardImages;
    
    UIImageView *cardViewsView[CDXCardsStackViewCardViewsSize];
    CGFloat cardViewsBorder;
    CGSize cardViewsSize;
    
    id<CDXCardsViewDelegate> viewDelegate;
    id<CDXCardsViewDataSource> viewDataSource;
    
    NSUInteger cardsCount;
    NSUInteger currentCardIndex;
}

- (id)initWithFrame:(CGRect)rect;

@property (nonatomic, assign) id<CDXCardsViewDelegate> viewDelegate;
@property (nonatomic, assign) id<CDXCardsViewDataSource> viewDataSource;

@end

