//
//
// CDXTextRenderingContext.h
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


// A text rendering context contains data about how a text gets rendered.
@interface CDXTextRenderingContext : NSObject {
    
@protected
    // size data
    CGFloat _width;
    CGFloat _height;
    
    NSUInteger _rowCount;
    CGFloat _rowHeight;
    
    // font data
    CGFloat _fontSize;
}

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) NSUInteger rowCount;
@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, assign) CGFloat fontSize;

+ (CDXTextRenderingContext *)contextForText:(NSArray *)text font:(UIFont *)font width:(CGFloat)width height:(CGFloat)height;

@end

