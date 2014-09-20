//
//
// CDXKeyboardExtensions.m
//
//
// Copyright (c) 2009-2014 Arne Harren <ah@0xc0.de>
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
#import "CDXDevice.h"


@implementation CDXKeyboardExtensions

synthesize_singleton(sharedKeyboardExtensions, CDXKeyboardExtensions);

@synthesize responder;
@synthesize keyboardExtensions;

static float keyboardExtensionsOsVersion;

- (id)init {
    if ((self = [super init])) {
        ivar_assign(toolbar, [[UIToolbar alloc] init]);
        toolbar.alpha = 0;
        toolbar.barStyle = UIBarStyleDefault;
        toolbar.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, 0, 32);
        toolbar.backgroundColor = [UIColor whiteColor];
        ivar_assign(toolbarButtons, [[NSMutableArray alloc] init]);
        ivar_assign_and_retain(toolbarKeyboardButton, [self toolbarButtonWithTitle:@"abc"]);
        ivar_assign(toolbarActionButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                       target:self
                                                                                       action:@selector(toolbarActionButtonPressed:)]);
        ivar_assign_and_retain(backgroundColor, [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]);
        enabled = NO;
        visible = NO;
        activeExtensionTag = -1;
        keyboardExtensionsOsVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        ivar_assign(viewInactiveExtensions, [[UIView alloc] init]);
        if ([[CDXDevice sharedDevice] deviceUIIdiom] == CDXDeviceUIIdiomPad) {
            viewInactiveExtensions.backgroundColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:0.5];
        }
        viewInactiveExtensions.userInteractionEnabled = NO;
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
    ivar_release_and_clear(viewInactiveExtensions);
    [super dealloc];
}

- (NSObject<CDXKeyboardExtension> *)keyboardExtensionByTag:(NSInteger)tag {
    if (tag >= 0) {
        return [[(NSObject<CDXKeyboardExtension> *)keyboardExtensions[tag] retain] autorelease];
    }
    
    return nil;
}

- (UIBarButtonItem *)toolbarButtonByTag:(NSInteger)tag {
    if (tag >= -1) {
        return [[(UIBarButtonItem *)toolbarButtons[tag + 1] retain] autorelease];
    }
    
    return toolbarKeyboardButton;
}

- (void)setToolbarHidden:(BOOL)hide notification:(NSNotification *)notification {
    qltrace(@"hide %d, %@", hide, notification);
    
    // get animation information for the keyboard
    double keyboardAnimationDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardAnimationDuration];
    UIViewAnimationCurve keyboardAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardAnimationCurve];
    CGRect keyboardAnimationBeginFrame;
    [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardAnimationBeginFrame];
    CGRect keyboardAnimationEndFrame;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardAnimationEndFrame];
    
    // remember the rectangle for the extension views
    if (!hide) {
        extensionViewRect = keyboardAnimationEndFrame;
    }

    // add the toolbar view to the application's main window
    [[[UIApplication sharedApplication] keyWindow] addSubview:toolbar];
    [toolbar sizeToFit];
    toolbar.frame = CGRectMake(keyboardAnimationBeginFrame.origin.x, keyboardAnimationBeginFrame.origin.y - toolbar.frame.size.height,
                               keyboardAnimationBeginFrame.size.width, toolbar.frame.size.height);

    [UIView setAnimationsEnabled:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:keyboardAnimationCurve];
    [UIView setAnimationDuration:keyboardAnimationDuration];
    
    toolbar.alpha = hide ? 0 : 1;
    toolbar.frame = CGRectMake(keyboardAnimationEndFrame.origin.x, keyboardAnimationEndFrame.origin.y - toolbar.frame.size.height,
                               keyboardAnimationEndFrame.size.width, toolbar.frame.size.height);
    
    if (activeExtensionTag != -1) {
        if (hide) {
            NSObject<CDXKeyboardExtension> *extension = [self keyboardExtensionByTag:activeExtensionTag];
            UIView *extensionView = [extension keyboardExtensionView];
            extensionView.frame = keyboardAnimationEndFrame;
            extensionView.alpha = 0;
            viewInactiveExtensions.hidden = YES;
        } else {
            [self deactivateKeyboardExtension:[self keyboardExtensionByTag:activeExtensionTag] tag:activeExtensionTag];
            [self activateKeyboardExtension:nil tag:-1];
        }
    }

    [UIView commitAnimations];
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
    
    NSUInteger alignmentFixWidth = ([[[CDXDevice sharedDevice] deviceSystemVersionString] floatValue] >= 8.0) ? 17 : 0;
    UIBarButtonItem *leftAlignmentFix = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    leftAlignmentFix.width = alignmentFixWidth;
    leftAlignmentFix.enabled = NO;
    UIBarButtonItem *rightAlignmentFix = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    rightAlignmentFix.width = alignmentFixWidth;
    rightAlignmentFix.enabled = NO;

    // set the toolbar buttons
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:toolbarButtons.count + 2];
    [buttons addObject:leftAlignmentFix];
    [buttons addObjectsFromArray:toolbarButtons];
    [buttons addObject:rightAlignmentFix];
    [toolbar setItems:buttons animated:NO];
    
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
        return applicationWindows[1];
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
    button.width = 41;
    NSDictionary *textAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:15] };
    [button setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    return button;
}

- (void)refreshKeyboardExtensions {
    NSUInteger count = [keyboardExtensions count];
    for (NSUInteger tag = 0; tag < count; tag++) {
        NSObject<CDXKeyboardExtension> *keyboardExtension = keyboardExtensions[tag];
        if (tag == activeExtensionTag) {
            if ([keyboardExtension respondsToSelector:@selector(keyboardExtensionWillBecomeActive)]) {
                [keyboardExtension keyboardExtensionWillBecomeActive];
            }
        }
        UIBarButtonItem *button = toolbarButtons[tag+1];
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
        view.alpha = 1;
        [[self keyboardWindow] addSubview:view];
        
        viewInactiveExtensions.frame = extensionViewRect;
        viewInactiveExtensions.hidden = YES;
        [[self keyboardWindow] addSubview:viewInactiveExtensions];
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
        
        [viewInactiveExtensions removeFromSuperview];
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

- (void)toolbarActionButtonPressed:(id)sender {
    UIBarButtonItem *toolbarButton = (UIBarButtonItem *)sender;
    if ([responder conformsToProtocol:@protocol(CDXKeyboardExtensionResponderWithActions)]) {
        NSObject<CDXKeyboardExtensionResponderWithActions> *r = (NSObject<CDXKeyboardExtensionResponderWithActions> *)responder;
        if ([r keyboardExtensionResponderHasActionsForExtensionAtIndex:activeExtensionTag]) {
            [r keyboardExtensionResponderRunActionsForExtensionAtIndex:activeExtensionTag barButtonItem:(UIBarButtonItem *)toolbarButton];
        }
    }
}

- (UIColor *)backgroundColor {
    return [[backgroundColor retain] autorelease];
}

- (void)setInactive:(BOOL)inactive {
    viewInactiveExtensions.hidden = !inactive;
}

@end

