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
#import "CDXAppSettings.h"
#import "CDXSettingsViewController.h"


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
    ivar_release_and_clear(tableCellTextFontAction);
    ivar_release_and_clear(tableCellTextTextColor);
    ivar_release_and_clear(tableCellTextTextColorNoCards);
    ivar_release_and_clear(tableCellTextTextColorAction);
    ivar_release_and_clear(tableCellDetailTextFont);
    ivar_release_and_clear(tableCellDetailTextTextColor);
    ivar_release_and_clear(tableCellBackgroundColorAction);
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
    ivar_assign_and_retain(tableCellTextFontAction, [UIFont boldSystemFontOfSize:11]);
    ivar_assign_and_retain(tableCellTextTextColor, [UIColor blackColor]);
    ivar_assign_and_retain(tableCellTextTextColorNoCards, [UIColor lightGrayColor]);
    ivar_assign_and_retain(tableCellTextTextColorAction, [UIColor lightGrayColor]);
    ivar_assign_and_retain(tableCellDetailTextFont, [UIFont systemFontOfSize:12]);
    ivar_assign_and_retain(tableCellDetailTextTextColor, [UIColor lightGrayColor]);
    ivar_assign_and_retain(tableCellBackgroundColorAction, [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]);
    tableCellImageSize = CGSizeMake(10, 10);
}

- (void)viewDidUnload {
    ivar_release_and_clear(cardDecksTableView);
    ivar_release_and_clear(viewToolbar);
    ivar_release_and_clear(tableCellTextFont);
    ivar_release_and_clear(tableCellTextFontAction);
    ivar_release_and_clear(tableCellTextTextColor);
    ivar_release_and_clear(tableCellTextTextColorNoCards);
    ivar_release_and_clear(tableCellTextTextColorAction);
    ivar_release_and_clear(tableCellDetailTextFont);
    ivar_release_and_clear(tableCellDetailTextTextColor);
    ivar_release_and_clear(tableCellBackgroundColorAction);
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        default:
        case 0:
            return 0;
        case 1:
            return [cardDecks cardDecksCount];
        case 2:
            return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifierSection1 = @"Section1Cell";
    static NSString *reuseIdentifierSection2 = @"Section2Cell";
    switch (indexPath.section) {
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
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            
            CDXCardDeck *deck = [cardDecks cardDeckAtIndex:indexPath.row];
            NSString *name = deck.name;
            if ([@"" isEqualToString:name]) {
                name = @" ";
            }
            cell.textLabel.text = name;
            cell.imageView.image = [[CDXImageFactory sharedImageFactory] imageForThumbnailCard:[deck cardAtIndex:0 orCard:nil] size:tableCellImageSize];
            
            if ([deck cardsCount] == 0) {
                cell.textLabel.textColor = tableCellTextTextColorNoCards;
                cell.detailTextLabel.text = @"TOUCH TO ADD CARDS";
            } else {
                cell.textLabel.textColor = tableCellTextTextColor;
                cell.detailTextLabel.text = deck.description;
            }
            
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSection2];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierSection2] autorelease];
                cell.textLabel.font = tableCellTextFontAction;
                cell.textLabel.textColor = tableCellTextTextColorAction;
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            
            switch (indexPath.row) {
                default:
                case 0: {
                    cell.textLabel.text = @"TOUCH TO ADD A DECK";
                    break;
                }
                case 1: {
                    cell.textLabel.text = @"TOUCH TO CONFIGURE DECK DEFAULTS";
                    break;
                }
            }
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
            break;
        default:
        case 0:
        case 2:
            cell.backgroundColor = tableCellBackgroundColorAction;
            break;
    }
}

- (void)pushCardDeckListViewControllerWithCardDeck:(CDXCardDeck *)deck {
    CDXCardDeckViewContext *context = [[[CDXCardDeckViewContext alloc] initWithCardDeck:deck] autorelease];
    CDXCardDeckListViewController *vc = [[[CDXCardDeckListViewController alloc] initWithCardDeckViewContext:context] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        default:
        case 0: {
            break;
        }
        case 1: {
            CDXCardDeck *deck = [cardDecks cardDeckAtIndex:indexPath.row];
            if ([deck cardsCount] == 0) {
                [self pushCardDeckListViewControllerWithCardDeck:deck];
                return;
            }
            
            [self pushCardDeckListViewControllerWithCardDeck:deck];
            break;
        }
        case 2: {
            switch (indexPath.row) {
                default:
                case 0: {
                    [self addButtonPressed];
                    break;
                }
                case 1: {
                    [self defaultsButtonPressed];
                    break;
                }
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1;
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

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    switch (proposedDestinationIndexPath.section) {
        default:
        case 0: {
            return [NSIndexPath indexPathForRow:0 inSection:1];
            break;
        }
        case 1: {
            return proposedDestinationIndexPath;
            break;
        }
        case 2: {
            return [NSIndexPath indexPathForRow:[self tableView:tableView numberOfRowsInSection:1]-1 inSection:1];
            break;
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [cardDecksTableView setEditing:editing animated:animated];
}

- (IBAction)addButtonPressed {
    qltrace();
    CDXCardDeck *deck = [cardDecks cardDeckWithDefaults];
    [cardDecks addCardDeck:deck];
    NSIndexPath *path = [NSIndexPath indexPathForRow:[cardDecks cardDecksCount]-1 inSection:1];
    [cardDecksTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [cardDecksTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [cardDecksTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    [cardDecksTableView deselectRowAtIndexPath:path animated:YES];
    [self setEditing:NO animated:YES];
}

- (IBAction)defaultsButtonPressed {
    qltrace();
    [self pushCardDeckListViewControllerWithCardDeck:cardDecks.cardDeckDefaults];
}

- (IBAction)editButtonPressed {
    qltrace();
    [self setEditing:!self.editing animated:YES];
}

- (IBAction)bottomButtonPressed {
    [cardDecksTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self tableView:cardDecksTableView numberOfRowsInSection:2]-1 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (IBAction)settingsButtonPressed {
    qltrace();
    CDXAppSettings *settings = [CDXAppSettings sharedAppSettings];
    CDXSettingsViewController *vc = [[[CDXSettingsViewController alloc] initWithSettings:settings] autorelease];
    [self presentModalViewController:vc animated:YES];
}

@end

