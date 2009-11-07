//
//
// CDXSymbolsKeyboardExtensionViewController.m
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

#import "CDXSymbolsKeyboardExtensionViewController.h"
#import "CDXSymbolsKeyboardExtensionTableViewController.h"


@implementation CDXSymbolsKeyboardExtensionViewController

#define LogFileComponent lcl_cCDXSymbolsKeyboardExtension

- (void)viewDidLoad {
    LogInvocation();
    
    [super viewDidLoad];

    self.navigationBar.hidden = YES;
    
    CDXSymbolsKeyboardExtensionTableViewController *tvc = [CDXSymbolsKeyboardExtensionTableViewController symbolsKeyboardExtensionTableViewControllerWithBlock:NULL];
    [self setViewControllers:[NSArray arrayWithObject:tvc]];
}

- (void)viewDidUnload {
    LogInvocation();
    
    [super viewDidUnload];
}   

- (void)resetState {
    LogInvocation();
    
    [self popToRootViewControllerAnimated:NO];
    CDXSymbolsKeyboardExtensionTableViewController *tvc = (CDXSymbolsKeyboardExtensionTableViewController *)[[self viewControllers] objectAtIndex:0];
 
    [tvc.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

+ (CDXSymbolsKeyboardExtensionViewController *)symbolsKeyboardExtensionViewController {
    LogInvocation();
    
    CDXSymbolsKeyboardExtensionViewController *controller = [[[CDXSymbolsKeyboardExtensionViewController alloc] initWithNibName:@"CDXSymbolsKeyboardExtensionView" bundle:nil] autorelease];
    return controller;
}

@end

