//
//
// CDXSymbolsKeyboardExtension.m
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

#import "CDXSymbolsKeyboardExtension.h"
#import "CDXAppSettings.h"
#import "CDXDevice.h"


static BOOL symbolsUseAllSymbols = NO;

@implementation CDXSymbolsKeyboardExtension

synthesize_singleton(sharedSymbolsKeyboardExtension, CDXSymbolsKeyboardExtension);

- (void)dealloc {
    ivar_release_and_clear(viewController);
    [super dealloc];
}

- (void)keyboardExtensionInitialize {
    symbolsUseAllSymbols = [[CDXAppSettings sharedAppSettings] enableAllKeyboardSymbols];
    [viewController reset];
}

- (NSString *)keyboardExtensionTitle {
    return @"sym";
}

- (UIView *)keyboardExtensionView {
    if (viewController == nil) {
        ivar_assign(viewController, [[CDXSymbolsKeyboardExtensionViewController alloc] init]);
    }
    
    return viewController.view;
}

- (void)keyboardExtensionWillBecomeActive {
    [self keyboardExtensionView];
    [viewController viewWillAppear:NO];
}

- (void)keyboardExtensionDidBecomeActive {
    [viewController viewDidAppear:NO];
}

- (void)keyboardExtensionWillBecomeInactive {
    [viewController viewWillDisappear:NO];
}

- (void)keyboardExtensionDidBecomeInactive {
    [viewController viewDidDisappear:NO];
}

- (void)reset {
    [viewController reset];
}

@end


