//
//
// CDXKeyboardExtensions.h
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


@protocol CDXKeyboardExtension

@required

- (void)keyboardExtensionInitialize;
- (void)keyboardExtensionReset;

- (NSString *)keyboardExtensionTitle;
- (UIView *)keyboardExtensionView;

@end


@protocol CDXKeyboardExtensionResponder

@optional
- (void)keyboardExtensionResponderExtensionBecameActiveAtIndex:(NSUInteger)index;

@end


@protocol CDXKeyboardExtensionResponderWithActions

@required
- (BOOL)keyboardExtensionResponderHasActionsForExtensionAtIndex:(NSUInteger)index;
- (void)keyboardExtensionResponderRunActionsForExtensionAtIndex:(NSUInteger)index barButtonItem:(UIBarButtonItem *)barButtonItem;

@end


@interface CDXKeyboardExtensionMarker : NSObject {
    
@protected
    UILabel *label;
    
}

@property (nonatomic, readonly) UIView *view;

- (void)positionAtBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
- (void)show;
- (void)hide;

@end


@interface CDXKeyboardExtensions : NSObject {
    
@protected
    UIToolbar *toolbar;
    NSMutableArray *toolbarButtons;
    UIBarButtonItem *toolbarKeyboardButton;
    UIBarButtonItem *toolbarActionButton;
    CDXKeyboardExtensionMarker *toolbarActiveButtonMarker;
    
    NSObject *responder;
    NSArray<UITextField *> *textFields;
    NSArray<UITextView *> *textViews;
    CGRect extensionViewRect;
    BOOL extensionViewRectIsSet;
    
    UIView *backgroundView;
    
    UIColor *backgroundColor;
    
    BOOL enabled;
    BOOL visible;
    BOOL offScreen;
    
    NSInteger activeExtensionTag;
    NSArray *keyboardExtensions;

    UIView *viewInactiveExtensions;
}

declare_singleton(sharedKeyboardExtensions, CDXKeyboardExtensions);

@property (nonatomic, retain) NSObject *responder;
@property (nonatomic, retain) NSArray<UITextField *> *textFields;
@property (nonatomic, retain) NSArray<UITextView *> *textViews;
@property (nonatomic, copy) NSArray *keyboardExtensions;

- (void)setResponder:(NSObject *)responder keyboardExtensions:(NSArray *)keyboardExtensions textFields:(NSArray<UITextField *> *)textFields textViews:(NSArray<UITextView *> *)textViews;
- (void)removeResponder;

- (void)setEnabled:(BOOL)enabled;

- (void)refreshKeyboardExtensions;
- (void)resetKeyboardExtensions;

- (void)activateKeyboardExtension:(NSObject<CDXKeyboardExtension> *)keyboardExtension tag:(NSInteger)tag;
- (void)deactivateKeyboardExtension:(NSObject<CDXKeyboardExtension> *)keyboardExtension tag:(NSInteger)tag;

- (void)toolbarButtonPressed:(id)sender;
- (void)toolbarActionButtonPressed:(id)sender;
- (UIBarButtonItem *)toolbarButtonWithTitle:(NSString *)title;

- (UIColor *)backgroundColor;
- (CGRect) toolbarFrame;

- (void)setInactive:(BOOL)inactive animated:(BOOL)animated;

+ (UIViewAnimationOptions)animationOptionsWithCurve:(UIViewAnimationCurve)curve;

@end

