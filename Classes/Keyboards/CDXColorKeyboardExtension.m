//
//
// CDXColorKeyboardExtension.m
//
//
// Copyright (c) 2009-2011 Arne Harren <ah@0xc0.de>
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

#import "CDXColorKeyboardExtension.h"


@implementation CDXColorKeyboardExtension

synthesize_singleton(sharedColorKeyboardExtension, CDXColorKeyboardExtension);

- (void)dealloc {
    ivar_release_and_clear(viewController);
    [super dealloc];
}

- (void)keyboardExtensionInitialize {
}

- (NSString *)keyboardExtensionTitle {
    return @"rgb";
}

- (UIView *)keyboardExtensionView {
    if (viewController == nil) {
        ivar_assign(viewController, [[CDXColorKeyboardExtensionViewController alloc] init]);
    }
    
    return viewController.view;
}

- (void)keyboardExtensionWillBecomeActive {
    [self keyboardExtensionView];
    [viewController viewWillAppear:NO];
}

- (void)keyboardExtensionDidBecomeActive {
    [viewController viewDidAppear:NO];
}

- (void)keyboardExtensionWillBecomeInactive {
    [viewController viewWillDisappear:NO];
}

- (void)keyboardExtensionDidBecomeInactive {
    [viewController viewDidDisappear:NO];
}

@end


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

@implementation CDXColorKeyboardExtensionViewController

- (void)dealloc {
    ivar_release_and_clear(toolbar);
    ivar_release_and_clear(simpleButton);
    ivar_release_and_clear(textButton);
    ivar_release_and_clear(backgroundButton);
    ivar_release_and_clear(colorChooserSimpleView);
    ivar_release_and_clear(colorChooserRGBView);
    ivar_release_and_clear(colorChooserRGBSliderRed);
    ivar_release_and_clear(colorChooserRGBSliderGreen);
    ivar_release_and_clear(colorChooserRGBSliderBlue);
    ivar_release_and_clear(colorChooserRGBSliderAlpha);
    ivar_release_and_clear(colorChooserRGBSliderRedLabel);
    ivar_release_and_clear(colorChooserRGBSliderGreenLabel);
    ivar_release_and_clear(colorChooserRGBSliderBlueLabel);
    ivar_release_and_clear(colorChooserRGBSliderAlphaLabel);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[CDXKeyboardExtensions sharedKeyboardExtensions] backgroundColor];
    [self simpleButtonPressed];
}

- (void)viewDidUnload {
    ivar_release_and_clear(toolbar);
    ivar_release_and_clear(simpleButton);
    ivar_release_and_clear(textButton);
    ivar_release_and_clear(backgroundButton);
    ivar_release_and_clear(colorChooserSimpleView);
    ivar_release_and_clear(colorChooserRGBView);
    ivar_release_and_clear(colorChooserRGBSliderRed);
    ivar_release_and_clear(colorChooserRGBSliderGreen);
    ivar_release_and_clear(colorChooserRGBSliderBlue);
    ivar_release_and_clear(colorChooserRGBSliderAlpha);
    ivar_release_and_clear(colorChooserRGBSliderRedLabel);
    ivar_release_and_clear(colorChooserRGBSliderGreenLabel);
    ivar_release_and_clear(colorChooserRGBSliderBlueLabel);
    ivar_release_and_clear(colorChooserRGBSliderAlphaLabel);
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateView];
}

- (void)setView:(UIView *)view button:(UIBarButtonItem *)button {
    simpleButton.enabled = YES;
    textButton.enabled = YES;
    backgroundButton.enabled = YES;
    
    [colorChooserSimpleView removeFromSuperview];
    [colorChooserRGBView removeFromSuperview];
    
    button.enabled = NO;
    [self.view addSubview:view];
    CGRect frame = view.frame;
    frame.origin.y = toolbar.frame.origin.y + toolbar.frame.size.height;
    view.frame = frame;
}

- (CDXColor *)colorChooserRGBSliderValues {
    return [CDXColor colorWithRed:colorChooserRGBSliderRed.value
                            green:colorChooserRGBSliderGreen.value
                             blue:colorChooserRGBSliderBlue.value
                            alpha:colorChooserRGBSliderAlpha.value];
}

- (void)setColorChooserRGBSliderValues:(CDXColor *)color {
    colorChooserRGBSliderRed.value = color.red;
    colorChooserRGBSliderGreen.value = color.green;
    colorChooserRGBSliderBlue.value = color.blue;
    colorChooserRGBSliderAlpha.value = color.alpha;
    colorChooserRGBSliderRedLabel.text = [NSString stringWithFormat:@"%02X", color.red];
    colorChooserRGBSliderGreenLabel.text = [NSString stringWithFormat:@"%02X", color.green];
    colorChooserRGBSliderBlueLabel.text = [NSString stringWithFormat:@"%02X", color.blue];
    colorChooserRGBSliderAlphaLabel.text = [NSString stringWithFormat:@"%02X", color.alpha];
}

- (void)updateView {
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if (!textButton.enabled) {    
        if ([responder conformsToProtocol:@protocol(CDXColorKeyboardExtensionResponder)]) {
            NSObject <CDXColorKeyboardExtensionResponder> *r = (NSObject <CDXColorKeyboardExtensionResponder> *)responder;
            [self setColorChooserRGBSliderValues:[r colorKeyboardExtensionTextColor]];
        } else {
            [self setColorChooserRGBSliderValues:[CDXColor colorBlack]];
        }
    } else if (!backgroundButton.enabled) {
        if ([responder conformsToProtocol:@protocol(CDXColorKeyboardExtensionResponder)]) {
            NSObject <CDXColorKeyboardExtensionResponder> *r = (NSObject <CDXColorKeyboardExtensionResponder> *)responder;
            [self setColorChooserRGBSliderValues:[r colorKeyboardExtensionBackgroundColor]];
        } else {
            [self setColorChooserRGBSliderValues:[CDXColor colorBlack]];
        }
    }
}

- (void)postColorUpdate:(CDXColor *)color textNotBackground:(BOOL)textNotBackground {
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if ([responder conformsToProtocol:@protocol(CDXColorKeyboardExtensionResponder)]) {
        NSObject <CDXColorKeyboardExtensionResponder> *r = (NSObject <CDXColorKeyboardExtensionResponder> *)responder;
        if (textNotBackground) {
            [r colorKeyboardExtensionSetTextColor:color];
        } else {
            [r colorKeyboardExtensionSetBackgroundColor:color];
        }
    }
    [self setColorChooserRGBSliderValues:color];
}

- (IBAction)simpleButtonPressed {
    [self setView:colorChooserSimpleView button:simpleButton];
    [self updateView];
}

- (IBAction)textButtonPressed {
    [self setView:colorChooserRGBView button:textButton];
    [self updateView];
}

- (IBAction)backgroundButtonPressed {
    [self setView:colorChooserRGBView button:backgroundButton];
    [self updateView];
}

- (IBAction)colorChooserRGBSliderValueChanged {
    [self postColorUpdate:[self colorChooserRGBSliderValues] textNotBackground:!textButton.enabled];
}

- (IBAction)colorChooserSimpleValueSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    CDXColorRGB colorRGB = colorChooserSimpleColors[tag % 10];
    CDXColor *color = [CDXColor colorWithRed:colorRGB.red green:colorRGB.green blue:colorRGB.blue alpha:255];
    
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

