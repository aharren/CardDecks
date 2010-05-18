//
//
// CDXCardDeckSettings.m
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

#import "CDXCardDeckSettings.h"


enum {
    CDXCardDeckSettingsPageControl,
    CDXCardDeckSettingsAutoRotate
};

static const CDXSetting settings[] = {
    { CDXCardDeckSettingsPageControl, CDXSettingTypeBoolean, @"Page Control" },
    { CDXCardDeckSettingsAutoRotate,  CDXSettingTypeBoolean, @"Auto Rotate"  }
};

typedef struct {
    NSString *title;
    unsigned int settingsCount;
    unsigned int firstIndex;
} CDXCardDeckSettingGroup;

static const CDXCardDeckSettingGroup groups[] = {
    { @"Appearance",    1, CDXCardDeckSettingsPageControl },
    { @"Device Events", 1, CDXCardDeckSettingsAutoRotate  }
};


@implementation CDXCardDeckSettings

- (id)initWithCardDeck:(CDXCardDeck *)deck {
    if ((self = [super init])) {
        ivar_assign_and_retain(cardDeck, deck);
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(cardDeck);
    [super dealloc];
}

- (NSString *)title {
    return @"Card Deck Settings";
}

- (NSUInteger)numberOfGroups {
    return sizeof(groups) / sizeof(CDXCardDeckSettingGroup);
}

- (NSString *)titleForGroup:(NSUInteger)group {
    return groups[group].title;
}

- (NSUInteger)numberOfSettingsInGroup:(NSUInteger)group {
    return groups[group].settingsCount;
}

- (CDXSetting)settingAtIndex:(NSUInteger)index inGroup:(NSUInteger)group {
    unsigned int firstIndex = groups[group].firstIndex;
    return settings[firstIndex + index];
}

- (BOOL)booleanValueForSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return NO;
        case CDXCardDeckSettingsPageControl:
            return cardDeck.wantsPageControl;
        case CDXCardDeckSettingsAutoRotate:
            return cardDeck.autoRotate;
    }
}

- (void)setBooleanValue:(BOOL)value forSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            break;
        case CDXCardDeckSettingsPageControl:
            cardDeck.wantsPageControl = value;
            break;
        case CDXCardDeckSettingsAutoRotate:
            cardDeck.autoRotate = value;
            break;
    }
}

@end

