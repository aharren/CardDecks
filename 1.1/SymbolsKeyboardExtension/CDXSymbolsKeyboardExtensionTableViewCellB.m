//
//
// CDXSymbolsKeyboardExtensionTableViewCellB.m
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

#import "CDXSymbolsKeyboardExtensionTableViewCellB.h"


@implementation CDXSymbolsKeyboardExtensionTableViewCellB

#define LogFileComponent lcl_cCDXSymbolsKeyboardExtension

@synthesize button1 = _button1;
@synthesize button2 = _button2;
@synthesize button3 = _button3;
@synthesize button4 = _button4;
@synthesize button5 = _button5;
@synthesize button6 = _button6;
@synthesize button7 = _button7;

- (id)init {
    LogInvocation();
    
    if ((self = [super init])) {
        // nothing to do
    }
    
    return self;
}

- (void)dealloc {
    LogInvocation();
    
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.button5 = nil;
    self.button6 = nil;
    self.button7 = nil;
    
    [super dealloc];
}

- (void)buttonPressed:(id)sender {
    LogInvocation();
    
    UIButton *button = (UIButton *)sender;
    
    // paste the button's symbol to the responder
    NSObject *responder = (NSObject *)[[CDXKeyboardExtensions sharedInstance] responder];
    if ([responder respondsToSelector:@selector(paste:)]) {
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        NSArray* pasteboardItems = [[pasteboard.items copy] autorelease];
    
        pasteboard.string = button.titleLabel.text;
        [responder paste:self];
    
        pasteboard.items = pasteboardItems;
    }
}

- (void)configureWithBlock:(CDXSymbolsKeyboardExtensionBlockStruct *)block offset:(NSInteger)offset {
    LogInvocation();
    
    NSInteger c = block->startCode + offset;
    LogDebug(@"%d", c);
    
    [_button1 setTitle:[NSString stringWithFormat:@"%C", (unichar)c] forState:UIControlStateNormal];
    [_button2 setTitle:[NSString stringWithFormat:@"%C", (unichar)c+1] forState:UIControlStateNormal];
    [_button3 setTitle:[NSString stringWithFormat:@"%C", (unichar)c+2] forState:UIControlStateNormal];
    [_button4 setTitle:[NSString stringWithFormat:@"%C", (unichar)c+3] forState:UIControlStateNormal];
    [_button5 setTitle:[NSString stringWithFormat:@"%C", (unichar)c+4] forState:UIControlStateNormal];
    [_button6 setTitle:[NSString stringWithFormat:@"%C", (unichar)c+5] forState:UIControlStateNormal];
    [_button7 setTitle:[NSString stringWithFormat:@"%C", (unichar)c+6] forState:UIControlStateNormal];
}

@end

