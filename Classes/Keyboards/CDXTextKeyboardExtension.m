//
//
// CDXTextKeyboardExtension.m
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

#import "CDXTextKeyboardExtension.h"
#import "CDXCardView.h"


@implementation CDXTextKeyboardExtension

synthesize_singleton(sharedtextKeyboardExtension, CDXTextKeyboardExtension);

- (void)dealloc {
    ivar_release_and_clear(viewController);
    [super dealloc];
}

+ (NSString *)stringForFontSize:(CGFloat)fontSize {
    if (fontSize == CDXCardFontSizeAutomatic) {
        return @"\u21e0\u21e2";
    } else {
        return [NSString stringWithFormat:@"%d", (int)floor(fontSize)];
    }
}

- (void)keyboardExtensionInitialize {
}

- (NSString *)keyboardExtensionTitle {
    CGFloat fontSize = CDXCardFontSizeAutomatic;
    CDXCardOrientation orientation = CDXCardOrientationUp;
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if ([responder conformsToProtocol:@protocol(CDXTextKeyboardExtensionResponder)]) {
        NSObject<CDXTextKeyboardExtensionResponder> *r = (NSObject<CDXTextKeyboardExtensionResponder> *)responder;
        fontSize = [r textKeyboardExtensionFontSize];
        orientation = [r textKeyboardExtensionCardOrientation];
    }
    NSString *fontText = [CDXTextKeyboardExtension stringForFontSize:fontSize];
    
    NSString *orientationText;
    switch (orientation) {
        default:
        case CDXCardOrientationUp:
            orientationText = @"\u25B3";
            break;
        case CDXCardOrientationRight:
            orientationText = @"\u25B7";
            break;
        case CDXCardOrientationDown:
            orientationText = @"\u25BD";
            break;
        case CDXCardOrientationLeft:
            orientationText = @"\u25C1";
            break;
    }
    
    return [orientationText stringByAppendingString:fontText];
}

- (UIView *)keyboardExtensionView {
    if (viewController == nil) {
        ivar_assign(viewController, [[CDXTextKeyboardExtensionViewController alloc] init]);
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


@implementation CDXTextKeyboardExtensionViewController

- (void)dealloc {
    ivar_release_and_clear(sizeChooserSlider);
    ivar_release_and_clear(sizeChooserSliderLabel);
    ivar_release_and_clear(orientationSample);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[CDXKeyboardExtensions sharedKeyboardExtensions] backgroundColor];
    [sizeChooserSlider setThumbImage:[UIImage imageNamed:@"Circle"] forState:UIControlStateNormal];
}

- (void)viewDidUnload {
    ivar_release_and_clear(sizeChooserSlider);
    ivar_release_and_clear(sizeChooserSliderLabel);
    ivar_release_and_clear(orientationSample);
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    sizeChooserSlider.minimumValue = CDXCardFontSizeAutomatic;
    sizeChooserSlider.maximumValue = CDXCardFontSizeMax;
    [self updateSize];
    [self updateOrientationSample];
}

- (void)updateSize {
    CGFloat fontSize = 0;
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if ([responder conformsToProtocol:@protocol(CDXTextKeyboardExtensionResponder)]) {
        NSObject <CDXTextKeyboardExtensionResponder> *r = (NSObject <CDXTextKeyboardExtensionResponder> *)responder;
        fontSize = [r textKeyboardExtensionFontSize];
    }
    sizeChooserSlider.value = fontSize;
    sizeChooserSliderLabel.text = [CDXTextKeyboardExtension stringForFontSize:fontSize];
}

- (void)updateOrientationSample {
    CDXCardOrientation orientation = CDXCardOrientationUp;
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if ([responder conformsToProtocol:@protocol(CDXTextKeyboardExtensionResponder)]) {
        NSObject<CDXTextKeyboardExtensionResponder> *r = (NSObject<CDXTextKeyboardExtensionResponder> *)responder;
        orientation = [r textKeyboardExtensionCardOrientation];
    }
    
    orientationSample.transform = [CDXCardView transformForCardOrientation:orientation];
}

- (IBAction)sizeChooserSliderValueChanged {
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if ([responder conformsToProtocol:@protocol(CDXTextKeyboardExtensionResponder)]) {
        NSObject <CDXTextKeyboardExtensionResponder> *r = (NSObject <CDXTextKeyboardExtensionResponder> *)responder;
        [r textKeyboardExtensionSetFontSize:sizeChooserSlider.value];
    }
    [self updateSize];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] refreshKeyboardExtensions];
}

- (IBAction)orientationButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    CDXCardOrientation orientation = (CDXCardOrientation)[button tag];
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if ([responder conformsToProtocol:@protocol(CDXTextKeyboardExtensionResponder)]) {
        NSObject<CDXTextKeyboardExtensionResponder> *r = (NSObject<CDXTextKeyboardExtensionResponder> *)responder;
        [r textKeyboardExtensionSetCardOrientation:orientation];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    UIColor *color = button.backgroundColor;
    button.backgroundColor = [UIColor grayColor];
    button.backgroundColor = color;
    [UIView commitAnimations];
    
    [self updateOrientationSample];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] refreshKeyboardExtensions];
}

@end

