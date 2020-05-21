//
//
// CDXAppWindowMessageView.m
//
//
// Copyright (c) 2009-2020 Arne Harren <ah@0xc0.de>
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

#import "CDXAppWindowMessageView.h"


@implementation CDXAppWindowMessageView

- (void)dealloc {
    qltrace();
    ivar_release_and_clear(text);
    [super dealloc];
}

- (void)hideAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    qltrace();
    [self removeFromSuperview];
}

- (void)hide {
    qltrace();
    if (!visible) {
        return;
    }
    visible = NO;
    [UIView beginAnimations:nil context:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDidStopSelector:@selector(hideAnimationDidStop:finished:context:)];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

- (void)show {
    qltrace();
    visible = YES;
    [UIView beginAnimations:nil context:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:timeInterval];
}

- (void)showMessage:(NSString *)aText timeInterval:(NSTimeInterval)aTimerInterval view:(UIView *)view backgroundColor:(UIColor *)backgroundColor height:(CGFloat)height afterDelay:(NSTimeInterval)timeDelay {
    qltrace();
    [view addSubview:self];
    text.text = aText;
    timeInterval = aTimerInterval;
    visible = NO;
    self.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - height, view.frame.size.width, height);
    self.backgroundColor = backgroundColor;
    
    [self performSelector:@selector(show) withObject:self afterDelay:timeDelay];
}

- (IBAction)closeButtonPressed {
    qltrace();
    [self hide];
}

@end
