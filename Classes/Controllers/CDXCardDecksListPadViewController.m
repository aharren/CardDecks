//
//
// CDXCardDecksListPadViewController.m
//
//
// Copyright (c) 2009-2012 Arne Harren <ah@0xc0.de>
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

#import "CDXCardDecksListPadViewController.h"
#import "CDXCardDeckCardViewController.h"
#import "CDXCardDeckListPadViewController.h"
#import "CDXImageFactory.h"
#import "CDXAppSettings.h"
#import "CDXSettingsViewController.h"
#import "CDXCardDecks.h"
#import <QuartzCore/QuartzCore.h>

#undef ql_component
#define ql_component lcl_cController


@implementation CDXCardDecksListPadViewController

- (id)initWithCardDecks:(CDXCardDecks *)decks {
    if ((self = [super initWithCardDecks:decks nibName:@"CDXCardDecksListPadView" bundle:nil])) {
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(viewTableViewContainer);
    ivar_release_and_clear(viewNavigationItem);
    ivar_release_and_clear(currentCardDeck);
    [super dealloc];
}

- (void)viewDidLoad {
    qltrace();
    [super viewDidLoad];
    
    viewTableViewContainer.layer.cornerRadius = 6;
    
    // steal the activity indicator
    viewNavigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
}

- (void)viewDidUnload {
    qltrace();
    ivar_release_and_clear(viewTableViewContainer);
    ivar_release_and_clear(viewNavigationItem);
    [super viewDidUnload];
}

- (void)updateNotificationForCardDeck:(id)object {
    qltrace();
    if (!ignoreCardDeckUpdateNotifications) {
        [viewTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        [cardDecks updateStorageObjectDeferred:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    qltrace();
    [super viewWillAppear:animated];
    if (!ignoreCardDeckUpdateNotifications) {
        ivar_release_and_clear(currentCardDeck);
        [viewTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    cardDeckQuickOpen = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    qltrace();
    [super viewDidAppear:animated];
    ignoreCardDeckUpdateNotifications = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationForCardDeck:) name:CDXCardDeckUpdateNotification object:nil];
    ignoreCardDeckUpdateNotifications = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    qltrace();
    ignoreCardDeckUpdateNotifications = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL selected = NO;
    if (indexPath.section == 1) {
        selected = [cardDecks cardDeckAtIndex:indexPath.row] == currentCardDeck;
    } else if (indexPath.section == 2) {
        selected = cardDecks.cardDeckDefaults == currentCardDeck;
    }
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath marked:selected];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSection:(NSUInteger)section {
    UITableViewCell *cell = [super tableView:tableView cellForSection:section];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)deleteCardDeckAtIndex:(NSUInteger)index {
    ignoreCardDeckUpdateNotifications = YES;
    CDXCardDeckBase *deck = [cardDecks cardDeckAtIndex:index];
    if (deck == currentCardDeck) {
        ivar_release_and_clear(currentCardDeck);
        [[CDXAppWindowManager sharedAppWindowManager] popToInitialViewController];
    }
    [super deleteCardDeckAtIndex:index];
    ignoreCardDeckUpdateNotifications = NO;
}

- (void)pushCardDeckListViewControllerWithCardDeckHolder:(CDXCardDeckHolder *)deckHolder {
    qltrace();
    if (deckHolder != nil && deckHolder != currentCardDeck) {
        CDXCardDeck *deck = deckHolder.cardDeck;
        if (deck != nil) {
            CDXCardDeckViewContext *context = [[[CDXCardDeckViewContext alloc] initWithCardDeck:deck cardDecks:cardDecks] autorelease];
            CDXCardDeckListPadViewController *vc = [[[CDXCardDeckListPadViewController alloc] initWithCardDeckViewContext:context] autorelease];
            [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
            
            ivar_assign_and_retain(currentCardDeck, deckHolder);
            [viewTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [viewTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    NSIndexPath *indexPath = [viewTableView indexPathForSelectedRow];
    [viewTableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performBlockingSelectorEnd];
}

- (void)processSinglePendingCardDeckAdd {
    ignoreCardDeckUpdateNotifications = YES;
    [super processSinglePendingCardDeckAdd];
    ignoreCardDeckUpdateNotifications = NO;
}

- (void)processPendingCardDeckAddsAtTopDelayed {
    [[CDXAppWindowManager sharedAppWindowManager] popToInitialViewController];
    ivar_release_and_clear(currentCardDeck);
    [viewTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    [super processPendingCardDeckAddsAtTopDelayed];
}

@end

