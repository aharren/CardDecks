//
//
// CDXLayoutKeyboardExtensionViewController.m
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

#import "CDXLayoutKeyboardExtensionViewController.h"
#import "CDXLayoutKeyboardExtension.h"


@implementation CDXLayoutKeyboardExtensionViewController

#define LogFileComponent lcl_cCDXLayoutKeyboardExtension

@synthesize orientationSample = _orientationSample;

- (void)dealloc {
    LogInvocation();
    
    self.orientationSample = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    LogInvocation();
    
    self.view.backgroundColor = [[CDXKeyboardExtensions sharedInstance] backgroundColor];
}

- (void)viewDidUnload {
    LogInvocation();
    
    self.orientationSample = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    LogInvocation();
    
    [self updateOrientationSample];
}

- (void)updateOrientationSample {
    LogInvocation();
    
    CDXCardOrientation orientation = CDXCardOrientationUp;
    NSObject *responder = [[CDXKeyboardExtensions sharedInstance] responder];
    if ([responder conformsToProtocol:@protocol(CDXLayoutKeyboardExtensionProtocol)]) {
        NSObject <CDXLayoutKeyboardExtensionProtocol> *r = (NSObject <CDXLayoutKeyboardExtensionProtocol> *)responder;
        orientation = [r cardOrientation];
    }
    
    _orientationSample.transform = [CDXCardOrientationHelper transformFromCardOrientation:orientation];
}

- (void)orientationButtonPressed:(id)sender {
    LogInvocation();
    
    UIButton *button = (UIButton *)sender;
    
    CDXCardOrientation orientation = (CDXCardOrientation)[button tag];
    NSObject *responder = [[CDXKeyboardExtensions sharedInstance] responder];
    if ([responder conformsToProtocol:@protocol(CDXLayoutKeyboardExtensionProtocol)]) {
        NSObject <CDXLayoutKeyboardExtensionProtocol> *r = (NSObject <CDXLayoutKeyboardExtensionProtocol> *)responder;
        [r setCardOrientation:orientation];
    }
    
    [self updateOrientationSample];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    UIColor *color = button.backgroundColor;
    button.backgroundColor = [UIColor blueColor];
    button.backgroundColor = color;
    [UIView commitAnimations];
}

+ (CDXLayoutKeyboardExtensionViewController *)LayoutKeyboardExtensionViewController {
    LogInvocation();
    
    CDXLayoutKeyboardExtensionViewController *controller = [[[CDXLayoutKeyboardExtensionViewController alloc] initWithNibName:@"CDXLayoutKeyboardExtensionView" bundle:nil] autorelease];
    return controller;
}

@end

