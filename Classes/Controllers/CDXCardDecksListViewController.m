//
//
// CDXCardDecksListViewController.m
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

#import "CDXCardDecksListViewController.h"
#import "CDXCardDeckCardViewController.h"
#import "CDXCardDeckListViewController.h"
#import "CDXImageFactory.h"


@implementation CDXCardDecksListViewController

- (id)initWithCardDecks:(CDXCardDecks *)decks {
    if ((self = [super initWithNibName:@"CDXCardDecksListView" bundle:nil])) {
        ivar_assign_and_retain(cardDecks, decks);
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(cardDecksTableView);
    ivar_release_and_clear(cardDecks);
    ivar_release_and_clear(viewToolbar);
    ivar_release_and_clear(tableCellTextFont);
    ivar_release_and_clear(tableCellTextTextColor);
    ivar_release_and_clear(tableCellTextTextColorNoCards);
    ivar_release_and_clear(tableCellDetailTextFont);
    ivar_release_and_clear(tableCellDetailTextTextColor);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = @"Card Decks";
    navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc]
                                         initWithTitle:@"Decks"
                                         style:UIBarButtonItemStylePlain
                                         target:nil
                                         action:nil]
                                        autorelease];
    self.toolbarItems = viewToolbar.items;
    ivar_assign_and_retain(tableCellTextFont, [UIFont boldSystemFontOfSize:18]);
    ivar_assign_and_retain(tableCellTextTextColor, [UIColor blackColor]);
    ivar_assign_and_retain(tableCellTextTextColorNoCards, [UIColor lightGrayColor]);
    ivar_assign_and_retain(tableCellDetailTextFont, [UIFont systemFontOfSize:12]);
    ivar_assign_and_retain(tableCellDetailTextTextColor, [UIColor lightGrayColor]);
    tableCellImageSize = CGSizeMake(10, 10);
}

- (void)viewDidUnload {
    ivar_release_and_clear(cardDecksTableView);
    ivar_release_and_clear(viewToolbar);
    ivar_release_and_clear(tableCellTextFont);
    ivar_release_and_clear(tableCellTextTextColor);
    ivar_release_and_clear(tableCellTextTextColorNoCards);
    ivar_release_and_clear(tableCellDetailTextFont);
    ivar_release_and_clear(tableCellDetailTextTextColor);
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [cardDecksTableView reloadData];
}

- (void)setUserInteractionEnabled:(BOOL)enabled {
}

- (void)deviceOrientationDidChange:(UIDeviceOrientation)orientation {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cardDecks cardDecksCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
        cell.textLabel.font = tableCellTextFont;
        cell.detailTextLabel.font = tableCellDetailTextFont;
        cell.detailTextLabel.textColor = tableCellDetailTextTextColor;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    CDXCardDeck *deck = [cardDecks cardDeckAtIndex:indexPath.row];
    NSString *name = deck.name;
    if ([@"" isEqualToString:name]) {
        name = @" ";
    }
    cell.textLabel.text = name;
    cell.detailTextLabel.text = deck.description;
    cell.imageView.image = [[CDXImageFactory sharedImageFactory] imageForThumbnailCard:[deck cardAtIndex:0 orCard:nil] size:tableCellImageSize];
    
    if ([deck cardsCount] == 0) {
        cell.textLabel.textColor = tableCellTextTextColorNoCards;
    } else {
        cell.textLabel.textColor = tableCellTextTextColor;
    }
    
    return cell;
}

- (void)pushCardDeckListViewControllerWithIndexPath:(NSIndexPath *)indexPath {
    CDXCardDeck *deck = [cardDecks cardDeckAtIndex:indexPath.row];
    CDXCardDeckViewContext *context = [[[CDXCardDeckViewContext alloc] initWithCardDeck:deck] autorelease];
    CDXCardDeckListViewController *vc = [[[CDXCardDeckListViewController alloc] initWithCardDeckViewContext:context] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CDXCardDeck *deck = [cardDecks cardDeckAtIndex:indexPath.row];
    if ([deck cardsCount] == 0) {
        [self pushCardDeckListViewControllerWithIndexPath:indexPath];
        return;
    }
    
    CDXCardDeckViewContext *context = [[[CDXCardDeckViewContext alloc] initWithCardDeck:deck] autorelease];
    CDXCardDeckCardViewController *vc = [[[CDXCardDeckCardViewController alloc] initWithCardDeckViewContext:context] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self pushCardDeckListViewControllerWithIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.editing ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [cardDecks removeCardDeckAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    qltrace();
    CDXCardDeck *deck = [cardDecks cardDeckAtIndex:fromIndexPath.row];
    [deck retain];
    [cardDecks removeCardDeckAtIndex:fromIndexPath.row];
    [cardDecks insertCardDeck:deck atIndex:toIndexPath.row];
    [deck release];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [cardDecksTableView setEditing:editing animated:animated];
}

- (IBAction)addButtonPressed {
    qltrace();
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    deck.name = @"New Card Deck";
    [cardDecks addCardDeck:deck];
    [cardDecksTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[cardDecks cardDecksCount]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [cardDecksTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[cardDecks cardDecksCount]-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self setEditing:NO animated:YES];
}

- (IBAction)editButtonPressed {
    qltrace();
    [self setEditing:!self.editing animated:YES];
}

@end

