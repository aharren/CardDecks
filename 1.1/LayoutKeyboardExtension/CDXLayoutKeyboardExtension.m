//
//
// CDXLayoutKeyboardExtension.m
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

#import "CDXLayoutKeyboardExtension.h"


@implementation CDXLayoutKeyboardExtension

#define LogFileComponent lcl_cCDXLayoutKeyboardExtension

static CDXLayoutKeyboardExtension *_sharedInstance;

@synthesize viewController = _viewController;

+ (void)initialize {
    // perform initialization only once
    if (self != [CDXLayoutKeyboardExtension class])
        return;
    
    _sharedInstance = [[CDXLayoutKeyboardExtension alloc] init];
}

- (id)init {
    LogInvocation();
    
    if ((self = [super init])) {
        // nothing to do
    }
    
    return self;
}

- (void)dealloc {
    LogInvocation();
    
    self.viewController = nil;
    
    [super dealloc];
}

- (void)extensionInitialize {
    LogInvocation();
}

- (NSString *)extensionTitle {
    LogInvocation();
    
    return @"Layout";
}

- (UIView *)extensionView {
    LogInvocation();
    
    if (_viewController == nil) {
        self.viewController = [CDXLayoutKeyboardExtensionViewController LayoutKeyboardExtensionViewController];
    }
    
    NSAssert(_viewController.view != nil, @"view should be loaded");    
    return _viewController.view;
}

- (void)extensionWillBecomeActive {
    LogInvocation();
    
    if (_viewController == nil) {
        self.viewController = [CDXLayoutKeyboardExtensionViewController LayoutKeyboardExtensionViewController];
    }
    
    [_viewController viewWillAppear:NO];
}

- (void)extensionDidBecomeActive {
    LogInvocation();
    
    [_viewController viewDidAppear:NO];
}

- (void)extensionWillBecomeInactive {
    LogInvocation();
    
    [_viewController viewWillDisappear:NO];
}

- (void)extensionDidBecomeInactive {
    LogInvocation();
    
    [_viewController viewDidDisappear:NO];
}

+ (CDXLayoutKeyboardExtension *)sharedInstance {
    LogInvocation();
    
    return _sharedInstance;
}

@end

