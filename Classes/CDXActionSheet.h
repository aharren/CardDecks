//
//
// CDXActionSheet.h
//
//
// Copyright (c) 2009-2015 Arne Harren <ah@0xc0.de>
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

#import "CDXActionSheetProtocols.h"


@interface CDXActionSheet : NSObject<UIActionSheetDelegate> {

@protected
    UIAlertController *alertController;
    UIActionSheet *actionSheet;
    NSInteger tag;
    NSInteger buttonIndexBase;
    id<CDXActionSheetDelegate> delegate;
    BOOL visible;
}

@property(nonatomic) NSInteger tag;
@property(nonatomic) NSInteger buttonIndexBase;
@property(nonatomic, assign) id delegate;
@property(nonatomic, getter=isVisible) BOOL visible;

- (void)presentWithViewController:(UIViewController *)viewController fromBarButtonItem:(UIBarButtonItem *)barButtomItem animated:(BOOL)animated;
- (void)presentWithViewController:(UIViewController *)viewController view:(UIView *)view animated:(BOOL)animated;
- (void)dismissActionSheetAnimated:(BOOL)animated;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

+ (CDXActionSheet *)actionSheetWithTitle:(NSString *)title tag:(NSInteger)tag delegate:(id<CDXActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

@end

