//
//
// CDXSettings.m
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

#import "CDXSettings.h"


@implementation CDXSettings

typedef struct {
    NSString *key;
    NSString *label;
    BOOL defaults;
} CDXSettingsKeyLabelDefault;

static CDXSettingsKeyLabelDefault settingsKeyLabelDefaults[CDXSettingsKeyCount] = {
    { @"show_status_bar",     @"Status Bar",         NO  },
    { @"show_page_control",   @"Page Control",       NO  },
    { @"enable_auto_rotate",  @"Auto Rotate",        NO  },
    { @"enable_shake_random", @"Shake for Random",   YES },
    { @"enable_idle_timer",   @"Idle Timer",         NO  },
    { @"enable_all_symbols",  @"Full Symbol Table",  NO  }
};

+ (BOOL)userDefaultsBoolForKey:(NSString *)key defaults:(BOOL)defaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:key] == nil) {
        return defaults;
    }
    return [userDefaults boolForKey:key];
}

+ (BOOL)boolForKey:(CDXSettingsKey)key {
    return [CDXSettings userDefaultsBoolForKey:settingsKeyLabelDefaults[key].key defaults:settingsKeyLabelDefaults[key].defaults];
}

+ (void)setBool:(BOOL)value forKey:(CDXSettingsKey)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setBool:value forKey:settingsKeyLabelDefaults[key].key];
}

+ (NSString *)labelForKey:(CDXSettingsKey)key {
    return settingsKeyLabelDefaults[key].label;
}

+ (BOOL)showStatusBar {
    return [CDXSettings boolForKey:CDXSettingsKeyShowStatusBar];
}

+ (BOOL)showPageControl {
    return [CDXSettings boolForKey:CDXSettingsKeyShowPageControl];
}

+ (BOOL)enableAutoRotate {
    return [CDXSettings boolForKey:CDXSettingsKeyEnableAutoRotate];
}

+ (BOOL)enableShakeRandom {
    return [CDXSettings boolForKey:CDXSettingsKeyEnableShakeRandom];
}

+ (BOOL)enableIdleTimer {
    return [CDXSettings boolForKey:CDXSettingsKeyEnableIdleTimer];
}

+ (BOOL)enableAllSymbols {
    return [CDXSettings boolForKey:CDXSettingsKeyEnableAllSymbols];
}

@end

