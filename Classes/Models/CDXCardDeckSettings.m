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
    CDXCardDeckSettingsName,
    CDXCardDeckSettingsDeckDisplayStyle,
    CDXCardDeckSettingsCornerStyle,
    CDXCardDeckSettingsPageControl,
    CDXCardDeckSettingsPageJumps,
    CDXCardDeckSettingsAutoRotate,
    CDXCardDeckSettingsShakeShuffle,
    CDXCardDeckSettingsCount
};

static const CDXSetting settings[] = {
    { CDXCardDeckSettingsName, CDXSettingTypeText, @"Name" },
    { CDXCardDeckSettingsDeckDisplayStyle, CDXSettingTypeEnumeration, @"Deck Style" },
    { CDXCardDeckSettingsCornerStyle, CDXSettingTypeEnumeration, @"Corner Style" },
    { CDXCardDeckSettingsPageControl, CDXSettingTypeBoolean, @"Page Display" },
    { CDXCardDeckSettingsPageJumps, CDXSettingTypeBoolean, @"Page Jumps" },
    { CDXCardDeckSettingsAutoRotate, CDXSettingTypeBoolean, @"Auto Rotate" },
    { CDXCardDeckSettingsShakeShuffle, CDXSettingTypeBoolean, @"Shake Shuffle" },
    { 0, 0, @"" }
};

typedef struct {
    NSString *title;
    unsigned int settingsCount;
    unsigned int firstIndex;
} CDXCardDeckSettingGroup;

static const CDXCardDeckSettingGroup groups[] = {
    { @"", 1, CDXCardDeckSettingsName },
    { @"Appearance", 4, CDXCardDeckSettingsDeckDisplayStyle },
    { @"Device Events", 2, CDXCardDeckSettingsAutoRotate },
    { @"", 0, 0 }
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
    return @"Deck Settings";
}

- (NSUInteger)numberOfGroups {
    return (sizeof(groups) / sizeof(CDXCardDeckSettingGroup)) - 1;
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
        case CDXCardDeckSettingsPageJumps:
            return cardDeck.wantsPageJumps;
        case CDXCardDeckSettingsAutoRotate:
            return cardDeck.wantsAutoRotate;
        case CDXCardDeckSettingsShakeShuffle:
            return cardDeck.wantsShakeShuffle;
    }
}

- (void)setBooleanValue:(BOOL)value forSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            break;
        case CDXCardDeckSettingsPageControl:
            cardDeck.wantsPageControl = value;
            break;
        case CDXCardDeckSettingsPageJumps:
            cardDeck.wantsPageJumps = value;
            break;
        case CDXCardDeckSettingsAutoRotate:
            cardDeck.wantsAutoRotate = value;
            break;
        case CDXCardDeckSettingsShakeShuffle:
            cardDeck.wantsShakeShuffle = value;
            break;
    }
}

- (NSUInteger)enumerationValueForSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return 0;
        case CDXCardDeckSettingsDeckDisplayStyle:
            return (NSUInteger)cardDeck.displayStyle;
        case CDXCardDeckSettingsCornerStyle:
            return (NSUInteger)cardDeck.cornerStyle;
    }
}

- (void)setEnumerationValue:(NSUInteger)value forSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            break;
        case CDXCardDeckSettingsDeckDisplayStyle:
            cardDeck.displayStyle = value;
            break;
        case CDXCardDeckSettingsCornerStyle:
            cardDeck.cornerStyle = value;
            break;
    }
}

- (NSUInteger)enumerationValuesCountForSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return 0;
        case CDXCardDeckSettingsDeckDisplayStyle:
            return (NSUInteger)CDXCardDeckDisplayStyleCount;
        case CDXCardDeckSettingsCornerStyle:
            return CDXCardCornerStyleCount;
    }
}

- (NSString *)descriptionForEumerationValue:(NSUInteger)value forSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return @"";
        case CDXCardDeckSettingsDeckDisplayStyle:
            switch (value) {
                default:
                case CDXCardDeckDisplayStyleSideBySide:
                    return @"Side-by-side (Scroll)";
                case CDXCardDeckDisplayStyleStack:
                    return @"Stacked (Scroll)";
                case CDXCardDeckDisplayStyleSwipeStack:
                    return @"Stacked (Swipe)";
            }
        case CDXCardDeckSettingsCornerStyle:
            switch (value) {
                default:
                case CDXCardCornerStyleRounded:
                    return @"Rounded";
                case CDXCardCornerStyleCornered:
                    return @"Cornered";
            }
    }
}

- (NSString *)textValueForSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return @"";
        case CDXCardDeckSettingsName:
            return cardDeck.name;
    }
}

- (void)setTextValue:(NSString *)value forSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            break;
        case CDXCardDeckSettingsName:
            cardDeck.name = value;
            break;
    }
}

@end

