//
//
// CDXCardDecksListViewController.m
//
//
// Copyright (c) 2009-2025 Arne Harren <ah@0xc0.de>
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
#import "CDXCopyPaste.h"
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
    ivar_release_and_clear(settingsButton);
    ivar_release_and_clear(settingsBarButtonItem);
    [super dealloc];
}

- (void)viewDidLoad {
    qltrace();
    [super viewDidLoad];
    
    ivar_assign_and_retain(addButton, [self systemButtonWithImageNamed:@"Toolbar-Add" action:@selector(addButtonPressed) longPressAction:@selector(handleToolbarLongPressGesture:)]);
    ivar_assign_and_retain(settingsButton, [self systemButtonWithImageNamed:@"Toolbar-Settings" action:@selector(settingsButtonPressed)]);
    
    ivar_assign_and_retain(settingsBarButtonItem, [self barButtonItemWithButton:settingsButton]);
    
    [self buildToolbarWithBarButtonItemsLeft:@[[self barButtonItemWithButton:editButton]] middle:[self barButtonItemWithButton:addButton] right:@[settingsBarButtonItem]];
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
                cell.detailTextLabel.textColor = tableCellDetailTextTextColor;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell-RightDetail"]] autorelease];
                [cell.contentView insertSubview:[[[UIImageView alloc] initWithFrame:CGRectMake(0,0,tableCellImageSize.width,tableCellImageSize.height)] autorelease] atIndex:0];
                cell.indentationWidth = 6;
                cell.indentationLevel = 1;
            }
            UIImageView* image = cell.contentView.subviews[0];
            [image setImage:nil];
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSection2];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierSection2] autorelease];
                cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
            if (!self.editing) {
                UIImageView* image = cell.contentView.subviews[0];
                [image setImage:[[CDXImageFactory sharedImageFactory] imageForColor:deck.thumbnailColor size:tableCellImageSize]];
            }
            cell.textLabel.text = name;

            NSInteger tag = 0;
            tag |= (deck.tag == currentTag) ? CDXTableViewCellTagNewObject : CDXTableViewCellTagNone;
            cell.tag = tag;

            if ([deck cardsCount] == 0) {
                cell.textLabel.textColor = tableCellTextTextColorNoCards;
                if ((cell.tag & CDXTableViewCellTagNewObject) == CDXTableViewCellTagNewObject) {
                    cell.detailTextLabel.text = @"tap here to add cards to this deck";
                } else {
                    cell.detailTextLabel.text = @"no cards";
                }
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
                    cell.textLabel.text = @"tap here to edit defaults for new decks";
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
            [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES withTouchLocation:currentTouchLocationInWindow];
        }
    }
    
    NSIndexPath *indexPath = [viewTableView indexPathForSelectedRow];
    [viewTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performBlockingSelectorEnd];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        default:
        case 0: {
            break;
        }
        case 1: {
            lastCardDeckIndex = indexPath.row;
            CDXCardDeckHolder *deckHolder = [cardDecks cardDeckAtIndex:indexPath.row];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if ((cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator ||
                 cell.accessoryType == UITableViewCellAccessoryDetailDisclosureButton)
                && [deckHolder cardsCount] != 0) {
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
                    [self defaultsButtonPressed];
                    break;
                }
            }
        }
    }
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
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
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    holder.tag = currentTag;
    [cardDecks addCardDeck:holder];
    [cardDecks updateStorageObjectDeferred:NO];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:[cardDecks cardDecksCount]-1 inSection:1];
    [viewTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    [viewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [viewTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    [viewTableView deselectRowAtIndexPath:path animated:YES];
    [self updateToolbarButtons];
}

- (void)processCardDeckAddAtBottom:(CDXCardDeckHolder *)holder {
    qltrace();
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
    [[CDXAppWindowManager sharedAppWindowManager] presentModalViewController:vc fromBarButtonItem:settingsBarButtonItem forViewController:self animated:YES];
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
    [[CDXAppWindowManager sharedAppWindowManager] presentModalViewController:vc fromBarButtonItem:settingsBarButtonItem forViewController:self animated:YES];
}

- (void)processSinglePendingCardDeckAdd {
    CDXCardDeckHolder *deck = [cardDecks popPendingCardDeckAdd];
    if (deck != nil) {
        deck.tag = currentTag;
        NSUInteger row = (lastCardDeckIndex < [cardDecks cardDecksCount]) ? lastCardDeckIndex : 0;
        [cardDecks insertCardDeck:deck atIndex:row];
        [cardDecks updateStorageObjectDeferred:YES];
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:1];
        [viewTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        [viewTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [self updateToolbarButtons];
    }
    
    if ([cardDecks hasPendingCardDeckAdds]) {
        [self performBlockingSelector:@selector(processSinglePendingCardDeckAdd) withObject:nil];
    } else {
        [CDXStorage drainAllDeferredActions];
        [self performBlockingSelectorEnd];
        [self processStartupCallbacks];
        
        if (deck != nil) {
            [[CDXAppWindowManager sharedAppWindowManager] showInfoMessage:@"Card deck added" afterDelay:0.3];
        }
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
            // paste is only possible if the pasteboard contains a potentially valid card deck
            NSString *carddeckString = [[UIPasteboard generalPasteboard] string];
            return [CDXCopyPaste mayBeCardDeck:carddeckString];
        }
    }
    if (action == @selector(duplicateButtonPressed)) {
        return YES;
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
            NSString *carddeckString = [[UIPasteboard generalPasteboard] string];
            if (![CDXCopyPaste mayBeCardDeck:carddeckString]) {
                return;
            }
            CDXCardDeck *sourceDeck = [CDXCopyPaste cardDeckFromString:carddeckString allowEmpty:NO];
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
            [viewTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        }
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender button:(UIButton *)button {
    qltrace();
    if (button == addButton) {
        if (action == @selector(paste:)) {
            // paste is only possible if the pasteboard contains a potentially valid card deck
            NSString *carddeckString = [[UIPasteboard generalPasteboard] string];
            return [CDXCopyPaste mayBeCardDeck:carddeckString];
        } else if (action == @selector(addButtonPressed)) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

- (void)performAction:(SEL)action withSender:(id)sender button:(UIButton *)button {
    qltrace();
    if (button == addButton) {
        if (action == @selector(paste:)) {
            // paste the card deck from the pasteboard as a new card deck
            NSString *carddeckString = [[UIPasteboard generalPasteboard] string];
            if (![CDXCopyPaste mayBeCardDeck:carddeckString]) {
                return;
            }
            CDXCardDeck *sourceDeck = [CDXCopyPaste cardDeckFromString:carddeckString allowEmpty:YES];
            if (sourceDeck == nil) {
                return;
            }
            CDXCardDeckHolder *holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:sourceDeck];
            [holder.cardDeck updateStorageObjectDeferred:NO];
            [self processCardDeckAddAtBottom:holder];
            return;
        } else {
            return;
        }
    }
}

- (void)duplicateButtonPressed {
    qltrace(@"%@", performActionTableViewIndexPath);
    if (performActionTableViewIndexPath.section != 1) {
        return;
    }
    CDXCardDeckHolder *sourceDeck = nil;
    sourceDeck = [cardDecks cardDeckAtIndex:performActionTableViewIndexPath.row];
    CDXCardDeck *deck = [[sourceDeck.cardDeck copy] autorelease];
    [deck updateStorageObjectDeferred:NO];
    CDXCardDeckHolder *holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
    [cardDecks addPendingCardDeckAdd:holder];
    lastCardDeckIndex = performActionTableViewIndexPath.row;
    [self processPendingCardDeckAdds];
}

- (UIMenu *)editMenuInteraction:(UIEditMenuInteraction *)interaction menuForConfiguration:(UIEditMenuConfiguration *)configuration suggestedActions:(NSArray<UIMenuElement *> *)suggestedActions {
    qltrace(@"configuration id %@", configuration.identifier);
    NSMutableArray<UIMenuElement *> *actions = [NSMutableArray arrayWithArray:suggestedActions];
    if (interaction == tableViewMenuInteraction) {
        [actions addObjectsFromArray:@[
            [UIAction actionWithTitle:@"Duplicate" image:nil identifier:nil handler:^(UIAction *action) {
                [self duplicateButtonPressed];
            }]
        ]];
    } else if (interaction == toolbarMenuInteraction) {
        if (performActionToolbarButton == addButton) {
            [actions addObjectsFromArray:@[
                [UIAction actionWithTitle:@"New" image:nil identifier:nil handler:^(UIAction *action) {
                    [self addButtonPressed];
                }]
            ]];
        }
    }
    return [UIMenu menuWithChildren:actions];
}

@end

