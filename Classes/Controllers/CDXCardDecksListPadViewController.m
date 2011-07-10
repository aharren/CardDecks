//
//
// CDXCardDecksListPadViewController.m
//
//
// Copyright (c) 2009-2011 Arne Harren <ah@0xc0.de>
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
    ivar_release_and_clear(tableCellBackgroundImage);
    ivar_release_and_clear(tableCellBackgroundImageAlt);
    ivar_release_and_clear(currentCardDeck);
    [super dealloc];
}

- (void)viewDidLoad {
    qltrace();
    [super viewDidLoad];
    
    viewTableViewContainer.layer.cornerRadius = 6;
    viewTableView.backgroundView = [[[UIImageView alloc] initWithImage:[[CDXImageFactory sharedImageFactory] imageForLinearGradientWithTopColor:[CDXColor colorWhite] bottomColor:[CDXColor colorWithRed:0xf0 green:0xf0 blue:0xf0 alpha:0xff] height:1024]] autorelease];
    
    ivar_assign_and_retain(tableCellBackgroundImage, [[CDXImageFactory sharedImageFactory] imageForLinearGradientWithTopColor:[CDXColor colorWhite] bottomColor:[CDXColor colorWithRed:0xf9 green:0xf9 blue:0xf9 alpha:0xff] height:44]);
    ivar_assign_and_retain(tableCellBackgroundImageAlt, [[CDXImageFactory sharedImageFactory] imageForLinearGradientWithTopColor:[CDXColor colorWithRed:0xf0 green:0xf0 blue:0xf0 alpha:0xff] bottomColor:[CDXColor colorWithRed:0xe9 green:0xe9 blue:0xe9 alpha:0xff] height:44]);
    ivar_assign_and_retain(tableCellBackgroundColorAction, [UIColor clearColor]);
    
    // steal the activity indicator
    viewNavigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
}

- (void)viewDidUnload {
    qltrace();
    ivar_release_and_clear(viewTableViewContainer);
    ivar_release_and_clear(viewNavigationItem);
    ivar_release_and_clear(tableCellBackgroundImage);
    ivar_release_and_clear(tableCellBackgroundImageAlt);
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
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    UIColor *clearColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = clearColor;
    cell.detailTextLabel.backgroundColor = clearColor;
    cell.backgroundColor = clearColor;
    BOOL selected = NO;
    if (indexPath.section == 1) {
        selected = [cardDecks cardDeckAtIndex:indexPath.row] == currentCardDeck;
    } else if (indexPath.section == 2) {
        selected = cardDecks.cardDeckDefaults == currentCardDeck;
    }
    if (selected) {
        cell.backgroundView	= [[[UIImageView alloc] initWithImage:tableCellBackgroundImageAlt] autorelease];
    } else {
        cell.backgroundView	= [[[UIImageView alloc] initWithImage:tableCellBackgroundImage] autorelease];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSection:(NSUInteger)section {
    switch (section) {
        case 0:
            return nil;
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSection1];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifierSection1] autorelease];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.backgroundView	= [[[UIImageView alloc] initWithImage:tableCellBackgroundImage] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSection2];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierSection2] autorelease];
                cell.textLabel.font = tableCellTextFontAction;
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.backgroundView	= [[[UIImageView alloc] initWithImage:tableCellBackgroundImage] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.textColor = self.editing ? tableCellTextTextColorActionInactive : tableCellTextTextColorAction;
            return cell;
        }
        default:
            return nil;
    }
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

- (void)pushCardDeckListViewControllerWithCardDeckBase:(CDXCardDeckBase *)deckBase {
    qltrace();
    if (deckBase != nil && deckBase != currentCardDeck) {
        CDXCardDeck *deck = deckBase.cardDeck;
        if (deck != nil) {
            CDXCardDeckViewContext *context = [[[CDXCardDeckViewContext alloc] initWithCardDeck:deck cardDecks:cardDecks] autorelease];
            CDXCardDeckListPadViewController *vc = [[[CDXCardDeckListPadViewController alloc] initWithCardDeckViewContext:context] autorelease];
            [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
            
            ivar_assign_and_retain(currentCardDeck, deckBase);
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

