//
//
// CDXTextRenderingContext.m
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


@implementation CDXTextRenderingContext

@synthesize width = _width;
@synthesize height = _height;

@synthesize rowCount = _rowCount;
@synthesize rowHeight = _rowHeight;

@synthesize fontSize = _fontSize;

+ (CDXTextRenderingContext *)contextForText:(NSArray *)textLines font:(UIFont *)font width:(CGFloat)width height:(CGFloat)height {
    CGFloat minFontSize = 400.0;
    NSUInteger textLinesCount = [textLines count];
    
    CGSize maxLineSize;
    maxLineSize.height = height / textLinesCount;
    maxLineSize.width = width-23;
    
    // calculate the minimal font size based on all text lines
    for (NSString *textLine in textLines) {
        CGFloat fontSize;
        [textLine sizeWithFont:[font fontWithSize:minFontSize] minFontSize:12 actualFontSize:&fontSize forWidth:maxLineSize.width lineBreakMode:UILineBreakModeClip];
        CGSize lineSize = [textLine sizeWithFont:[font fontWithSize:fontSize] constrainedToSize:maxLineSize];
        
        if (lineSize.height > maxLineSize.height) {
            fontSize = fontSize / lineSize.height * maxLineSize.height;
            [textLine sizeWithFont:[font fontWithSize:fontSize] minFontSize:12 actualFontSize:&fontSize forWidth:maxLineSize.width lineBreakMode:UILineBreakModeClip];
        }
        
        minFontSize = MIN(minFontSize, fontSize);
    }
    
    // create the context object
    CDXTextRenderingContext *context = [[[CDXTextRenderingContext alloc] init] autorelease];
    context.fontSize = floor(minFontSize);
    context.rowCount = textLinesCount;
    context.rowHeight = floor([@"Pp" sizeWithFont:[font fontWithSize:context.fontSize]].height)+1;
    context.width = width;
    context.height = MIN(height, context.rowHeight * textLinesCount);
    
    return context;
}

@end

