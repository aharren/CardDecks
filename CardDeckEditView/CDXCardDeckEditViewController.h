//
//
// CDXCardDeckEditViewController.h
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

#import "CDXCardDeck.h"
#import "CDXCardDeckList.h"
#import "CDXCardEditViewController.h"
#import "CDXCardDeckEditViewTableCell.h"


// A controller for editing a card deck.
@interface CDXCardDeckEditViewController : UIViewController {
    
@protected
    // data objects
    CDXCardDeck *_cardDeck;
    
    // UI elements and controllers
    UITableView *_tableView;
    UITextField *_name;
    UIBarButtonItem *_nameButton;
    
    CDXCardEditViewController *_cardEditViewController;
    
    CDXCardDeckEditViewTableCell *_loadedTableViewCell;
    
    // editing state
    BOOL _editModeActive;
    NSIndexPath *_tableViewSelectedRowIndexPath;
    
    CDXCardDeck *_cardDeckInList; 
    CDXCardDeckList *_cardDeckList;
    CDXCard *_newCard;
    CDXCard *_editCard;
}

@property (nonatomic, retain) CDXCardDeck *cardDeck;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nameButton;

@property (nonatomic, retain) CDXCardEditViewController *cardEditViewController;

@property (nonatomic, retain) IBOutlet CDXCardDeckEditViewTableCell *loadedTableViewCell;

@property (nonatomic, retain) NSIndexPath *tableViewSelectedRowIndexPath;

@property (nonatomic, retain) CDXCardDeckList *cardDeckList;
@property (nonatomic, retain) CDXCardDeck *cardDeckInList;
@property (nonatomic, retain) CDXCard *editCard;
@property (nonatomic, retain) CDXCard *newCard;

- (NSIndexPath *)insertNewCard;
- (void)initCardEditViewController;

- (IBAction)nameDidEndOnExit;
- (IBAction)nameEditingDidEnd;
- (IBAction)sendButtonPressed;
- (IBAction)nameButtonPressed;

+ (CDXCardDeckEditViewController *)cardDeckEditViewControllerWithCardDeck:(CDXCardDeck *)cardDeck cardDeckList:(CDXCardDeckList *)cardDeckList cardDeckInList:(CDXCardDeck *)cardDeckInList;

@end


