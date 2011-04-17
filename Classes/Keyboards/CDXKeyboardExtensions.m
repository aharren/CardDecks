//
//
// CDXKeyboardExtensions.m
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

#import "CDXKeyboardExtensions.h"


@implementation CDXKeyboardExtensions

synthesize_singleton(sharedKeyboardExtensions, CDXKeyboardExtensions);

@synthesize responder;
@synthesize keyboardExtensions;

static float keyboardExtensionsOsVersion;

- (id)init {
    if ((self = [super init])) {
        ivar_assign(toolbar, [[UIToolbar alloc] init]);
        toolbar.barStyle = UIBarStyleDefault;
        ivar_assign(toolbarButtons, [[NSMutableArray alloc] init]);
        ivar_assign_and_retain(toolbarKeyboardButton, [self toolbarButtonWithTitle:@"abc"]);
        ivar_assign(toolbarActionButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                       target:self
                                                                                       action:@selector(toolbarActionButtonPressed)]);
        ivar_assign_and_retain(backgroundColor, [UIColor colorWithPatternImage:[UIImage imageNamed:@"KeyboardExtensionsBackground.png"]]);
        enabled = NO;
        visible = NO;
        activeExtensionTag = -1;
        keyboardExtensionsOsVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    }
    
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(toolbar);
    ivar_release_and_clear(toolbarButtons);
    ivar_release_and_clear(toolbarKeyboardButton);
    ivar_release_and_clear(toolbarActionButton);
    ivar_release_and_clear(responder);
    ivar_release_and_clear(keyboardExtensions);
    ivar_release_and_clear(backgroundColor);
    [super dealloc];
}

- (NSObject<CDXKeyboardExtension> *)keyboardExtensionByTag:(NSInteger)tag {
    if (tag >= 0) {
        return [[(NSObject<CDXKeyboardExtension> *)[keyboardExtensions objectAtIndex:tag] retain] autorelease];
    }
    
    return nil;
}

- (UIBarButtonItem *)toolbarButtonByTag:(NSInteger)tag {
    if (tag >= -1) {
        return [[(UIBarButtonItem *)[toolbarButtons objectAtIndex:tag + 1] retain] autorelease];
    }
    
    return toolbarKeyboardButton;
}

