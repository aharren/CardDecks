//
//
// CDXAppSettings.m
//
//
// Copyright (c) 2009-2014 Arne Harren <ah@0xc0.de>
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

#import "CDXAppSettings.h"
#import "CDXAppAboutSettings.h"
#import "CDXDevice.h"

#undef ql_component
#define ql_component lcl_cModel

#undef  CDXAppSettingsShowInternals
//#define CDXAppSettingsShowInternals


enum {
    CDXAppSettingsAbout,
    CDXAppSettingsMigrationState,
    CDXAppSettingsVersionState,
    CDXAppSettingsIdleTimer,
    CDXAppSettingsCloseTapCount,
    CDXAppSettingsActionButtonsOnLeftSide,
    CDXAppSettingsDoneButtonOnLeftSide,
    CDXAppSettingsAllKeyboardSymbols,
    CDXAppSettingsCount
};

static const CDXSetting settings[] = {
    { CDXAppSettingsAbout, CDXSettingTypeSettings, @"About Card Decks" },
    { CDXAppSettingsMigrationState, CDXSettingTypeText, @"Migration" },
    { CDXAppSettingsVersionState, CDXSettingTypeText, @"Version" },
    { CDXAppSettingsIdleTimer, CDXSettingTypeBoolean, @"Idle Timer" },
    { CDXAppSettingsCloseTapCount, CDXSettingTypeEnumeration, @"Close Gesture" },
    { CDXAppSettingsActionButtonsOnLeftSide, CDXSettingTypeEnumeration, @"Action Buttons" },
    { CDXAppSettingsDoneButtonOnLeftSide, CDXSettingTypeEnumeration, @"Done Button" },
    { CDXAppSettingsAllKeyboardSymbols, CDXSettingTypeBoolean, @"All Unicode Symbols" },
    { 0, 0, @"" }
};

static NSString *settingsUserDefaultsKeys[] = {
    nil,
    @"Migration",
    @"Version",
    @"IdleTimer",
    @"CloseTapCount",
    @"ActionButtonsOnLeftSide",
    @"DoneButtonOnLeftSide",
    @"AllKeyboardSymbols",
    nil
};

typedef struct {
    NSString *title;
    unsigned int settingsCount;
    unsigned int firstIndex;
} CDXAppSettingGroup;

static const CDXAppSettingGroup groupsPhone[] = {
    { @"", 1, CDXAppSettingsAbout },
#ifdef CDXAppSettingsShowInternals
    { @"Internals", 2, CDXAppSettingsMigrationState },
#endif
    { @"Energy Saver", 1, CDXAppSettingsIdleTimer },
    { @"Card Deck", 2, CDXAppSettingsCloseTapCount },
    { @"User Interface", 1, CDXAppSettingsDoneButtonOnLeftSide },
    { @"Keyboard", 1, CDXAppSettingsAllKeyboardSymbols },
    { @"", 0, 0 }
};

static const CDXAppSettingGroup groupsPad[] = {
    { @"", 1, CDXAppSettingsAbout },
#ifdef CDXAppSettingsShowInternals
    { @"Internals", 2, CDXAppSettingsMigrationState },
#endif
    { @"Energy Saver", 1, CDXAppSettingsIdleTimer },
    { @"Card Deck", 2, CDXAppSettingsCloseTapCount },
    { @"Keyboard", 1, CDXAppSettingsAllKeyboardSymbols },
    { @"", 0, 0 }
};

static const CDXAppSettingGroup* groups = groupsPhone;
static size_t numberOfGroups = (sizeof(groupsPhone) / sizeof(CDXAppSettingGroup)) - 1;

@implementation CDXAppSettings

synthesize_singleton_definition(sharedAppSettings, CDXAppSettings);
synthesize_singleton_methods(sharedAppSettings, CDXAppSettings);

+ (void)initialize {
    synthesize_singleton_initialization_allocate(sharedAppSettings, CDXAppSettings);
    if ([[CDXDevice sharedDevice] deviceUIIdiom] == CDXDeviceUIIdiomPad) {
        groups = groupsPad;
        numberOfGroups = (sizeof(groupsPad) / sizeof(CDXAppSettingGroup)) - 1;
    }
}

+ (BOOL)userDefaultsBooleanValueForKey:(NSString *)key defaultsTo:(BOOL)defaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:key] == nil) {
        return defaults;
    }
    return [userDefaults boolForKey:key];
}

+ (void)setUserDefaultsBooleanValue:(BOOL)value forKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];    
    [userDefaults setBool:value forKey:key];
}

+ (NSInteger)userDefaultsIntegerValueForKey:(NSString *)key defaultsTo:(NSInteger)defaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:key] == nil) {
        return defaults;
    }
    return [userDefaults integerForKey:key];
}

+ (void)setUserDefaultsIntegerValue:(NSInteger)value forKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:key];
}

+ (NSString *)userDefaultsStringValueForKey:(NSString *)key defaultsTo:(NSString *)defaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults stringForKey:key] == nil) {
        return defaults;
    }
    return [userDefaults stringForKey:key];
}

+ (void)setUserDefaultsStringValue:(NSString *)value forKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
}

- (BOOL)enableIdleTimer {
    return [CDXAppSettings userDefaultsBooleanValueForKey:settingsUserDefaultsKeys[CDXAppSettingsIdleTimer] defaultsTo:NO];
}

- (BOOL)enableAllKeyboardSymbols {
    return [CDXAppSettings userDefaultsBooleanValueForKey:settingsUserDefaultsKeys[CDXAppSettingsAllKeyboardSymbols] defaultsTo:NO];
}

