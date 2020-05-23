//
//
// CDXReleaseNotesViewController.m
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

#import "CDXReleaseNotesViewController.h"
#import "CDXDevice.h"
#import "CDXAppSettings.h"


@interface CDXReleaseNotesHTMLTextViewController : UIViewController {
    
@protected
    NSString *htmlText;
    
    WKWebView *viewWebView;
}

@end


@implementation CDXReleaseNotesHTMLTextViewController

- (id)initWithHTMLText:(NSString *)aHtmlText title:(NSString *)aTitle {
    if ((self = [super init])) {
        ivar_assign_and_copy(htmlText, aHtmlText);
        self.navigationItem.title = aTitle;
        if ([[CDXDevice sharedDevice] deviceUIIdiom] != CDXDeviceUIIdiomPad) {
            UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc]
                                            initWithTitle:@"Done"
                                            style:UIBarButtonItemStyleDone
                                            target:self
                                            action:@selector(closeButtonPressed)]
                                           autorelease];
            if ([[CDXAppSettings sharedAppSettings] doneButtonOnLeftSide]) {
                self.navigationItem.leftBarButtonItem = doneButton;
                self.navigationItem.rightBarButtonItem = nil;
            } else {
                self.navigationItem.rightBarButtonItem = doneButton;
                self.navigationItem.leftBarButtonItem = nil;
            }
        }
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(htmlText);
    ivar_release_and_clear(viewWebView);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ivar_assign(viewWebView, [[WKWebView alloc] init]);
    [viewWebView loadHTMLString:htmlText baseURL:nil];
    self.view = viewWebView;
}

- (void)closeButtonPressed {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end


@implementation CDXReleaseNotesViewController

- (id)init {
    if ((self = [super init])) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ReleaseNotes" ofType:@"html"];
        NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        UIViewController *vc = [[[CDXReleaseNotesHTMLTextViewController alloc] initWithHTMLText:text title:@"Release Notes"] autorelease];
        [self pushViewController:vc animated:NO];
    }
    return self;
}

@end

