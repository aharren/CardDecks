//
//
// CDXSymbolsKeyboardExtension.h
//
//
// Copyright (c) 2009-2025 Arne Harren <ah@0xc0.de>
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

#import "CDXKeyboardExtensions.h"


@class CDXSymbolsKeyboardExtensionViewController;


@interface CDXSymbolsKeyboardExtension : NSObject<CDXKeyboardExtension> {
    
@protected
    CDXSymbolsKeyboardExtensionViewController *viewController;
    
}

declare_singleton(sharedSymbolsKeyboardExtension, CDXSymbolsKeyboardExtension);

@end


typedef struct {
    NSInteger startCode;
    NSInteger endCode;
    NSString *blockName;
} CDXSymbolsKeyboardExtensionBlockStruct;


@interface CDXSymbolsKeyboardExtensionBlocks : NSObject {
    
}

+ (NSUInteger)count;
+ (CDXSymbolsKeyboardExtensionBlockStruct *)blockByIndex:(NSUInteger)index;

@end


@interface CDXSymbolsKeyboardExtensionViewController : UINavigationController {
    
}

- (void)reset;

@end


@interface CDXSymbolsKeyboardExtensionTableViewCellA : UITableViewCell {
    
@protected
    IBOutlet UILabel *label;
}

- (void)configureWithBlock:(CDXSymbolsKeyboardExtensionBlockStruct *)block;

@end


@interface CDXSymbolsKeyboardExtensionTableViewCellB : UITableViewCell {
    
@protected
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    IBOutlet UIButton *button3;
    IBOutlet UIButton *button4;
    IBOutlet UIButton *button5;
    IBOutlet UIButton *button6;
    
}

- (void)configureWithBlock:(CDXSymbolsKeyboardExtensionBlockStruct *)block offset:(NSInteger)offset;
- (IBAction)buttonPressed:(id)sender;

@end


@interface CDXSymbolsKeyboardExtensionTableViewController : UIViewController {
    
@protected
    IBOutlet CDXSymbolsKeyboardExtensionTableViewCellA *loadedTableViewCellA;
    IBOutlet CDXSymbolsKeyboardExtensionTableViewCellB *loadedTableViewCellB;
    
}

- (void)reset;

@end


@interface CDXSymbolsKeyboardExtensionTablePhoneViewController : CDXSymbolsKeyboardExtensionTableViewController {
    
@protected
    IBOutlet UITableView *tableView;
    IBOutlet UIButton *backButton;
    
    CDXSymbolsKeyboardExtensionBlockStruct *block;
}

- (id)initWithBlock:(CDXSymbolsKeyboardExtensionBlockStruct *)block;
- (IBAction)backButtonPressed;

@end


@interface CDXSymbolsKeyboardExtensionTablePadViewController : CDXSymbolsKeyboardExtensionTableViewController {
    
@protected
    IBOutlet UITableView *listTableView;
    IBOutlet UITableView *blockTableView;
    
    CDXSymbolsKeyboardExtensionBlockStruct *currentBlock;
    NSUInteger currentBlockIndex;
}

@end

