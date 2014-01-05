//
//
// CDXCardDecksListViewController.m
//
//
// Copyright (c) 2009-2014 Arne Harren <ah@0xc0.de>
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
#import "CDXReleaseNotesViewController.h"
#import "CDXImageFactory.h"
#import "CDXAppSettings.h"
#import "CDXSettingsViewController.h"
#import "CDXCardDecks.h"
#import "CDXAppURL.h"
#import "CDXApplicationVersion.h"

#undef ql_component
#define ql_component lcl_cController


@implementation CDXCardDecksListViewController

- (id)initWithCardDecks:(CDXCardDecks *)decks nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil titleText:@"Card Decks" backButtonText:@"Decks"])) {
        ivar_assign_and_retain(cardDecks, decks);
    }
    return self;
}

- (id)initWithCardDecks:(CDXCardDecks *)decks {
    return [self initWithCardDecks:decks nibName:@"CDXCardDecksListView" bundle:nil];
}

- (void)dealloc {
    ivar_release_and_clear(cardDecks);
    ivar_release_and_clear(addButton);
    [super dealloc];
}

- (void)viewDidUnload {
    ivar_release_and_clear(addButton);
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    qltrace();
    [super viewWillAppear:animated];
    [CDXStorage drainAllDeferredActions];
}

- (void)viewDidAppear:(BOOL)animated {
    qltrace();
    [super viewDidAppear:animated];
    [self processPendingCardDeckAdds];
}

- (void)processStartupCallbacks {
    if (![[[CDXAppSettings sharedAppSettings] versionState] isEqualToString:CDXApplicationVersion]) {
        [[CDXAppSettings sharedAppSettings] setVersionState:CDXApplicationVersion];
        [self performSelector:@selector(showReleaseNotes) withObject:nil afterDelay:0.001];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        default:
        case 0:
            return 0;
        case 1:
            return [cardDecks cardDecksCount];
        case 2:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSection:(NSUInteger)section {
    switch (section) {
        default:
        case 0:
            return nil;
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSection1];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifierSection1] autorelease];
                cell.textLabel.font = tableCellTextFont;
                cell.detailTextLabel.font = tableCellDetailTextFont;
                cell.detailTextLabel.textColor = tableCellDetailTextTextColor;
                cell.backgroundView = [[[UIImageView alloc] initWithImage:tableCellBackgroundImage] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell-RightDetail"]] autorelease];
            }
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSection2];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierSection2] autorelease];
                cell.textLabel.font = tableCellTextFontAction;
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundView = [[[UIImageView alloc] initWithImage:tableCellBackgroundImage] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell-RightDetail"]] autorelease];
            }
            cell.textLabel.textColor = self.editing ? tableCellTextTextColorActionInactive : tableCellTextTextColorAction;
            return cell;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        default:
        case 0:
            return nil;
        case 1: {
            UITableViewCell *cell = [self tableView:tableView cellForSection:indexPath.section];
            CDXCardDeckBase *deck = [cardDecks cardDeckAtIndex:indexPath.row];
            NSString *name = deck.name;
            if ([@"" isEqualToString:name]) {
                name = @" ";
            }
            cell.textLabel.text = name;
            cell.imageView.image = [[CDXImageFactory sharedImageFactory] imageForColor:deck.thumbnailColor size:tableCellImageSize];
            
            if ([deck cardsCount] == 0) {
                cell.textLabel.textColor = tableCellTextTextColorNoCards;
                cell.detailTextLabel.text = @"NO CARDS";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.textLabel.textColor = tableCellTextTextColor;
                NSString *description = deck.description;
                if ([@"" isEqualToString:description]) {
                    description = @" ";
                }
                NSString *text = [description stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                cell.detailTextLabel.text = text;
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            }
            
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [self tableView:tableView cellForSection:indexPath.section];
            switch (indexPath.row) {
                default:
                case 0: {
                    cell.textLabel.text = @"  DECK DEFAULTS";
                    break;
                }
            }
            
            return cell;
        }
    }
}

