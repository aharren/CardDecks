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


@implementation CDXCardDeckListViewController

- (id)initWithCardDeck:(CDXCardDeck *)deck {
    if ((self = [super initWithNibName:@"CDXCardDeckListView" bundle:nil])) {
        ivar_assign_and_retain(cardDeck, deck);
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(cardDeckTableView);
    ivar_release_and_clear(cardDeck);
    ivar_release_and_clear(viewToolbar);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = cardDeck.name;
    self.toolbarItems = viewToolbar.items;
}

- (void)viewDidUnload {
    ivar_release_and_clear(cardDeckTableView);
    ivar_release_and_clear(viewToolbar);
    [super viewDidUnload];
}

- (void)setUserInteractionEnabled:(BOOL)enabled {
}

- (void)deviceOrientationDidChange:(UIDeviceOrientation)orientation {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cardDeck cardsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    CDXCard *card = [cardDeck cardAtIndex:indexPath.row];
    cell.textLabel.text = card.text;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CDXCardDeckCardViewController *vc = [[[CDXCardDeckCardViewController alloc] initWithCardDeck:cardDeck atIndex:indexPath.row] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return editMode == CDXCardDeckListViewControllerEditModeReorder;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editMode == CDXCardDeckListViewControllerEditModeDelete) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return editMode == CDXCardDeckListViewControllerEditModeDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editMode == CDXCardDeckListViewControllerEditModeDelete) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [cardDeck removeCardAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
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
}

- (IBAction)deleteButtonPressed {
    qltrace();
    if (editMode == CDXCardDeckListViewControllerEditModeDelete) {
        editMode = CDXCardDeckListViewControllerEditModeNone;
        [self setEditing:NO animated:NO];
        [cardDeckTableView setEditing:NO animated:YES];
    } else {
        if (editMode != CDXCardDeckListViewControllerEditModeNone) {
            editMode = CDXCardDeckListViewControllerEditModeNone;
            [self setEditing:NO animated:NO];
            [cardDeckTableView setEditing:NO animated:YES];
            [self performSelector:@selector(deleteButtonPressed) withObject:nil afterDelay:0.4];
        } else {
            editMode = CDXCardDeckListViewControllerEditModeDelete;
            [self setEditing:YES animated:NO];
            [cardDeckTableView setEditing:YES animated:YES];
        }
    }
}

- (IBAction)reorderButtonPressed {
    qltrace();
    if (editMode == CDXCardDeckListViewControllerEditModeReorder) {
        editMode = CDXCardDeckListViewControllerEditModeNone;
        [self setEditing:NO animated:NO];
        [cardDeckTableView setEditing:NO animated:YES];
    } else {
        if (editMode != CDXCardDeckListViewControllerEditModeNone) {
            editMode = CDXCardDeckListViewControllerEditModeNone;
            [self setEditing:NO animated:NO];
            [cardDeckTableView setEditing:NO animated:YES];
            [self performSelector:@selector(reorderButtonPressed) withObject:nil afterDelay:0.4];
        } else {
            editMode = CDXCardDeckListViewControllerEditModeReorder;
            [self setEditing:YES animated:NO];
            [cardDeckTableView setEditing:YES animated:YES];
        }
    }
}

@end

