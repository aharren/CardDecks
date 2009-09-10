//
//
// CDXCardDeckEditViewController.m
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

#import "CDXCardDeckEditViewController.h"
#import "CDXCardDeckViewController.h"
#import "CDXCardEditViewController.h"


@implementation CDXCardDeckEditViewController

#define LogFileComponent lcl_cCDXCardDeckEditViewController

@synthesize cardDeck = _cardDeck;

@synthesize tableView = _tableView;
@synthesize name = _name;
@synthesize nameButton = _nameButton;

@synthesize cardEditViewController = _cardEditViewController;
@synthesize loadedTableViewCell = _loadedTableViewCell;

@synthesize tableViewSelectedRowIndexPath = _tableViewSelectedRowIndexPath;

@synthesize cardDeckList = _cardDeckList;
@synthesize cardDeckInList = _cardDeckInList;
@synthesize editCard = _editCard;
@synthesize newCard = _newCard;

- (void)dealloc {
    LogInvocation();
    
    self.cardDeck = nil;
    
    self.tableView = nil;
    self.name = nil;
    self.nameButton = nil;
    
    self.cardEditViewController = nil;
    self.loadedTableViewCell = nil;
    
    self.tableViewSelectedRowIndexPath = nil;
    
    self.cardDeckList = nil;
    self.cardDeckInList = nil;
    self.editCard = nil;
    self.newCard = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    LogInvocation();
    
    [super viewDidLoad];
    
    _name.text = _cardDeck.name;
    
    UINavigationItem *navigationItem = [self navigationItem];
    navigationItem.title = _cardDeck.name;
    navigationItem.titleView = _name;
    navigationItem.rightBarButtonItem = _nameButton;
    navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc]
                                         initWithTitle:@"Back" 
                                         style:UIBarButtonItemStylePlain 
                                         target:nil
                                         action:nil]
                                        autorelease];
}

