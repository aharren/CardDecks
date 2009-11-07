//
//
// CDXCardDeckListViewController.m
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

#import "CDXCardDeckListViewController.h"
#import "CDXCardDeckViewController.h"
#import "CDXCardDeckEditViewController.h"
#import "CDXInfoViewController.h"


@implementation CDXCardDeckListViewController

#define LogFileComponent lcl_cCDXCardDeckListViewController

@synthesize cardDeckList = _cardDeckList;

@synthesize tableView = _tableView;
@synthesize toolBar = _toolBar;

@synthesize editButton = _editButton;
@synthesize worldButton = _worldButton;

@synthesize loadedTableViewCell = _loadedTableViewCell;

@synthesize tableViewSelectedRowIndexPath = _tableViewSelectedRowIndexPath;

@synthesize editCardDeck = _editCardDeck;
@synthesize editCardDeckDetail = _editCardDeckDetail;
@synthesize newCardDeck = _newCardDeck;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    LogInvocation();
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // nothing to do
    }
    
    return self;
}

- (void)dealloc {
    LogInvocation();
    
    [_cardDeckList release];
    
    [_tableView release];
    [_toolBar release];
    
    [_editButton release];
    [_worldButton release];
    
    [_loadedTableViewCell release];
    
    [_tableViewSelectedRowIndexPath release];
    
    [_editCardDeck release];
    [_editCardDeckDetail release];
    [_newCardDeck release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    LogInvocation();
    
    [super viewDidLoad];
    
    _editButton.enabled = YES;
    _editButton.title = @" Edit ";
    _editButton.style = UIBarButtonItemStyleBordered;
    
    _worldButton.enabled = NO;
    
    UINavigationItem *navigationItem = [self navigationItem];
    navigationItem.title = @"Card Decks";
    navigationItem.rightBarButtonItem = _editButton;
    navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc]
                                         initWithTitle:@"Back"
                                         style:UIBarButtonItemStylePlain
                                         target:nil
                                         action:nil]
                                        autorelease];
    
    _tableView.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    _tableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TableBackground.png"]];
}

