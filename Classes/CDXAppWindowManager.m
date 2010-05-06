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


@interface CDXAppWindowManagerAnimationContext : NSObject {
    
@protected
    UIView *viewToRemove;
    UIView *viewToAdd;
}

@property (nonatomic, retain) UIView *viewToRemove;
@property (nonatomic, retain) UIView *viewToAdd;

@end


@implementation CDXAppWindowManagerAnimationContext

@synthesize viewToRemove;
@synthesize viewToAdd;

- (void) dealloc {
    ivar_release_and_clear(viewToRemove);
    ivar_release_and_clear(viewToAdd);
    [super dealloc];
}

@end


@implementation CDXAppWindowManager

synthesize_singleton(sharedAppWindowManager, CDXAppWindowManager);

- (id)init {
    if ((self = [super init])) {
        ivar_assign(navigationController, [[UINavigationController alloc] init]);
    }
    return self;
}

- (void)pushViewControllerAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    CDXAppWindowManagerAnimationContext *animationContext = (CDXAppWindowManagerAnimationContext *)context;
    [animationContext.viewToRemove removeFromSuperview];
    [window addSubview:animationContext.viewToAdd];
    [animationContext release];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController wantsFullScreenLayout]) {
        UIView *viewToHide = navigationController.view;
        UIView *viewToShow = viewController.view;
        if (animated) {
            [window addSubview:viewToShow];
            UIImage *image = [[CDXImageFactory sharedImageFactory] imageForView:viewToShow size:[UIScreen mainScreen].bounds.size];
            UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
            [viewToShow removeFromSuperview];
            viewToShow = imageView;
            
            CDXAppWindowManagerAnimationContext *animationContext = [[CDXAppWindowManagerAnimationContext alloc] init];
            animationContext.viewToAdd = viewController.view;
            animationContext.viewToRemove = imageView;
            
            [UIView beginAnimations:nil context:animationContext];
            [UIView setAnimationDuration:0.6];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:YES];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(pushViewControllerAnimationDidStop:finished:context:)];
        }
        
        [navigationController pushViewController:viewController animated:NO];
        [viewToHide removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
        [window addSubview:viewToShow];
        
        if (animated) {
            [UIView commitAnimations];
        }
    } else {
        [navigationController pushViewController:viewController animated:animated];
    }
}

- (void)popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewControllerToHide = [navigationController visibleViewController];
    if ([viewControllerToHide wantsFullScreenLayout]) {
        UIView *viewToHide = viewControllerToHide.view;
        UIView *viewToShow = navigationController.view;
        if (animated) {
            UIImage *image = [[CDXImageFactory sharedImageFactory] imageForView:viewToHide size:[UIScreen mainScreen].bounds.size];
            UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
            [window addSubview:imageView];
            [viewToHide removeFromSuperview];
            viewToHide = imageView;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.6];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        }
        
        [navigationController popViewControllerAnimated:NO];
        [viewToHide removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
        [window addSubview:viewToShow];
        
        if (animated) {
            [UIView commitAnimations];
        }
    } else {
        [navigationController popViewControllerAnimated:animated];
    }
}

- (void)makeWindowKeyAndVisible {
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
}

@end

