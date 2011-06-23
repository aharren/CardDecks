//
//
// CDXAppWindowManager.m
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

#import "CDXAppWindowManager.h"
#import "CDXImageFactory.h"
#import "CDXDevice.h"

#undef ql_component
#define ql_component lcl_cApplication


@implementation CDXAppWindowManager

@synthesize window;
@synthesize deviceOrientation;

synthesize_singleton_definition(sharedAppWindowManager, CDXAppWindowManager);

- (id)init {
    qltrace();
    if ((self = [super init])) {
        deviceOrientation = UIDeviceOrientationPortrait;
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (UIViewController *)visibleViewController {
    qltrace();
    return nil;
}

- (void)pushViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated {
    qltrace();
}

- (void)popViewControllerAnimated:(BOOL)animated {
    qltrace();
}

- (void)popToInitialViewController {
    qltrace();
}

- (void)makeWindowKeyAndVisible {
    qltrace();
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIDeviceOrientation newDeviceOrientation = [[UIDevice currentDevice] orientation];
    if (newDeviceOrientation == deviceOrientation) {
        return;
    }
    switch (newDeviceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationLandscapeRight:
            break;
        default:
            return;
    }
    qltrace();
    
    deviceOrientation = newDeviceOrientation;
    
    UIViewController *vc = [self visibleViewController];
    if ([vc conformsToProtocol:@protocol(CDXAppWindowViewController)]) {
        [(UIViewController<CDXAppWindowViewController> *)vc deviceOrientationDidChange:newDeviceOrientation];
    }
}

- (void)showNoticeWithImageNamed:(NSString *)name text:(NSString *)text timeInterval:(NSTimeInterval)timeInterval orientation:(UIDeviceOrientation)orientation {
    qltrace();
    [[NSBundle mainBundle] loadNibNamed:@"CDXAppWindowNoticeView" owner:self options:nil];
    [noticeView showImageNamed:name text:text timeInterval:timeInterval orientation:orientation window:window];
    ivar_release_and_clear(noticeView);
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    qltrace();
    [[self visibleViewController] dismissModalViewControllerAnimated:animated];
}

- (void)showActionSheet:(UIActionSheet*)actionSheet fromBarButtonItem:(UIBarButtonItem*)barButtonItem {
    qltrace();
}

+ (CGAffineTransform)transformForDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    CGFloat transformAngle;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
        default:
            transformAngle = 0;
            break;
        case UIDeviceOrientationLandscapeLeft:
            transformAngle = M_PI_2;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            transformAngle = M_PI;
            break;
        case UIDeviceOrientationLandscapeRight:
            transformAngle = -M_PI_2;
            break;
    }
    
    return CGAffineTransformRotate(CGAffineTransformIdentity, transformAngle);
}

@end


@interface CDXAppWindowManagerPhone : CDXAppWindowManager {
    
@protected
    IBOutlet UIView *navigationView;
    IBOutlet UIView *statusBarView;
    
    UINavigationController *navigationController;
    UIViewController<CDXAppWindowViewController> *fullScreenViewController;
}

@end


@implementation CDXAppWindowManagerPhone

synthesize_singleton_initialization(sharedAppWindowManager, CDXAppWindowManager);

synthesize_singleton_methods(sharedAppWindowManager, CDXAppWindowManager);

- (id)init {
    qltrace();
    if ((self = [super init])) {
        ivar_assign(navigationController, [[UINavigationController alloc] init]);
        navigationController.toolbarHidden = NO;
    }
    return self;
}

- (UIViewController *)visibleViewController {
    qltrace();
    if (fullScreenViewController != nil) {
        return fullScreenViewController;
    } else {
        return [navigationController visibleViewController];
    }
}

- (void)pushFullScreenViewControllerAnimationWillStart:(NSString *)animationID context:(void *)context {
    qltrace();
}

- (void)pushFullScreenViewControllerAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    qltrace();
    [fullScreenViewController setUserInteractionEnabled:YES];
}

- (void)pushFullScreenViewControllerAnimatedAndRemoveView:(UIView *)view {
    qltrace();
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(pushFullScreenViewControllerAnimationWillStart:context:)];
    [UIView setAnimationDidStopSelector:@selector(pushFullScreenViewControllerAnimationDidStop:finished:context:)];
    
    [view removeFromSuperview];
    [window addSubview:fullScreenViewController.view];
    
    [UIView commitAnimations];
}

