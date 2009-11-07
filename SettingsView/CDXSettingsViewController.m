//
//
// CDXSettingsViewController.m
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

#import "CDXSettingsViewController.h"


@implementation CDXSettingsViewController

#define LogFileComponent lcl_cCDXSettingsViewController

@synthesize tableView = _tableView;
@synthesize closeButton = _closeButton;

@synthesize loadedTableViewCell = _loadedTableViewCell;

typedef struct {
    NSString *group;
    CDXSettingsKey key;
    NSUInteger count;
} CDXSettingsViewGroupKeyCount;

static CDXSettingsViewGroupKeyCount settings[] = {
    { @"Card Appearence", CDXSettingsKeyShowStatusBar, 2},
    { @"Device Events", CDXSettingsKeyEnableAutoRotate, 2},
    { @"Energy Saver", CDXSettingsKeyEnableIdleTimer, 1}
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    LogInvocation();
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // nothing to do
    }
    
    return self;
}

- (void)dealloc {
    LogInvocation();
    
    self.tableView = nil;
    
    self.closeButton = nil;
    
    self.loadedTableViewCell = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    LogInvocation();
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    LogInvocation();
    
    self.tableView = nil;
    
    self.closeButton = nil;
    
    self.loadedTableViewCell = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    LogInvocation();
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    LogInvocation();
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:animated];
    [super viewWillDisappear:animated];
}

- (IBAction)closeButtonPressed {
    LogInvocation();
    
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    LogInvocation();
    
    return sizeof(settings) / sizeof(CDXSettingsViewGroupKeyCount);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    LogInvocation();
    
    return settings[section].group;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LogInvocation();
    
    return settings[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation();
    
    CDXSettingsViewTableCell *cell = (CDXSettingsViewTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CDXSettingsViewTableCell"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CDXSettingsViewTableCell" owner:self options:nil];
        cell = self.loadedTableViewCell;
        self.loadedTableViewCell = nil;
        NSAssert([@"CDXSettingsViewTableCell" isEqualToString:[cell reuseIdentifier]], @"reuseIdentifier must match");        
    }
    
    [cell configureWithKey:settings[indexPath.section].key + indexPath.row];
    return cell;
}

+ (CDXSettingsViewController *)settingsViewController {
    LogInvocation();
    
    CDXSettingsViewController *controller = [[[CDXSettingsViewController alloc] initWithNibName:@"CDXSettingsView" bundle:nil] autorelease];
    return controller;
}

@end