- (void)viewDidUnload {
    LogInvocation();
    
    self.tableView = nil;
    self.name = nil;
    self.nameButton = nil;
    
    self.loadedTableViewCell = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    LogInvocation();
    
    [super viewWillAppear:animated];
    
    if (!_editModeActive) {
        _editModeActive = YES;
        [self insertNewCard];
    }
    
    if (_editModeActive && ![_tableView isEditing]) {
        [_tableView setEditing:YES animated:NO];
    }
    
    if (_tableViewSelectedRowIndexPath != nil) {
        CDXCardDeckEditViewTableCell *cell = (CDXCardDeckEditViewTableCell *)[_tableView cellForRowAtIndexPath:_tableViewSelectedRowIndexPath];
        [cell setSelected:YES];
        [_tableView deselectRowAtIndexPath:_tableViewSelectedRowIndexPath animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    LogInvocation();
    
    [super viewDidAppear:animated];
    NSIndexPath *newCardIndexPath = nil;
    
    if (_tableViewSelectedRowIndexPath != nil) {
        [_tableView beginUpdates]; 
        if (_editModeActive && _editCard != nil && _editCard.dirty) {
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_tableViewSelectedRowIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:_tableViewSelectedRowIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            CDXCardDeckEditViewTableCell *cell = (CDXCardDeckEditViewTableCell *) [_tableView cellForRowAtIndexPath:_tableViewSelectedRowIndexPath];
            [cell configureWithCard:_editCard editing:YES];
            
            _editCard.committed = YES;
            _editCard.dirty = NO;
            
            _cardDeck.committed = YES;
            [CDXStorage update:_cardDeck deferred:YES];
            
            if (_editCard == _newCard) {
                newCardIndexPath = [self insertNewCard];
            }
        }
        [_tableView endUpdates];
    }
    
    [_editCard autorelease];
    _editCard = nil;
    
    self.tableViewSelectedRowIndexPath = nil;

    if (newCardIndexPath != nil) {
        [_tableView scrollToRowAtIndexPath:newCardIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    LogInvocation();
    
    [super viewWillDisappear:animated];
    
    if (_editCard == nil) {
        [CDXStorage drainDeferred:_cardDeck];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    LogInvocation();
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LogInvocation();
    
    return [_cardDeck cardsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation();
    
    CDXCardDeckEditViewTableCell *cell = (CDXCardDeckEditViewTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CDXCardDeckEditViewTableCell"];
    
    if (cell == nil) {
        LogDebug(@"new");
        
        [[NSBundle mainBundle] loadNibNamed:@"CDXCardDeckEditViewTableCell" owner:self options:nil];
        cell = self.loadedTableViewCell;
        self.loadedTableViewCell = nil;
        
        NSAssert([@"CDXCardDeckEditViewTableCell" isEqualToString:[cell reuseIdentifier]], @"reuseIdentifier must match");        
    } else {
        LogDebug(@"dequeued");
    }
    
    [cell configureWithCard:[_cardDeck cardAtIndex:indexPath.row] editing:YES];
    if ([indexPath isEqual:_tableViewSelectedRowIndexPath]) {
        [cell setSelected:YES];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation();
    
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation();
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    LogInvocation();
    
    if (fromIndexPath.row == toIndexPath.row) {
        return;
    }
    
    CDXCard *card = [[[_cardDeck cardAtIndex:fromIndexPath.row] retain] autorelease];
    [_cardDeck removeCardAtIndex:fromIndexPath.row];
    [_cardDeck insertCard:card atIndex:toIndexPath.row];
    
    [CDXStorage update:_cardDeck deferred:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation();
    
    self.tableViewSelectedRowIndexPath = indexPath;
    
    [_name resignFirstResponder];
    
    _editCard = [[_cardDeck cardAtIndex:indexPath.row] retain];
    _editCard.dirty = NO;
    
    if (_editCard == _newCard) {
        _editCard.textColor = _cardDeck.defaultTextColor;
        _editCard.backgroundColor = _cardDeck.defaultBackgroundColor;
    }
    
    [self initCardEditViewController];
    [_cardEditViewController configureWithCard:_editCard cardDeck:_cardDeck cardDeckList:_cardDeckList cardDeckInList:_cardDeckInList];
    [[self navigationController] pushViewController:_cardEditViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation();
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_cardDeck removeCardAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [CDXStorage update:_cardDeck deferred:YES];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInvocation();
    
    if ([_cardDeck cardAtIndex:indexPath.row] ==  _newCard) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (NSIndexPath *)insertNewCard {
    LogInvocation();
    
    NSUInteger row = -1;
    if (_newCard != nil && _editCard == _newCard) {
        row = [_cardDeck indexOfCard:_newCard] + 1;
    }
    
    self.newCard = [[[CDXCard alloc] init] autorelease];
    _newCard.text = @"New Card";
    
    if (row == -1) {
        row = 0;
    }
    
    LogDebug(@"row %d", row);
    [_cardDeck insertCard:_newCard atIndex:row];
    NSIndexPath *newCardIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newCardIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    return newCardIndexPath;
}

- (void)initCardEditViewController {
    LogInvocation();
    
    if (_cardEditViewController == nil) {
        self.cardEditViewController = [CDXCardEditViewController cardEditViewControllerWithCard:nil cardDeck:nil cardDeckList:nil cardDeckInList:nil];
    }
}

- (IBAction)nameDidEndOnExit {
}

- (IBAction)nameEditingDidEnd {
    _cardDeck.name = _name.text;
    [CDXStorage update:_cardDeck deferred:YES];
    
    _cardDeckInList.name = _cardDeck.name;
    _cardDeckInList.file = _cardDeck.file;
    _cardDeckInList.dirty = YES;
    _cardDeckInList.committed = YES;
    [CDXStorage update:_cardDeckList deferred:YES];                
    
    self.navigationItem.title = _cardDeck.name;
}

- (IBAction)sendButtonPressed {
    LogInvocation();
    
    NSString *url = nil;
    
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        [CDXStorage drainDeferred:nil];
        
        NSArray *cardDeckURLComponents = [_cardDeck stateAsURLComponents];
        NSString *cardDeckURL = [NSString stringWithFormat:@"carddecks:///add?%@",
                                 [cardDeckURLComponents componentsJoinedByString:@"&"]];
        NSString *body = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", cardDeckURL, cardDeckURL];
        
        url = [NSString stringWithFormat:@"mailto:?&subject=%@&body=%@",
               [[_cardDeck.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
                stringByReplacingOccurrencesOfString:@"&" withString:@"%26"], 
               [[body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
                stringByReplacingOccurrencesOfString:@"&" withString:@"%26"]];
        
        [url retain];
        [pool release];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    [url release];
}

- (IBAction)nameButtonPressed {
    LogInvocation();
    
    if ([_name isFirstResponder]) {
        [_name resignFirstResponder];
    } else {
        [_name becomeFirstResponder];
    }
}

+ (CDXCardDeckEditViewController *)cardDeckEditViewControllerWithCardDeck:(CDXCardDeck *)cardDeck cardDeckList:(CDXCardDeckList *)cardDeckList cardDeckInList:(CDXCardDeck *)cardDeckInList {
    LogInvocation();
    
    CDXCardDeckEditViewController *controller = [[[CDXCardDeckEditViewController alloc] initWithNibName:@"CDXCardDeckEditView" bundle:nil] autorelease];
    controller.cardDeck = cardDeck;
    controller.cardDeckList = cardDeckList;
    controller.cardDeckInList = cardDeckInList;
    return controller;
}

@end

