//
//
// CDXCard.h
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

#import "CDXTextRenderingContext.h"


// A card which has a text, a text color, and a background color.
@interface CDXCard : NSObject {
    
@protected
    // the real data
    NSString *_text;
    CDXColor *_textColor;
    CDXColor *_backgroundColor;
    
    // editing state
    BOOL _committed;
    BOOL _dirty;
    
    // rendering data
    CDXTextRenderingContext *_standardRenderingContextPortrait;
    CDXTextRenderingContext *_standardRenderingContextLandscape;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) CDXColor *textColor;
@property (nonatomic, retain) CDXColor *backgroundColor;

@property (nonatomic, assign) BOOL committed;
@property (nonatomic, assign) BOOL dirty;

@property (nonatomic, retain) CDXTextRenderingContext *standardRenderingContextPortrait;
@property (nonatomic, retain) CDXTextRenderingContext *standardRenderingContextLandscape;

- (id)init;
- (id)initWithContentsOfDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)stateAsDictionary;

+ (CDXCard *)cardWithContentsOfDictionary:(NSDictionary *)dictionary;

- (CDXTextRenderingContext *)renderingContextPortraitForFont:(UIFont *)font width:(CGFloat)width height:(CGFloat)height text:(NSArray *)text cached:(BOOL)cached standard:(BOOL)standard;
- (CDXTextRenderingContext *)renderingContextLandscapeForFont:(UIFont *)font width:(CGFloat)width height:(CGFloat)height text:(NSArray *)text cached:(BOOL)cached standard:(BOOL)standard;

@end

