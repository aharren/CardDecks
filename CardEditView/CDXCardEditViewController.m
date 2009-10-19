//
//
// CDXCardEditViewController.m
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

#import "CDXCardEditViewController.h"
#import "CDXTextRenderingContext.h"


@implementation CDXCardEditViewController

#define LogFileComponent lcl_cCDXCardEditViewController

@synthesize cardDeck = _cardDeck;
@synthesize cardDeckList = _cardDeckList;
@synthesize cardDeckInList = _cardDeckInList;
@synthesize card = _card;

@synthesize titleView = _titleView;
@synthesize rightBarButtonItem = _rightBarButtonItem;
@synthesize editingSegment = _editingSegment;

@synthesize text = _text;
@synthesize textEditable = _textEditable;

@synthesize colorView = _colorView;

@synthesize colorView0 = _colorView0;
@synthesize colorView0Segment = _colorView0Segment;

@synthesize colorView1 = _colorView1;
@synthesize colorView1RedSlider = _colorView1RedSlider;
@synthesize colorView1GreenSlider = _colorView1GreenSlider;
@synthesize colorView1BlueSlider = _colorView1BlueSlider;

@synthesize colorView2 = _colorView2;

typedef struct {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
} CDXColorRGB;

static CDXColorRGB cdxColorsRGB[] = {
{ 255,   0,   0 },
{ 255,   0, 255 },
{   0,   0,   0 },

{ 255, 255,   0 },
{   0,   0, 255 },
{ 128, 128, 128 },

{   0, 255,   0 },
{   0, 255, 255 },
{ 255, 255, 255 },

{ 255, 255, 255 },
{ 255, 255, 255 }
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    LogInvocation();
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // nothing to do
    }
    
    return self;
}

- (void)dealloc {
    LogInvocation();
    
    self.card = nil;
    self.cardDeck = nil;
    self.cardDeckList = nil;
    self.cardDeckInList = nil;
    
    self.editingSegment = nil;
    
    self.text = nil;
    self.textEditable = nil;
    
    self.colorView = nil;
    
    self.colorView0 = nil;
    self.colorView0Segment = nil;
    
    self.colorView1 = nil;
    self.colorView1RedSlider = nil;
    self.colorView1GreenSlider = nil;
    self.colorView1BlueSlider = nil;
    
    self.colorView2 = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    LogInvocation();
    
    [super viewDidLoad];
    [_colorView addSubview:_colorView0];
    [_colorView addSubview:_colorView1];
    [_colorView addSubview:_colorView2];
    _colorView1.alpha = 0.0;
    
    _text.numberOfLines = 0;
    
    [self navigationItem].rightBarButtonItem = _rightBarButtonItem; // _titleView;
}

- (void)viewDidUnload {
    LogInvocation();
    
    self.text = nil;
    self.textEditable = nil;
    
    self.editingSegment = nil;
    
    self.colorView = nil;
    
    self.colorView0 = nil;
    self.colorView0Segment = nil;
    
    self.colorView1 = nil;
    self.colorView1RedSlider = nil;
    self.colorView1GreenSlider = nil;
    self.colorView1BlueSlider = nil;
    
    self.colorView2 = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    LogInvocation();
    
    // set text editing mode
    [self setTextEditable:NO animated:NO];
    [self setEditModeTextAnimated:NO];
    
    // reset the color editor
    _colorView0Segment.selectedSegmentIndex = 0;
    
    [super viewWillAppear:animated];    
}

- (void)viewDidAppear:(BOOL)animated {
    LogInvocation();
    
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    LogInvocation();
    
    [super viewDidDisappear:animated];
    
    if (_card.dirty) {
        if (!_card.committed && !_textEdited) {
            _card.text = @"";
        }
        _card.committed = YES;
        [CDXStorage update:_cardDeck deferred:YES];
        
        LogInvocation(@"%d", _cardDeckInList.committed);
        if (!_cardDeckInList.committed) {
            _cardDeckInList.committed = YES;
            _cardDeckInList.dirty = YES;
            [CDXStorage update:_cardDeckList deferred:YES];
        }
    }
}

