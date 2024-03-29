//
//
// CDXCardsViewProtocols.h
//
//
// Copyright (c) 2009-2021 Arne Harren <ah@0xc0.de>
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


@protocol CDXCardsViewDataSource

@required
- (NSUInteger)cardsViewDataSourceCardsCount;
- (CDXCard *)cardsViewDataSourceCardAtIndex:(NSUInteger)index;
- (NSUInteger)cardsViewDataSourceInitialCardIndex;

@end


@protocol CDXCardsViewDelegate

@required
- (void)cardsViewDelegateTapRecognized:(UITapGestureRecognizer *)sender tapCount:(NSUInteger)tapCount;
- (void)cardsViewDelegateCurrentCardIndexHasChangedTo:(NSUInteger)index;

@end


@protocol CDXCardsViewView

@required
- (id)initWithFrame:(CGRect)rect;
- (void)setViewDelegate:(id<CDXCardsViewDelegate>)delegate;
- (void)setViewDataSource:(id<CDXCardsViewDataSource>)dataSource;
- (void)showCardAtIndex:(NSUInteger)index;
- (void)showCardAtIndex:(NSUInteger)index tellDelegate:(BOOL)tellDelegate;
- (void)invalidateDataSourceCaches;
- (NSUInteger)currentCardIndex;
- (void)deviceOrientationDidChange:(UIDeviceOrientation)orientation;
- (void)setDeviceOrientation:(UIDeviceOrientation)orientation;
- (UIDeviceOrientation)deviceOrientation;

@end

