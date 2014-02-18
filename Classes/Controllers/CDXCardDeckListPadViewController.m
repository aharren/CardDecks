//
//
// CDXCardDeckListPadViewController.m
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

#import "CDXCardDeckListPadViewController.h"
#import "CDXCardDeckCardViewController.h"
#import "CDXCardDeckListViewController.h"
#import "CDXCardDeckCardEditPadViewController.h"
#import "CDXImageFactory.h"
#import "CDXAppSettings.h"
#import "CDXSettingsViewController.h"
#import "CDXCardDecks.h"
#import <QuartzCore/QuartzCore.h>

#undef ql_component
#define ql_component lcl_cController


@implementation CDXCardDeckListPadViewController

- (id)initWithCardDeckViewContext:(CDXCardDeckViewContext *)aCardDeckViewContext {
    if ((self = [super initWithCardDeckViewContext:aCardDeckViewContext nibName:@"CDXCardDeckListPadView" bundle:nil])) {
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(viewTableViewContainer);
    ivar_release_and_clear(navigationItem);
    ivar_release_and_clear(viewNoTableView);
    [super dealloc];
}

- (void)viewDidLoad {
    qltrace();
    [super viewDidLoad];
    
    viewTableView.hidden = cardDeck == nil;
    viewNoTableView.hidden = !viewTableView.hidden;
}

- (void)viewDidUnload {
    qltrace();
    ivar_release_and_clear(viewTableViewContainer);
    ivar_release_and_clear(navigationItem);
    ivar_release_and_clear(viewNoTableView);
    ivar_release_and_clear(tableCellBackgroundImage);
    ivar_release_and_clear(tableCellBackgroundImageAlt);
    [super viewDidUnload];
}

- (void)updateNotificationForCardDeck:(id)object {
    qltrace();
    if (!ignoreCardDeckUpdateNotifications) {
        [viewTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        self.navigationItem.title = cardDeck.name;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    qltrace();
    settingsButton.enabled = YES;
    actionButton.enabled = YES;
    shuffleButton.enabled = YES;
    editButton.enabled = YES;
    addButton.enabled = YES;
    [super viewWillAppear:animated];
    if (!viewNoTableView.hidden) {
        settingsButton.enabled = NO;
        actionButton.enabled = NO;
        shuffleButton.enabled = NO;
        editButton.enabled = NO;
        addButton.enabled = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    qltrace();
    [super viewDidAppear:animated];
    ignoreCardDeckUpdateNotifications = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationForCardDeck:) name:CDXCardDeckUpdateNotification object:cardDeck];
    ignoreCardDeckUpdateNotifications = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    qltrace();
    ignoreCardDeckUpdateNotifications = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
    [CDXStorage drainAllDeferredActions];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ignoreCardDeckUpdateNotifications = YES;
    [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    ignoreCardDeckUpdateNotifications = NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    ignoreCardDeckUpdateNotifications = YES;
    [super tableView:tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    ignoreCardDeckUpdateNotifications = NO;
}

- (void)processCardAddAtBottomDelayed:(NSArray *)cards {
    ignoreCardDeckUpdateNotifications = YES;
    [super processCardAddAtBottomDelayed:cards];
    ignoreCardDeckUpdateNotifications = NO;
}

- (void)pushCardDeckEditViewController {
    CDXCardDeckCardEditPadViewController *vc = [[[CDXCardDeckCardEditPadViewController alloc] initWithCardDeckViewContext:cardDeckViewContext editDefaults:NO] autorelease];
    UINavigationController *nvc = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] presentModalViewController:nvc animated:YES];
    [self performBlockingSelectorEnd];
}

- (void)pushCardDeckEditViewControllerForDefaults {
    CDXCardDeckCardEditPadViewController *vc = [[[CDXCardDeckCardEditPadViewController alloc] initWithCardDeckViewContext:cardDeckViewContext editDefaults:YES] autorelease];
    UINavigationController *nvc = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [[CDXAppWindowManager sharedAppWindowManager] presentModalViewController:nvc animated:YES];
    [self performBlockingSelectorEnd];
}

- (void)performAction:(SEL)action withSender:(id)sender tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    ignoreCardDeckUpdateNotifications = YES;
    [super performAction:action withSender:sender tableView:tableView indexPath:indexPath];
    ignoreCardDeckUpdateNotifications = NO;
}

- (IBAction)actionButtonPressed {
    CDXCardDeckListViewControllerTextActivityItemProvider *textItem = [[[CDXCardDeckListViewControllerTextActivityItemProvider alloc] initWithCardDeckViewContext:cardDeckViewContext] autorelease];
    CDXCardDeckListViewControllerURLActivityItemProvider *urlItem = [[[CDXCardDeckListViewControllerURLActivityItemProvider alloc]  initWithCardDeckViewContext:cardDeckViewContext] autorelease];
    
    NSArray *items = @[textItem, urlItem];
    NSArray *activities = nil;
    
    UIActivityViewController *vc = [[[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:activities] autorelease];
    
    [[CDXAppWindowManager sharedAppWindowManager] presentModalViewController:vc fromBarButtonItem:actionButton animated:YES];
}

@end

