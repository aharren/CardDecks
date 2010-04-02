//
//
// CDXKeyboardExtensions.h
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


// A protocol for keyboard extensions.
@protocol CDXKeyboardExtension

@required

- (void)extensionInitialize;

- (NSString *)extensionTitle;
- (UIView *)extensionView;

@optional

- (void)extensionWillBecomeActive;
- (void)extensionDidBecomeActive;
- (void)extensionWillBecomeInactive;
- (void)extensionDidBecomeInactive;

@end


// A keyboard extension mechanism based on a toolbar which is shown above the
// keyboard.
@interface CDXKeyboardExtensions : NSObject {
    
@protected
    // UI elements and controllers
    UIToolbar *_toolbar;
    NSMutableArray *_toolbarButtons;
    UIBarButtonItem *_toolbarKeyboardButton;
    
    NSObject *_responder;
    CGRect _extensionViewRect;
    
    UIColor *_backgroundColor;
    
    // state
    BOOL _enabled;
    BOOL _visible;
    
    NSInteger _activeExtensionTag;
    NSArray *_extensions;
}

@property (nonatomic, retain) NSObject *responder;
@property (nonatomic, copy) NSArray *extensions;

- (void)setResponder:(NSObject *)responder extensions:(NSArray *)extensions;

- (void)setEnabled:(BOOL)enabled;

- (void)activateExtension:(NSObject <CDXKeyboardExtension> *)extension tag:(NSInteger)tag;
- (void)deactivateExtension:(NSObject <CDXKeyboardExtension> *)extension tag:(NSInteger)tag;

- (void)toolbarButtonPressed:(id)sender;
- (UIBarButtonItem *)toolbarButtonWithTitle:(NSString *)title;

- (UIColor *)backgroundColor;

+ (CDXKeyboardExtensions *)sharedInstance;

@end