- (void)pushCardDeckListViewControllerWithCardDeckHolder:(CDXCardDeckHolder *)deckHolder {
    if (deckHolder != nil) {
        CDXCardDeck *deck = deckHolder.cardDeck;
        if (deck != nil) {
            CDXCardDeckViewContext *context = [[[CDXCardDeckViewContext alloc] initWithCardDeck:deck cardDecks:cardDecks] autorelease];
            CDXCardDeckListViewController *vc = [[[CDXCardDeckListViewController alloc] initWithCardDeckViewContext:context] autorelease];
            [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
        }
    }
    
    NSIndexPath *indexPath = [viewTableView indexPathForSelectedRow];
    [viewTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performBlockingSelectorEnd];
}

- (void)pushCardDeckCardViewControllerWithCardDeckHolder:(CDXCardDeckHolder *)deckHolder {
    if (deckHolder != nil) {
        CDXCardDeck *deck = deckHolder.cardDeck;
        if (deck != nil && [deck cardsCount] != 0) {
            CDXCardDeckViewContext *context = [[[CDXCardDeckViewContext alloc] initWithCardDeck:deck cardDecks:cardDecks] autorelease];
            CDXCardDeckCardViewController *vc = [[[CDXCardDeckCardViewController alloc] initWithCardDeckViewContext:context] autorelease];
            keepViewTableViewContentOffsetY = YES;
            [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
        }
    }
    
    NSIndexPath *indexPath = [viewTableView indexPathForSelectedRow];
    [viewTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performBlockingSelectorEnd];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL deselectRow = YES;
    switch (indexPath.section) {
        default:
        case 0: {
            break;
        }
        case 1: {
            lastCardDeckIndex = indexPath.row;
            deselectRow = NO;
            CDXCardDeckHolder *deckHolder = [cardDecks cardDeckAtIndex:indexPath.row];
            if ([deckHolder cardsCount] != 0) {
                [self performBlockingSelector:@selector(pushCardDeckCardViewControllerWithCardDeckHolder:)
                                   withObject:deckHolder];
            } else {
                [self performBlockingSelector:@selector(pushCardDeckListViewControllerWithCardDeckHolder:)
                                   withObject:deckHolder];
            }
            break;
        }
        case 2: {
            switch (indexPath.row) {
                default:
                case 0: {
                    deselectRow = NO;
                    [self defaultsButtonPressed];
                    break;
                }
            }
        }
    }
    if (deselectRow) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    lastCardDeckIndex = indexPath.row;
    [self performBlockingSelector:@selector(pushCardDeckListViewControllerWithCardDeckHolder:)
                       withObject:[cardDecks cardDeckAtIndex:indexPath.row]];
}

- (void)deleteCardDeckAtIndex:(NSUInteger)index {
    CDXCardDeckBase *deck = [cardDecks cardDeckAtIndex:index];
    [CDXStorage removeStorageObject:deck.cardDeck deferred:NO];
    
    [cardDecks removeCardDeckAtIndex:index];
    [cardDecks updateStorageObjectDeferred:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteCardDeckAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateToolbarButtons];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    qltrace();
    CDXCardDeckHolder *deck = [cardDecks cardDeckAtIndex:fromIndexPath.row];
    [deck retain];
    [cardDecks removeCardDeckAtIndex:fromIndexPath.row];
    [cardDecks insertCardDeck:deck atIndex:toIndexPath.row];
    [cardDecks updateStorageObjectDeferred:YES];
    [deck release];
}

- (void)processCardDeckAddAtBottomDelayed:(CDXCardDeckHolder *)holder {
    qltrace();
    [cardDecks addCardDeck:holder];
    [cardDecks updateStorageObjectDeferred:NO];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:[cardDecks cardDecksCount]-1 inSection:1];
    [viewTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [viewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [viewTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    [viewTableView deselectRowAtIndexPath:path animated:YES];
    [self updateToolbarButtons];
}

- (void)processCardDeckAddAtBottom:(CDXCardDeckHolder *)holder {
    if (![[viewTableView indexPathsForVisibleRows] containsObject:[NSIndexPath indexPathForRow:0 inSection:2]] ||
        [viewTableView isEditing]) {
        qltrace();
        [self setEditing:NO animated:YES];
        [viewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [self performSelector:@selector(processCardDeckAddAtBottomDelayed:) withObject:holder afterDelay:0.3];
    } else {
        [self processCardDeckAddAtBottomDelayed:holder];
    }
}

- (void)showReleaseNotes {
    CDXReleaseNotesViewController *vc = [[[CDXReleaseNotesViewController alloc] init] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] presentModalViewController:vc fromBarButtonItem:settingsButton animated:YES];
}

- (IBAction)addButtonPressed {
    qltrace();
    CDXCardDeckHolder *holder = [cardDecks cardDeckWithDefaults];
    [holder.cardDeck updateStorageObjectDeferred:NO];
    [self processCardDeckAddAtBottom:holder];
}

- (IBAction)defaultsButtonPressed {
    qltrace();
    [self performBlockingSelector:@selector(pushCardDeckListViewControllerWithCardDeckHolder:)
                       withObject:cardDecks.cardDeckDefaults];
}

- (IBAction)settingsButtonPressed {
    qltrace();
    CDXAppSettings *settings = [CDXAppSettings sharedAppSettings];
    CDXSettingsViewController *vc = [[[CDXSettingsViewController alloc] initWithSettings:settings] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] presentModalViewController:vc fromBarButtonItem:settingsButton animated:YES];
}

- (void)processSinglePendingCardDeckAdd {
    CDXCardDeckHolder *deck = [cardDecks popPendingCardDeckAdd];
    if (deck != nil) {
        NSUInteger row = (lastCardDeckIndex < [cardDecks cardDecksCount]) ? lastCardDeckIndex : 0;
        [cardDecks insertCardDeck:deck atIndex:row];
        [cardDecks updateStorageObjectDeferred:YES];
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:1];
        [viewTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
        [viewTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
        [viewTableView deselectRowAtIndexPath:path animated:YES];
        [self updateToolbarButtons];
    }
    
    if ([cardDecks hasPendingCardDeckAdds]) {
        [self performBlockingSelector:@selector(processSinglePendingCardDeckAdd) withObject:nil];
    } else {
        [CDXStorage drainAllDeferredActions];
        [self performBlockingSelectorEnd];
        [self processStartupCallbacks];
    }
}

- (void)processPendingCardDeckAdds {
    if ([cardDecks hasPendingCardDeckAdds]) {
        [self performBlockingSelector:@selector(processSinglePendingCardDeckAdd) withObject:nil];
    } else {
        [self processStartupCallbacks];
    }
}

- (void)processPendingCardDeckAddsAtTopDelayed {
    qltrace();
    lastCardDeckIndex = 0;
    [self setEditing:NO animated:YES];
    if ([cardDecks cardDecksCount] > 0) {
        [viewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    [self performSelector:@selector(processPendingCardDeckAdds) withObject:nil afterDelay:0.5];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    qltrace();
    if (indexPath.section == 1 && indexPath.row < [cardDecks cardDecksCount]) {
        if (action == @selector(copy:)) {
            // copy is always possible
            return YES;
        } else if (action == @selector(paste:)) {
            // paste is only possible if the pasteboard contains a "valid" URL
            NSString *carddeckUrl = [[UIPasteboard generalPasteboard] string];
            return [CDXAppURL mayBeCardDecksURLString:carddeckUrl];
        }
    }
    return NO;
}

- (void)performAction:(SEL)action withSender:(id)sender tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    qltrace();
    if (indexPath.section == 1 && indexPath.row < [cardDecks cardDecksCount]) {
        if (action == @selector(copy:)) {
            // copy the card deck to the pasteboard
            CDXCardDeck* cardDeck = [cardDecks cardDeckAtIndex:indexPath.row].cardDeck;
            NSString *carddeckUrl = [CDXAppURL carddecksURLStringForVersion2AddActionFromCardDeck:cardDeck];
            [[UIPasteboard generalPasteboard] setString:carddeckUrl];
        } else if (action == @selector(paste:)) {
            // paste the card deck from the pasteboard
            NSString *carddeckUrl = [[UIPasteboard generalPasteboard] string];
            if (![CDXAppURL mayBeCardDecksURLString:carddeckUrl]) {
                return;
            }
            CDXCardDeck *sourceDeck = [CDXAppURL cardDeckFromURL:[NSURL URLWithString:carddeckUrl]];
            if (sourceDeck == nil) {
                return;
            }
            CDXCardDeck *targetDeck = [cardDecks cardDeckAtIndex:indexPath.row].cardDeck;
            UITableViewRowAnimation animation = UITableViewRowAnimationNone;
            if ([targetDeck cardsCount] == 0) {
                // paste everything if the target deck is empty, e.g. a new deck
                [targetDeck setName:sourceDeck.name];
                [targetDeck setCardDefaults:[[[sourceDeck cardDefaults] copy] autorelease]];
                [targetDeck setFlagsFromCardDeck:sourceDeck];
                [targetDeck sort];
                [targetDeck addCards:[sourceDeck removeCards]];
                animation = UITableViewRowAnimationRight;
            } else {
                // add cards if the targe deck is not empty
                [targetDeck addCards:[sourceDeck removeCards]];
                animation = UITableViewRowAnimationLeft;
            }
            [targetDeck updateStorageObjectDeferred:NO];
            [cardDecks updateStorageObjectDeferred:NO];
            [viewTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animation];
        }
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender barButtonItem:(UIBarButtonItem *)barButtonItem {
    qltrace();
    if (barButtonItem == addButton) {
        if (action == @selector(paste:)) {
            // paste is only possible if the pasteboard contains a "valid" URL
            NSString *carddeckUrl = [[UIPasteboard generalPasteboard] string];
            return [CDXAppURL mayBeCardDecksURLString:carddeckUrl];
        } else {
            return NO;
        }
    }
    return NO;
}

- (void)performAction:(SEL)action withSender:(id)sender barButtonItem:(UIBarButtonItem *)barButtonItem {
    qltrace();
    if (barButtonItem == addButton) {
        if (action == @selector(paste:)) {
            // paste the card deck from the pasteboard as a new card deck
            NSString *carddeckUrl = [[UIPasteboard generalPasteboard] string];
            if (![CDXAppURL mayBeCardDecksURLString:carddeckUrl]) {
                return;
            }
            CDXCardDeck *deck = [CDXAppURL cardDeckFromURL:[NSURL URLWithString:carddeckUrl]];
            if (deck == nil) {
                return;
            }
            CDXCardDeckHolder *holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
            [holder.cardDeck updateStorageObjectDeferred:NO];
            [self processCardDeckAddAtBottom:holder];
            return;
        } else {
            return;
        }
    }
}

@end

