//
//
// CDXColorKeyboardExtensionViewController.m
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

#import "CDXColorKeyboardExtensionViewController.h"
#import "CDXColorKeyboardExtension.h"


@implementation CDXColorKeyboardExtensionViewController

#define LogFileComponent lcl_cCDXColorKeyboardExtension

@synthesize toolbar = _toolbar;

@synthesize simpleButton = _simpleButton;
@synthesize textButton = _textButton;
@synthesize backgroundButton = _backgroundButton;

@synthesize colorChooserSimpleView = _colorChooserSimpleView;

@synthesize colorChooserRGBView = _colorChooserRGBView;
@synthesize colorChooserRGBSliderRed = _colorChooserRGBSliderRed;
@synthesize colorChooserRGBSliderGreen = _colorChooserRGBSliderGreen;
@synthesize colorChooserRGBSliderBlue = _colorChooserRGBSliderBlue;

typedef struct {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
} CDXColorRGB;

static CDXColorRGB colorChooserSimpleColors[] = {
    { 255,   0,   0 },
    { 255,   0, 255 },
    {   0,   0,   0 },
    
    { 255, 255,   0 },
    {   0,   0, 255 },
    { 128, 128, 128 },
    
    {   0, 255,   0 },
    {   0, 255, 255 },
    { 255, 255, 255 },
    
    { 255, 255, 255 },
    { 255, 255, 255 }
};

- (void)dealloc {
    LogInvocation();
    
    self.toolbar = nil;
    
    self.simpleButton = nil;
    self.textButton = nil;
    self.backgroundButton = nil;
    
    self.colorChooserSimpleView = nil;
    
    self.colorChooserRGBView = nil;
    self.colorChooserRGBSliderRed = nil;
    self.colorChooserRGBSliderGreen = nil;
    self.colorChooserRGBSliderBlue = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    LogInvocation();
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [[CDXKeyboardExtensions sharedInstance] backgroundColor];
    
    [self simpleButtonPressed];
}

- (void)viewDidUnload {
    LogInvocation();
    
    self.toolbar = nil;
    
    self.simpleButton = nil;
    self.textButton = nil;
    self.backgroundButton = nil;
    
    self.colorChooserSimpleView = nil;
    
    self.colorChooserRGBView = nil;
    self.colorChooserRGBSliderRed = nil;
    self.colorChooserRGBSliderGreen = nil;
    self.colorChooserRGBSliderBlue = nil;
    
    [super viewDidUnload];
}

+ (CDXColorKeyboardExtensionViewController *)colorKeyboardExtensionViewController {
    LogInvocation();
    
    CDXColorKeyboardExtensionViewController *controller = [[[CDXColorKeyboardExtensionViewController alloc] initWithNibName:@"CDXColorKeyboardExtensionView" bundle:nil] autorelease];
    return controller;
}

- (void)setView:(UIView *)view button:(UIBarButtonItem *)button {
    _simpleButton.style = UIBarButtonItemStyleBordered;
    _textButton.style = UIBarButtonItemStyleBordered;
    _backgroundButton.style = UIBarButtonItemStyleBordered;
    
    [_colorChooserSimpleView removeFromSuperview];
    [_colorChooserRGBView removeFromSuperview];
    
    button.style = UIBarButtonItemStyleDone;
    [self.view addSubview:view];
    CGRect frame = view.frame;
    frame.origin.y = _toolbar.frame.origin.y + _toolbar.frame.size.height;
    view.frame = frame;
}

- (CDXColor *)colorChooserRGBSliderValues {
    return [CDXColor cdxColorWithRed:_colorChooserRGBSliderRed.value
                               green:_colorChooserRGBSliderGreen.value
                                blue:_colorChooserRGBSliderBlue.value];
}

- (void)setColorChooserRGBSliderValues:(CDXColor *)color {
    _colorChooserRGBSliderRed.value = color.red;
    _colorChooserRGBSliderGreen.value = color.green;
    _colorChooserRGBSliderBlue.value = color.blue;
}

- (void)postColorUpdate:(CDXColor *)color textNotBackground:(BOOL)textNotBackground {
    NSObject *responder = [[CDXKeyboardExtensions sharedInstance] responder];
    if ([responder conformsToProtocol:@protocol(CDXColorKeyboardExtensionProtocol)]) {
        NSObject <CDXColorKeyboardExtensionProtocol> *r = (NSObject <CDXColorKeyboardExtensionProtocol> *)responder;
        if (textNotBackground) {
            [r setTextCDXColor:color];
        } else {
            [r setBackgroundCDXColor:color];
        }
    }
}

- (IBAction)simpleButtonPressed {
    [self setView:_colorChooserSimpleView button:_simpleButton];
}

- (IBAction)textButtonPressed {
    [self setView:_colorChooserRGBView button:_textButton];
    
    NSObject *responder = [[CDXKeyboardExtensions sharedInstance] responder];
    if ([responder conformsToProtocol:@protocol(CDXColorKeyboardExtensionProtocol)]) {
        NSObject <CDXColorKeyboardExtensionProtocol> *r = (NSObject <CDXColorKeyboardExtensionProtocol> *)responder;
        [self setColorChooserRGBSliderValues:[r textCDXColor]];
    } else {
        [self setColorChooserRGBSliderValues:[CDXColor blackColor]];
    }
    
}

- (IBAction)backgroundButtonPressed {
    [self setView:_colorChooserRGBView button:_backgroundButton];
    
    NSObject *responder = [[CDXKeyboardExtensions sharedInstance] responder];
    if ([responder conformsToProtocol:@protocol(CDXColorKeyboardExtensionProtocol)]) {
        NSObject <CDXColorKeyboardExtensionProtocol> *obj = (NSObject <CDXColorKeyboardExtensionProtocol> *)responder;
        [self setColorChooserRGBSliderValues:[obj backgroundCDXColor]];
    } else {
        [self setColorChooserRGBSliderValues:[CDXColor blackColor]];
    }
}

- (IBAction)colorChooserRGBSliderValueChanged {
    [self postColorUpdate:[self colorChooserRGBSliderValues] textNotBackground:_textButton.style == UIBarButtonItemStyleDone];
}

- (IBAction)colorChooserSimpleValueSelected:(id)sender {
    LogInvocation();
    
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    CDXColorRGB colorRGB = colorChooserSimpleColors[tag % 10];
    CDXColor *color = [CDXColor cdxColorWithRed:colorRGB.red green:colorRGB.green blue:colorRGB.blue];
    
    [self postColorUpdate:color textNotBackground:tag % 20 < 10];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if (tag % 10 == 8) {
        button.backgroundColor = [UIColor blackColor];
    } else {
        button.backgroundColor = [UIColor whiteColor];
    }
    
    button.backgroundColor = [color uiColor];
    [UIView commitAnimations];
}

@end

