//
//
// CDXInfoOverviewViewController.m
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

#import "CDXInfoOverviewViewController.h"
#import "CDXInfoHTMLViewController.h"


@implementation CDXInfoOverviewViewController

#define LogFileComponent lcl_cCDXInfoOverviewViewController

@synthesize tableView = _tableView;
@synthesize tableViewHeaderView = _tableViewHeaderView;

@synthesize closeButton = _closeButton;
@synthesize versionLabel = _versionLabel;

@synthesize loadedTableViewCell = _loadedTableViewCell;

@synthesize tableViewSelectedRowIndexPath = _tableViewSelectedRowIndexPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // nothing to do
    }
    
    return self;
}

- (void)dealloc {
    self.tableView = nil;
    self.tableViewHeaderView = nil;
    
    self.closeButton = nil;
    self.versionLabel = nil;
    
    self.loadedTableViewCell = nil;
    self.tableViewSelectedRowIndexPath = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.tableHeaderView = _tableViewHeaderView;
    _tableView.backgroundColor = [UIColor blackColor];
    
    _versionLabel.text = CDXApplicationVersion;
    
    UINavigationItem *navigationItem = [self navigationItem];
    navigationItem.rightBarButtonItem = _closeButton;
    navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc]
                                         initWithTitle:@"Back" 
                                         style:UIBarButtonItemStylePlain 
                                         target:nil
                                         action:nil]
                                        autorelease];
}    

- (void)viewDidUnload {
    self.tableView = nil;
    self.tableViewHeaderView = nil;
    
    self.closeButton = nil;
    self.versionLabel = nil;
    
    self.loadedTableViewCell = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_tableViewSelectedRowIndexPath != nil) {
        [_tableView deselectRowAtIndexPath:_tableViewSelectedRowIndexPath animated:animated];
    }    
}

- (IBAction)closeButtonPressed {
    [self dismissModalViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else {
        return 1;
    }    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDXInfoOverviewViewTableCell *cell = (CDXInfoOverviewViewTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CDXInfoOverviewViewTableCell"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CDXInfoOverviewViewTableCell" owner:self options:nil];
        cell = self.loadedTableViewCell;
        self.loadedTableViewCell = nil;
        NSAssert([@"CDXInfoOverviewViewTableCell" isEqualToString:[cell reuseIdentifier]], @"reuseIdentifier must match");        
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell configureWithText:@"0xc0.de/CardDecks"];
        } else {
            [cell configureWithText:@"Feedback, Bugs, ..."];
        }
    } else if (indexPath.section == 1) {
        [cell configureWithText:@"License, Acknowledgements, ..."];
    } else {
        [cell configureWithText:@""];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *url;
        if (indexPath.row == 0) {
            url = @"http://0xc0.de/CardDecks?m" CDXApplicationVersion "";
        } else {
            url = @"mailto:carddecks@0xc0.de?subject=CardDecks " CDXApplicationVersion ": Feedback";
        }
        LogDebug(@"url %@", url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } else if (indexPath.section == 1) {
        NSString *folder = [NSHomeDirectory() stringByAppendingPathComponent:@"CardDecks.app"];
        NSString *path = [folder stringByAppendingPathComponent:@"License.html"];
        NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        if (text == nil) {
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        CDXInfoHTMLViewController *infoHTMLViewController = [CDXInfoHTMLViewController infoHTMLViewControllerWithText:text];
        [self.navigationController pushViewController:infoHTMLViewController animated:YES];
        self.tableViewSelectedRowIndexPath = indexPath;
    } else {
    }    
}

+ (CDXInfoOverviewViewController *)infoOverviewViewController {
    CDXInfoOverviewViewController *controller = [[[CDXInfoOverviewViewController alloc] initWithNibName:@"CDXInfoOverviewView" bundle:nil] autorelease];
    return controller;
}

@end

