//
//
// CDXListViewControllerBase.h
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

#import "CDXAppWindowProtocols.h"


typedef enum {
    CDXListViewControllerBasePerformActionStateNone = 0,
    CDXListViewControllerBasePerformActionStateTableView,
    CDXListViewControllerBasePerformActionStateToolbar
} CDXListViewControllerBasePerformActionState;

typedef NS_OPTIONS(NSInteger, CDXTableViewCellTag) {
    CDXTableViewCellTagMarked = 1 << 0,
    CDXTableViewCellTagAltGroup = 1 << 1,
    CDXTableViewCellTagNewObject = 1 << 2,
    CDXTableViewCellTagNone = 0
};

@interface CDXListViewControllerBase : UIViewController<CDXAppWindowViewController> {
    
@protected
    IBOutlet UITableView *viewTableView;
    IBOutlet UIToolbar *viewToolbar;
    CGFloat viewTableViewContentOffsetY;
    BOOL keepViewTableViewContentOffsetY;
    IBOutlet UIBarButtonItem *editButton;
    IBOutlet UIBarButtonItem *settingsButton;
    
    UIActivityIndicatorView *activityIndicator;
    
    UIColor *tableCellTextTextColor;
    UIColor *tableCellTextTextColorNoCards;
    UIColor *tableCellTextTextColorAction;
    UIColor *tableCellTextTextColorActionInactive;
    UIColor *tableCellDetailTextTextColor;
    UIColor *tableCellBackgroundColor;
    UIColor *tableCellBackgroundColorAltGroup;
    UIColor *tableCellBackgroundColorMarked;
    UIColor *tableCellBackgroundColorNewObject;
    UIColor *tableCellBackgroundColorNewObjectAltGroup;
    CGSize tableCellImageSize;
    
    NSString *titleText;
    NSString *backButtonText;
    
    NSString *reuseIdentifierSection1;
    NSString *reuseIdentifierSection2;
    
    UILongPressGestureRecognizer *viewTableViewLongPressRecognizer;
    UILongPressGestureRecognizer *viewToolbarLongPressRecognizer;
    UITapGestureRecognizer *viewTableViewTapRecognizer;
    CDXListViewControllerBasePerformActionState performActionState;
    NSIndexPath *performActionTableViewIndexPath;
    UIBarButtonItem *performActionToolbarBarButtonItem;
    
    CGPoint currentTouchLocationInWindow;
    NSUInteger currentTag;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil titleText:(NSString*)titleText backButtonText:(NSString *)backButtonText;

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSection:(NSUInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)performAction:(SEL)action withSender:(id)sender tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender barButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)performAction:(SEL)action withSender:(id)sender barButtonItem:(UIBarButtonItem *)barButtonItem;

- (void)menu:(UIMenuController *)menuController itemsForTableView:(UITableView *)tableView cell:(UITableViewCell *)cell;
- (void)menu:(UIMenuController *)menuController itemsForBarButtonItem:(UIBarButtonItem *)barButtonItem;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
- (void)updateToolbarButtons;

- (IBAction)editButtonPressed;

- (void)performBlockingSelector:(SEL)selector withObject:(NSObject *)object;
- (void)performBlockingSelectorEnd;

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

