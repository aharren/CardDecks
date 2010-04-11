//
//
// CDXColor.h
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


@interface CDXColor : NSObject {
    
@protected
    uint8_t red;
    uint8_t green;
    uint8_t blue;
    uint8_t alpha;
    
}

@property (nonatomic, readonly) uint8_t red;
@property (nonatomic, readonly) uint8_t green;
@property (nonatomic, readonly) uint8_t blue;
@property (nonatomic, readonly) uint8_t alpha;

- (NSString *)rgbaString;
- (UIColor *)uiColor;

- (BOOL)isEqual:(id)anObject;
- (NSString *)description;

+ (CDXColor *)colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue alpha:(uint8_t)alpha;
+ (CDXColor *)colorWithRGBAString:(NSString *)string defaulsTo:(CDXColor *)defaultColor;

+ (CDXColor *)colorWhite;
+ (CDXColor *)colorBlack;

@end

