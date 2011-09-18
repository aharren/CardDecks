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

- (void)showNoticeWithImageNamed:(NSString *)name text:(NSString *)text timeInterval:(NSTimeInterval)timeInterval orientation:(UIDeviceOrientation)orientation view:(UIView*)viewOrNil {
    qltrace();
    [[NSBundle mainBundle] loadNibNamed:@"CDXAppWindowNoticeView" owner:self options:nil];
    [noticeView showImageNamed:name text:text timeInterval:timeInterval orientation:orientation view:viewOrNil != nil ? viewOrNil : window];
    ivar_release_and_clear(noticeView);
}

- (void)presentModalViewController:(UIViewController *)viewController animated:(BOOL)animated {
    qltrace();
    [[self visibleViewController] presentModalViewController:viewController animated:animated];
}

- (void)presentModalViewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated {
    qltrace();
    [[self visibleViewController] presentModalViewController:viewController animated:animated];
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

- (void)pushFullScreenViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated {
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
}

- (void)popFullScreenViewControllerAnimationWillStart:(NSString *)animationID context:(void *)context {
    qltrace();
}

- (void)popFullScreenViewControllerAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    qltrace();
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    navigationView.frame = [[UIScreen mainScreen] bounds];
    navigationView.userInteractionEnabled = YES;
}

- (void)popFullScreenViewControllerAnimated:(BOOL)animated {
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
}

@end


@interface CDXAppWindowManagerPhone : CDXAppWindowManager {
    
@protected
    IBOutlet UIView *statusBarView;
    