- (void)setToolbarHidden:(BOOL)hidden notification:(NSNotification *)notification {
    qltrace(@"hidden %d", hidden);
    CGRect keyboardBounds;
    CGPoint keyboardAnimationStartPoint;
    CGPoint keyboardAnimationEndPoint;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    // get animation information for the keyboard
    double keyboardAnimationDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardAnimationDuration];
    qltrace(@"FrameBegin");
    CGRect keyboardAnimationStartFrame;
    [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardAnimationStartFrame];
    CGRect keyboardAnimationEndFrame;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardAnimationEndFrame];
    keyboardAnimationEndPoint.x = keyboardAnimationEndFrame.origin.x + keyboardAnimationEndFrame.size.width / 2;
    keyboardAnimationEndPoint.y = keyboardAnimationEndFrame.origin.y + keyboardAnimationEndFrame.size.height / 2;
    keyboardAnimationStartPoint.x = keyboardAnimationStartFrame.origin.x + keyboardAnimationStartFrame.size.width / 2;
    keyboardAnimationStartPoint.y = keyboardAnimationStartFrame.origin.y + keyboardAnimationStartFrame.size.height / 2;
    keyboardBounds.origin = CGPointMake(0, 0);
    keyboardBounds.size = CGSizeMake(MAX(keyboardAnimationStartFrame.size.width, keyboardAnimationEndFrame.size.width),
                                     MAX(keyboardAnimationStartFrame.size.height, keyboardAnimationEndFrame.size.height));
    qltrace(@"start: %3f %3f", keyboardAnimationStartPoint.x, keyboardAnimationStartPoint.y);
    qltrace(@"end  : %3f %3f", keyboardAnimationEndPoint.x, keyboardAnimationEndPoint.y);
    BOOL offScreenNew = keyboardAnimationEndFrame.origin.x < 0 || keyboardAnimationEndFrame.origin.x >= screenWidth;
    if (offScreenNew && offScreen) {
        // already off-screen
        return;
    }
    offScreen = offScreenNew;

    // animate the toolbar?
    BOOL keyboardAnimationHasYDistance = keyboardAnimationStartPoint.y != keyboardAnimationEndPoint.y;
    BOOL keyboardAnimationHasXDistance = keyboardAnimationStartPoint.x != keyboardAnimationEndPoint.x;
    BOOL animated = keyboardAnimationHasYDistance || keyboardAnimationHasXDistance;
    if (!hidden) {
        animated = animated & !visible;
    }
    
    // add the toolbar view to the application's main window
    [[[UIApplication sharedApplication] keyWindow] addSubview:toolbar];
    [toolbar sizeToFit];
    
    // get animation information for the toolbar
    CGRect toolbarFrame = [toolbar frame];
    CGRect toolbarFrameAnimationStart = toolbarFrame;
    toolbarFrameAnimationStart.origin.y = keyboardAnimationStartPoint.y - keyboardBounds.size.height/2 - toolbarFrame.size.height;
    toolbarFrameAnimationStart.origin.x = keyboardAnimationStartPoint.x - keyboardBounds.size.width/2;
    CGRect toolbarFrameAnimationEnd = toolbarFrame;
    toolbarFrameAnimationEnd.origin.y = keyboardAnimationEndPoint.y - keyboardBounds.size.height/2 - toolbarFrame.size.height;
    toolbarFrameAnimationEnd.origin.x = keyboardAnimationEndPoint.x - keyboardBounds.size.width/2;
    if (toolbarFrameAnimationStart.origin.y >= screenHeight - toolbarFrame.size.height) {
        toolbarFrameAnimationStart.origin.y = screenHeight;
    }
    if (toolbarFrameAnimationEnd.origin.y >= screenHeight - toolbarFrame.size.height) {
        toolbarFrameAnimationEnd.origin.y = screenHeight;
    }
    
    // now, animate and position the toolbar
    if (animated) {
        [toolbar setFrame:toolbarFrameAnimationStart];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:keyboardAnimationDuration];
    }
    [toolbar setFrame:toolbarFrameAnimationEnd];
    
    if (hidden && activeExtensionTag != -1) {
        NSObject<CDXKeyboardExtension> *extension = [self keyboardExtensionByTag:activeExtensionTag];
        UIView *extensionView = [extension keyboardExtensionView];
        CGRect extensionViewFrameAnimationEnd = [extensionView frame];
        extensionViewFrameAnimationEnd.origin.y = keyboardAnimationEndPoint.y - keyboardBounds.size.height/2;
        extensionViewFrameAnimationEnd.origin.x = keyboardAnimationEndPoint.x - keyboardBounds.size.width/2;
        [extensionView setFrame:extensionViewFrameAnimationEnd];
    }
    if (!hidden && activeExtensionTag != -1) {
        [self deactivateKeyboardExtension:[self keyboardExtensionByTag:activeExtensionTag] tag:activeExtensionTag];
        [self activateKeyboardExtension:nil tag:-1];
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
    
    // remember the rectangle for the extension views
    if (!hidden) {
        extensionViewRect.size = keyboardBounds.size;
        extensionViewRect.origin.x = keyboardAnimationEndPoint.x - keyboardBounds.size.width/2;
        extensionViewRect.origin.y = keyboardAnimationEndPoint.y - keyboardBounds.size.height/2;
        extensionViewRect.size.height = extensionViewRect.size.height;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    qltrace();
    [self setToolbarHidden:NO notification:notification];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    qltrace();
    visible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    qltrace();
    [self setToolbarHidden:YES notification:notification];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    qltrace();
    [toolbar removeFromSuperview];
    visible = NO;
}

- (void)setEnabled:(BOOL)aEnabled {
    // nothing to do if already enabled
    if (enabled == aEnabled)
        return;
    
    enabled = aEnabled;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if (enabled) {
        // register for keyboard...Show events
        [notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    } else {
        // deregister for all events
        [notificationCenter removeObserver:self];
    }
}

- (void)setResponder:(NSObject *)aResponder keyboardExtensions:(NSArray *)aKeyboardExtensions {
    NSInteger tag = -1;
    ivar_assign_and_retain(responder, aResponder);
    [toolbarButtons removeAllObjects];
    [toolbarButtons addObject:toolbarKeyboardButton];
    toolbarKeyboardButton.tag = tag;
    
    ivar_assign_and_copy(keyboardExtensions, aKeyboardExtensions);
    for (NSObject<CDXKeyboardExtension> *extension in keyboardExtensions) {
        UIBarButtonItem *button = [self toolbarButtonWithTitle:[extension keyboardExtensionTitle]];
        button.tag = ++tag;
        [toolbarButtons addObject:button];
        [extension keyboardExtensionInitialize];
    }
    
    if ([aResponder conformsToProtocol:@protocol(CDXKeyboardExtensionResponderWithActions)]) {
        [toolbarButtons addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
        [toolbarButtons addObject:toolbarActionButton];
    }
    
    // set the toolbar buttons
    [toolbar setItems:toolbarButtons animated:NO];
    
    [self activateKeyboardExtension:nil tag:-1];
}

- (void)removeResponder {
    ivar_release_and_clear(responder);
}

- (UIWindow *)keyboardWindow {
    // try to find the keyboard's window
    NSArray *applicationWindows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in applicationWindows) {
        for (UIView *view in [window subviews]) {
            if ([@"UIKeyboard" isEqualToString:NSStringFromClass([view class])]) {
                return window;
            }
        }
    }
    // return the second window
    if ([applicationWindows count] > 1) {
        return [applicationWindows objectAtIndex:1];
    }
    // fail
    return nil;
}

- (UIBarButtonItem *)toolbarButtonWithTitle:(NSString *)title {
    UIBarButtonItem *button = [[[UIBarButtonItem alloc] 
                                initWithTitle:title
                                style:UIBarButtonItemStyleBordered
                                target:self action:@selector(toolbarButtonPressed:)]
                               autorelease];
    button.width = 40;
    return button;
}

- (void)refreshKeyboardExtensions {
    NSUInteger count = [keyboardExtensions count];
    for (NSUInteger tag = 0; tag < count; tag++) {
        NSObject<CDXKeyboardExtension> *keyboardExtension = [keyboardExtensions objectAtIndex:tag];
        if (tag == activeExtensionTag) {
            if ([keyboardExtension respondsToSelector:@selector(keyboardExtensionWillBecomeActive)]) {
                [keyboardExtension keyboardExtensionWillBecomeActive];
            }
        }
        UIBarButtonItem *button = [toolbarButtons objectAtIndex:tag+1];
        button.title = [keyboardExtension keyboardExtensionTitle];
        if (tag == activeExtensionTag) {
            if ([keyboardExtension respondsToSelector:@selector(keyboardExtensionDidBecomeActive)]) {
                [keyboardExtension keyboardExtensionDidBecomeActive];
            }
        }
    }
}

- (void)activateKeyboardExtension:(NSObject<CDXKeyboardExtension> *)keyboardExtension tag:(NSInteger)tag {
    if ([keyboardExtension respondsToSelector:@selector(keyboardExtensionWillBecomeActive)]) {
        [keyboardExtension keyboardExtensionWillBecomeActive];
    }
    
    if (keyboardExtension != nil) {
        UIView *view = [keyboardExtension keyboardExtensionView];
        view.frame = extensionViewRect;
        [[self keyboardWindow] addSubview:view];
    }
    
    if ([keyboardExtension respondsToSelector:@selector(keyboardExtensionDidBecomeActive)]) {
        [keyboardExtension keyboardExtensionDidBecomeActive];
    }
    
    activeExtensionTag = tag;
    UIBarButtonItem *button = [self toolbarButtonByTag:tag];
    button.enabled = NO;
    if (tag != -1) {
        button.title = [keyboardExtension keyboardExtensionTitle];
    }
    
    if ([responder conformsToProtocol:@protocol(CDXKeyboardExtensionResponderWithActions)]) {
        NSObject<CDXKeyboardExtensionResponderWithActions> *r = (NSObject<CDXKeyboardExtensionResponderWithActions> *)responder;
        toolbarActionButton.enabled = [r keyboardExtensionResponderHasActionsForExtensionAtIndex:tag];
    }
    
    if ([responder conformsToProtocol:@protocol(CDXKeyboardExtensionResponder)] &&
        [responder respondsToSelector:@selector(keyboardExtensionResponderExtensionBecameActiveAtIndex:)]) {
        NSObject<CDXKeyboardExtensionResponder> *r = (NSObject<CDXKeyboardExtensionResponder> *)responder;
        [r keyboardExtensionResponderExtensionBecameActiveAtIndex:tag];
    }
}

- (void)deactivateKeyboardExtension:(NSObject<CDXKeyboardExtension> *)keyboardExtension tag:(NSInteger)tag {
    if ([keyboardExtension respondsToSelector:@selector(keyboardExtensionWillBecomeInactive)]) {
        [keyboardExtension keyboardExtensionWillBecomeInactive];
    }    
    
    if (keyboardExtension != nil) {
        UIView *view = [keyboardExtension keyboardExtensionView];
        [view removeFromSuperview];
    }
    
    if ([keyboardExtension respondsToSelector:@selector(keyboardExtensionDidBecomeInactive)]) {
        [keyboardExtension keyboardExtensionDidBecomeInactive];
    }    
    
    UIBarButtonItem *button = [self toolbarButtonByTag:tag];
    button.enabled = YES;
}

- (void)toolbarButtonPressed:(id)sender {
    UIBarButtonItem *toolbarButton = (UIBarButtonItem *)sender;
    NSInteger eventExtensionTag = toolbarButton.tag;
    
    if (activeExtensionTag == eventExtensionTag) {
        // nothing to do
        return;
    }
    
    [self deactivateKeyboardExtension:[self keyboardExtensionByTag:activeExtensionTag] tag:activeExtensionTag];
    [self activateKeyboardExtension:[self keyboardExtensionByTag:eventExtensionTag] tag:eventExtensionTag];
}

- (void)toolbarActionButtonPressed {
    if ([responder conformsToProtocol:@protocol(CDXKeyboardExtensionResponderWithActions)]) {
        NSObject<CDXKeyboardExtensionResponderWithActions> *r = (NSObject<CDXKeyboardExtensionResponderWithActions> *)responder;
        if ([r keyboardExtensionResponderHasActionsForExtensionAtIndex:activeExtensionTag]) {
            [r keyboardExtensionResponderRunActionsForExtensionAtIndex:activeExtensionTag];
        }
    }
}

- (UIColor *)backgroundColor {
    return [[backgroundColor retain] autorelease];
}

@end

