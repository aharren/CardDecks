//
//
// CDXCardDeckListViewController.m
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

#import "CDXCardDeckListViewController.h"
#import "CDXCardDeckCardViewController.h"
#import "CDXCardDeckCardEditViewController.h"
#import "CDXSettingsViewController.h"
#import "CDXImageFactory.h"
#import "CDXCardDecks.h"
#import "CDXAppURL.h"
#import "CDXAppSettings.h"
#import "CDXDevice.h"
#import <Twitter/Twitter.h>

#undef ql_component
#define ql_component lcl_cController


@implementation CDXCardDeckListViewController

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)aCardDeckViewContext nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil titleText:aCardDeckViewContext.cardDeck.name backButtonText:@"Cards"])) {
        ivar_assign_and_retain(cardDeckViewContext, aCardDeckViewContext);
        ivar_assign_and_retain(cardDeck, aCardDeckViewContext.cardDeck);
        viewWasAlreadyVisible = NO;
    }
    return self;
}

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)aCardDeckViewContext {
    return [self initWithCardDeckViewContext:aCardDeckViewContext nibName:@"CDXCardDeckListView" bundle:nil];
}

- (void)dealloc {
    ivar_release_and_clear(cardDeckViewContext);
    ivar_release_and_clear(cardDeck);
    ivar_release_and_clear(shuffleButton);
    ivar_release_and_clear(actionButton);
    ivar_release_and_clear(addButton);
    ivar_release_and_clear(activeActionSheet);
    [super dealloc];
}

- (void)viewDidUnload {
    ivar_release_and_clear(shuffleButton);
    ivar_release_and_clear(actionButton);
    ivar_release_and_clear(addButton);
    ivar_release_and_clear(activeActionSheet);
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    qltrace();
    [super viewWillAppear:animated];
    self.navigationItem.title = cardDeckViewContext.cardDeck.name;
    if ([viewTableView numberOfRowsInSection:1] != 0) {
        [viewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cardDeckViewContext.currentCardIndex inSection:1] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    qltrace();
    [super viewDidAppear:animated];
    self.navigationItem.title = cardDeckViewContext.cardDeck.name;
    if ([cardDeck isShuffled]) {
        if (!viewWasAlreadyVisible) {
            [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Shuffle.png" text:@"shuffle" timeInterval:0.4 orientation:UIDeviceOrientationFaceUp view:self.view];
        }
    }
    viewWasAlreadyVisible = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        default:
        case 0:
            return 0;
        case 1:
            return [cardDeck cardsCount];
        case 2:
            return 1;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL otherGroup = NO;
    if (indexPath.section == 1) {
        NSUInteger groupSize = [cardDeck groupSize];
        if (groupSize > 0 && (indexPath.row / groupSize) % 2 == 0) {
            otherGroup = YES;
        }
    }
    
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath marked:otherGroup];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSection:(NSUInteger)section {
    switch (section) {
        default:
        case 0: {
            return nil;
        }
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSection1];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierSection1] autorelease];
                cell.textLabel.font = tableCellTextFont;
                cell.textLabel.textColor = tableCellTextTextColor;
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                cell.backgroundView = [[[UIImageView alloc] initWithImage:tableCellBackgroundImage] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
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
            }
            cell.textLabel.textColor = self.editing ? tableCellTextTextColorActionInactive : tableCellTextTextColorAction;
            return cell;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        default:
        case 0: {
            return nil;
        }
        case 1: {
            UITableViewCell *cell = [self tableView:tableView cellForSection:indexPath.section];
            CDXCard *card = [cardDeck cardAtIndex:indexPath.row];
            cell.textLabel.text = card.text;
            cell.imageView.image = [[CDXImageFactory sharedImageFactory] imageForColor:card.backgroundColor size:tableCellImageSize];
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [self tableView:tableView cellForSection:indexPath.section];
            cell.textLabel.textColor = self.editing ? tableCellTextTextColorActionInactive : tableCellTextTextColorAction;
            switch (indexPath.row) {
                default:
                case 0: {
                    cell.textLabel.text = @"  CARD DEFAULTS";
                    break;
                }
            }
            
            return cell;
        }
    }
}

