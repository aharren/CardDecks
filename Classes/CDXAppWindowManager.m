//
//
// CDXAppWindowManager.m
//
//
// Copyright (c) 2009-2018 Arne Harren <ah@0xc0.de>
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHideMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
    }
    return self;
}

- (UIEdgeInsets)safeAreaInsets {
    UIEdgeInsets insets = window.safeAreaInsets;
    return insets;
}

- (UIEdgeInsets)maxSafeAreaInsets {
    UIEdgeInsets insets = [self safeAreaInsets];
    CGFloat maxTopBottomInset = MAX(insets.top, insets.bottom);
    insets.top = maxTopBottomInset;
    insets.bottom = maxTopBottomInset;
    return insets;
}

- (CGRect)frameWithMaxSafeAreaInsets:(CGRect)frame {
    UIEdgeInsets safeInsets = [self maxSafeAreaInsets];
    frame.size.height = frame.size.height - safeInsets.top - safeInsets.bottom;
    frame.origin.y = frame.origin.y + safeInsets.top;
    return frame;
}

- (UIViewController *)visibleViewController {
    qltrace();
    return nil;
}

- (void)pushViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated {
    qltrace();
    [self pushViewController:viewController animated:animated withTouchLocation:CGPointMake(window.bounds.size.width,window.bounds.size.height)];
}

- (void)pushViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated withTouchLocation:(CGPoint)location {
    qltrace();
}

- (void)popViewControllerAnimated:(BOOL)animated {
    qltrace();
    [self popViewControllerAnimated:animated withTouchLocation:CGPointMake(window.bounds.size.width,window.bounds.size.height)];
}

