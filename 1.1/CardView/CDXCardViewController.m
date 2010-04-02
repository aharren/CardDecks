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

- (void)setOrientation:(CDXCardOrientation)orientation {
    LogInvocation();
    
    // add card's orientation and the device orientation
    CDXCardOrientation cardOrientation = _card.orientation + orientation;
    cardOrientation %= CDXCardOrientationCount;
    
    // retrieve the corresponding transform
    CGAffineTransform transform = [CDXCardOrientationHelper transformFromCardOrientation:cardOrientation];
    
    // update the views
    switch (cardOrientation) {
        default:
        case CDXCardOrientationUp:
        case CDXCardOrientationDown:
            _textLandscape.alpha = 0;
            
            _textPortrait.transform = transform;
            _textPortrait.alpha = 1;
            break;
        case CDXCardOrientationLeft:
        case CDXCardOrientationRight:
            _textPortrait.alpha = 0;
            
            _textLandscape.transform = transform;
            _textLandscape.alpha = 1;
            break;
    }
    
    LogDebug(@"%@", _card.text);
    LogDebug(@"portrait  frame  %8.2f %8.2f %8.2f %8.2f", _textPortrait.frame.origin.x, _textPortrait.frame.origin.y, _textPortrait.frame.size.width, _textPortrait.frame.size.height);
    LogDebug(@"portrait  bounds %8.2f %8.2f %8.2f %8.2f", _textPortrait.bounds.origin.x, _textPortrait.bounds.origin.y, _textPortrait.bounds.size.width, _textPortrait.bounds.size.height);
    LogDebug(@"landscape frame  %8.2f %8.2f %8.2f %8.2f", _textLandscape.frame.origin.x, _textLandscape.frame.origin.y, _textLandscape.frame.size.width, _textLandscape.frame.size.height);
    LogDebug(@"landscape bounds %8.2f %8.2f %8.2f %8.2f", _textLandscape.bounds.origin.x, _textLandscape.bounds.origin.y, _textLandscape.bounds.size.width, _textLandscape.bounds.size.height);
}

+ (CDXCardViewController *)cardViewController {
    LogInvocation();
    
    CDXCardViewController *controller = [[[CDXCardViewController alloc] initWithNibName:@"CDXCardView" bundle:nil] autorelease];
    return controller;
}

- (void)configureWithCard:(CDXCard *)card landscapeRenderingContext:(CDXTextRenderingContext *)landscapeRenderingContext portraitRenderingContext:(CDXTextRenderingContext *)portraitRenderingContext frame:(CGRect)frame orientation:(CDXCardOrientation)orientation {
    LogInvocation();
    CGRect rect;
    const CGFloat widthInternal = 800.0;
    
    self.card = card;
    UIFont *font = [UIFont boldSystemFontOfSize:400];
    
    NSString *text = _card.text;
    if (text == nil) text = @"";
    // add a single space for the last line if it is empty
    if ([text length] >= 1 && [text characterAtIndex:[text length]-1] == '\n') {
        text = [text stringByAppendingString:@" "];
    }
    
    // get the colors
    UIColor *textColor = [_card.textColor uiColor];
    UIColor *backgroundColor = [_card.backgroundColor uiColor];
    
    // configure the view
    self.view.backgroundColor = backgroundColor;
    self.view.alpha = 1;
    self.view.clipsToBounds = YES;
    self.view.autoresizesSubviews = NO;
    self.view.frame = frame;
    
    // configure the portrait view
    _textPortrait.numberOfLines = 0;
    _textPortrait.opaque = YES;
    _textPortrait.text = text;
    _textPortrait.textColor = textColor;
    _textPortrait.backgroundColor = backgroundColor;
    _textPortrait.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
    _textPortrait.font = [font fontWithSize:portraitRenderingContext.fontSize];
    rect = _textPortrait.bounds;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = widthInternal;
    rect.size.height = portraitRenderingContext.height + 20;
    _textPortrait.bounds = rect;
    rect = _textPortrait.frame;
    rect.origin.x = (frame.size.width - widthInternal)/2;
    _textPortrait.frame = rect;
    
    // configure the landscape view
    _textLandscape.numberOfLines = 0;
    _textLandscape.opaque = YES;
    _textLandscape.text = text;
    _textLandscape.textColor = textColor;
    _textLandscape.backgroundColor = backgroundColor;
    _textLandscape.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    _textLandscape.font = [font fontWithSize:landscapeRenderingContext.fontSize];
    rect = _textLandscape.bounds;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = 440;
    rect.size.height = landscapeRenderingContext.height + 20;
    _textLandscape.bounds = rect;
    
    // set the current orientation
    [self setOrientation:orientation];
}

@end

