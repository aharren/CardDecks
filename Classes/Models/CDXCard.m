//
//
// CDXCard.m
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


@implementation CDXCard

@synthesize text;
@synthesize textColor;
@synthesize backgroundColor;
@synthesize orientation;
@synthesize cornerStyle;

- (id)init {
    if ((self = [super init])) {
        ivar_assign_and_copy(text, @"");
        ivar_assign_and_retain(textColor, [CDXColor colorWhite]);
        ivar_assign_and_retain(backgroundColor, [CDXColor colorBlack]);
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(text);
    ivar_release_and_clear(textColor);
    ivar_release_and_clear(backgroundColor);
    [super dealloc];
}

- (void)setText:(NSString *)aText {
    // canonicalize linebreaks to \n
    ivar_assign_and_copy(text, [aText stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"]);
}

- (CGFloat)fontSizeConstrainedToSize:(CGSize)size {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray *textLines = [text componentsSeparatedByString:@"\n"];
    NSUInteger textLinesCount = [textLines count];
    size.height = size.height / textLinesCount;
    
    CGFloat minFontSize = 400.0;
    UIFont *font = [UIFont systemFontOfSize:floor(minFontSize)];
    
    // calculate the minimal font size based on all text lines
    for (NSString *textLine in textLines) {
        // use a single space for an empty line
        if ([@"" isEqualToString:textLine]) {
            textLine = @" ";
        }
        
        CGFloat fontSize;
        {
            UIFont *fontWithMinFontSize = [font fontWithSize:floor(minFontSize)];
            [textLine sizeWithFont:fontWithMinFontSize minFontSize:12 actualFontSize:&fontSize forWidth:size.width lineBreakMode:UILineBreakModeClip];
        }
        
        CGSize lineSize;
        {
            UIFont *fontWithFontSize = [font fontWithSize:floor(fontSize)];
            lineSize = [textLine sizeWithFont:fontWithFontSize constrainedToSize:size];
        }
        
        if (lineSize.height > size.height) {
            fontSize = fontSize / lineSize.height * size.height;
            UIFont *fontWithFontSize = [font fontWithSize:floor(fontSize)];
            [textLine sizeWithFont:fontWithFontSize minFontSize:12 actualFontSize:&fontSize forWidth:size.width lineBreakMode:UILineBreakModeClip];
        }
        
        minFontSize = MIN(minFontSize, fontSize);
    }
    
    [pool release];
    return floor(minFontSize);
}

@end