static CDXSymbolsKeyboardExtensionBlockStruct symbolsBlocksAll[] = {
    { 0xFB00, 0xFB4F, @"Alphabetic Presentation Forms" },
    { 0x0600, 0x06FF, @"Arabic" },
    { 0x0750, 0x077F, @"Arabic Supplement" },
    { 0xFB50, 0xFDFF, @"Arabic Presentation Forms-A" },
    { 0xFE70, 0xFEFF, @"Arabic Presentation Forms-B" },
    { 0x0530, 0x058F, @"Armenian" },
    { 0x2190, 0x21FF, @"Arrows" },
    { 0x1B00, 0x1B7F, @"Balinese" },
    { 0xA6A0, 0xA6FF, @"Bamum" },
    { 0x0000, 0x007F, @"Basic Latin" },
    { 0x1E00, 0x1EFF, @"Latin Extended Additional" },
    { 0x0100, 0x017F, @"Latin Extended-A" },
    { 0x0180, 0x024F, @"Latin Extended-B" },
    { 0x2C60, 0x2C7F, @"Latin Extended-C" },
    { 0xA720, 0xA7FF, @"Latin Extended-D" },
    { 0x0080, 0x00FF, @"Latin-1 Supplement" },
    { 0x0980, 0x09FF, @"Bengali" },
    { 0x2580, 0x259F, @"Block Elements" },
    { 0x31A0, 0x31BF, @"Bopomofo Extended" },
    { 0x3100, 0x312F, @"Bopomofo" },
    { 0x2500, 0x257F, @"Box Drawing" },
    { 0x2800, 0x28FF, @"Braille Patterns" },
    { 0x1A00, 0x1A1F, @"Buginese" },
    { 0x1740, 0x175F, @"Buhid" },
    { 0xFE30, 0xFE4F, @"CJK Compatibility Forms" },
    { 0xF900, 0xFAFF, @"CJK Compatibility Ideographs" },
    { 0x3300, 0x33FF, @"CJK Compatibility" },
    { 0x2E80, 0x2EFF, @"CJK Radicals Supplement" },
    { 0x31C0, 0x31EF, @"CJK Strokes" },
    { 0x3000, 0x303F, @"CJK Symbols and Punctuation" },
    { 0x3400, 0x4DBF, @"CJK Unified Ideographs Extension A" },
    { 0x4E00, 0x9FFF, @"CJK Unified Ideographs" },
    { 0xAA00, 0xAA5F, @"Cham" },
    { 0x13A0, 0x13FF, @"Cherokee" },
    { 0x1DC0, 0x1DFF, @"Combining Diacritical Marks Supplement" },
    { 0x20D0, 0x20FF, @"Combining Diacritical Marks for Symbols" },
    { 0x0300, 0x036F, @"Combining Diacritical Marks" },
    { 0xFE20, 0xFE2F, @"Combining Half Marks" },
    { 0xA830, 0xA83F, @"Common Indic Number Forms" },
    { 0x2400, 0x243F, @"Control Pictures" },
    { 0x2C80, 0x2CFF, @"Coptic" },
    { 0x20A0, 0x20CF, @"Currency Symbols" },
    { 0x0400, 0x04FF, @"Cyrillic" },
    { 0x2DE0, 0x2DFF, @"Cyrillic Extended-A" },
    { 0xA640, 0xA69F, @"Cyrillic Extended-B" },
    { 0x0500, 0x052F, @"Cyrillic Supplement" },
    { 0xA8E0, 0xA8FF, @"Devanagari Extended" },
    { 0x0900, 0x097F, @"Devanagari" },
    { 0x2700, 0x27BF, @"Dingbats" },
    { 0x2460, 0x24FF, @"Enclosed Alphanumerics" },
    { 0x3200, 0x32FF, @"Enclosed CJK Letters and Months" },
    { 0x1200, 0x137F, @"Ethiopic" },
    { 0x2D80, 0x2DDF, @"Ethiopic Extended" },
    { 0x1380, 0x139F, @"Ethiopic Supplement" },
    { 0x2000, 0x206F, @"General Punctuation" },
    { 0x25A0, 0x25FF, @"Geometric Shapes" },
    { 0x10A0, 0x10FF, @"Georgian" },
    { 0x2D00, 0x2D2F, @"Georgian Supplement" },
    { 0x2C00, 0x2C5F, @"Glagolitic" },
    { 0x1F00, 0x1FFF, @"Greek Extended" },
    { 0x0370, 0x03FF, @"Greek and Coptic" },
    { 0x0A80, 0x0AFF, @"Gujarati" },
    { 0x0A00, 0x0A7F, @"Gurmukhi" },
    { 0xFF00, 0xFFEF, @"Halfwidth and Fullwidth Forms" },
    { 0x3130, 0x318F, @"Hangul Compatibility Jamo" },
    { 0xA960, 0xA97F, @"Hangul Jamo Extended-A" },
    { 0xD7B0, 0xD7FF, @"Hangul Jamo Extended-B" },
    { 0x1100, 0x11FF, @"Hangul Jamo" },
    { 0xAC00, 0xD7AF, @"Hangul Syllables" },
    { 0x1720, 0x173F, @"Hanunoo" },
    { 0x0590, 0x05FF, @"Hebrew" },
    { 0xDB80, 0xDBFF, @"High Private Use Surrogates" },
    { 0xD800, 0xDB7F, @"High Surrogates" },
    { 0x3040, 0x309F, @"Hiragana" },
    { 0x0250, 0x02AF, @"IPA Extensions" },
    { 0x2FF0, 0x2FFF, @"Ideographic Description Characters" },
    { 0xA980, 0xA9DF, @"Javanese" },
    { 0x3190, 0x319F, @"Kanbun" },
    { 0x2F00, 0x2FDF, @"Kangxi Radicals" },
    { 0x0C80, 0x0CFF, @"Kannada" },
    { 0x30A0, 0x30FF, @"Katakana" },
    { 0x31F0, 0x31FF, @"Katakana Phonetic Extensions" },
    { 0xA900, 0xA92F, @"Kayah Li" },
    { 0x1780, 0x17FF, @"Khmer" },
    { 0x19E0, 0x19FF, @"Khmer Symbols" },
    { 0x0E80, 0x0EFF, @"Lao" },
    { 0x1C00, 0x1C4F, @"Lepcha" },
    { 0x2100, 0x214F, @"Letterlike Symbols" },
    { 0x1900, 0x194F, @"Limbu" },
    { 0xA4D0, 0xA4FF, @"Lisu" },
    { 0xDC00, 0xDFFF, @"Low Surrogates" },
    { 0x0D00, 0x0D7F, @"Malayalam" },
    { 0x2200, 0x22FF, @"Mathematical Operators" },
    { 0xABC0, 0xABFF, @"Meetei Mayek" },
    { 0x27C0, 0x27EF, @"Miscellaneous Mathematical Symbols-A" },
    { 0x2980, 0x29FF, @"Miscellaneous Mathematical Symbols-B" },
    { 0x2B00, 0x2BFF, @"Miscellaneous Symbols and Arrows" },
    { 0x2600, 0x26FF, @"Miscellaneous Symbols" },
    { 0x2300, 0x23FF, @"Miscellaneous Technical" },
    { 0xA700, 0xA71F, @"Modifier Tone Letters" },
    { 0x1800, 0x18AF, @"Mongolian" },
    { 0xAA60, 0xAA7F, @"Myanmar Extended-A" },
    { 0x1000, 0x109F, @"Myanmar" },
    { 0x07C0, 0x07FF, @"NKo" },
    { 0x1980, 0x19DF, @"New Tai Lue" },
    { 0x2150, 0x218F, @"Number Forms" },
    { 0x1680, 0x169F, @"Ogham" },
    { 0x1C50, 0x1C7F, @"Ol Chiki" },
    { 0x2440, 0x245F, @"Optical Character Recognition" },
    { 0x0B00, 0x0B7F, @"Oriya" },
    { 0xA840, 0xA87F, @"Phags-pa" },
    { 0x1D00, 0x1D7F, @"Phonetic Extensions" },
    { 0x1D80, 0x1DBF, @"Phonetic Extensions Supplement" },
    { 0xE000, 0xF8FF, @"Private Use Area" },
    { 0xA930, 0xA95F, @"Rejang" },
    { 0x16A0, 0x16FF, @"Runic" },
    { 0x0800, 0x083F, @"Samaritan" },
    { 0xA880, 0xA8DF, @"Saurashtra" },
    { 0x0D80, 0x0DFF, @"Sinhala" },
    { 0xFE50, 0xFE6F, @"Small Form Variants" },
    { 0x02B0, 0x02FF, @"Spacing Modifier Letters" },
    { 0xFFF0, 0xFFFF, @"Specials" },
    { 0x1B80, 0x1BBF, @"Sundanese" },
    { 0x2070, 0x209F, @"Superscripts and Subscripts" },
    { 0x27F0, 0x27FF, @"Supplemental Arrows-A" },
    { 0x2900, 0x297F, @"Supplemental Arrows-B" },
    { 0x2A00, 0x2AFF, @"Supplemental Mathematical Operators" },
    { 0x2E00, 0x2E7F, @"Supplemental Punctuation" },
    { 0xA800, 0xA82F, @"Syloti Nagri" },
    { 0x0700, 0x074F, @"Syriac" },
    { 0x1700, 0x171F, @"Tagalog" },
    { 0x1760, 0x177F, @"Tagbanwa" },
    { 0x1950, 0x197F, @"Tai Le" },
    { 0x1A20, 0x1AAF, @"Tai Tham" },
    { 0xAA80, 0xAADF, @"Tai Viet" },
    { 0x0B80, 0x0BFF, @"Tamil" },
    { 0x0C00, 0x0C7F, @"Telugu" },
    { 0x0780, 0x07BF, @"Thaana" },
    { 0x0E00, 0x0E7F, @"Thai" },
    { 0x0F00, 0x0FFF, @"Tibetan" },
    { 0x2D30, 0x2D7F, @"Tifinagh" },
    { 0x1400, 0x167F, @"Unified Canadian Aboriginal Syllabics" },
    { 0x18B0, 0x18FF, @"Unified Canadian Aboriginal Syllabics Extended" },
    { 0xA500, 0xA63F, @"Vai" },
    { 0xFE00, 0xFE0F, @"Variation Selectors" },
    { 0x1CD0, 0x1CFF, @"Vedic Extensions" },
    { 0xFE10, 0xFE1F, @"Vertical Forms" },
    { 0xA490, 0xA4CF, @"Yi Radicals" },
    { 0xA000, 0xA48F, @"Yi Syllables" },
    { 0x4DC0, 0x4DFF, @"Yijing Hexagram Symbols" }
};

