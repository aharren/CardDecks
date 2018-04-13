//
//
// CDXTimerKeyboardExtension.m
//
//
// Copyright (c) 2009-2015 Arne Harren <ah@0xc0.de>
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

#import "CDXTimerKeyboardExtension.h"
#import "CDXCardView.h"


@implementation CDXTimerKeyboardExtension

synthesize_singleton(sharedTimerKeyboardExtension, CDXTimerKeyboardExtension);

- (void)dealloc {
    ivar_release_and_clear(viewController);
    [super dealloc];
}

- (void)keyboardExtensionInitialize {
}

- (void)keyboardExtensionReset {
}

- (NSString *)keyboardExtensionTitle {
    NSUInteger minutes = 0;
    NSUInteger seconds = 0;
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if ([responder conformsToProtocol:@protocol(CDXTimerKeyboardExtensionResponder)]) {
        NSObject <CDXTimerKeyboardExtensionResponder> *r = (NSObject <CDXTimerKeyboardExtensionResponder> *)responder;
        NSTimeInterval timer = [r timerKeyboardExtensionTimerInterval];
        minutes = ((NSUInteger)timer) / 60;
        seconds = ((NSUInteger)timer) % 60;
    }
    if (minutes == 0 && seconds == 0) {
        return @"\u25a0";
    } else {
        return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)minutes, (unsigned long)seconds];
    }
}

- (UIView *)keyboardExtensionView {
    if (viewController == nil) {
        ivar_assign(viewController, [[CDXTimerKeyboardExtensionViewController alloc] init]);
    }
    
    return viewController.view;
}

- (void)keyboardExtensionWillBecomeActive {
    [self keyboardExtensionView];
    [viewController viewWillAppear:NO];
}

- (void)keyboardExtensionDidBecomeActive {
    [viewController viewDidAppear:NO];
}

- (void)keyboardExtensionWillBecomeInactive {
    [viewController viewWillDisappear:NO];
}

- (void)keyboardExtensionDidBecomeInactive {
    [viewController viewDidDisappear:NO];
}

@end


@implementation CDXTimerKeyboardExtensionViewController

- (void)dealloc {
    ivar_release_and_clear(timerIntervalPicker);
    ivar_release_and_clear(minutesLabel);
    ivar_release_and_clear(secondsLabel);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[CDXKeyboardExtensions sharedKeyboardExtensions] backgroundColor];
}

- (void)viewDidAppear:(BOOL)animated {
    qltrace();
    [super viewDidAppear:animated];
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    minutes = 0;
    seconds = 0;
    if ([responder conformsToProtocol:@protocol(CDXTimerKeyboardExtensionResponder)]) {
        NSObject <CDXTimerKeyboardExtensionResponder> *r = (NSObject <CDXTimerKeyboardExtensionResponder> *)responder;
        NSTimeInterval timer = [r timerKeyboardExtensionTimerInterval];
        minutes = ((NSUInteger)timer) / 60;
        seconds = ((NSUInteger)timer) % 60;
    }
    [timerIntervalPicker selectRow:minutes inComponent:0 animated:NO];
    minutesLabel.text = (minutes == 1) ? @"minute" : @"minutes";
    [timerIntervalPicker selectRow:seconds inComponent:1 animated:NO];
    secondsLabel.text = (seconds == 1) ? @"second" : @"seconds";
}

- (IBAction)datePickerValueChanged {
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 60;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *text;
    if (component == 0) {
        text = [NSString stringWithFormat:@"%ld", (long)row];
    } else {
        text = [NSString stringWithFormat:@"%ld", (long)row];
    }
    
    NSAttributedString *string = [[[NSAttributedString alloc] initWithString:text attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] }] autorelease];
    return string;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    qltrace();
    if (component == 0) {
        minutesLabel.text = (row == 1) ? @"minute" : @"minutes";
        minutes = row;
    } else {
        secondsLabel.text = (row == 1) ? @"second" : @"seconds";
        seconds = row;
    }
    
    NSObject *responder = [[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if ([responder conformsToProtocol:@protocol(CDXTimerKeyboardExtensionResponder)]) {
        NSObject <CDXTimerKeyboardExtensionResponder> *r = (NSObject <CDXTimerKeyboardExtensionResponder> *)responder;
        [r timerKeyboardExtensionSetTimerInterval:(NSTimeInterval)(minutes * 60 + seconds)];
    }
    
    [[CDXKeyboardExtensions sharedKeyboardExtensions] refreshKeyboardExtensions];
}

@end