- (void)popViewControllerAnimated:(BOOL)animated withTouchLocation:(CGPoint)location {
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

- (void)menuControllerWillHideMenu:(NSNotification *)notification {
    UIViewController *vc = [self visibleViewController];
    if ([vc conformsToProtocol:@protocol(CDXAppWindowViewController)]) {
        [(UIViewController<CDXAppWindowViewController> *)vc menuControllerWillHideMenu];
    }
}

- (void)showNoticeWithImageNamed:(NSString *)name text:(NSString *)text timeInterval:(NSTimeInterval)timeInterval orientation:(UIDeviceOrientation)orientation view:(UIView*)viewOrNil {
    qltrace();
    [[NSBundle mainBundle] loadNibNamed:@"CDXAppWindowNoticeView" owner:self options:nil];
    [noticeView showImageNamed:name text:text timeInterval:timeInterval orientation:orientation view:viewOrNil != nil ? viewOrNil : window];
    ivar_release_and_clear(noticeView);
}

- (void)showInfoMessage:(NSString *)text afterDelay:(NSTimeInterval)timeDelay {
    qltrace();
    [[NSBundle mainBundle] loadNibNamed:@"CDXAppWindowMessageView" owner:self options:nil];
    [messageView showMessage:text timeInterval:2 view:window backgroundColor:[CDXColor colorWithRed:0 green:121 blue:255 alpha:220].uiColor height:65 afterDelay:timeDelay];
    ivar_release_and_clear(messageView);
}

- (void)showErrorMessage:(NSString *)text afterDelay:(NSTimeInterval)timeDelay {
    qltrace();
    [[NSBundle mainBundle] loadNibNamed:@"CDXAppWindowMessageView" owner:self options:nil];
    [messageView showMessage:text timeInterval:2 view:window backgroundColor:[CDXColor colorWithRed:255 green:0 blue:0 alpha:220].uiColor height:65 afterDelay:timeDelay];
    ivar_release_and_clear(messageView);
}

- (void)presentModalViewController:(UIViewController *)viewController animated:(BOOL)animated {
    qltrace();
    [[self visibleViewController] presentViewController:viewController animated:animated completion:NULL];
}

- (void)presentModalViewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated {
    qltrace();
    [[self visibleViewController] presentViewController:viewController animated:animated completion:NULL];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    qltrace();
    [[self visibleViewController] dismissViewControllerAnimated:animated completion:NULL];
}

- (void)applicationWillEnterForeground {
    qltrace();
    UIViewController* vc = [self visibleViewController];
    if ([vc conformsToProtocol:@protocol(CDXAppWindowViewController)]) {
        UIViewController <CDXAppWindowViewController> *c = (UIViewController <CDXAppWindowViewController> *)vc;
        if ([c respondsToSelector:@selector(applicationWillEnterForeground)]) {
            [c applicationWillEnterForeground];
        }
    }
}

- (void)applicationDidEnterBackground {
    qltrace();
    UIViewController* vc = [self visibleViewController];
    if ([vc conformsToProtocol:@protocol(CDXAppWindowViewController)]) {
        UIViewController <CDXAppWindowViewController> *c = (UIViewController <CDXAppWindowViewController> *)vc;
        if ([c respondsToSelector:@selector(applicationDidEnterBackground)]) {
            [c applicationDidEnterBackground];
        }
    }
}

- (void)showActionSheet:(CDXActionSheet *)actionSheet viewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem *)barButtonItem {
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

- (void)pushFullScreenViewControllerAnimatedAndRemoveView:(NSArray *)data {
    qltrace();
    
    UIView *view = data[0];
    NSNumber *location_x = data[1];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.6];
    UIViewAnimationTransition transition = (location_x.floatValue > window.bounds.size.width / 2) ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight;
    [UIView setAnimationTransition:transition forView:window cache:NO];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(pushFullScreenViewControllerAnimationWillStart:context:)];
    [UIView setAnimationDidStopSelector:@selector(pushFullScreenViewControllerAnimationDidStop:finished:context:)];
    
    [view removeFromSuperview];
    [window addSubview:fullScreenViewController.view];
    [window setRootViewController:fullScreenViewController];
    
    [UIView commitAnimations];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)pushFullScreenViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated withTouchLocation:(CGPoint)location {
    ivar_assign_and_retain(fullScreenViewController, viewController);
    [fullScreenViewController setUserInteractionEnabled:!animated];
    if (animated) {
        CGFloat location_x = ([CDXDevice sharedDevice].deviceUIIdiom == CDXDeviceUIIdiomPad) ? (window.bounds.size.width - 1) : (location.x);
        navigationView.userInteractionEnabled = NO;
        if ([[CDXDevice sharedDevice] useImageBasedRendering]) {
            UIImageView *screenshotView = [[[UIImageView alloc] initWithImage:[[CDXImageFactory sharedImageFactory] imageForScreen]] autorelease];
            [navigationView removeFromSuperview];
            [window addSubview:screenshotView];
            [self performSelector:@selector(pushFullScreenViewControllerAnimatedAndRemoveView:) withObject:@[screenshotView, @(location_x)] afterDelay:0.001];
        } else {
            [self performSelector:@selector(pushFullScreenViewControllerAnimatedAndRemoveView:) withObject:@[navigationView, @(location_x)] afterDelay:0.001];
        }
    } else {
        [navigationView removeFromSuperview];
        [window addSubview:fullScreenViewController.view];
        [window setRootViewController:fullScreenViewController];
    }
}

- (void)popFullScreenViewControllerAnimationWillStart:(NSString *)animationID context:(void *)context {
    qltrace();
}

- (void)popFullScreenViewControllerAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    qltrace();
    navigationView.userInteractionEnabled = YES;
}

