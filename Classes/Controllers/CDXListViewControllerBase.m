//
//
// CDXListViewControllerBase.m
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
    ivar_release_and_clear(tableCellBackgroundImage);
    ivar_release_and_clear(tableCellBackgroundImageAlt);
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
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = titleText;
    navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc]
                                         initWithTitle:backButtonText
                                         style:UIBarButtonItemStylePlain
                                         target:nil
                                         action:nil]
                                        autorelease];
    
    ivar_assign(activityIndicator, [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]);
    activityIndicator.hidesWhenStopped = YES;
    if ([[CDXDevice sharedDevice] deviceUIIdiom] == CDXDeviceUIIdiomPad) {
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                          initWithCustomView:activityIndicator]
                                         autorelease];
    self.toolbarItems = viewToolbar.items;
    ivar_assign_and_retain(tableCellTextFont, [UIFont boldSystemFontOfSize:18]);
    ivar_assign_and_retain(tableCellTextFontAction, [UIFont boldSystemFontOfSize:11]);
    ivar_assign_and_retain(tableCellTextTextColor, [UIColor blackColor]);
    ivar_assign_and_retain(tableCellTextTextColorNoCards, [UIColor grayColor]);
    ivar_assign_and_retain(tableCellTextTextColorAction, [UIColor grayColor]);
    ivar_assign_and_retain(tableCellTextTextColorActionInactive, [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]);
    ivar_assign_and_retain(tableCellDetailTextFont, [UIFont systemFontOfSize:10]);
    ivar_assign_and_retain(tableCellDetailTextTextColor, [UIColor grayColor]);
    CGFloat rowHeight = viewTableView.rowHeight;
    BOOL useReducedGraphicsEffects = [[CDXDevice sharedDevice] useReducedGraphicsEffects];
    CGFloat base = useReducedGraphicsEffects ? 1.0 : 0.75;
    if (!useReducedGraphicsEffects) {
        ivar_assign_and_retain(tableCellBackgroundImage, [[CDXImageFactory sharedImageFactory] imageForLinearGradientWithTopColor:[CDXColor colorWhite] bottomColor:[CDXColor colorWithRed:0xf8 green:0xf8 blue:0xf8 alpha:0xff] height:rowHeight base:base]);
    }
    ivar_assign_and_retain(tableCellBackgroundImageAlt, [[CDXImageFactory sharedImageFactory] imageForLinearGradientWithTopColor:[CDXColor colorWithRed:0xf0 green:0xf0 blue:0xf0 alpha:0xff] bottomColor:[CDXColor colorWithRed:0xe8 green:0xe8 blue:0xe8 alpha:0xff] height:rowHeight base:base]);
    tableCellImageSize = CGSizeMake(10, 10);
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    viewTableView.backgroundView = [[[UIImageView alloc] initWithImage:[[CDXImageFactory sharedImageFactory] imageForLinearGradientWithTopColor:[CDXColor colorWhite] bottomColor:[CDXColor colorWithRed:0xf8 green:0xf8 blue:0xf8 alpha:0xff] height:screenHeight base:0.0]] autorelease];
}

- (void)viewDidUnload {
    qltrace();
    [self detachViewObjects];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    qltrace();
    [super viewWillAppear:animated];
    [self performBlockingSelectorEnd];
    [viewTableView reloadData];
    [self updateToolbarButtons];
    viewTableView.contentOffset = CGPointMake(0, MAX(0, viewTableViewContentOffsetY));
}

- (void)viewWillDisappear:(BOOL)animated {
    qltrace();
    [super viewWillDisappear:animated];
    [self performBlockingSelectorEnd];
    viewTableViewContentOffsetY = viewTableView.contentOffset.y;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if ([self isEditing] == editing) {
        return;
    }
    [super setEditing:editing animated:animated];
    [viewTableView setEditing:editing animated:animated];
    [viewTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [viewTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
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

#pragma mark -
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath  marked:(BOOL)marked {
    UIColor *clearColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = clearColor;
    cell.detailTextLabel.backgroundColor = clearColor;
    cell.backgroundColor = clearColor;
    cell.backgroundView = [[[UIImageView alloc] initWithImage:marked ? tableCellBackgroundImageAlt : tableCellBackgroundImage] autorelease];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath marked:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSection:(NSUInteger)section {
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
    return NO;
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

@end

