//
//
// CDXColorKeyboardExtension.h
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

#import "CDXColor.h"
#import "CDXKeyboardExtensions.h"


@protocol CDXColorKeyboardExtensionResponder

@required

- (CDXColor *)colorKeyboardExtensionTextColor;
- (void)colorKeyboardExtensionSetTextColor:(CDXColor *)color;

- (CDXColor *)colorKeyboardExtensionBackgroundColor;
- (void)colorKeyboardExtensionSetBackgroundColor:(CDXColor *)color;

@end

@class CDXColorKeyboardExtensionViewController;


@interface CDXColorKeyboardExtension : NSObject<CDXKeyboardExtension> {
    
@protected
    CDXColorKeyboardExtensionViewController *viewController;
    
}

declare_singleton(sharedColorKeyboardExtension, CDXColorKeyboardExtension);

@end


@interface CDXColorKeyboardExtensionViewController : UIViewController {
    
@protected
    IBOutlet UIToolbar *toolbar;
    
    IBOutlet UIBarButtonItem *simpleButton;
    IBOutlet UIBarButtonItem *textButton;
    IBOutlet UIBarButtonItem *backgroundButton;
    
    IBOutlet UIView *colorChooserSimpleView;
    
    IBOutlet UIView *colorChooserRGBView;
    IBOutlet UISlider *colorChooserRGBSliderRed;
    IBOutlet UISlider *colorChooserRGBSliderGreen;
    IBOutlet UISlider *colorChooserRGBSliderBlue;
    IBOutlet UISlider *colorChooserRGBSliderAlpha;
    IBOutlet UILabel *colorChooserRGBSliderRedLabel;
    IBOutlet UILabel *colorChooserRGBSliderGreenLabel;
    IBOutlet UILabel *colorChooserRGBSliderBlueLabel;
    IBOutlet UILabel *colorChooserRGBSliderAlphaLabel;
    
}

- (void)updateView;

- (IBAction)simpleButtonPressed;
- (IBAction)textButtonPressed;
- (IBAction)backgroundButtonPressed;

- (IBAction)colorChooserRGBSliderValueChanged;
- (IBAction)colorChooserSimpleValueSelected:(id)sender;

@end

