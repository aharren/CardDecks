//
//
// CDXCardDeckListViewController.h
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

#import "CDXCardDeckList.h"
#import "CDXCardDeckListViewTableCell.h"


@interface CDXCardDeckListViewController : UIViewController {
    
@protected
    // data objects
    CDXCardDeckList *_cardDeckList;
    
    // UI elements and controllers
    UITableView *_tableView;
    UIToolbar *_toolBar;
    
    UIBarButtonItem *_editButton;
    UIBarButtonItem *_worldButton;
    
    CDXCardDeckListViewTableCell *_loadedTableViewCell;
    
    // editing state
    BOOL _editModeActive;
    NSIndexPath *_tableViewSelectedRowIndexPath;
    
    CDXCardDeck *_editCardDeck;
    CDXCardDeck *_editCardDeckDetail;
    CDXCardDeck *_newCardDeck;
    
    // events
    BOOL _setEditModeInactive;
}

@property (nonatomic, retain) CDXCardDeckList *cardDeckList;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *worldButton;

@property (nonatomic, retain) IBOutlet CDXCardDeckListViewTableCell *loadedTableViewCell;

@property (nonatomic, retain) NSIndexPath *tableViewSelectedRowIndexPath;

@property (nonatomic, retain) CDXCardDeck *editCardDeck;
@property (nonatomic, retain) CDXCardDeck *editCardDeckDetail;
@property (nonatomic, retain) CDXCardDeck *newCardDeck;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (NSIndexPath *)insertNewCardDeck;
- (void)setEditMode:(BOOL)editMode withNewCard:(BOOL)withNewCard animated:(BOOL)animated;
- (void)selectRowAtIndexPath:(NSIndexPath *)selectedRowPath;

- (IBAction)editButtonPressed;
- (IBAction)worldButtonPressed;

- (void)setEditModeInactive;

+ (CDXCardDeckListViewController *)cardDeckListViewControllerWithCardDeckList:(CDXCardDeckList *)cardDeckList;

@end

