//
//
// CDXColor.h
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


// A color which consists of red-green-blue values (no alpha yet).
@interface CDXColor : NSObject {
    
@protected
    unsigned int _red;
    unsigned int _green;
    unsigned int _blue;
    
}

@property (nonatomic, readonly) unsigned int red;
@property (nonatomic, readonly) unsigned int green;
@property (nonatomic, readonly) unsigned int blue;

- (UIColor *)uiColor;
- (NSString *)rgbString;

+ (CDXColor *)cdxColorWithRed:(unsigned int)red green:(unsigned int)green blue:(unsigned int)blue;
+ (CDXColor *)cdxColorWithRGBString:(NSString *)string defaulsTo:(CDXColor *)defaultColor;

+ (CDXColor *)blackColor;
+ (CDXColor *)whiteColor;

@end