static CDXSymbolsKeyboardExtensionBlockStruct symbolsBlocksSubset[] = {
    { 0x2190, 0x2190 + 13*7, @"Arrows" },
    { 0x2580, 0x2580 +  4*7, @"Block Elements" },
    { 0x2500, 0x257F       , @"Box Drawing" },
    { 0xFE30, 0xFE30 +  4*7, @"CJK Compatibility Forms" },
    { 0x3000, 0x303F       , @"CJK Symbols and Punctuation" },
    { 0x20D0, 0x20D0 +  3*7, @"Combining Diacritical Marks for Symbols" },
    { 0x20A0, 0x20A0 +  4*7, @"Currency Symbols" },
    { 0x2700, 0x27BF       , @"Dingbats" },
    { 0x2460, 0x2460 + 20*7, @"Enclosed Alphanumerics" },
    { 0x2000, 0x206F       , @"General Punctuation" },
    { 0x25A0, 0x25A0 + 12*7, @"Geometric Shapes" },
    { 0x0370, 0x03FF       , @"Greek and Coptic" },
    { 0x0080 + 4*7, 0x00FF , @"Latin-1 Supplement" },
    { 0x2100, 0x214F       , @"Letterlike Symbols" },
    { 0x2200, 0x22FF       , @"Mathematical Operators" },
    { 0x2600, 0x2600 + 16*7, @"Miscellaneous Symbols" },
    { 0x2300, 0x23FF       , @"Miscellaneous Technical" },
    { 0xA700, 0xA71F       , @"Modifier Tone Letters" },
    { 0x2150, 0x2150 +  8*7, @"Number Forms" }
};