- (void)setColorViewHidden:(BOOL)hidden animated:(BOOL)animated {
    LogInvocation();
    
    if (hidden) {
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
        }
        
        CGRect frame;
        frame= _colorView.frame;
        frame.origin.y = self.view.frame.size.height;
        _colorView.frame = frame;
        if (animated) {
            [UIView commitAnimations];
        }
    } else {
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
        }
        
        CGRect frame;
        frame= _colorView.frame;
        frame.origin.y = self.view.frame.size.height - 216;
        _colorView.frame = frame;
        
        if (animated) {
            [UIView commitAnimations];
        }
    }
}

- (void)setTextEditable:(BOOL)editable animated:(BOOL)animated {
    LogInvocation();
    
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
    }
    
    if (editable) {
        [_textEditable becomeFirstResponder];
        _textEditable.font = [UIFont boldSystemFontOfSize:28];
        _textEditable.alpha = 1;
        _text.alpha = 0;
    } else {
        [_textEditable resignFirstResponder];
        _textEditable.alpha = 0;
        _text.alpha = 1;
        _text.text = _textEditable.text;
        
        UIFont *font = [UIFont boldSystemFontOfSize:400];
        NSArray *textLines = [_text.text componentsSeparatedByString:@"\n"];
        CDXTextRenderingContext *textRenderingContext = [CDXTextRenderingContext contextForText:textLines font:font width:320 height:440];
        _text.font = [font fontWithSize:textRenderingContext.fontSize];
        const CGFloat widthInternal = 800.0;
        CGRect rect = _text.bounds;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.width = widthInternal;
        _text.bounds = rect;
        rect = _text.frame;
        rect.origin.x = (self.view.frame.size.width - widthInternal)/2;
        _text.frame = rect;
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)setEditModeTextAnimated:(BOOL)animated {
    LogInvocation();
    
    _editModeTransition = YES;
    [self setColorViewHidden:YES animated:animated];
    [self setTextEditable:YES animated:animated];
    _editMode = CDXCardEditViewControllerEditModeText;
    _editingSegment.selectedSegmentIndex = 0;
    _editModeTransition = NO;        
}

- (void)setEditModeColorAnimated:(BOOL)animated {
    LogInvocation();
    
    _editModeTransition = YES;
    [self setColorViewHidden:NO animated:animated];
    [self setTextEditable:NO animated:animated];
    _editMode = CDXCardEditViewControllerEditModeColor;
    _editingSegment.selectedSegmentIndex = 1;
    _editModeTransition = NO;        
}

- (void)cardTextColorChanged:(CDXColor *)color {
    LogInvocation();
    
    _card.textColor = color;
    _card.dirty = YES;
    
    _cardDeck.defaultTextColor = color;
    
    _textEditable.textColor = [color uiColor];
    _text.textColor = [color uiColor];
}

- (void)cardBackgroundColorChanged:(CDXColor *)color {
    LogInvocation();
    
    _card.backgroundColor = color;
    _card.dirty = YES;
    
    _cardDeck.defaultBackgroundColor = color;
    
    self.view.backgroundColor = [color uiColor];
}    

- (IBAction)colorView1ValueChanged {
    LogInvocation();
    
    CDXColor *color = [CDXColor cdxColorWithRed:(int)_colorView1RedSlider.value
                                          green:(int)_colorView1GreenSlider.value
                                           blue:(int)_colorView1BlueSlider.value];
    
    if (_colorView0Segment.selectedSegmentIndex == 1) {
        [self cardTextColorChanged:color];
    } else {
        [self cardBackgroundColorChanged:color];
    }
}