- (void)viewDidUnload {
    LogInvocation();
    
    self.tableView = nil;
    self.toolBar = nil;
    
    self.editButton = nil;
    self.worldButton = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    LogInvocation();
    
    [super viewWillAppear:animated];
    
    if (_editModeActive && ![_tableView isEditing]) {
        [self setEditMode:YES withNewCard:NO animated:NO];
    }
    
    if (_tableViewSelectedRowIndexPath != nil) {
        CDXCardDeckListViewTableCell *cell = (CDXCardDeckListViewTableCell *)[_tableView cellForRowAtIndexPath:_tableViewSelectedRowIndexPath];
        [cell setSelected:YES];
        [_tableView deselectRowAtIndexPath:_tableViewSelectedRowIndexPath animated:animated];
    }

    [[[self navigationController] navigationBar] setAlpha:1.0];
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    LogInvocation();
    
    NSIndexPath *newCardDeckIndexPath = nil;

    if (_tableViewSelectedRowIndexPath != nil) {
        [_tableView beginUpdates];
        LogDebug(@"%d %d %d", _editModeActive, _editCardDeck != nil, _editCardDeck.dirty);
        if (_editModeActive && _editCardDeck != nil && _editCardDeck.dirty) {
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_tableViewSelectedRowIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:_tableViewSelectedRowIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            CDXCardDeckListViewTableCell *cell = (CDXCardDeckListViewTableCell *)[_tableView cellForRowAtIndexPath:_tableViewSelectedRowIndexPath];
            [cell configureWithCardDeck:_editCardDeck editing:_editModeActive];
            
            _editCardDeck.dirty = NO;
            [CDXStorage update:_cardDeckList deferred:YES];
            
            if (_editCardDeck == _newCardDeck) {
                newCardDeckIndexPath = [self insertNewCardDeck];
            }
        }
        [_tableView endUpdates];
    }
    
    [super viewDidAppear:animated];
    
    self.tableViewSelectedRowIndexPath = nil;
    
    if (newCardDeckIndexPath != nil) {
        [_tableView scrollToRowAtIndexPath:newCardDeckIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    
    if (_editModeActive && _setEditModeInactive) {
        [self setEditMode:NO withNewCard:NO animated:YES];
    }
    _setEditModeInactive = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    LogInvocation();
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LogInvocation("%d", section);
    
    return [_cardDeckList cardDecksCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation(@"%d", indexPath.row);
    
    CDXCardDeckListViewTableCell *cell = (CDXCardDeckListViewTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CDXCardDeckListViewTableCell"];
    if (cell == nil) {
        LogDebug(@"new");
        
        [[NSBundle mainBundle] loadNibNamed:@"CDXCardDeckListViewTableCell" owner:self options:nil];
        cell = self.loadedTableViewCell;
        self.loadedTableViewCell = nil;
        
        NSAssert([@"CDXCardDeckListViewTableCell" isEqualToString:[cell reuseIdentifier]], @"reuseIdentifier must match");        
    } else {
        LogDebug(@"dequeued");
    }
    
    [cell configureWithCardDeck:[_cardDeckList cardDeckAtIndex:indexPath.row] editing:_editModeActive];
    if ([indexPath isEqual:_tableViewSelectedRowIndexPath]) {
        [cell setSelected:YES];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation(@"%d", indexPath.row);
    
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation(@"%d", indexPath.row);
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    LogInvocation(@"%d -> %d", fromIndexPath.row, toIndexPath.row);
    
    if (fromIndexPath.row == toIndexPath.row) {
        return;
    }
    
    CDXCardDeck *cardDeck = [[[_cardDeckList cardDeckAtIndex:fromIndexPath.row] retain] autorelease];
    [_cardDeckList removeCardDeckAtIndex:fromIndexPath.row];
    [_cardDeckList insertCardDeck:cardDeck atIndex:toIndexPath.row];
    
    [CDXStorage update:_cardDeckList deferred:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation();
    
    self.tableViewSelectedRowIndexPath = indexPath;
    
    CDXCardDeck *cardDeck = [_cardDeckList cardDeckAtIndex:indexPath.row];
    NSString *file = [cardDeck file];
    
    if (_editModeActive) {
        NSUInteger newCardDeckIndex = [_cardDeckList indexOfCardDeck:_newCardDeck];
        if (newCardDeckIndex == indexPath.row) {
            file = @"New.CardDeck";
            cardDeck.file = [CDXStorage storageNameWithSuffix:@".CardDeck"];
            cardDeck.committed = NO;
        }
    }
    
    NSDictionary *dictionary = [CDXStorage readAsDictionary:file];
    if (dictionary == nil) {
        [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
        return;        
    }
    
    CDXCardDeck *cardDeckDetail = [CDXCardDeck cardDeckWithContentsOfDictionary:dictionary cards:YES colors:YES];
    cardDeckDetail.name = cardDeck.name;
    cardDeckDetail.file = cardDeck.file;
    cardDeckDetail.committed = cardDeck.committed;
    
    if (_editModeActive) {
        self.editCardDeck = [[cardDeck retain] autorelease];
        _editCardDeck.dirty = NO;
        self.editCardDeckDetail = [[cardDeckDetail retain] autorelease];
        
        CDXCardDeckEditViewController *cardDeckEditViewController = [CDXCardDeckEditViewController cardDeckEditViewControllerWithCardDeck:_editCardDeckDetail cardDeckList:_cardDeckList cardDeckInList:_editCardDeck];
        [[self navigationController] pushViewController:cardDeckEditViewController animated:YES];
    } else {
        CDXCardDeckViewController *cardDeckViewController = [CDXCardDeckViewController cardDeckViewControllerWithCardDeck:cardDeckDetail];
        [[self navigationController] pushViewController:cardDeckViewController animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation(@"%d", indexPath.row);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CDXCardDeck *cardDeck = [[[_cardDeckList cardDeckAtIndex:indexPath.row] retain] autorelease];
        [_cardDeckList removeCardDeckAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        [CDXStorage remove:cardDeck deferred:YES];
        [CDXStorage update:_cardDeckList deferred:YES];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation(@"%d", indexPath.row);
    
    if (!_editModeActive) {
        return UITableViewCellEditingStyleNone;
    }
    
    if ([_cardDeckList cardDeckAtIndex:indexPath.row] ==  _newCardDeck && !_newCardDeck.committed) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}


- (NSIndexPath *)insertNewCardDeck {
    LogInvocation();
    
    NSUInteger row = -1;
    if (_newCardDeck != nil && _editCardDeck == _newCardDeck) {
        row = [_cardDeckList indexOfCardDeck:_newCardDeck] + 1;
    }
    
    self.newCardDeck = [[[CDXCardDeck alloc] init] autorelease];
    _newCardDeck.name = @"New Card Deck";
    
    if (row == -1) {
        row = 0;
    }
    
    [_cardDeckList insertCardDeck:_newCardDeck atIndex:row];
    NSIndexPath *newCardDeckIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newCardDeckIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    return newCardDeckIndexPath;
}

- (void)setEditMode:(BOOL)editMode withNewCard:(BOOL)withNewCard animated:(BOOL)animated {
    if (!editMode) {
        _editModeActive = NO;
        
        [_tableView setEditing:NO animated:animated];
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
        }
        
        CGRect frame;
        frame = _tableView.frame;
        frame.size.height = frame.size.height+24;
        _tableView.frame = frame;
        
        frame = _toolBar.frame;
        frame.origin.y = frame.origin.y+24;
        _toolBar.frame = frame;
        
        _worldButton.image = [UIImage imageNamed:@"Transparent.png"];
        _worldButton.enabled = NO;
        
        if (animated) {
            [UIView commitAnimations];
        }
        
        if (_newCardDeck != nil) {
            NSUInteger newCardDeckIndex = [_cardDeckList indexOfCardDeck:_newCardDeck];
            [_cardDeckList removeCardDeckAtIndex:newCardDeckIndex];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:newCardDeckIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            self.newCardDeck = nil;
        }
        
        self.editCardDeck = nil;
        self.editCardDeckDetail = nil;
        
        [_editButton setTitle:@" Edit "];
        [_editButton setStyle:UIBarButtonItemStyleBordered];
        
        [CDXStorage drainDeferred:nil];
    } else {
        _editModeActive = YES;
        
        if (withNewCard) {
            self.editCardDeck = nil;
            self.editCardDeckDetail = nil;
            
            [self insertNewCardDeck];
        }
        
        [_tableView setEditing:YES animated:animated];
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
        }
        
        CGRect frame;
        frame = _tableView.frame;
        frame.size.height = frame.size.height-24;
        _tableView.frame = frame;
        
        frame = _toolBar.frame;
        frame.origin.y = frame.origin.y-24;
        _toolBar.frame = frame;
        
        _worldButton.image = [UIImage imageNamed:@"World.png"];
        _worldButton.enabled = YES;
        
        if (animated) {
            [UIView commitAnimations];
        }
        
        [_editButton setTitle:@"Done"];
        [_editButton setStyle:UIBarButtonItemStyleDone];
    }
}

- (IBAction)editButtonPressed {
    LogInvocation();
    
    [self setEditMode:!_editModeActive withNewCard:YES animated:YES];
}

- (IBAction)worldButtonPressed {
    CDXInfoViewController *infoViewController = [CDXInfoViewController infoViewController];
    
    [self presentModalViewController:infoViewController animated:YES];
}

- (void)setEditModeInactive {
    _setEditModeInactive = YES;
}

- (void)selectRowAtIndexPath:(NSIndexPath *)selectedRowPath {
    [_tableView selectRowAtIndexPath:selectedRowPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    [_tableView deselectRowAtIndexPath:selectedRowPath animated:YES];
}

+ (CDXCardDeckListViewController *)cardDeckListViewControllerWithCardDeckList:(CDXCardDeckList *)cardDeckList {
    LogInvocation();
    
    CDXCardDeckListViewController *controller = [[[CDXCardDeckListViewController alloc] initWithNibName:@"CDXCardDeckListView" bundle:nil] autorelease];
    controller.cardDeckList = cardDeckList;
    
    return controller;
}

@end

