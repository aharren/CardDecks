//
//
// CDXListViewControllerBase.m
//
//
// Copyright (c) 2009-2021 Arne Harren <ah@0xc0.de>
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

#import "CDXListViewControllerBase.h"
#import "CDXDevice.h"
#import "CDXImageFactory.h"

#undef ql_component
#define ql_component lcl_cController


@implementation CDXListViewControllerBase

#pragma mark -
#pragma mark Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil titleText:(NSString*)aTitleText backButtonText:(NSString *)aBackButtonText {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        ivar_assign_and_copy(titleText, aTitleText);
        ivar_assign_and_copy(backButtonText, aBackButtonText);
        ivar_assign_and_retain(reuseIdentifierSection1, @"Section1Cell");
        ivar_assign_and_retain(reuseIdentifierSection2, @"Section2Cell");
        performActionState = CDXListViewControllerBasePerformActionStateNone;
        currentTag = 1;
    }
    return self;
}

- (void)detachViewObjects {
    qltrace();
    ivar_release_and_clear(viewTableView);
    ivar_release_and_clear(viewToolbar);
    ivar_release_and_clear(editButton);
    ivar_release_and_clear(settingsButton);
    ivar_release_and_clear(activityIndicator);
    ivar_release_and_clear(tableCellTextFont);
    ivar_release_and_clear(tableCellTextFontAction);
    ivar_release_and_clear(tableCellTextTextColor);
    ivar_release_and_clear(tableCellTextTextColorNoCards);
    ivar_release_and_clear(tableCellTextTextColorAction);
    ivar_release_and_clear(tableCellTextTextColorActionInactive);
    ivar_release_and_clear(tableCellDetailTextFont);
    ivar_release_and_clear(tableCellDetailTextTextColor);
    ivar_release_and_clear(tableCellBackgroundColor);
    ivar_release_and_clear(tableCellBackgroundColorMarked);
    ivar_release_and_clear(tableCellBackgroundColorAltGroup);
    ivar_release_and_clear(tableCellBackgroundColorNewObject);
    ivar_release_and_clear(tableCellBackgroundColorNewObjectAltGroup);
    ivar_release_and_clear(viewTableViewLongPressRecognizer);
    ivar_release_and_clear(viewToolbarLongPressRecognizer);
    ivar_release_and_clear(viewTableViewTapRecognizer);
    ivar_release_and_clear(performActionTableViewIndexPath);
    ivar_release_and_clear(performActionToolbarBarButtonItem);
}

- (void)dealloc {
    qltrace();
    [self detachViewObjects];
    ivar_release_and_clear(titleText);
    ivar_release_and_clear(backButtonText);
    ivar_release_and_clear(reuseIdentifierSection1);
    ivar_release_and_clear(reuseIdentifierSection2);
    [super dealloc];
}

#pragma mark -
#pragma mark View

- (void)viewDidLoad {
    qltrace();
    [super viewDidLoad];
    keepViewTableViewContentOffsetY = NO;

    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = titleText;
    navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc]
                                         initWithTitle:backButtonText
                                         style:UIBarButtonItemStylePlain
                                         target:nil
                                         action:nil]
                                        autorelease];
    
    ivar_assign(activityIndicator, [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium]);
    activityIndicator.hidesWhenStopped = YES;
    navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                          initWithCustomView:activityIndicator]
                                         autorelease];
    self.toolbarItems = viewToolbar.items;
    ivar_assign_and_retain(tableCellTextFont, [UIFont systemFontOfSize:17]);
    ivar_assign_and_retain(tableCellTextFontAction, [UIFont systemFontOfSize:10]);
    ivar_assign_and_retain(tableCellTextTextColor, [UIColor labelColor]);
    ivar_assign_and_retain(tableCellTextTextColorNoCards, [UIColor systemGray2Color]);
    ivar_assign_and_retain(tableCellTextTextColorAction, [UIColor systemGray2Color]);
    ivar_assign_and_retain(tableCellTextTextColorActionInactive, [UIColor systemGray5Color]);
    ivar_assign_and_retain(tableCellDetailTextFont, [UIFont systemFontOfSize:9]);
    ivar_assign_and_retain(tableCellDetailTextTextColor, [UIColor secondaryLabelColor]);
    ivar_assign_and_retain(tableCellBackgroundColor, [UIColor systemBackgroundColor]);
    ivar_assign_and_retain(tableCellBackgroundColorMarked, [UIColor systemGray4Color]);
    ivar_assign_and_retain(tableCellBackgroundColorAltGroup, [UIColor systemGray6Color]);
    ivar_assign_and_retain(tableCellBackgroundColorNewObject, [UIColor systemGray5Color]);
    ivar_assign_and_retain(tableCellBackgroundColorNewObjectAltGroup, [UIColor systemGray4Color]);
    tableCellImageSize = CGSizeMake(5, 51);
    
    ivar_assign(viewTableViewLongPressRecognizer, [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(handleTableViewLongPressGesture:)]);
    ivar_assign(viewToolbarLongPressRecognizer, [[UILongPressGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(handleToolbarLongPressGesture:)]);
    ivar_assign(viewTableViewTapRecognizer, [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleTableViewTapGesture:)]);
}

