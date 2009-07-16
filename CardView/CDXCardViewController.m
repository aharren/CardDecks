//
//
// CDXCardViewController.m
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

#import "CDXCardViewController.h"


@implementation CDXCardViewController

#define LogFileComponent lcl_cCDXCardViewController

@synthesize card = _card;

@synthesize textPortrait = _textPortrait;
@synthesize textLandscape = _textLandscape;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    LogInvocation();
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // nothing to do
    }
    
    return self;
}

- (void)dealloc {
    LogInvocation();
    
    self.card = nil;
    
    self.textPortrait = nil;
    self.textLandscape = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    LogInvocation();
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    LogInvocation();
    
    self.textPortrait = nil;
    self.textLandscape = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    LogInvocation();
    
    [super viewWillAppear:animated];
}

- (void)setOrientation:(UIDeviceOrientation)orientation {
    LogInvocation();
    
    CGFloat transformAngle;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        default:
            transformAngle = 0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            transformAngle = M_PI;
            break;
        case UIDeviceOrientationLandscapeLeft:
            transformAngle = M_PI_2;
            break;
        case UIDeviceOrientationLandscapeRight:
            transformAngle = -M_PI_2;
            break;
    }
    
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, transformAngle);
    switch (orientation) {
        default:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            _textLandscape.alpha = 0;
            
            _textPortrait.transform = transform;
            _textPortrait.alpha = 1;
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            _textPortrait.alpha = 0;
            
            _textLandscape.transform = transform;
            _textLandscape.alpha = 1;
            break;
    }
    
    LogDebug(@"%@", _card.text);
    LogDebug(@"portrait  %f %f %f %f", _textPortrait.frame.origin.x, _textPortrait.frame.origin.y, _textPortrait.frame.size.width, _textPortrait.frame.size.height);
    LogDebug(@"landscape %f %f %f %f", _textLandscape.frame.origin.x, _textLandscape.frame.origin.y, _textLandscape.frame.size.width, _textLandscape.frame.size.height);
}

+ (CDXCardViewController *)cardViewController {
    LogInvocation();
    
    CDXCardViewController *controller = [[[CDXCardViewController alloc] initWithNibName:@"CDXCardView" bundle:nil] autorelease];
    return controller;
}

- (void)configureWithCard:(CDXCard *)card {
    LogInvocation();
    
    self.card = card;
    UIFont *font = [UIFont boldSystemFontOfSize:400];
    CGRect rect;
    
    NSString *text = _card.text;
    if (text == nil) text = @"";
    
    _textPortrait.text = text;
    _textLandscape.text = text;
    
    _textPortrait.textColor = [_card.textColor uiColor];
    _textLandscape.textColor = [_card.textColor uiColor];
    
    CDXTextRenderingContext *textRenderingContextPortrait = [_card renderingContextPortraitForFont:font width:320 height:440 text:nil cached:YES standard:YES];
    
    _textPortrait.font = [font fontWithSize:textRenderingContextPortrait.fontSize];
    rect = _textPortrait.bounds;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = 320;
    rect.size.height = textRenderingContextPortrait.height + 20;
    _textPortrait.bounds = rect;            
    
    CDXTextRenderingContext *textRenderingContextLandscape = [_card renderingContextLandscapeForFont:font width:440 height:320 text:nil cached:YES standard:YES];
    
    _textLandscape.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    _textLandscape.font = [font fontWithSize:textRenderingContextLandscape.fontSize];
    rect = _textLandscape.bounds;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = 440;
    rect.size.height = textRenderingContextLandscape.height + 20;
    _textLandscape.bounds = rect;
    
    [self setOrientation:[[UIDevice currentDevice] orientation]];
    self.view.backgroundColor = [_card.backgroundColor uiColor];
    
    self.view.alpha = 1;
}

@end

