//
//
// CDXAppSettings.m
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

#import "CDXAppSettings.h"

#undef ql_component
#define ql_component lcl_cCDXModel


enum {
    CDXAppSettingsIdleTimer,
    CDXAppSettingsCount
};

static const CDXSetting settings[] = {
    { CDXAppSettingsIdleTimer, CDXSettingTypeBoolean, @"Idle Timer" },
    { 0, 0, @"" }
};

static NSString *settingsUserDefaultsKeys[] = {
    @"enable_idle_timer",
    nil
};

typedef struct {
    NSString *title;
    unsigned int settingsCount;
    unsigned int firstIndex;
} CDXAppSettingGroup;

static const CDXAppSettingGroup groups[] = {
    { @"Energy Saver", 1, CDXAppSettingsIdleTimer },
    { @"", 0, 0 }
};


@implementation CDXAppSettings

synthesize_singleton(sharedAppSettings, CDXAppSettings);

+ (BOOL)userDefaultsBooleanValueForKey:(NSString *)key defaults:(BOOL)defaults {
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

- (BOOL)enableIdleTimer {
    return [CDXAppSettings userDefaultsBooleanValueForKey:settingsUserDefaultsKeys[CDXAppSettingsIdleTimer] defaults:NO];
}

- (NSString *)title {
    return @"Settings";
}

- (NSUInteger)numberOfGroups {
    return (sizeof(groups) / sizeof(CDXAppSettingGroup)) - 1;
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
    }
}

- (void)setBooleanValue:(BOOL)value forSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            break;
        case CDXAppSettingsIdleTimer:
            [CDXAppSettings setUserDefaultsBooleanValue:value forKey:settingsUserDefaultsKeys[tag]];
            break;
    }
}

- (NSUInteger)enumerationValueForSettingWithTag:(NSUInteger)tag {
    return 0;
}

- (void)setEnumerationValue:(NSUInteger)value  forSettingWithTag:(NSUInteger)tag {
}

- (NSUInteger)enumerationValuesCountForSettingWithTag:(NSUInteger)tag {
    return 0;
}

- (NSString *)descriptionForEumerationValue:(NSUInteger)value forSettingWithTag:(NSUInteger)tag {
    return @"";
}

- (NSString *)textValueForSettingWithTag:(NSUInteger)tag {
    return @"";
}

- (void)setTextValue:(NSString *)value forSettingWithTag:(NSUInteger)tag {
}

@end