- (void)viewWillAppear:(BOOL)animated {
    qltrace();
    [super viewWillAppear:animated];
    [self performBlockingSelectorEnd];
    [viewTableView reloadData];
    [self updateToolbarButtons];
    if (keepViewTableViewContentOffsetY) {
        viewTableView.contentOffset = CGPointMake(0, viewTableViewContentOffsetY);
    }
    keepViewTableViewContentOffsetY = NO;
    performActionState = CDXListViewControllerBasePerformActionStateNone;
    ivar_release_and_clear(performActionTableViewIndexPath);
    ivar_release_and_clear(performActionToolbarBarButtonItem);
    [viewTableView addGestureRecognizer:viewTableViewLongPressRecognizer];
    [self.navigationController.toolbar addGestureRecognizer:viewToolbarLongPressRecognizer];
    [viewTableView addGestureRecognizer:viewTableViewTapRecognizer];
    
    if ([CDXDevice sharedDevice].useLargeTitles) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationController.navigationBar.largeTitleTextAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:23]};
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    }

    ++currentTag;
}

- (void)viewWillDisappear:(BOOL)animated {
    qltrace();
    [super viewWillDisappear:animated];
    if (keepViewTableViewContentOffsetY) {
        viewTableViewContentOffsetY = viewTableView.contentOffset.y;
    }
    [self performBlockingSelectorEnd];
    [viewTableView removeGestureRecognizer:viewTableViewLongPressRecognizer];
    [self.navigationController.toolbar removeGestureRecognizer:viewToolbarLongPressRecognizer];
    [viewTableView removeGestureRecognizer:viewTableViewTapRecognizer];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if ([self isEditing] == editing) {
        return;
    }

    [viewTableView reloadData];

    [viewTableView beginUpdates];
    [super setEditing:editing animated:animated];
    [viewTableView setEditing:editing animated:animated];
    [viewTableView endUpdates];

    if (editing) {
        [viewTableView removeGestureRecognizer:viewTableViewLongPressRecognizer];
        [viewTableView removeGestureRecognizer:viewTableViewTapRecognizer];
    } else {
        [viewTableView addGestureRecognizer:viewTableViewLongPressRecognizer];
        [viewTableView addGestureRecognizer:viewTableViewTapRecognizer];
    }
}

- (void)updateToolbarButtons {
    editButton.enabled = ([self tableView:viewTableView numberOfRowsInSection:1] != 0);
}

#pragma mark -
#pragma mark WindowView

- (void)setUserInteractionEnabled:(BOOL)enabled {
}

- (void)deviceOrientationDidChange:(UIDeviceOrientation)orientation {
}

- (void)menuControllerWillHideMenu {
    if (performActionState == CDXListViewControllerBasePerformActionStateTableView) {
        UITableViewCell *cell = [viewTableView cellForRowAtIndexPath:performActionTableViewIndexPath];
        cell.selected = NO;
    }
    performActionState = CDXListViewControllerBasePerformActionStateNone;
    ivar_release_and_clear(performActionTableViewIndexPath);
    ivar_release_and_clear(performActionToolbarBarButtonItem);
}

