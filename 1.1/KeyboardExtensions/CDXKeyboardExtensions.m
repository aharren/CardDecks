//
//
// CDXKeyboardExtensions.m
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

#import "CDXKeyboardExtensions.h"


@implementation CDXKeyboardExtensions

#define LogFileComponent lcl_cCDXKeyboardExtensions

static CDXKeyboardExtensions *_sharedInstance;

@synthesize responder = _responder;
@synthesize extensions = _extensions;

+ (void)initialize {
    // perform initialization only once
    if (self != [CDXKeyboardExtensions class])
        return;
    
    _sharedInstance = [[CDXKeyboardExtensions alloc] init];
}

- (id)init {
    if ((self = [super init])) {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.barStyle = UIBarStyleBlackTranslucent;
        _toolbarButtons = [[NSMutableArray alloc] init];
        
        _backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"KeyboardExtensionsBackground.png"]] retain];
        
        _toolbarKeyboardButton = [[self toolbarButtonWithTitle:@"Keyboard"] retain];
        _enabled = NO;
        _visible = NO;
        _activeExtensionTag = -1;
    }
    
    return self;
}

- (void)dealloc {
    [_toolbar removeFromSuperview];
    [_toolbar release];
    _toolbar = nil;
    [_toolbarButtons release];
    _toolbarButtons = nil;
    [_toolbarKeyboardButton release];
    _toolbarKeyboardButton = nil;
    
    self.responder = nil;
    self.extensions = nil;
    
    [super dealloc];
}

- (NSObject <CDXKeyboardExtension> *)extensionByTag:(NSInteger)tag {
    if (tag >= 0)
        return [[(NSObject <CDXKeyboardExtension> *)[_extensions objectAtIndex:tag] retain] autorelease];
    
    return nil;
}

- (UIBarButtonItem *)toolbarButtonByTag:(NSInteger)tag {
    if (tag >= -1)
        return [[(UIBarButtonItem *)[_toolbarButtons objectAtIndex:tag + 1] retain] autorelease];
    
    return _toolbarKeyboardButton;
}

