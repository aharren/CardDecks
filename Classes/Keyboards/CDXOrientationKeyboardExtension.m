//
//
// CDXOrientationKeyboardExtension.m
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

#import "CDXOrientationKeyboardExtension.h"
#import "CDXCardView.h"


@implementation CDXOrientationKeyboardExtension

synthesize_singleton(sharedOrientationKeyboardExtension, CDXOrientationKeyboardExtension);

- (void)dealloc {
    ivar_release_and_clear(viewController);
    [super dealloc];
}

- (void)keyboardExtensionInitialize {
}

- (NSString *)keyboardExtensionTitle {
    CDXCardOrientation orientation = CDXCardOrientationUp;
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if ([responder conformsToProtocol:@protocol(CDXOrientationKeyboardExtensionResponder)]) {
        NSObject<CDXOrientationKeyboardExtensionResponder> *r = (NSObject<CDXOrientationKeyboardExtensionResponder> *)responder;
        orientation = [r orientationKeyboardExtensionCardOrientation];
    }
    
    switch (orientation) {
        default:
        case CDXCardOrientationUp:
            return @"\u25B2";
        case CDXCardOrientationRight:
            return @"\u25B6";
        case CDXCardOrientationDown:
            return @"\u25BC";
        case CDXCardOrientationLeft:
            return @"\u25C0";
    }
}

- (UIView *)keyboardExtensionView {
    if (viewController == nil) {
        ivar_assign(viewController, [[CDXOrientationKeyboardExtensionViewController alloc] init]);
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


@implementation CDXOrientationKeyboardExtensionViewController 

- (id)init {
    if ((self = [super initWithNibName:@"CDXOrientationKeyboardExtensionView" bundle:nil])) {
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(orientationSample);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[CDXKeyboardExtensions sharedKeyboardExtensions] backgroundColor];
}

- (void)viewDidUnload {
    ivar_release_and_clear(orientationSample);
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateOrientationSample];
}

- (void)updateOrientationSample {
    CDXCardOrientation orientation = CDXCardOrientationUp;
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if ([responder conformsToProtocol:@protocol(CDXOrientationKeyboardExtensionResponder)]) {
        NSObject<CDXOrientationKeyboardExtensionResponder> *r = (NSObject<CDXOrientationKeyboardExtensionResponder> *)responder;
        orientation = [r orientationKeyboardExtensionCardOrientation];
    }
    
    orientationSample.transform = [CDXCardView transformForCardOrientation:orientation];
}

- (IBAction)orientationButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    CDXCardOrientation orientation = (CDXCardOrientation)[button tag];
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if ([responder conformsToProtocol:@protocol(CDXOrientationKeyboardExtensionResponder)]) {
        NSObject<CDXOrientationKeyboardExtensionResponder> *r = (NSObject<CDXOrientationKeyboardExtensionResponder> *)responder;
        [r orientationKeyboardExtensionSetCardOrientation:orientation];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    UIColor *color = button.backgroundColor;
    button.backgroundColor = [UIColor blueColor];
    button.backgroundColor = color;
    [UIView commitAnimations];

    [self updateOrientationSample];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] refreshKeyboardExtensions];
}

@end


