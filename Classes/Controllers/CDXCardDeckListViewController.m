//
//
// CDXCardDeckListViewController.m
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

#import "CDXCardDeckListViewController.h"
#import "CDXCardDeckCardViewController.h"
#import "CDXCardDeckCardEditViewController.h"
#import "CDXSettingsViewController.h"
#import "CDXImageFactory.h"


@implementation CDXCardDeckListViewController

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)aCardDeckViewContext {
    if ((self = [super initWithNibName:@"CDXCardDeckListView" bundle:nil titleText:aCardDeckViewContext.cardDeck.name backButtonText:@"Cards"])) {
        ivar_assign_and_retain(cardDeckViewContext, aCardDeckViewContext);
        ivar_assign_and_retain(cardDeck, aCardDeckViewContext.cardDeck);
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(cardDeckViewContext);
    ivar_release_and_clear(cardDeck);
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = cardDeckViewContext.cardDeck.name;
    if ([viewTableView numberOfRowsInSection:1] != 0) {
        [viewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cardDeckViewContext.currentCardIndex inSection:1] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        default:
        case 0:
            return 0;
        case 1:
            return [cardDeck cardsCount];
        case 2:
            return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifierSection1 = @"Section1Cell";
    static NSString *reuseIdentifierSection2 = @"Section2Cell";
    switch (indexPath.section) {
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
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            
            CDXCard *card = [cardDeck cardAtIndex:indexPath.row];
            cell.textLabel.text = card.text;
            cell.imageView.image = [[CDXImageFactory sharedImageFactory] imageForThumbnailCard:card size:tableCellImageSize];
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSection2];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierSection2] autorelease];
                cell.textLabel.font = tableCellTextFontAction;
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            
            cell.textLabel.textColor = self.editing ? tableCellTextTextColorActionInactive : tableCellTextTextColorAction;
            switch (indexPath.row) {
                default:
                case 0: {
                    cell.textLabel.text = @"TAP HERE TO ADD A CARD";
                    break;
                }
                case 1: {
                    cell.textLabel.text = @"TAP HERE TO CONFIGURE CARD DEFAULTS";
                    break;
                }
            }
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        default:
        case 0: {
            break;
        }
        case 1: {
            cardDeckViewContext.currentCardIndex = indexPath.row;
            CDXCardDeckCardViewController *vc = [[[CDXCardDeckCardViewController alloc] initWithCardDeckViewContext:cardDeckViewContext] autorelease];
            [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    cardDeckViewContext.currentCardIndex = indexPath.row;
    CDXCardDeckCardEditViewController *vc = [[[CDXCardDeckCardEditViewController alloc] initWithCardDeckViewContext:cardDeckViewContext] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [cardDeck removeCardAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    qltrace();
    CDXCard *card = [cardDeck cardAtIndex:fromIndexPath.row];
    [card retain];
    [cardDeck removeCardAtIndex:fromIndexPath.row];
    [cardDeck insertCard:card atIndex:toIndexPath.row];
    [card release];
}

- (IBAction)addButtonPressed {
    qltrace();
    CDXCard *card = [cardDeck cardWithDefaults];
    [cardDeck addCard:card];
    cardDeckViewContext.currentCardIndex = [cardDeck cardsCount]-1;
    NSIndexPath *path = [NSIndexPath indexPathForRow:cardDeckViewContext.currentCardIndex inSection:1];
    [viewTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [viewTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [viewTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    [viewTableView deselectRowAtIndexPath:path animated:YES];
    [self setEditing:NO animated:YES];
}

- (IBAction)defaultsButtonPressed {
    qltrace();
    cardDeckViewContext.currentCardIndex = [cardDeck cardsCount]-1;
    CDXCardDeck *deck = [[[CDXCardDeck alloc] init] autorelease];
    [deck addCard:cardDeck.cardDefaults];
    CDXCardDeckViewContext *context = [[[CDXCardDeckViewContext alloc] initWithCardDeck:deck] autorelease];
    CDXCardDeckCardEditViewController *vc = [[[CDXCardDeckCardEditViewController alloc] initWithCardDeckViewContext:context] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
}

- (IBAction)settingsButtonPressed {
    qltrace();
    CDXCardDeckSettings *settings = [[[CDXCardDeckSettings alloc] initWithCardDeck:cardDeck] autorelease];
    CDXSettingsViewController *vc = [[[CDXSettingsViewController alloc] initWithSettings:settings] autorelease];
    [self presentModalViewController:vc animated:YES];
}

@end

