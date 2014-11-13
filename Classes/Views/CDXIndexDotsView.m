//
//
// CDXIndexDotsView.m
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

#import "CDXIndexDotsView.h"


@implementation CDXIndexDotsView

@synthesize numberOfPages;
@synthesize currentPage;
@synthesize invisibleByDefault;
@synthesize style;

#define CDXIndexDotsViewAlphaVisible 1
#define CDXIndexDotsViewAlphaInvisible 0

#define CDXIndexDotsViewDotAlphaWhite 0.7
#define CDXIndexDotsViewDotAlphaBlack 0.25
#define CDXIndexDotsViewDotAlphaHightlighted 1

#define CDXIndexDotsViewDotDistance 16
#define CDXIndexDotsViewDotWidth 6

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(imageDot);
    ivar_release_and_clear(imageDotHighlighted);
    [super dealloc];
}

- (void)setStyle:(CDXIndexDotsViewStyle)newStyle {
    style = newStyle;
    switch (style) {
        default:
        case CDXIndexDotsViewStyleLight:
            ivar_assign_and_retain(imageDot, [UIImage imageNamed:@"IndexDotGray"]);
            imageDotAlpha = CDXIndexDotsViewDotAlphaWhite;
            ivar_assign_and_retain(imageDotHighlighted, [UIImage imageNamed:@"IndexDotWhite"]);
            imageDotAlphaHighlighted = CDXIndexDotsViewDotAlphaHightlighted;
            break;
        case CDXIndexDotsViewStyleDark:
            ivar_assign_and_retain(imageDot, [UIImage imageNamed:@"IndexDotGray"]);
            imageDotAlpha = CDXIndexDotsViewDotAlphaBlack;
            ivar_assign_and_retain(imageDotHighlighted, [UIImage imageNamed:@"IndexDotBlack"]);
            imageDotAlphaHighlighted = CDXIndexDotsViewDotAlphaHightlighted;
            break;
    }
}

- (void)setNumberOfPages:(NSUInteger)newNumberOfPages {
    numberOfPages = newNumberOfPages;
    
    NSUInteger width =  self.frame.size.width;
    NSUInteger maxNumberOfVisiblePages = width / CDXIndexDotsViewDotDistance;
    NSUInteger numberOfVisiblePages;
    if (numberOfPages > maxNumberOfVisiblePages) {
        firstVisiblePage = (numberOfPages - maxNumberOfVisiblePages) / 2;
        lastVisiblePage = firstVisiblePage + maxNumberOfVisiblePages - 1;
        numberOfVisiblePages = maxNumberOfVisiblePages;
    } else {
        firstVisiblePage = 0;
        lastVisiblePage = numberOfPages - 1;
        numberOfVisiblePages = numberOfPages;
    }
    NSUInteger left = (width - numberOfVisiblePages * CDXIndexDotsViewDotDistance) / 2 + 2;
    for (NSUInteger i = 0; i  < numberOfVisiblePages; i++) {
        UIImageView *view = [[UIImageView alloc] initWithImage:imageDot highlightedImage:imageDotHighlighted];
        view.frame = CGRectMake(left + i * CDXIndexDotsViewDotDistance + CDXIndexDotsViewDotWidth/2, 0, CDXIndexDotsViewDotWidth, CDXIndexDotsViewDotWidth);
        view.highlighted = NO;
        view.alpha = imageDotAlpha;
        [self addSubview:view];
        [view release];
    }
}

- (void)setCurrentPage:(NSUInteger)newCurrentPage animated:(BOOL)animated {
    if (currentPage >= firstVisiblePage && currentPage <= lastVisiblePage) {
        UIImageView *view = [self subviews][currentPage-firstVisiblePage];
        view.highlighted = NO;
        view.alpha = imageDotAlpha;
    }
    currentPage = newCurrentPage;
    if (currentPage >= firstVisiblePage && currentPage <= lastVisiblePage) {
        UIImageView *view = [self subviews][currentPage-firstVisiblePage];
        view.highlighted = YES;
        view.alpha = imageDotAlphaHighlighted;
    }
}

- (void)setInvisibleByDefault:(BOOL)newInvisibleByDefault {
    invisibleByDefault = newInvisibleByDefault;
    self.alpha = invisibleByDefault ? CDXIndexDotsViewAlphaInvisible : CDXIndexDotsViewAlphaVisible;
}

@end

