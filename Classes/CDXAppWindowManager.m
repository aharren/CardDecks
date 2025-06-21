//
//
// CDXAppWindowManager.m
//
//
// Copyright (c) 2009-2025 Arne Harren <ah@0xc0.de>
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

- (UIUserInterfaceStyle)userInterfaceStyle {
    return window.traitCollection.userInterfaceStyle;
}

- (UIEdgeInsets)safeAreaInsets {
    // we only consider portrait mode here, because the app is always in portrait mode
    // since iOS 12, top also reflects the size of the status bar; so, we use bottom here for detection
    qltrace(@"top %f bottom %f", window.safeAreaInsets.top, window.safeAreaInsets.bottom);
    CGFloat inset = 0;
    if (window.safeAreaInsets.bottom > 0) {
        inset = 38;
        if (window.safeAreaInsets.top > 50) {
            inset = 54;
        }
    }
    return UIEdgeInsetsMake(inset, 0, inset, 0);
}

- (UIEdgeInsets)maxSafeAreaInsets {
    UIEdgeInsets insets = [self safeAreaInsets];
    CGFloat maxTopBottomInset = MAX(insets.top, insets.bottom);
    insets.top = maxTopBottomInset;
    insets.bottom = maxTopBottomInset;
    qltrace(@"top %f bottom %f", insets.top, insets.bottom);
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

- (void)showNoticeWithImageNamed:(NSString *)name text:(NSString *)text timeInterval:(NSTimeInterval)timeInterval orientation:(UIDeviceOrientation)orientation view:(UIView*)viewOrNil {
    qltrace();
    [[NSBundle mainBundle] loadNibNamed:@"CDXAppWindowNoticeView" owner:self options:nil];
    [noticeView showImageNamed:name text:text timeInterval:timeInterval orientation:orientation view:viewOrNil != nil ? viewOrNil : window];
    ivar_release_and_clear(noticeView);
}

- (void)showInfoMessage:(NSString *)text afterDelay:(NSTimeInterval)timeDelay {
    qltrace();
    [[NSBundle mainBundle] loadNibNamed:@"CDXAppWindowMessageView" owner:self options:nil];
    CGFloat height = MAX([self safeAreaInsets].top, 22) + 44;
    [messageView showMessage:text timeInterval:2 view:window backgroundColor:[CDXColor colorWithRed:0 green:121 blue:255 alpha:220].uiColor height:height afterDelay:timeDelay];
    ivar_release_and_clear(messageView);
}

- (void)showErrorMessage:(NSString *)text afterDelay:(NSTimeInterval)timeDelay {
    qltrace();
    [[NSBundle mainBundle] loadNibNamed:@"CDXAppWindowMessageView" owner:self options:nil];
    CGFloat height = MAX([self safeAreaInsets].top, 22) + 44;
    [messageView showMessage:text timeInterval:2 view:window backgroundColor:[CDXColor colorWithRed:255 green:0 blue:0 alpha:220].uiColor height:height afterDelay:timeDelay];
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

- (void)pushFullScreenViewController:(UIViewController<CDXAppWindowViewController> *)viewController animated:(BOOL)animated withTouchLocation:(CGPoint)location {
    ivar_assign_and_retain(fullScreenViewController, viewController);
    [fullScreenViewController setUserInteractionEnabled:!animated];

    UIViewAnimationOptions transition = (location.x > window.bounds.size.width / 2) ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
    UIViewAnimationOptions curve = UIViewAnimationOptionCurveEaseInOut;
    UIViewAnimationOptions flags = UIViewAnimationOptionLayoutSubviews;
    UIViewAnimationOptions animateOptions = transition | curve | flags;
    
    [UIView transitionWithView:window duration:animated ? 0.6 : 0 options:animateOptions animations:^{
        [window setRootViewController:fullScreenViewController];
    } completion:^(BOOL finished) {
        [fullScreenViewController setUserInteractionEnabled:YES];
    }];
}

- (void)popFullScreenViewControllerAnimated:(BOOL)animated withTouchLocation:(CGPoint)location {
    qltrace(@"location %f %f", location.x, location.y);
    [fullScreenViewController setUserInteractionEnabled:NO];
    
    UIViewAnimationOptions transition = (location.x > window.bounds.size.width / 2) ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
    UIViewAnimationOptions curve = UIViewAnimationOptionCurveEaseInOut;
    UIViewAnimationOptions flags = UIViewAnimationOptionLayoutSubviews;
    UIViewAnimationOptions animateOptions = transition | curve | flags;

    [UIView transitionWithView:window duration:animated ? 0.6 : 0 options:animateOptions animations:^{
        [window setRootViewController:navigationViewController];
    } completion:^(BOOL finished) {
    }];
    
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
    
    [window setRootViewController:navigationViewController];
    [window makeKeyAndVisible];
}

- (void)showActionSheet:(CDXActionSheet *)actionSheet viewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem *)barButtonItem {
    qltrace();
    [actionSheet presentWithViewController:viewController view:window animated:YES];
}

@end


@interface CDXAppWindowManagerPad : CDXAppWindowManager<UIPopoverControllerDelegate> {
    
@protected
    UISplitViewController* splitViewController;
    
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
        ivar_assign(splitViewController, [[UISplitViewController alloc] initWithStyle:UISplitViewControllerStyleDoubleColumn]);
        ivar_assign(leftNavigationController, [[UINavigationController alloc] init]);
        [leftNavigationController setToolbarHidden:NO];
        [leftNavigationController setNavigationBarHidden:NO];
        [splitViewController setViewController:leftNavigationController forColumn:UISplitViewControllerColumnPrimary];
        ivar_assign(rightNavigationController, [[UINavigationController alloc] init]);
        [rightNavigationController setToolbarHidden:NO];
        [rightNavigationController setNavigationBarHidden:NO];
        rightNavigationController.navigationBar.prefersLargeTitles = [CDXDevice sharedDevice].useLargeTitles;
        [splitViewController setViewController:rightNavigationController forColumn:UISplitViewControllerColumnSecondary];

        [splitViewController setPreferredSplitBehavior:UISplitViewControllerSplitBehaviorTile];
        [splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModeOneBesideSecondary];
        
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
    
    [window setRootViewController:navigationViewController];    
    [window makeKeyAndVisible];
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
    modalViewControllerContainer.popoverContentSize = CGSizeMake(520, 820);

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