- (void)pushCardDeckCardViewController {
    CDXCardDeckCardViewController *vc = [[[CDXCardDeckCardViewController alloc] initWithCardDeckViewContext:cardDeckViewContext] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
    
    [viewTableView deselectRowAtIndexPath:[viewTableView indexPathForSelectedRow] animated:YES];
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
            cardDeckViewContext.currentCardIndex = indexPath.row;
            [self performBlockingSelector:@selector(pushCardDeckCardViewController)
                               withObject:nil];
            deselectRow = NO;
            break;
        }
        case 2: {
            switch (indexPath.row) {
                default:
                case 0: {
                    [self defaultsButtonPressed];
                    deselectRow = NO;
                    break;
                }
            }
        }
    }
    if (deselectRow) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)pushCardDeckEditViewController {
    CDXCardDeckCardEditViewController *vc = [[[CDXCardDeckCardEditViewController alloc] initWithCardDeckViewContext:cardDeckViewContext editDefaults:NO] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
    [self performBlockingSelectorEnd];
}

- (void)pushCardDeckEditViewControllerForDefaults {
    CDXCardDeckCardEditViewController *vc = [[[CDXCardDeckCardEditViewController alloc] initWithCardDeckViewContext:cardDeckViewContext editDefaults:YES] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
    [self performBlockingSelectorEnd];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    cardDeckViewContext.currentCardIndex = indexPath.row;
    [self performBlockingSelector:@selector(pushCardDeckEditViewController)
                       withObject:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [cardDeck removeCardAtIndex:indexPath.row];
        [cardDeckViewContext updateStorageObjectsDeferred:YES];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateToolbarButtons];
        [viewTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    qltrace();
    [cardDeck moveCardAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
    [cardDeckViewContext updateStorageObjectsDeferred:YES];
    
    [viewTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
}

- (void)updateShuffleButton {
    if ([cardDeck isShuffled]) {
        shuffleButton.image = [UIImage imageNamed:@"Toolbar-Sort.png"];
    } else {
        shuffleButton.image = [UIImage imageNamed:@"Toolbar-Shuffle.png"];
    }
    shuffleButton.enabled = ([self tableView:viewTableView numberOfRowsInSection:1] != 0);
}

- (void)updateToolbarButtons {
    [super updateToolbarButtons];
    [self updateShuffleButton];
    actionButton.enabled = ([self tableView:viewTableView numberOfRowsInSection:1] != 0);
}

- (IBAction)addButtonPressedDelayed {
    CDXCard *card = [cardDeck cardWithDefaults];
    [cardDeck addCard:card];
    [cardDeckViewContext updateStorageObjectsDeferred:YES];
    
    cardDeckViewContext.currentCardIndex = [cardDeck cardsCount]-1;
    NSIndexPath *path = [NSIndexPath indexPathForRow:cardDeckViewContext.currentCardIndex inSection:1];
    [viewTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [viewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [viewTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    [viewTableView deselectRowAtIndexPath:path animated:YES];
    [self updateToolbarButtons];
}

- (IBAction)addButtonPressed {
    if (![[viewTableView indexPathsForVisibleRows] containsObject:[NSIndexPath indexPathForRow:0 inSection:2]] ||
        [viewTableView isEditing]) {
        qltrace();
        [self setEditing:NO animated:YES];
        [viewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [self performSelector:@selector(addButtonPressedDelayed) withObject:nil afterDelay:0.3];
    } else {
        [self addButtonPressedDelayed];
    }
}

- (IBAction)defaultsButtonPressed {
    qltrace();
    cardDeckViewContext.currentCardIndex = [cardDeck cardsCount]-1;
    [self performBlockingSelector:@selector(pushCardDeckEditViewControllerForDefaults)
                       withObject:NO];
}

- (IBAction)settingsButtonPressed {
    qltrace();
    CDXCardDeckSettings *settings = [[[CDXCardDeckSettings alloc] initWithCardDeck:cardDeck] autorelease];
    CDXSettingsViewController *vc = [[[CDXSettingsViewController alloc] initWithSettings:settings] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] presentModalViewController:vc fromBarButtonItem:settingsButton animated:YES];
}

- (IBAction)shuffleButtonPressed {
    if ([cardDeck isShuffled]) {
        [cardDeck sort];
        [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Sort.png" text:@"sort" timeInterval:0.4 orientation:UIDeviceOrientationFaceUp view:self.view];
    } else {
        [cardDeck shuffle];
        [[CDXAppWindowManager sharedAppWindowManager] showNoticeWithImageNamed:@"Notice-Shuffle.png" text:@"shuffle" timeInterval:0.4 orientation:UIDeviceOrientationFaceUp view:self.view];
    }
    [cardDeck updateStorageObjectDeferred:YES];
    
    [self updateShuffleButton];
    [viewTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dismissActionSheet {
    if (activeActionSheet != nil) {
        [activeActionSheet dismissWithClickedButtonIndex:[activeActionSheet cancelButtonIndex] animated:NO];
        ivar_release_and_clear(activeActionSheet);
    }
}

typedef enum {
    CDXCardDeckListViewControllerActionEmailDeck = 0,
    CDXCardDeckListViewControllerActionTweekDeck,
    CDXCardDeckListViewControllerActionDuplicateDeck,
    CDXCardDeckListViewControllerActionCount
} CDXCardDeckListViewControllerAction;

typedef struct {
    CDXCardDeckListViewControllerAction action;
    NSString *title;
} CDXCardDeckListViewControllerActionSheetButton;

static const CDXCardDeckListViewControllerActionSheetButton actionSheetButtons[2][4] = {
    {
        { CDXCardDeckListViewControllerActionEmailDeck, @"Email Deck" },
        { CDXCardDeckListViewControllerActionTweekDeck, @"Tweet Deck" },
        { CDXCardDeckListViewControllerActionDuplicateDeck, @"Duplicate Deck" },
        { -1, nil }
    },
    {
        { CDXCardDeckListViewControllerActionEmailDeck, @"Email Deck" },
        { CDXCardDeckListViewControllerActionDuplicateDeck, @"Duplicate Deck" },
        { -1, nil },
        { -1, nil }
    }
};

- (IBAction)actionButtonPressed {
    const int type = ([[CDXDevice sharedDevice] hasTwitterIntegration]) ? 0 : 1;
    UIActionSheet *actionSheet = [[[UIActionSheet alloc]
                                   initWithTitle:nil
                                   delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                   otherButtonTitles:
                                   actionSheetButtons[type][0].title,
                                   actionSheetButtons[type][1].title,
                                   actionSheetButtons[type][2].title,
                                   nil]
                                  autorelease];
    actionSheet.tag = type + 1;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    if (activeActionSheet != nil) {
        [self dismissActionSheet];
        // don't open a new sheet, just closed the same one
        return;
    }
    [[CDXAppWindowManager sharedAppWindowManager] showActionSheet:actionSheet fromBarButtonItem:actionButton];
    ivar_assign_and_retain(activeActionSheet, actionSheet);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    qltrace();
    ivar_release_and_clear(activeActionSheet);
    int type = actionSheet.tag - 1;
    if (type != 0 && type != 1) {
        return;
    }
    if (buttonIndex < 0 || buttonIndex > 3) {
        return;
    }
    switch (actionSheetButtons[type][buttonIndex].action) {
        default:
            return;
        case CDXCardDeckListViewControllerActionEmailDeck: {
            NSString *carddeckUrl = [CDXAppURL carddecksURLStringForVersion2AddActionFromCardDeck:cardDeck];
            if ([[CDXAppSettings sharedAppSettings] useMailApplication] || ![MFMailComposeViewController canSendMail]) {
                NSString *mailUrl = [NSString stringWithFormat:@"mailto:?&subject=%@&body=%@",
                                     [[cardDeck.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                      stringByReplacingOccurrencesOfString:@"&" withString:@"%26"],
                                     [[carddeckUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                      stringByReplacingOccurrencesOfString:@"&" withString:@"%26"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailUrl]];
            } else {
                MFMailComposeViewController *vc = [[[MFMailComposeViewController alloc] init] autorelease];
                [vc setMailComposeDelegate:self];
                [vc setSubject:cardDeck.name];
                [vc setMessageBody:[carddeckUrl stringByAppendingString:@" "] isHTML:NO];
                [[CDXKeyboardExtensions sharedKeyboardExtensions] setEnabled:NO];
                [[CDXAppWindowManager sharedAppWindowManager] presentModalViewController:vc animated:YES];
            }
            return;
        }
        case CDXCardDeckListViewControllerActionTweekDeck: {
            if ([[CDXDevice sharedDevice] hasTwitterIntegration]) {
                // we don't check [TWTweetComposeViewController canSendTweet] here
                // in order to get the 'No Twitter Accounts' system message if no
                // account is configured yet
                TWTweetComposeViewController *twc = [[[TWTweetComposeViewController alloc] init] autorelease];
                NSURL *url = [NSURL URLWithString:[CDXAppURL httpURLStringForVersion2AddActionFromCardDeck:cardDeck]];
                if ([twc addURL:url] == NO) {
                    return;
                }
                [[CDXKeyboardExtensions sharedKeyboardExtensions] setEnabled:NO];
                [[CDXAppWindowManager sharedAppWindowManager] presentModalViewController:twc animated:YES];
            }
            return;
        }
        case CDXCardDeckListViewControllerActionDuplicateDeck: {
            CDXCardDeck *deck = [[cardDeck copy] autorelease];
            deck.name = [deck.name stringByAppendingString:@" - Copy"];
            [deck updateStorageObjectDeferred:NO];
            CDXCardDeckHolder *holder = [CDXCardDeckHolder cardDeckHolderWithCardDeck:deck];
            [cardDeckViewContext.cardDecks addPendingCardDeckAdd:holder];
            [[CDXAppWindowManager sharedAppWindowManager] popViewControllerAnimated:YES];
            return;
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissModalViewControllerAnimated:YES];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setEnabled:YES];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    qltrace();
    [super dismissModalViewControllerAnimated:animated];
    [self dismissActionSheet];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    qltrace();
    if (indexPath.section == 1 && indexPath.row < [cardDeck cardsCount]) {
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
    if (indexPath.section == 1 && indexPath.row < [cardDeck cardsCount]) {
        if (action == @selector(copy:)) {
            // copy a temporary card deck with a single card to the pasteboard
            CDXCardDeck* tempDeck = [[[CDXCardDeck alloc] init] autorelease];
            [tempDeck setCardDefaults:[[[cardDeck cardDefaults] copy] autorelease]];
            [tempDeck setName:@""];
            [tempDeck setFlagsFromCardDeck:cardDeck];
            [tempDeck addCard:[[[cardDeck cardAtIndex:indexPath.row] copy] autorelease]];
            NSString *carddeckUrl = [CDXAppURL carddecksURLStringForVersion2AddActionFromCardDeck:tempDeck];
            [[UIPasteboard generalPasteboard] setString:carddeckUrl];
        } else if (action == @selector(paste:)) {
            // paste the first card from the card deck from the pasteboard
            NSString *carddeckUrl = [[UIPasteboard generalPasteboard] string];
            if (![CDXAppURL mayBeCardDecksURLString:carddeckUrl]) {
                return;
            }
            CDXCardDeck *sourceDeck = [CDXAppURL cardDeckFromURL:[NSURL URLWithString:carddeckUrl]];
            if (sourceDeck == nil || [sourceDeck cardsCount] == 0) {
                return;
            }
            [cardDeck replaceCardAtIndex:indexPath.row withCard:[[[sourceDeck cardAtIndex:0] copy] autorelease]];
            [cardDeck updateStorageObjectDeferred:YES];
            [viewTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        }
    }
}

@end

