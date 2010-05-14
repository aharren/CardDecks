//
//
// CDXAppWindowManager.m
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

#import "CDXAppWindowManager.h"
#import "CDXImageFactory.h"

#undef ql_component
#define ql_component lcl_cCDXAppWindowManager


@implementation CDXAppWindowManager

@synthesize deviceOrientation;

synthesize_singleton(sharedAppWindowManager, CDXAppWindowManager);

- (id)init {
    if ((self = [super init])) {
        ivar_assign(navigationController, [[UINavigationController alloc] init]);
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)pushFullScreenViewControllerAnimationWillStart:(NSString *)animationID context:(void *)context {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
}

- (void)pushFullScreenViewControllerAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    [fullScreenViewController setUserInteractionEnabled:YES];
}

- (void)pushViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated {
    if ([viewController wantsFullScreenLayout]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
        [fullScreenViewController setUserInteractionEnabled:NO];
        ivar_assign_and_retain(fullScreenViewController, viewController);
        
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.6];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:YES];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationWillStartSelector:@selector(pushFullScreenViewControllerAnimationWillStart:context:)];
            [UIView setAnimationDidStopSelector:@selector(pushFullScreenViewControllerAnimationDidStop:finished:context:)];
        }
        [navigationController.view removeFromSuperview];
        [window addSubview:fullScreenViewController.view];
        if (animated) {
            [UIView commitAnimations];
        }
    } else {
        [navigationController pushViewController:viewController animated:animated];
    }
}

- (void)popFullScreenViewControllerAnimationWillStart:(NSString *)animationID context:(void *)context {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)popViewControllerAnimated:(BOOL)animated {
    if (fullScreenViewController != nil) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
        [fullScreenViewController setUserInteractionEnabled:NO];
        
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.6];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationWillStartSelector:@selector(popFullScreenViewControllerAnimationWillStart:context:)];
        }
        [fullScreenViewController.view removeFromSuperview];
        [window addSubview:navigationController.view];
        if (animated) {
            [UIView commitAnimations];
        }

        ivar_release_and_clear(fullScreenViewController);
    } else {
        [navigationController popViewControllerAnimated:animated];
    }
}

- (void)makeWindowKeyAndVisible {
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIDeviceOrientation newDeviceOrientation = [[UIDevice currentDevice] orientation];
    if (newDeviceOrientation == deviceOrientation) {
        return;
    }
    qltrace();
    
    deviceOrientation = newDeviceOrientation;
}

@end