#pragma mark -
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tag = cell.tag;
    UIColor *backgroundColor = tableCellBackgroundColor;
    if (tag & CDXTableViewCellTagMarked) {
        backgroundColor = tableCellBackgroundColorMarked;
    } else if (tag & CDXTableViewCellTagNewObject) {
        if (tag & CDXTableViewCellTagAltGroup) {
            backgroundColor = tableCellBackgroundColorNewObjectAltGroup;
        } else {
            backgroundColor = tableCellBackgroundColorNewObject;
        }
    } else if (tag & CDXTableViewCellTagAltGroup) {
        backgroundColor = tableCellBackgroundColorAltGroup;
    }
    cell.backgroundColor = backgroundColor;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSection:(NSUInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.editing ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    qltrace();
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    qltrace();
}

#pragma mark -
#pragma mark Gesture

- (void)handleTableViewLongPressGesture:(UILongPressGestureRecognizer *)sender {
    qltrace(@"%@", sender);
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [viewTableView indexPathForRowAtPoint:[sender locationInView:viewTableView]];
        UITableViewCell *cell = [viewTableView cellForRowAtIndexPath:indexPath];
        // ignore gesture if not inside the cell content
        if (cell.accessoryType == UITableViewCellAccessoryDetailDisclosureButton) {
            if (cell.frame.origin.x + cell.frame.size.width - 44 < [sender locationInView:cell].x) {
                return;
            }
        }
        // ignore gesture if not in section 1
        if (indexPath.section != 1) {
            return;
        }
        
        // keep state
        performActionState = CDXListViewControllerBasePerformActionStateTableView;
        ivar_assign_and_retain(performActionTableViewIndexPath, indexPath);
        
        // show menu
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        // add additional menu items, defined by subclass
        [self menu:menu itemsForTableView:viewTableView cell:cell];
        // show
        [menu showMenuFromView:sender.view rect:cell.frame];

        // keep cell selected
        cell.selected = YES;
    }
}

- (void)handleToolbarLongPressGesture:(UILongPressGestureRecognizer *)sender {
    qltrace(@"%@", sender);
    if (sender.state == UIGestureRecognizerStateBegan) {
        // find the control which was touched
        CGPoint point = [sender locationInView:sender.view];
        qltrace("%f %f %@", point.x, point.y, sender.view);

        // calculate total fixed width and width of flexible elements
        CGFloat totalFixedWidth = 0;
        NSUInteger countFlexibleWidthElements = 0;
        for (UIBarButtonItem *item in [viewToolbar items]) {
            if (item.tag != 0) {
                totalFixedWidth += 44;
            } else {
                if (item.width != 0) {
                    totalFixedWidth += item.width;
                } else {
                    countFlexibleWidthElements++;
                }
            }
        }
        CGFloat singleFlexibleWidth = (sender.view.frame.size.width - totalFixedWidth) / countFlexibleWidthElements;

        // find touched button
        CGFloat left = 0;
        CGFloat touchArea = 10.0;
        for (UIBarButtonItem *item in [viewToolbar items]) {
            CGFloat width = 0;
            if (item.tag != 0) {
                width = 44;
            } else {
                if (item.width != 0) {
                    width = item.width;
                } else {
                    width = singleFlexibleWidth;
                }
            }

            if (item.tag != 0 && point.x >= left - touchArea && point.x <= left + width + touchArea) {
                if (!item.isEnabled) {
                    // skip item if not enabled
                    qltrace(@"item %@ is not enabled", item);
                    return;
                }

                // keep state
                performActionState = CDXListViewControllerBasePerformActionStateToolbar;
                ivar_assign_and_retain(performActionToolbarBarButtonItem, item);

                // show menu
                [self becomeFirstResponder];
                UIMenuController *menu = [UIMenuController sharedMenuController];
                // add additional menu items, defined by subclass
                [self menu:menu itemsForBarButtonItem:item];
                // show
                [menu showMenuFromView:sender.view rect:CGRectMake(left, 0, width, 1)];

                return;
            }

            left += width;
        }
    }
}

- (void)menu:(UIMenuController *)menuController itemsForTableView:(UITableView *)tableView cell:(UITableViewCell *)cell {
}

