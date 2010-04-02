//
//
// CDXColorKeyboardExtensionViewController.h
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


// The view controller for the color keyboard extension.
@interface CDXColorKeyboardExtensionViewController : UIViewController {
    
@protected
    // UI elements
    UIToolbar *_toolbar;
    
    UIBarButtonItem *_simpleButton;
    UIBarButtonItem *_textButton;
    UIBarButtonItem *_backgroundButton;

    UIView *_colorChooserSimpleView;
    
    UIView *_colorChooserRGBView;
    UISlider *_colorChooserRGBSliderRed;
    UISlider *_colorChooserRGBSliderGreen;
    UISlider *_colorChooserRGBSliderBlue;
    
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *simpleButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *textButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backgroundButton;

@property (nonatomic, retain) IBOutlet UIView *colorChooserSimpleView;

@property (nonatomic, retain) IBOutlet UIView *colorChooserRGBView;
@property (nonatomic, retain) IBOutlet UISlider *colorChooserRGBSliderRed;
@property (nonatomic, retain) IBOutlet UISlider *colorChooserRGBSliderGreen;
@property (nonatomic, retain) IBOutlet UISlider *colorChooserRGBSliderBlue;

- (IBAction)simpleButtonPressed;
- (IBAction)textButtonPressed;
- (IBAction)backgroundButtonPressed;

- (IBAction)colorChooserRGBSliderValueChanged;
- (IBAction)colorChooserSimpleValueSelected:(id)sender;

+ (CDXColorKeyboardExtensionViewController *)colorKeyboardExtensionViewController;

@end