- (void)pushViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated {
    qltrace();
    if ([viewController wantsFullScreenLayout]) {
        ivar_assign_and_retain(fullScreenViewController, viewController);
        [fullScreenViewController setUserInteractionEnabled:!animated];
        if (animated) {
            UIImageView *screenshotView = [[[UIImageView alloc] initWithImage:[[CDXImageFactory sharedImageFactory] imageForScreen]] autorelease];
            navigationView.userInteractionEnabled = NO;
            [navigationView removeFromSuperview];
            [window addSubview:screenshotView];
            [self performSelector:@selector(pushFullScreenViewControllerAnimatedAndRemoveView:) withObject:screenshotView afterDelay:0.001];
        } else {
            [navigationView removeFromSuperview];
            [window addSubview:fullScreenViewController.view];
        }
    } else {
        [navigationController pushViewController:viewController animated:animated];
        navigationController.view.frame = [[UIScreen mainScreen] applicationFrame];
    }
}

- (void)popFullScreenViewControllerAnimationWillStart:(NSString *)animationID context:(void *)context {
    qltrace();
}

- (void)popFullScreenViewControllerAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    qltrace();
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    navigationController.view.frame = [[UIScreen mainScreen] applicationFrame];
    navigationView.userInteractionEnabled = YES;
}

- (void)popViewControllerAnimated:(BOOL)animated {
    qltrace();
    if (fullScreenViewController != nil) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [fullScreenViewController setUserInteractionEnabled:NO];
        navigationView.frame = [[UIScreen mainScreen] bounds];
        
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.6];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationWillStartSelector:@selector(popFullScreenViewControllerAnimationWillStart:context:)];
            [UIView setAnimationDidStopSelector:@selector(popFullScreenViewControllerAnimationDidStop:finished:context:)];
        } else {
            [self popFullScreenViewControllerAnimationDidStop:nil finished:nil context:NULL];
        }
        
        [fullScreenViewController.view removeFromSuperview];
        [window addSubview:navigationView];
        
        if (animated) {
            [UIView commitAnimations];
        }
        
        ivar_release_and_clear(fullScreenViewController);
    } else {
        [navigationController popViewControllerAnimated:animated];
    }
}

- (void)popToInitialViewController {
    qltrace();
    if (fullScreenViewController != nil) {
        [self popViewControllerAnimated:NO];
    }
    [navigationController popToRootViewControllerAnimated:NO];
}

- (void)makeWindowKeyAndVisible {
    qltrace();
    const CDXDeviceType deviceType = [CDXDevice sharedDevice].deviceType;
    statusBarView.hidden = !(deviceType == CDXDeviceTypeiPhone || deviceType == CDXDeviceTypeiPodTouch);
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [window addSubview:navigationView];
    navigationView.frame = [[UIScreen mainScreen] bounds];
    [navigationView addSubview:navigationController.view];
    
    [window makeKeyAndVisible];
}

- (void)showActionSheet:(UIActionSheet*)actionSheet fromBarButtonItem:(UIBarButtonItem*)barButtonItem {
    qltrace();
    [actionSheet showInView:window];
}

@end


@interface CDXAppWindowManagerPad : CDXAppWindowManager {
    
@protected
}

@end


@implementation CDXAppWindowManagerPad

synthesize_singleton_initialization(sharedAppWindowManager, CDXAppWindowManager);

synthesize_singleton_methods(sharedAppWindowManager, CDXAppWindowManager);

- (id)init {
    qltrace();
    if ((self = [super init])) {
    }
    return self;
}

- (UIViewController *)visibleViewController {
    qltrace();
    return nil;
}

- (void)pushViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated {
    qltrace();
}

- (void)popViewControllerAnimated:(BOOL)animated {
    qltrace();
}

- (void)popToInitialViewController {
    qltrace();
}

- (void)makeWindowKeyAndVisible {
    qltrace();
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [window makeKeyAndVisible];
}

- (void)showActionSheet:(UIActionSheet*)actionSheet fromBarButtonItem:(UIBarButtonItem*)barButtonItem {
    qltrace();
    [actionSheet showFromBarButtonItem:barButtonItem animated:NO];
}

@end