- (IBAction)colorView2ValueChanged:(id)sender {
    LogInvocation();
    
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    CDXColorRGB colorRGB = cdxColorsRGB[tag % 10];
    CDXColor *color = [CDXColor cdxColorWithRed:colorRGB.red green:colorRGB.green blue:colorRGB.blue];
    
    if (tag % 20 < 10) {
        [self cardTextColorChanged:color];
    } else {
        [self cardBackgroundColorChanged:color];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if (tag % 10 == 8) {
        button.backgroundColor = [UIColor blackColor];
    } else {
        button.backgroundColor = [UIColor whiteColor];
    }
    
    button.backgroundColor = [color uiColor];
    [UIView commitAnimations];
}

- (IBAction)editingSegmentSelected {
    LogInvocation();
    
    NSInteger selectedIndex = _editingSegment.selectedSegmentIndex;
    switch (selectedIndex) {
        default:
        case 0:
            [self setEditModeTextAnimated:YES];
            break;
        case 1:
            [self setEditModeColorAnimated:YES];
            break;
    }
}

- (IBAction)colorView0SegmentSelected {
    LogInvocation();
    
    NSInteger selectedIndex = _colorView0Segment.selectedSegmentIndex;
    CDXColor *color = nil;
    switch (selectedIndex) {
        default:
        case 0:
            _colorView1.alpha = 0.0;
            _colorView2.alpha = 1.0;
            break;
        case 1:
            _colorView1.alpha = 1.0;
            _colorView2.alpha = 0.0;
            
            color = _card.textColor;
            _colorView1RedSlider.value = color.red;
            _colorView1GreenSlider.value = color.green;
            _colorView1BlueSlider.value = color.blue;            
            break;
        case 2:
            _colorView1.alpha = 1.0;
            _colorView2.alpha = 0.0;
            
            color = _card.backgroundColor;
            _colorView1RedSlider.value = color.red;
            _colorView1GreenSlider.value = color.green;
            _colorView1BlueSlider.value = color.blue;            
            break;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    LogInvocation();
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    LogInvocation();
    
    if (![_textEditable.text isEqualToString:_text.text]) {
        _card.text = _textEditable.text;
        _card.dirty = YES;
        _textEdited = YES;
    }
    
    if (!_editModeTransition) {
        [self setEditModeColorAnimated:YES];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    LogInvocation();
    
}

- (void)configureWithCard:(CDXCard *)card cardDeck:(CDXCardDeck *)cardDeck cardDeckList:(CDXCardDeckList *)cardDeckList cardDeckInList:(CDXCardDeck *)cardDeckInList {
    LogInvocation();
    
    self.card = card;
    _card.dirty = NO;
    _textEdited = NO;
    
    LogDebug(@"dirty %d", _card.dirty);
    
    self.cardDeck = cardDeck;
    self.cardDeckList = cardDeckList;
    self.cardDeckInList = cardDeckInList;
    
    NSString *text = card == nil || !card.committed ? @"" : card.text;
    _textEditable.text = text;
    _text.text = text;
    
    UIColor *textColor = card == nil ? [UIColor whiteColor] : [card.textColor uiColor];
    _textEditable.textColor = textColor;
    _text.textColor = textColor;
    
    UIColor *backgroundColor = card == nil  ? [UIColor blackColor] : [card.backgroundColor uiColor];
    self.view.backgroundColor = backgroundColor;
}

+ (CDXCardEditViewController *)cardEditViewControllerWithCard:(CDXCard *)card cardDeck:(CDXCardDeck *)cardDeck cardDeckList:(CDXCardDeckList *)cardDeckList cardDeckInList:(CDXCardDeck *)cardDeckInList {
    LogInvocation();
    
    CDXCardEditViewController *controller = [[[CDXCardEditViewController alloc] initWithNibName:@"CDXCardEditView" bundle:nil] autorelease];
    [controller configureWithCard:card cardDeck:cardDeck cardDeckList:cardDeckList cardDeckInList:cardDeckInList];
    return controller;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    LogInvocation();
    
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 1) {
        LogInvocation(@"1 %d", _editMode);
        switch (_editMode) {
            default:
            case CDXCardEditViewControllerEditModeText:
                [self setEditModeColorAnimated:YES];
                break;
            case CDXCardEditViewControllerEditModeColor:
                break;
        }
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

@end