@implementation CDXSymbolsKeyboardExtensionBlocks

+ (NSUInteger)count {
    if (symbolsUseAllSymbols) {
        return sizeof(symbolsBlocksAll)/sizeof(CDXSymbolsKeyboardExtensionBlockStruct);
    } else {
        return sizeof(symbolsBlocksSubset)/sizeof(CDXSymbolsKeyboardExtensionBlockStruct);
    }
}

+ (CDXSymbolsKeyboardExtensionBlockStruct *)blockByIndex:(NSUInteger)index {
    if (symbolsUseAllSymbols) {
        if (index < sizeof(symbolsBlocksAll)/sizeof(CDXSymbolsKeyboardExtensionBlockStruct)) {
            return &symbolsBlocksAll[index];
        }
    } else {
        if (index < sizeof(symbolsBlocksSubset)/sizeof(CDXSymbolsKeyboardExtensionBlockStruct)) {
            return &symbolsBlocksSubset[index];
        }
    }
    
    return NULL;
}

@end


@implementation CDXSymbolsKeyboardExtensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.hidden = YES;
    
    CDXSymbolsKeyboardExtensionTableViewController *tvc = nil;
    if ([[CDXDevice sharedDevice] deviceUIIdiom] == CDXDeviceUIIdiomPhone) {
        tvc = [[[CDXSymbolsKeyboardExtensionTablePhoneViewController alloc] initWithBlock:NULL] autorelease];
    } else {
        tvc = [[[CDXSymbolsKeyboardExtensionTablePadViewController alloc] init] autorelease];
    }
    [self setViewControllers:[NSArray arrayWithObject:tvc]];
}

- (void)reset {
    [self popToRootViewControllerAnimated:NO];
    if ([[self viewControllers] count] > 0) {
        CDXSymbolsKeyboardExtensionTableViewController *tvc = (CDXSymbolsKeyboardExtensionTableViewController *)[[self viewControllers] objectAtIndex:0];
        [tvc reset];
    }
}

@end


@implementation CDXSymbolsKeyboardExtensionTableViewCellA

- (void)dealloc {
    ivar_release_and_clear(label);
    [super dealloc];
}

- (void)configureWithBlock:(CDXSymbolsKeyboardExtensionBlockStruct *)block {
    label.text = block->blockName;
}

@end


@implementation CDXSymbolsKeyboardExtensionTableViewCellB

- (void)dealloc {
    ivar_release_and_clear(button1);
    ivar_release_and_clear(button2);
    ivar_release_and_clear(button3);
    ivar_release_and_clear(button4);
    ivar_release_and_clear(button5);
    ivar_release_and_clear(button6);
    ivar_release_and_clear(button7);
    [super dealloc];
}