- (void)popFullScreenViewControllerAnimated:(BOOL)animated withTouchLocation:(CGPoint)location {
    qltrace(@"location %f %f", location.x, location.y);
    [fullScreenViewController setUserInteractionEnabled:NO];
    
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.6];
        UIViewAnimationTransition transition =  (location.x > window.bounds.size.width / 2) ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight;
        [UIView setAnimationTransition:transition forView:window cache:NO];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationWillStartSelector:@selector(popFullScreenViewControllerAnimationWillStart:context:)];
        [UIView setAnimationDidStopSelector:@selector(popFullScreenViewControllerAnimationDidStop:finished:context:)];
    } else {
        [self popFullScreenViewControllerAnimationDidStop:nil finished:nil context:NULL];
    }
    
    [fullScreenViewController.view removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [window addSubview:navigationView];
    [window setRootViewController:navigationViewController];
    
    if (animated) {
        [UIView commitAnimations];
    }
    
    ivar_release_and_clear(fullScreenViewController);
}

@end


@interface CDXAppWindowManagerPhone : CDXAppWindowManager {
    
@protected
    UINavigationController *navigationController;
}

@end


@implementation CDXAppWindowManagerPhone

synthesize_singleton_definition(sharedAppWindowManagerPhone, CDXAppWindowManagerPhone);

+ (void)initialize {
    synthesize_singleton_initialization_allocate(sharedAppWindowManagerPhone, CDXAppWindowManagerPhone);
    if (!sharedAppWindowManager) {
        sharedAppWindowManager = sharedAppWindowManagerPhone;
    }
}

synthesize_singleton_methods(sharedAppWindowManagerPhone, CDXAppWindowManagerPhone);

