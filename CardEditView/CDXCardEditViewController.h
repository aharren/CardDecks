//
//
// CDXCardEditViewController.h
//
//
// Copyright (c) 2009 Arne Harren <ah@0xc0.de>
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

#import "CDXCard.h"
#import "CDXCardDeck.h"
#import "CDXCardDeckList.h"


typedef enum {
    CDXCardEditViewControllerEditModeText  = 0,
    CDXCardEditViewControllerEditModeColor = 1
} CDXCardEditViewControllerEditMode;


// A controller for editing a single card.
@interface CDXCardEditViewController : UIViewController {
    
@protected
    // data objects
    CDXCardDeck *_cardDeck;
    CDXCardDeckList *_cardDeckList;
    CDXCardDeck *_cardDeckInList;
    CDXCard *_card;
    
    // editing state
    CDXCardEditViewControllerEditMode _editMode;
    BOOL _editModeTransition;
    BOOL _textEdited;
    
    // UI elements and controllers
    UIView *_titleView;
    UIBarButtonItem *_rightBarButtonItem;
    UISegmentedControl *_editingSegment;
    
    UITextView *_text;
    UITextView *_textEditable;
    
    UIView *_colorView;
    
    UIView *_colorView0;
    UISegmentedControl *_colorView0Segment;
    
    UIView *_colorView1;
    UISlider *_colorView1RedSlider;
    UISlider *_colorView1GreenSlider;
    UISlider *_colorView1BlueSlider;
    
    UIView *_colorView2;
    
    CGFloat _sizeStartFontSize;
    CGFloat _sizeStartDistance;
    CGFloat _sizeEndDistance;
}

@property (nonatomic, retain) CDXCardDeck *cardDeck;
@property (nonatomic, retain) CDXCardDeckList *cardDeckList;
@property (nonatomic, retain) CDXCardDeck *cardDeckInList;
@property (nonatomic, retain) CDXCard *card;

@property (nonatomic, retain) IBOutlet UIView *titleView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, retain) IBOutlet UISegmentedControl *editingSegment;

@property (nonatomic, retain) IBOutlet UITextView *text;
@property (nonatomic, retain) IBOutlet UITextView *textEditable;

@property (nonatomic, retain) IBOutlet UIView *colorView;

@property (nonatomic, retain) IBOutlet UIView *colorView0;
@property (nonatomic, retain) IBOutlet UISegmentedControl *colorView0Segment;

@property (nonatomic, retain) IBOutlet UIView *colorView1;
@property (nonatomic, retain) IBOutlet UISlider *colorView1RedSlider;
@property (nonatomic, retain) IBOutlet UISlider *colorView1GreenSlider;
@property (nonatomic, retain) IBOutlet UISlider *colorView1BlueSlider;

@property (nonatomic, retain) IBOutlet UIView *colorView2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)configureWithCard:(CDXCard *)card cardDeck:(CDXCardDeck *)cardDeck cardDeckList:(CDXCardDeckList *)cardDeckList cardDeckInList:(CDXCardDeck *)cardDeckInList;

- (void)setColorViewHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setTextEditable:(BOOL)editable animated:(BOOL)animated;
- (void)setEditModeTextAnimated:(BOOL)animated;
- (void)setEditModeColorAnimated:(BOOL)animated;
- (void)cardTextColorChanged:(CDXColor *)color;
- (void)cardBackgroundColorChanged:(CDXColor *)color;

- (IBAction)editingSegmentSelected;
- (IBAction)colorView0SegmentSelected;
- (IBAction)colorView1ValueChanged;
- (IBAction)colorView2ValueChanged:(id)sender;

+ (CDXCardEditViewController *)cardEditViewControllerWithCard:(CDXCard *)card cardDeck:(CDXCardDeck *)cardDeck cardDeckList:(CDXCardDeckList *)cardDeckList cardDeckInList:(CDXCardDeck *)cardDeckInList;

@end