- (NSUInteger)closeTapCount {
    NSUInteger value = [CDXAppSettings userDefaultsIntegerValueForKey:settingsUserDefaultsKeys[CDXAppSettingsCloseTapCount] defaultsTo:1];
    if (value >= 1 && value <= 2) {
        return value;
    } else {
        return 2;
    }
}

- (BOOL)doneButtonOnLeftSide {
    return [CDXAppSettings userDefaultsBooleanValueForKey:settingsUserDefaultsKeys[CDXAppSettingsDoneButtonOnLeftSide] defaultsTo:YES];
}

- (BOOL)actionButtonsOnLeftSide {
    return [CDXAppSettings userDefaultsBooleanValueForKey:settingsUserDefaultsKeys[CDXAppSettingsActionButtonsOnLeftSide] defaultsTo:YES];
}

- (NSUInteger)migrationState {
    NSUInteger value = [CDXAppSettings userDefaultsIntegerValueForKey:settingsUserDefaultsKeys[CDXAppSettingsMigrationState] defaultsTo:0];
    return value;
}

- (void)setMigrationState:(NSUInteger)value {
    [CDXAppSettings setUserDefaultsIntegerValue:value forKey:settingsUserDefaultsKeys[CDXAppSettingsMigrationState]];
}

- (NSString *)versionState {
    NSString *value = [CDXAppSettings userDefaultsStringValueForKey:settingsUserDefaultsKeys[CDXAppSettingsVersionState] defaultsTo:@""];
    return value;
}

- (void)setVersionState:(NSString *)value {
    [CDXAppSettings setUserDefaultsStringValue:value forKey:settingsUserDefaultsKeys[CDXAppSettingsVersionState]];
}

- (NSString *)title {
    return @"Settings";
}

- (UIView *)titleView {
    return nil;
}

- (NSUInteger)numberOfGroups {
    return numberOfGroups;
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
        case CDXAppSettingsIdleTimer:
            return [self enableIdleTimer];
        case CDXAppSettingsAllKeyboardSymbols:
            return [self enableAllKeyboardSymbols];
    }
}

- (void)setBooleanValue:(BOOL)value forSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            break;
        case CDXAppSettingsIdleTimer:
        case CDXAppSettingsAllKeyboardSymbols:
            [CDXAppSettings setUserDefaultsBooleanValue:value forKey:settingsUserDefaultsKeys[tag]];
            break;
    }
}

- (NSUInteger)enumerationValueForSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return 0;
        case CDXAppSettingsCloseTapCount:
            return [self closeTapCount] - 1;
        case CDXAppSettingsDoneButtonOnLeftSide:
            return [self doneButtonOnLeftSide] ? 0 : 1;
        case CDXAppSettingsActionButtonsOnLeftSide:
            return [self actionButtonsOnLeftSide] ? 0 : 1;
    }
}

- (void)setEnumerationValue:(NSUInteger)value forSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            break;
        case CDXAppSettingsCloseTapCount:
            [CDXAppSettings setUserDefaultsIntegerValue:(value + 1) forKey:settingsUserDefaultsKeys[tag]];
            break;
        case CDXAppSettingsDoneButtonOnLeftSide:
        case CDXAppSettingsActionButtonsOnLeftSide:
            [CDXAppSettings setUserDefaultsBooleanValue:(value ? NO : YES) forKey:settingsUserDefaultsKeys[tag]];
            break;
    }
}

- (NSUInteger)enumerationValuesCountForSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return 0;
        case CDXAppSettingsMigrationState:
            return 2;
        case CDXAppSettingsCloseTapCount:
            return 2;
        case CDXAppSettingsDoneButtonOnLeftSide:
        case CDXAppSettingsActionButtonsOnLeftSide:
            return 2;
    }
}

- (NSString *)descriptionForEumerationValue:(NSUInteger)value forSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return @"";
        case CDXAppSettingsMigrationState:
            return [NSString stringWithFormat:@"%lu",(unsigned long)value];
        case CDXAppSettingsCloseTapCount:
            switch (value) {
                default:
                case 0:
                    return @"Single Tap";
                case 1:
                    return @"Double Tap";
            }
        case CDXAppSettingsDoneButtonOnLeftSide:
        case CDXAppSettingsActionButtonsOnLeftSide:
            switch (value) {
                default:
                case 0:
                    return @"On Left Side";
                case 1:
                    return @"On Right Side";
            }
    }
}

- (NSString *)textValueForSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return @"";
        case CDXAppSettingsMigrationState:
            return [NSString stringWithFormat:@"%lu", (unsigned long)[self migrationState]];
        case CDXAppSettingsVersionState:
            return [self versionState];
    }
}

- (void)setTextValue:(NSString *)value forSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            break;
        case CDXAppSettingsMigrationState:
            [self setMigrationState:[value integerValue]];
            return;
        case CDXAppSettingsVersionState:
            [self setVersionState:value];
            return;
    }
}

- (UIImage *)settingsImageForSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return nil;
            break;
        case CDXAppSettingsAbout:
            return [UIImage imageNamed:@"Cell-Logo.png"];
            break;
    }
}

- (NSObject<CDXSettings> *)settingsSettingsForSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return nil;
            break;
        case CDXAppSettingsAbout:
            return [CDXAppAboutSettings sharedAppAboutSettings];
            break;
    }
}

- (NSString *)urlActionURLForSettingWithTag:(NSUInteger)tag {
    return nil;
}

- (NSString *)htmlTextValueForSettingWithTag:(NSUInteger)tag {
    return nil;
}

@end

