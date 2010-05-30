//
//
// CDXListViewControllerBase.m
//
//
// Copyright (c) 2009-2010 Arne Harren <ah@0xc0.de>
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

#import "CDXListViewControllerBase.h"


@implementation CDXListViewControllerBase

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil titleText:(NSString*)aTitleText backButtonText:(NSString *)aBackButtonText {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        ivar_assign_and_copy(titleText, aTitleText);
        ivar_assign_and_copy(backButtonText, aBackButtonText);
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(viewTableView);
    ivar_release_and_clear(viewToolbar);
    ivar_release_and_clear(tableCellTextFont);
    ivar_release_and_clear(tableCellTextFontAction);
    ivar_release_and_clear(tableCellTextTextColor);
    ivar_release_and_clear(tableCellTextTextColorNoCards);
    ivar_release_and_clear(tableCellTextTextColorAction);
    ivar_release_and_clear(tableCellDetailTextFont);
    ivar_release_and_clear(tableCellDetailTextTextColor);
    ivar_release_and_clear(tableCellBackgroundColorAction);
    ivar_release_and_clear(titleText);
    ivar_release_and_clear(backButtonText);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = titleText;
    navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc]
                                         initWithTitle:backButtonText
                                         style:UIBarButtonItemStylePlain
                                         target:nil
                                         action:nil]
                                        autorelease];
    self.toolbarItems = viewToolbar.items;
    ivar_assign_and_retain(tableCellTextFont, [UIFont boldSystemFontOfSize:18]);
    ivar_assign_and_retain(tableCellTextFontAction, [UIFont boldSystemFontOfSize:11]);
    ivar_assign_and_retain(tableCellTextTextColor, [UIColor blackColor]);
    ivar_assign_and_retain(tableCellTextTextColorNoCards, [UIColor lightGrayColor]);
    ivar_assign_and_retain(tableCellTextTextColorAction, [UIColor lightGrayColor]);
    ivar_assign_and_retain(tableCellDetailTextFont, [UIFont systemFontOfSize:12]);
    ivar_assign_and_retain(tableCellDetailTextTextColor, [UIColor lightGrayColor]);
    ivar_assign_and_retain(tableCellBackgroundColorAction, [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]);
    tableCellImageSize = CGSizeMake(10, 10);
}

- (void)viewDidUnload {
    ivar_release_and_clear(viewTableView);
    ivar_release_and_clear(viewToolbar);
    ivar_release_and_clear(tableCellTextFont);
    ivar_release_and_clear(tableCellTextFontAction);
    ivar_release_and_clear(tableCellTextTextColor);
    ivar_release_and_clear(tableCellTextTextColorNoCards);
    ivar_release_and_clear(tableCellTextTextColorAction);
    ivar_release_and_clear(tableCellDetailTextFont);
    ivar_release_and_clear(tableCellDetailTextTextColor);
    ivar_release_and_clear(tableCellBackgroundColorAction);
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [viewTableView reloadData];
}

- (void)setUserInteractionEnabled:(BOOL)enabled {
}

- (void)deviceOrientationDidChange:(UIDeviceOrientation)orientation {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [viewTableView setEditing:editing animated:animated];
}

- (IBAction)editButtonPressed {
    qltrace();
    [self setEditing:!self.editing animated:YES];
}

- (IBAction)bottomButtonPressed {
    [viewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self tableView:viewTableView numberOfRowsInSection:2]-1 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end