    UINavigationController *navigationController;
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


- (void)pushViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated {
    qltrace();
    if ([viewController wantsFullScreenLayout]) {
        [self pushFullScreenViewController:viewController animated:animated];
    } else {
        [navigationController pushViewController:viewController animated:animated];
        navigationController.view.frame = [[UIScreen mainScreen] applicationFrame];
    }
}

- (void)popViewControllerAnimated:(BOOL)animated {
    qltrace();
    if (fullScreenViewController != nil) {
        [self popFullScreenViewControllerAnimated:animated];
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


@interface CDXLeftRightSplitViewController : UIViewController {
    
@protected
    UIViewController *leftViewController;
    UIViewController *rightViewController;
}

- (void)setLeftViewController:(UIViewController *)viewController;
- (void)setRightViewController:(UIViewController *)viewController;

@end


@implementation CDXLeftRightSplitViewController

- (void)dealloc {
    ivar_release_and_clear(leftViewController);
    ivar_release_and_clear(rightViewController);
    [super dealloc];
}

- (void)setLeftViewController:(UIViewController *)viewController {
    qltrace();
    ivar_assign_and_retain(leftViewController, viewController);
    [self.view addSubview:leftViewController.view];
}

- (void)setRightViewController:(UIViewController *)viewController {
    qltrace();
    ivar_assign_and_retain(rightViewController, viewController);
    [self.view addSubview:rightViewController.view];
}

- (void)layoutViewControllerViews {
    qltrace();
    leftViewController.view.frame = CGRectMake(0, 0, 346, 1004);
    rightViewController.view.frame = CGRectMake(346, 0, 768-346, 1004);
}

- (void)viewDidLoad {
    qltrace();
    [super viewDidLoad];
    [leftViewController viewDidLoad];
    [rightViewController viewDidLoad];
}

- (void)viewDidUnload {
    qltrace();
    [leftViewController viewDidUnload];
    [rightViewController viewDidUnload];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    qltrace();
    [super viewWillAppear:animated];
    [leftViewController viewWillAppear:animated];
    [rightViewController viewWillAppear:animated];
    [self layoutViewControllerViews];
}

- (void)viewDidAppear:(BOOL)animated {
    qltrace();
    [leftViewController viewDidAppear:animated];
    [rightViewController viewDidAppear:animated];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    qltrace();
    [super viewWillDisappear:animated];
    [leftViewController viewWillDisappear:animated];
    [rightViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    qltrace();
    [leftViewController viewDidDisappear:animated];
    [rightViewController viewDidDisappear:animated];
    [super viewDidDisappear:animated];
}

@end


@interface CDXAppWindowManagerPad : CDXAppWindowManager<UIPopoverControllerDelegate> {
    
@protected
    CDXLeftRightSplitViewController* splitViewController;
    
    UINavigationController *leftNavigationController;
    UINavigationController *rightNavigationController;
    
    UIViewController<CDXAppWindowViewController> * initialLeftViewController;
    UIViewController<CDXAppWindowViewController> * initialRightViewController;
    
    UIPopoverController *modalViewControllerContainer;
}

@end


@implementation CDXAppWindowManagerPad

synthesize_singleton_initialization(sharedAppWindowManager, CDXAppWindowManager);

synthesize_singleton_methods(sharedAppWindowManager, CDXAppWindowManager);

- (id)init {
    qltrace();
    if ((self = [super init])) {
        ivar_assign(splitViewController, [[CDXLeftRightSplitViewController alloc] init]);
        ivar_assign(leftNavigationController, [[UINavigationController alloc] init]);
        [leftNavigationController setToolbarHidden:YES];
        [leftNavigationController setNavigationBarHidden:YES];
        [splitViewController setLeftViewController:leftNavigationController];
        ivar_assign(rightNavigationController, [[UINavigationController alloc] init]);
        [rightNavigationController setToolbarHidden:YES];
        [rightNavigationController setNavigationBarHidden:YES];
        [splitViewController setRightViewController:rightNavigationController];
    }
    return self;
}

- (UIViewController *)visibleViewController {
    qltrace();
    if (fullScreenViewController != nil) {
        return fullScreenViewController;
    } else {
        return initialLeftViewController;
    }
}

- (void)pushViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated {
    qltrace();
    if (initialLeftViewController == nil) {
        ivar_assign_and_retain(initialLeftViewController, viewController);
        [leftNavigationController pushViewController:viewController animated:NO];
    } else {
        if ([viewController wantsFullScreenLayout]) {
            [self pushFullScreenViewController:viewController animated:animated];
        } else {
            if (initialRightViewController == nil) {
                ivar_assign_and_retain(initialRightViewController, viewController);
                [rightNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
            } else {
                [rightNavigationController setViewControllers:[NSArray arrayWithObjects:initialRightViewController, viewController, nil] animated:NO];
            }
        }
    }
}

- (void)popViewControllerAnimated:(BOOL)animated {
    qltrace();
    if (fullScreenViewController != nil) {
        [self popFullScreenViewControllerAnimated:animated];
    } else {
        [rightNavigationController popToRootViewControllerAnimated:NO];
        [initialLeftViewController viewWillAppear:NO];
        [initialLeftViewController viewDidAppear:NO];
    }
}

- (void)popToInitialViewController {
    qltrace();
    if (fullScreenViewController != nil) {
        [self popViewControllerAnimated:NO];
    }
    [rightNavigationController popToRootViewControllerAnimated:NO];
    [initialLeftViewController viewWillAppear:NO];
    [initialLeftViewController viewDidAppear:NO];
}

- (void)makeWindowKeyAndVisible {
    qltrace();
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [window addSubview:navigationView];
    navigationView.frame = [[UIScreen mainScreen] bounds];
    [navigationView addSubview:splitViewController.view];
    
    [window makeKeyAndVisible];
}

- (void)presentModalViewController:(UIViewController *)viewController animated:(BOOL)animated {
    qltrace();
    if (modalViewControllerContainer != nil) {
        [self dismissModalViewControllerAnimated:animated];
    }
    
    [splitViewController presentModalViewController:viewController animated:animated];
}

- (void)presentModalViewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated {
    qltrace();
    if (modalViewControllerContainer != nil) {
        [self dismissModalViewControllerAnimated:animated];
        return;
    }
    
    ivar_assign(modalViewControllerContainer, [[UIPopoverController alloc] initWithContentViewController:viewController]);
    modalViewControllerContainer.delegate = self;

    [modalViewControllerContainer presentPopoverFromBarButtonItem:barButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:animated];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    qltrace();
    [self dismissModalViewControllerAnimated:NO];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    qltrace();
    [splitViewController dismissModalViewControllerAnimated:animated];
    [modalViewControllerContainer dismissPopoverAnimated:animated];
    ivar_release_and_clear(modalViewControllerContainer);
}

- (void)showActionSheet:(UIActionSheet*)actionSheet fromBarButtonItem:(UIBarButtonItem*)barButtonItem {
    qltrace();
    [actionSheet showFromBarButtonItem:barButtonItem animated:NO];
}

@end

