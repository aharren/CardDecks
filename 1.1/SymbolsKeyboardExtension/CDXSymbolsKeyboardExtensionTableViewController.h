//
//
// CDXSymbolsKeyboardExtensionTableViewController.h
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

#import "CDXSymbolsKeyboardExtensionBlocks.h"
#import "CDXSymbolsKeyboardExtensionTableViewCellA.h"
#import "CDXSymbolsKeyboardExtensionTableViewCellB.h"


// A table view controller for the lists of unicode blocks and symbols.
@interface CDXSymbolsKeyboardExtensionTableViewController : UIViewController {
    
@protected
    // UI elements
    UITableView *_tableView;
    UIButton *_backButton;
    
    CDXSymbolsKeyboardExtensionTableViewCellA *_loadedTableViewCellA;
    CDXSymbolsKeyboardExtensionTableViewCellB *_loadedTableViewCellB;
    
    // state
    CDXSymbolsKeyboardExtensionBlockStruct *_block;
    
    NSIndexPath *_tableViewSelectedRowIndexPath;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *backButton;

@property (nonatomic, retain) IBOutlet CDXSymbolsKeyboardExtensionTableViewCellA *loadedTableViewCellA;
@property (nonatomic, retain) IBOutlet CDXSymbolsKeyboardExtensionTableViewCellB *loadedTableViewCellB;

@property (nonatomic, retain) NSIndexPath *tableViewSelectedRowIndexPath;

@property (nonatomic, assign) CDXSymbolsKeyboardExtensionBlockStruct *block;

- (IBAction)backButtonPressed;

+ (CDXSymbolsKeyboardExtensionTableViewController *)symbolsKeyboardExtensionTableViewControllerWithBlock:(CDXSymbolsKeyboardExtensionBlockStruct *)block;

@end

