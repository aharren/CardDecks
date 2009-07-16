//
//
// CDXInfoOverviewViewController.h
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

#import "CDXInfoOverviewViewTableCell.h"


// The overview view controller for the info page.
@interface CDXInfoOverviewViewController : UIViewController {
    
@protected
    // UI elements and controllers
    UITableView *_tableView;
    UIView *_tableViewHeaderView;
    
    UIBarButtonItem *_closeButton;
    UILabel *_versionLabel;
    
    CDXInfoOverviewViewTableCell *_loadedTableViewCell;

    // editing state
    NSIndexPath *_tableViewSelectedRowIndexPath;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIView *tableViewHeaderView;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *closeButton;
@property (nonatomic, retain) IBOutlet UILabel *versionLabel;

@property (nonatomic, retain) IBOutlet CDXInfoOverviewViewTableCell *loadedTableViewCell;

@property (nonatomic, retain) IBOutlet NSIndexPath *tableViewSelectedRowIndexPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (IBAction)closeButtonPressed;

+ (CDXInfoOverviewViewController *)infoOverviewViewController;

@end

