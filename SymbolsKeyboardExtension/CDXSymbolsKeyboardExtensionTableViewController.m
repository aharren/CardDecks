//
//
// CDXSymbolsKeyboardExtensionTableViewController.m
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

#import "CDXSymbolsKeyboardExtensionTableViewController.h"


@implementation CDXSymbolsKeyboardExtensionTableViewController

#define LogFileComponent lcl_cCDXSymbolsKeyboardExtension

@synthesize tableView = _tableView;
@synthesize backButton = _backButton;

@synthesize loadedTableViewCellA = _loadedTableViewCellA;
@synthesize loadedTableViewCellB = _loadedTableViewCellB;

@synthesize tableViewSelectedRowIndexPath = _tableViewSelectedRowIndexPath;

@synthesize block = _block;

- (void)dealloc {
    LogInvocation();
    
    self.tableView = nil;
    self.backButton = nil;
    
    self.loadedTableViewCellA = nil;
    self.loadedTableViewCellB = nil;
    
    self.tableViewSelectedRowIndexPath = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    LogInvocation();
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [[CDXKeyboardExtensions sharedInstance] backgroundColor];
}

- (void)viewDidUnload {
    LogInvocation();
    
    self.tableView = nil;
    self.backButton = nil;
    
    self.loadedTableViewCellA = nil;
    self.loadedTableViewCellB = nil;
    
    [super viewDidUnload];
} 

- (void)viewWillAppear:(BOOL)animated {
    LogInvocation();
    
    _backButton.alpha = 0;
    
    if (_block != NULL) {
        // the back button is visible if we are displaying the symbols of a block
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
        }
        _backButton.alpha = 1;
        if (animated) {
            [UIView commitAnimations];
        }
    }
    
    if (_tableViewSelectedRowIndexPath != nil) {
        UITableViewCell *cell = (UITableViewCell *)[_tableView cellForRowAtIndexPath:_tableViewSelectedRowIndexPath];
        [cell setSelected:YES];
        [_tableView deselectRowAtIndexPath:_tableViewSelectedRowIndexPath animated:animated];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    LogInvocation();
    
    self.tableViewSelectedRowIndexPath = nil;
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    LogInvocation();
    
    if (_block != NULL) {
        // hide the back button if we were displaying the symbols of a block
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
        }
        _backButton.alpha = 0;
        if (animated) {
            [UIView commitAnimations];
        }
    }
    
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    LogInvocation();
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LogInvocation();
    
    if (_block == NULL) {
        return [CDXSymbolsKeyboardExtensionBlocks count];
    } else {
        return ((_block->endCode - _block->startCode) + 6) / 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation();
    
    if (_block == NULL) {
        // get a cell for the list of unicode blocks
        CDXSymbolsKeyboardExtensionTableViewCellA *cell = (CDXSymbolsKeyboardExtensionTableViewCellA *)[tableView dequeueReusableCellWithIdentifier:@"CDXSymbolsKeyboardExtensionTableViewCellA"];
        if (cell == nil) {
            LogDebug(@"new");
            
            [[NSBundle mainBundle] loadNibNamed:@"CDXSymbolsKeyboardExtensionTableViewCellA" owner:self options:nil];
            cell = self.loadedTableViewCellA;
            self.loadedTableViewCellA = nil;
            
            NSAssert([@"CDXSymbolsKeyboardExtensionTableViewCellA" isEqualToString:[cell reuseIdentifier]], @"reuseIdentifier must match");        
        } else {
            LogDebug(@"dequeued");
        }
        [cell configureWithBlock:[CDXSymbolsKeyboardExtensionBlocks blockByIndex:indexPath.row]];
        return cell;
    } else {
        // get a cell for the list of symbols
        CDXSymbolsKeyboardExtensionTableViewCellB *cell = (CDXSymbolsKeyboardExtensionTableViewCellB *)[tableView dequeueReusableCellWithIdentifier:@"CDXSymbolsKeyboardExtensionTableViewCellB"];
        if (cell == nil) {
            LogDebug(@"new");
            
            [[NSBundle mainBundle] loadNibNamed:@"CDXSymbolsKeyboardExtensionTableViewCellB" owner:self options:nil];
            cell = self.loadedTableViewCellB;
            self.loadedTableViewCellB = nil;
            
            NSAssert([@"CDXSymbolsKeyboardExtensionTableViewCellB" isEqualToString:[cell reuseIdentifier]], @"reuseIdentifier must match");        
        } else {
            LogDebug(@"dequeued");
        }
        [cell configureWithBlock:_block offset:indexPath.row * 7];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation();
    
    self.tableViewSelectedRowIndexPath = indexPath;
    if (_block == NULL) {
        // push the view with the block's symbol
        CDXSymbolsKeyboardExtensionTableViewController *tvc = [CDXSymbolsKeyboardExtensionTableViewController symbolsKeyboardExtensionTableViewControllerWithBlock:[CDXSymbolsKeyboardExtensionBlocks blockByIndex:indexPath.row]]; 
        [self.navigationController pushViewController:tvc animated:YES];
    } else {
        [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (IBAction)backButtonPressed {
    LogInvocation();
    
    [self.navigationController popViewControllerAnimated:YES];
}

+ (CDXSymbolsKeyboardExtensionTableViewController *)symbolsKeyboardExtensionTableViewControllerWithBlock:(CDXSymbolsKeyboardExtensionBlockStruct *)block {
    LogInvocation();
    
    CDXSymbolsKeyboardExtensionTableViewController *controller = [[[CDXSymbolsKeyboardExtensionTableViewController alloc] initWithNibName:@"CDXSymbolsKeyboardExtensionTableView" bundle:nil] autorelease];
    controller.block = block;
    
    return controller;
}

@end

