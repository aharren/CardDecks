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
    ivar_release_and_clear(tableCellBackgroundImage);
    [super dealloc];
}

- (void)viewDidLoad {
    qltrace();
    [super viewDidLoad];
    
    viewTableViewContainer.layer.cornerRadius = 6;
    viewTableView.backgroundView = [[[UIImageView alloc] initWithImage:[[CDXImageFactory sharedImageFactory] imageForLinearGradientWithTopColor:[CDXColor colorWhite] bottomColor:[CDXColor colorWithRed:0xf0 green:0xf0 blue:0xf0 alpha:0xff] height:1024]] autorelease];
    
    ivar_assign_and_retain(tableCellBackgroundImage, [[CDXImageFactory sharedImageFactory] imageForLinearGradientWithTopColor:[CDXColor colorWhite] bottomColor:[CDXColor colorWithRed:0xf9 green:0xf9 blue:0xf9 alpha:0xff] height:44]);
    ivar_assign_and_retain(tableCellBackgroundColorAction, [UIColor clearColor]);
}

- (void)viewDidUnload {
    qltrace();
    ivar_release_and_clear(viewTableViewContainer);
    ivar_release_and_clear(tableCellBackgroundImage);
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    cardDeckQuickOpen = NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    UIColor *clearColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = clearColor;
    cell.detailTextLabel.backgroundColor = clearColor;
    cell.backgroundColor = clearColor;
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
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            cell.textLabel.textColor = self.editing ? tableCellTextTextColorActionInactive : tableCellTextTextColorAction;
            return cell;
        }
        default:
            return nil;
    }
}

- (void)pushCardDeckListViewControllerWithCardDeckBase:(CDXCardDeckBase *)deckBase {
    if (deckBase == nil) {
        return;
    }
    
    CDXCardDeck *deck = deckBase.cardDeck;
    if (deck != nil) {
        CDXCardDeckViewContext *context = [[[CDXCardDeckViewContext alloc] initWithCardDeck:deck cardDecks:cardDecks] autorelease];
        CDXCardDeckListPadViewController *vc = [[[CDXCardDeckListPadViewController alloc] initWithCardDeckViewContext:context] autorelease];
        [[CDXAppWindowManager sharedAppWindowManager] pushViewController:vc animated:YES];
    }
    NSIndexPath *indexPath = [viewTableView indexPathForSelectedRow];
    [viewTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performBlockingSelectorEnd];
}

@end