- (void)buttonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    NSObject *responder = (NSObject *)[[CDXKeyboardExtensions sharedKeyboardExtensions] responder];
    if ([responder respondsToSelector:@selector(paste:)]) {
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        NSArray* pasteboardItems = [[pasteboard.items copy] autorelease];
        
        pasteboard.string = button.titleLabel.text;
        [responder paste:self];
        
        pasteboard.items = pasteboardItems;
    }
}

- (void)configureWithBlock:(CDXSymbolsKeyboardExtensionBlockStruct *)block offset:(NSInteger)offset {
    NSInteger c = block->startCode + offset;
    NSInteger last = block->endCode;
    
    [button1 setTitle:[NSString stringWithFormat:@"%C", (unichar) ((c+0) <= last ? (c+0) : 32)] forState:UIControlStateNormal];
    [button2 setTitle:[NSString stringWithFormat:@"%C", (unichar) ((c+1) <= last ? (c+1) : 32)] forState:UIControlStateNormal];
    [button3 setTitle:[NSString stringWithFormat:@"%C", (unichar) ((c+2) <= last ? (c+2) : 32)] forState:UIControlStateNormal];
    [button4 setTitle:[NSString stringWithFormat:@"%C", (unichar) ((c+3) <= last ? (c+3) : 32)] forState:UIControlStateNormal];
    [button5 setTitle:[NSString stringWithFormat:@"%C", (unichar) ((c+4) <= last ? (c+4) : 32)] forState:UIControlStateNormal];
    [button6 setTitle:[NSString stringWithFormat:@"%C", (unichar) ((c+5) <= last ? (c+5) : 32)] forState:UIControlStateNormal];
    [button7 setTitle:[NSString stringWithFormat:@"%C", (unichar) ((c+6) <= last ? (c+6) : 32)] forState:UIControlStateNormal];
}

@end


@implementation CDXSymbolsKeyboardExtensionTableViewController

- (void)dealloc {
    ivar_release_and_clear(loadedTableViewCellA);
    ivar_release_and_clear(loadedTableViewCellB);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[CDXKeyboardExtensions sharedKeyboardExtensions] backgroundColor];
}

- (void)viewDidUnload {
    ivar_release_and_clear(loadedTableViewCellA);
    ivar_release_and_clear(loadedTableViewCellB);
    [super viewDidUnload];
}

- (void)reset {
    
}

@end


@implementation CDXSymbolsKeyboardExtensionTablePhoneViewController

- (id)initWithBlock:(CDXSymbolsKeyboardExtensionBlockStruct *)aBlock {
    if ((self = [super initWithNibName:@"CDXSymbolsKeyboardExtensionTableView" bundle:nil])) {
        block = aBlock;
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(tableView);
    ivar_release_and_clear(backButton);
    [super dealloc];
}

- (void)viewDidUnload {
    ivar_release_and_clear(tableView);
    ivar_release_and_clear(backButton);
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    backButton.alpha = 0;
    if (block != NULL) {
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
        }
        backButton.alpha = 1;
        if (animated) {
            [UIView commitAnimations];
        }
    }
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (block == NULL) {
        return [CDXSymbolsKeyboardExtensionBlocks count];
    } else {
        return ((block->endCode - block->startCode) + 6) / 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (block == NULL) {
        CDXSymbolsKeyboardExtensionTableViewCellA *cell = (CDXSymbolsKeyboardExtensionTableViewCellA *)[tableView dequeueReusableCellWithIdentifier:@"CDXSymbolsKeyboardExtensionTableViewCellA"];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"CDXSymbolsKeyboardExtensionTableViewCellA" owner:self options:nil];
            cell = loadedTableViewCellA;
            ivar_release_and_clear(loadedTableViewCellA);
            NSAssert([@"CDXSymbolsKeyboardExtensionTableViewCellA" isEqualToString:[cell reuseIdentifier]], @"reuseIdentifier must match");        
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        [cell configureWithBlock:[CDXSymbolsKeyboardExtensionBlocks blockByIndex:indexPath.row]];
        return cell;
    } else {
        CDXSymbolsKeyboardExtensionTableViewCellB *cell = (CDXSymbolsKeyboardExtensionTableViewCellB *)[tableView dequeueReusableCellWithIdentifier:@"CDXSymbolsKeyboardExtensionTableViewCellB"];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"CDXSymbolsKeyboardExtensionTableViewCellB" owner:self options:nil];
            cell = loadedTableViewCellB;
            ivar_release_and_clear(loadedTableViewCellB);
            NSAssert([@"CDXSymbolsKeyboardExtensionTableViewCellB" isEqualToString:[cell reuseIdentifier]], @"reuseIdentifier must match");        
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        [cell configureWithBlock:block offset:indexPath.row * 7];
        return cell;
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (block == NULL) {
        CDXSymbolsKeyboardExtensionTablePhoneViewController *tvc = [[[CDXSymbolsKeyboardExtensionTablePhoneViewController alloc] initWithBlock:[CDXSymbolsKeyboardExtensionBlocks blockByIndex:indexPath.row]] autorelease]; 
        [self.navigationController pushViewController:tvc animated:YES];
    }
}

