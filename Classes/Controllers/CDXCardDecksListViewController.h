//
//
// CDXCardDecksListViewController.h
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

#import "CDXCardDecks.h"
#import "CDXAppWindowProtocols.h"


@interface CDXCardDecksListViewController : UIViewController<CDXAppWindowViewController> {
    
@protected
    IBOutlet UITableView *cardDecksTableView;
    CDXCardDecks *cardDecks;
    
    IBOutlet UIToolbar *viewToolbar;
    
    UIFont *tableCellTextFont;
    UIFont *tableCellTextFontAction;
    UIColor *tableCellTextTextColor;
    UIColor *tableCellTextTextColorNoCards;
    UIColor *tableCellTextTextColorAction;
    UIFont *tableCellDetailTextFont;
    UIColor *tableCellDetailTextTextColor;
    UIColor *tableCellBackgroundColorAction;
    CGSize tableCellImageSize;
}

- (id)initWithCardDecks:(CDXCardDecks *)cardDecks;

- (IBAction)addButtonPressed;
- (IBAction)defaultsButtonPressed;
- (IBAction)editButtonPressed;
- (IBAction)bottomButtonPressed;
- (IBAction)settingsButtonPressed;

@end