- (id)init {
    qltrace();
    if ((self = [super init])) {
        ivar_assign(navigationController, [[UINavigationController alloc] init]);
        navigationController.toolbarHidden = NO;

        navigationViewController = navigationController;
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


- (void)pushViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated withTouchLocation:(CGPoint)location {
    qltrace();
    if ([viewController respondsToSelector:@selector(requiresFullScreenLayout)] && [viewController requiresFullScreenLayout]) {
        [self pushFullScreenViewController:viewController animated:animated withTouchLocation:(CGPoint)location];
    } else {
        [navigationController pushViewController:viewController animated:animated];
    }
}

- (void)popViewControllerAnimated:(BOOL)animated withTouchLocation:(CGPoint)location {
    qltrace();
    if (fullScreenViewController != nil) {
        [self popFullScreenViewControllerAnimated:animated withTouchLocation:location];
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [window addSubview:navigationView];
    navigationView.frame = [[UIScreen mainScreen] bounds];
    [window setRootViewController:navigationViewController];
    [navigationView addSubview:navigationController.view];
    
    [window makeKeyAndVisible];
}

- (void)showActionSheet:(CDXActionSheet *)actionSheet viewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem *)barButtonItem {
    qltrace();
    [actionSheet presentWithViewController:viewController view:window animated:YES];
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
    CGRect frame = self.view.frame;
    leftViewController.view.frame = CGRectMake(0, 0, 340, frame.size.height);
    rightViewController.view.frame = CGRectMake(341, 0, frame.size.width - 341, frame.size.height);
}

- (void)viewDidLoad {
    qltrace();
    [super viewDidLoad];
    [leftViewController viewDidLoad];
    [rightViewController viewDidLoad];
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

synthesize_singleton_definition(sharedAppWindowManagerPad, CDXAppWindowManagerPad);

+ (void)initialize {
    synthesize_singleton_initialization_allocate(sharedAppWindowManagerPad, CDXAppWindowManagerPad);
    if (!sharedAppWindowManager) {
        sharedAppWindowManager = sharedAppWindowManagerPad;
    }
}

synthesize_singleton_methods(sharedAppWindowManagerPad, CDXAppWindowManagerPad);

- (id)init {
    qltrace();
    if ((self = [super init])) {
        ivar_assign(splitViewController, [[CDXLeftRightSplitViewController alloc] init]);
        ivar_assign(leftNavigationController, [[UINavigationController alloc] init]);
        [leftNavigationController setToolbarHidden:NO];
        [leftNavigationController setNavigationBarHidden:NO];
        [splitViewController setLeftViewController:leftNavigationController];
        ivar_assign(rightNavigationController, [[UINavigationController alloc] init]);
        [rightNavigationController setToolbarHidden:NO];
        [rightNavigationController setNavigationBarHidden:NO];
        rightNavigationController.navigationBar.prefersLargeTitles = YES;
        [splitViewController setRightViewController:rightNavigationController];

        navigationViewController = splitViewController;
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

- (void)pushViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated withTouchLocation:(CGPoint)location {
    qltrace();
    if (initialLeftViewController == nil) {
        ivar_assign_and_retain(initialLeftViewController, viewController);
        [leftNavigationController pushViewController:viewController animated:NO];
    } else {
        if ([viewController respondsToSelector:@selector(requiresFullScreenLayout)] && [viewController requiresFullScreenLayout]) {
            [self pushFullScreenViewController:viewController animated:animated withTouchLocation:location];
        } else {
            if (initialRightViewController == nil) {
                ivar_assign_and_retain(initialRightViewController, viewController);
            }
            [rightNavigationController setViewControllers:@[viewController] animated:NO];
        }
    }
}

- (void)popViewControllerAnimated:(BOOL)animated withTouchLocation:(CGPoint)location {
    qltrace();
    if (fullScreenViewController != nil) {
        [self popFullScreenViewControllerAnimated:animated withTouchLocation:location];
    } else {
        [rightNavigationController setViewControllers:@[initialRightViewController] animated:NO];
    }
}

- (void)popToInitialViewController {
    qltrace();
    if (fullScreenViewController != nil) {
        [self popViewControllerAnimated:NO];
    }
    [rightNavigationController setViewControllers:@[initialRightViewController] animated:NO];
}

- (void)makeWindowKeyAndVisible {
    qltrace();
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [window addSubview:navigationView];
    [window setRootViewController:navigationViewController];
    navigationView.frame = [[UIScreen mainScreen] bounds];
    [navigationView addSubview:splitViewController.view];
    
    [window makeKeyAndVisible];
}

- (void)menuControllerWillHideMenu:(NSNotification *)notification {
    UIViewController *vcleft = [leftNavigationController visibleViewController];
    if ([vcleft conformsToProtocol:@protocol(CDXAppWindowViewController)]) {
        [(UIViewController<CDXAppWindowViewController> *)vcleft menuControllerWillHideMenu];
    }
    UIViewController *vcright = [rightNavigationController visibleViewController];
    if ([vcright conformsToProtocol:@protocol(CDXAppWindowViewController)]) {
        [(UIViewController<CDXAppWindowViewController> *)vcright menuControllerWillHideMenu];
    }
}

- (void)presentModalViewController:(UIViewController *)viewController animated:(BOOL)animated {
    qltrace();
    if (modalViewControllerContainer != nil) {
        [self dismissModalViewControllerAnimated:animated];
    }
    
    [splitViewController presentViewController:viewController animated:animated completion:NULL];
}

- (void)presentModalViewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated {
    qltrace();
    if (modalViewControllerContainer != nil) {
        [self dismissModalViewControllerAnimated:animated];
        return;
    }
    
    ivar_assign(modalViewControllerContainer, [[UIPopoverController alloc] initWithContentViewController:viewController]);
    modalViewControllerContainer.delegate = self;
    modalViewControllerContainer.popoverContentSize = CGSizeMake(320, 720);

    [modalViewControllerContainer presentPopoverFromBarButtonItem:barButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:animated];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    qltrace();
    [self dismissModalViewControllerAnimated:NO];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    qltrace();
    [splitViewController dismissViewControllerAnimated:animated completion:NULL];
    [modalViewControllerContainer dismissPopoverAnimated:animated];
    ivar_release_and_clear(modalViewControllerContainer);
}

- (void)showActionSheet:(CDXActionSheet *)actionSheet viewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem *)barButtonItem {
    qltrace();
    [actionSheet presentWithViewController:viewController fromBarButtonItem:barButtonItem animated:NO];
}

@end