- (UITableView *)tableView {
    return tableView;
}

- (IBAction)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reset {
    [tableView reloadData];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

@end


@implementation CDXSymbolsKeyboardExtensionTablePadViewController

- (id)init {
    if ((self = [super initWithNibName:@"CDXSymbolsKeyboardExtensionTablePadView" bundle:nil])) {
        currentBlockIndex = 0;
        currentBlock = [CDXSymbolsKeyboardExtensionBlocks blockByIndex:currentBlockIndex];
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(listTableView);
    ivar_release_and_clear(blockTableView);
    [super dealloc];
}

- (void)viewDidUnload {
    ivar_release_and_clear(listTableView);
    ivar_release_and_clear(blockTableView);
    [super viewDidUnload];
}

- (void)setCurrentBlock:(NSUInteger)index {
    currentBlockIndex = index;
    currentBlock = [CDXSymbolsKeyboardExtensionBlocks blockByIndex:currentBlockIndex];
    [blockTableView reloadData];
    [blockTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    blockTableView.scrollEnabled = (((currentBlock->endCode - currentBlock->startCode) + 6) / 7) > 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == listTableView) {
        return [CDXSymbolsKeyboardExtensionBlocks count];
    } else {
        return MAX(7, ((currentBlock->endCode - currentBlock->startCode) + 6) / 7);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == listTableView) {
        if (indexPath.row == currentBlockIndex) {
            cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        } else {
            cell.backgroundColor = [UIColor clearColor];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == listTableView) {
        CDXSymbolsKeyboardExtensionTableViewCellA *cell = (CDXSymbolsKeyboardExtensionTableViewCellA *)[tableView dequeueReusableCellWithIdentifier:@"CDXSymbolsKeyboardExtensionTableViewCellA"];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"CDXSymbolsKeyboardExtensionTableViewCellA" owner:self options:nil];
            cell = loadedTableViewCellA;
            ivar_release_and_clear(loadedTableViewCellA);
            NSAssert([@"CDXSymbolsKeyboardExtensionTableViewCellA" isEqualToString:[cell reuseIdentifier]], @"reuseIdentifier must match");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        [cell configureWithBlock:[CDXSymbolsKeyboardExtensionBlocks blockByIndex:indexPath.row]];
        return cell;
    } else {
        CDXSymbolsKeyboardExtensionTableViewCellB *cell = (CDXSymbolsKeyboardExtensionTableViewCellB *)[tableView dequeueReusableCellWithIdentifier:@"CDXSymbolsKeyboardExtensionTableViewCellB"];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"CDXSymbolsKeyboardExtensionTableViewCellB" owner:self options:nil];
            cell = loadedTableViewCellB;
            ivar_release_and_clear(loadedTableViewCellB);
            NSAssert([@"CDXSymbolsKeyboardExtensionTableViewCellB" isEqualToString:[cell reuseIdentifier]], @"reuseIdentifier must match");
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        [cell configureWithBlock:currentBlock offset:indexPath.row * 7];
        return cell;
    }}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView == listTableView) {
        [self setCurrentBlock:indexPath.row];
        [listTableView reloadData];
    }
}

- (void)reset {
    [listTableView reloadData];
    [listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self setCurrentBlock:0];
}

@end

