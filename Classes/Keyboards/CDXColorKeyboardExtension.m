//
//
// CDXColorKeyboardExtension.m
//
//
// Copyright (c) 2009-2015 Arne Harren <ah@0xc0.de>
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
    return @"col";
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
    ivar_release_and_clear(colorChooserRGBSliderRedValue);
    ivar_release_and_clear(colorChooserRGBSliderGreenValue);
    ivar_release_and_clear(colorChooserRGBSliderBlueValue);
    ivar_release_and_clear(colorChooserRGBSliderAlphaValue);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[CDXKeyboardExtensions sharedKeyboardExtensions] backgroundColor];
    [self simpleButtonPressed];
    NSDictionary *textAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:15] };
    [simpleButton setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [textButton setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [backgroundButton setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [colorChooserRGBSliderRed setThumbImage:[UIImage imageNamed:@"Circle"] forState:UIControlStateNormal];
    [colorChooserRGBSliderGreen setThumbImage:[UIImage imageNamed:@"Circle"] forState:UIControlStateNormal];
    [colorChooserRGBSliderBlue setThumbImage:[UIImage imageNamed:@"Circle"] forState:UIControlStateNormal];
    [colorChooserRGBSliderAlpha setThumbImage:[UIImage imageNamed:@"Circle"] forState:UIControlStateNormal];
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
    ivar_release_and_clear(colorChooserRGBSliderRedValue);
    ivar_release_and_clear(colorChooserRGBSliderGreenValue);
    ivar_release_and_clear(colorChooserRGBSliderBlueValue);
    ivar_release_and_clear(colorChooserRGBSliderAlphaValue);
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
    view.frame = CGRectMake(0, CGRectGetHeight(toolbar.bounds) + 2, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(toolbar.bounds) - 2);
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
    [colorChooserRGBSliderRedValue setTitle:[NSString stringWithFormat:@"%02x", color.red] forState:UIControlStateNormal];
    [colorChooserRGBSliderGreenValue setTitle:[NSString stringWithFormat:@"%02x", color.green] forState:UIControlStateNormal];
    [colorChooserRGBSliderBlueValue setTitle:[NSString stringWithFormat:@"%02x", color.blue] forState:UIControlStateNormal];
    [colorChooserRGBSliderAlphaValue setTitle:[NSString stringWithFormat:@"%02x", color.alpha] forState:UIControlStateNormal];
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

- (void)colorChooserRGBSliderButtonPressedPostProcess:(UIButton *)button {
    [self colorChooserRGBSliderValueChanged];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    UIColor *color = button.backgroundColor;
    button.backgroundColor = [UIColor grayColor];
    button.backgroundColor = color;
    [UIView commitAnimations];
}

- (IBAction)colorChooserRGBSliderRedButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    colorChooserRGBSliderRed.value += tag;
    
    [self colorChooserRGBSliderButtonPressedPostProcess:button];
}

- (IBAction)colorChooserRGBSliderGreenButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    colorChooserRGBSliderGreen.value += tag;

    [self colorChooserRGBSliderButtonPressedPostProcess:button];
}

- (IBAction)colorChooserRGBSliderBlueButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    colorChooserRGBSliderBlue.value += tag;

    [self colorChooserRGBSliderButtonPressedPostProcess:button];
}

- (IBAction)colorChooserRGBSliderAlphaButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    colorChooserRGBSliderAlpha.value += tag;

    [self colorChooserRGBSliderButtonPressedPostProcess:button];
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