- (void)setToolbarHidden:(BOOL)hidden notification:(NSNotification *)notification {
    LogInvocation();
    
    // get animation information for the keyboard
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardBounds];
    double keyboardAnimationDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardAnimationDuration];
    CGPoint keyboardAnimationStartPoint;
    [[notification.userInfo valueForKey:UIKeyboardCenterBeginUserInfoKey] getValue:&keyboardAnimationStartPoint];
    CGPoint keyboardAnimationEndPoint;
    [[notification.userInfo valueForKey:UIKeyboardCenterEndUserInfoKey] getValue:&keyboardAnimationEndPoint];
    
    // animate the toolbar?
    BOOL keyboardAnimationHasYDistance = keyboardAnimationStartPoint.y != keyboardAnimationEndPoint.y;
    BOOL keyboardAnimationHasXDistance = keyboardAnimationStartPoint.x != keyboardAnimationEndPoint.x;
    BOOL animated = keyboardAnimationHasYDistance || keyboardAnimationHasXDistance;
    if (!hidden) {
        animated = animated & !_visible;
    }
    
    // add the toolbar view to the application's main window
    [[[UIApplication sharedApplication] keyWindow] addSubview:_toolbar];
    [_toolbar sizeToFit];
    
    // get animation information for the toolbar
    CGRect toolbarFrame = [_toolbar frame];
    CGRect toolbarFrameAnimationStart = toolbarFrame;
    toolbarFrameAnimationStart.origin.y = keyboardAnimationStartPoint.y - keyboardBounds.size.height/2 - toolbarFrame.size.height;
    toolbarFrameAnimationStart.origin.x = keyboardAnimationStartPoint.x - keyboardBounds.size.width/2;
    CGRect toolbarFrameAnimationEnd = toolbarFrame;
    toolbarFrameAnimationEnd.origin.y = keyboardAnimationEndPoint.y - keyboardBounds.size.height/2 - toolbarFrame.size.height;
    toolbarFrameAnimationEnd.origin.x = keyboardAnimationEndPoint.x - keyboardBounds.size.width/2;
    if (toolbarFrameAnimationStart.origin.y >= 480 - toolbarFrame.size.height) {
        toolbarFrameAnimationStart.origin.y = 480;
    }
    if (toolbarFrameAnimationEnd.origin.y >= 480 - toolbarFrame.size.height) {
        toolbarFrameAnimationEnd.origin.y = 480;
    }
    
    // now, animate and position the toolbar
    if (animated) {
        [_toolbar setFrame:toolbarFrameAnimationStart];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:keyboardAnimationDuration];
    }
    [_toolbar setFrame:toolbarFrameAnimationEnd];
    
    if (hidden && _activeExtensionTag != -1) {
        NSObject <CDXKeyboardExtension> *extension = [self extensionByTag:_activeExtensionTag];
        UIView *extensionView = [extension extensionView];
        CGRect extensionViewFrameAnimationEnd = [extensionView frame];
        extensionViewFrameAnimationEnd.origin.y = keyboardAnimationEndPoint.y - keyboardBounds.size.height/2;
        extensionViewFrameAnimationEnd.origin.x = keyboardAnimationEndPoint.x - keyboardBounds.size.width/2;
        [extensionView setFrame:extensionViewFrameAnimationEnd];
    }
    if (!hidden && _activeExtensionTag != -1) {
        [self deactivateExtension:[self extensionByTag:_activeExtensionTag] tag:_activeExtensionTag];
        [self activateExtension:nil tag:-1];
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
    
    // remember the rectangle for the extension views
    if (!hidden) {
        _extensionViewRect.size = keyboardBounds.size;
        _extensionViewRect.origin.x = keyboardAnimationEndPoint.x - keyboardBounds.size.width/2;
        _extensionViewRect.origin.y = keyboardAnimationEndPoint.y - keyboardBounds.size.height/2;
        _extensionViewRect.size.height = _extensionViewRect.size.height;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    LogInvocation();
    
    [self setToolbarHidden:NO notification:notification];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    LogInvocation();
    
    _visible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    LogInvocation();
    
    [self setToolbarHidden:YES notification:notification];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    LogInvocation();
    
    [_toolbar removeFromSuperview];
    _visible = NO;
}

- (void)setEnabled:(BOOL)enabled {
    LogInvocation();
    
    // nothing to do if already enabled
    if (enabled == _enabled)
        return;
    
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
    
    // remember
    _enabled = enabled;
}

- (void)setResponder:(NSObject *)responder extensions:(NSArray *)extensions {
    LogInvocation();
    NSInteger tag = -1;
    self.responder = responder;
    [_toolbarButtons removeAllObjects];
    [_toolbarButtons addObject:_toolbarKeyboardButton];
    _toolbarKeyboardButton.tag = tag;
    
    for (NSObject <CDXKeyboardExtension> *extension in extensions) {
        UIBarButtonItem *button = [self toolbarButtonWithTitle:[extension extensionTitle]];
        button.tag = ++tag;
        [_toolbarButtons addObject:button];
        [extension extensionInitialize];
    }
    
    // keep the extensions
    self.extensions = extensions;
    
    // set the toolbar buttons
    [_toolbar setItems:_toolbarButtons animated:NO];
    
    [self activateExtension:nil tag:-1];
}

- (UIWindow *)keyboardWindow {
    // try to find the keyboard's window
    NSArray *applicationWindows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in applicationWindows) {
        LogDebug(@"%@", window);
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
    LogInvocation();
    
    return [[[UIBarButtonItem alloc] 
             initWithTitle:title
             style:UIBarButtonItemStyleBordered
             target:self action:@selector(toolbarButtonPressed:)]
            autorelease];
}

- (void)activateExtension:(NSObject <CDXKeyboardExtension> *)extension tag:(NSInteger)tag {
    LogInvocation();
    
    if ([extension respondsToSelector:@selector(extensionWillBecomeActive)]) {
        [extension extensionWillBecomeActive];
    }
    
    if (extension != nil) {
        UIView *view = [extension extensionView];
        view.frame = _extensionViewRect;
        [[self keyboardWindow] addSubview:view];
    }
    
    if ([extension respondsToSelector:@selector(extensionDidBecomeActive)]) {
        [extension extensionDidBecomeActive];
    }
    
    _activeExtensionTag = tag;
    UIBarButtonItem *button = [self toolbarButtonByTag:tag];
    button.style = UIBarButtonItemStyleDone;
}

- (void)deactivateExtension:(NSObject <CDXKeyboardExtension> *)extension tag:(NSInteger)tag {
    LogInvocation();
    
    if ([extension respondsToSelector:@selector(extensionWillBecomeInactive)]) {
        [extension extensionWillBecomeInactive];
    }    
    
    if (extension != nil) {
        UIView *view = [extension extensionView];
        [view removeFromSuperview];
    }
    
    if ([extension respondsToSelector:@selector(extensionDidBecomeInactive)]) {
        [extension extensionDidBecomeInactive];
    }    
    
    UIBarButtonItem *button = [self toolbarButtonByTag:tag];
    button.style = UIBarButtonItemStyleBordered;
}

- (void)toolbarButtonPressed:(id)sender {
    LogInvocation();
    
    UIBarButtonItem *toolbarButton = (UIBarButtonItem *)sender;
    
    NSInteger activeExtensionTag = _activeExtensionTag;
    NSInteger eventExtensionTag = toolbarButton.tag;
    
    if (activeExtensionTag == eventExtensionTag) {
        // nothing to do
        return;
    }
    
    [self deactivateExtension:[self extensionByTag:activeExtensionTag] tag:activeExtensionTag];
    [self activateExtension:[self extensionByTag:eventExtensionTag] tag:eventExtensionTag];
}

- (UIColor *)backgroundColor {
    return [[_backgroundColor retain] autorelease];
}

+ (CDXKeyboardExtensions *)sharedInstance {
    LogInvocation();
    
    return _sharedInstance;
}

@end