- (void)menu:(UIMenuController *)menuController itemsForBarButtonItem:(UIBarButtonItem *)barButtonItem {
}

- (void)handleTableViewTapGesture:(UITapGestureRecognizer *)sender {
    qltrace(@"%@", sender);
    currentTouchLocationInWindow = [sender locationInView:self.view];
    qltrace(@"location %f %f", currentTouchLocationInWindow.x, currentTouchLocationInWindow.y);

    NSIndexPath *indexPath = [viewTableView indexPathForRowAtPoint:[sender locationInView:viewTableView]];
    UITableViewCell *cell = [viewTableView cellForRowAtIndexPath:indexPath];
    
    if (sender.state == UIGestureRecognizerStateRecognized) {
        cell.selected = YES;
        
        if (cell.accessoryType == UITableViewCellAccessoryDetailDisclosureButton) {
            if (cell.frame.origin.x + cell.frame.size.width - 44 < [sender locationInView:cell].x) {
                [self tableView:viewTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
                return;
            }
        }
        
        [self tableView:viewTableView didSelectRowAtIndexPath:indexPath];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    qltrace();
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender barButtonItem:(UIBarButtonItem *)barButtonItem {
    qltrace();
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    qltrace(@"%@", sender);
    // dispatch to specialized canPerformAction method of sub-class
    if (performActionState == CDXListViewControllerBasePerformActionStateTableView) {
        if (performActionTableViewIndexPath != nil) {
            return [self canPerformAction:action withSender:sender tableView:viewTableView indexPath:performActionTableViewIndexPath];
        } else {
            return NO;
        }
    } else if (performActionState == CDXListViewControllerBasePerformActionStateToolbar) {
        if (performActionToolbarBarButtonItem != nil) {
            return [self canPerformAction:action withSender:sender barButtonItem:performActionToolbarBarButtonItem];
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)performAction:(SEL)action withSender:(id)sender tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    qltrace();
}

- (void)performAction:(SEL)action withSender:(id)sender barButtonItem:(UIBarButtonItem *)barButtonItem {
    qltrace();
}

- (void)copy:(id)sender {
    qltrace(@"%@", sender);
    // dispatch to specialized performAction method of sub-class
    if (performActionState == CDXListViewControllerBasePerformActionStateTableView) {
        if (performActionTableViewIndexPath != nil) {
            [self performAction:@selector(copy:) withSender:sender tableView:viewTableView indexPath:performActionTableViewIndexPath];
            return;
        }
    } else if (performActionState == CDXListViewControllerBasePerformActionStateToolbar) {
        if (performActionToolbarBarButtonItem != nil) {
            [self performAction:@selector(copy:) withSender:sender barButtonItem:performActionToolbarBarButtonItem];
            return;
        }
    }
}

- (void)paste:(id)sender {
    qltrace(@"%@", sender);
    // dispatch to specialized performAction method of sub-class
    if (performActionState == CDXListViewControllerBasePerformActionStateTableView) {
        if (performActionTableViewIndexPath != nil) {
            [self performAction:@selector(paste:) withSender:sender tableView:viewTableView indexPath:performActionTableViewIndexPath];
            return;
        }
    } else if (performActionState == CDXListViewControllerBasePerformActionStateToolbar) {
        if (performActionToolbarBarButtonItem != nil) {
            [self performAction:@selector(paste:) withSender:sender barButtonItem:performActionToolbarBarButtonItem];
            return;
        }
    }
}

#pragma mark -
#pragma mark Action

- (IBAction)editButtonPressed {
    qltrace();
    [self setEditing:!self.editing animated:YES];
}

#pragma mark -
#pragma mark Blocking

- (void)performBlockingSelector:(SEL)selector withObject:(NSObject *)object {
    [self setUserInteractionEnabled:NO];
    [activityIndicator startAnimating];
    [self performSelector:selector withObject:object afterDelay:0.001];
}

- (void)performBlockingSelectorEnd {
    [self setUserInteractionEnabled:YES];
    [activityIndicator stopAnimating];
}

#pragma mark -
#pragma mark Appearance

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [viewTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

@end

