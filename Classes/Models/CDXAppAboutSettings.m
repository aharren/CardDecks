//
//
// CDXAppAboutSettings.m
//
//
// Copyright (c) 2009-2012 Arne Harren <ah@0xc0.de>
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

#import "CDXAppAboutSettings.h"
#import "CDXApplicationVersion.h"
#import "CDXDevice.h"

#undef ql_component
#define ql_component lcl_cModel


enum {
    CDXAppAboutSettingsFeedback,
    CDXAppAboutSettingsSite,
    CDXAppAboutSettingsReleaseNotes,
    CDXAppAboutSettingsLegal,
    CDXAppAboutSettingsDeviceInfo,
    CDXAppAboutSettingsCount
};

static const CDXSetting settings[] = {
    { CDXAppAboutSettingsFeedback, CDXSettingTypeURLAction, @"Feedback" },
    { CDXAppAboutSettingsSite, CDXSettingTypeURLAction, @"0xc0.de/CardDecks" },
    { CDXAppAboutSettingsReleaseNotes, CDXSettingTypeHTMLText, @"Release Notes" },
    { CDXAppAboutSettingsLegal, CDXSettingTypeHTMLText, @"Legal" },
    { CDXAppAboutSettingsDeviceInfo, CDXSettingTypeHTMLText, @"Device Information" },
    { 0, 0, @"" }
};

typedef struct {
    NSString *title;
    unsigned int settingsCount;
    unsigned int firstIndex;
} CDXAppSettingGroup;

static const CDXAppSettingGroup groups[] = {
    { @"", 2, CDXAppAboutSettingsFeedback },
    { @"", 2, CDXAppAboutSettingsReleaseNotes },
    { @"", 1, CDXAppAboutSettingsDeviceInfo },
    { @"", 0, 0 }
};


@implementation CDXAppAboutSettings

synthesize_singleton(sharedAppAboutSettings, CDXAppAboutSettings);

- (NSString *)title {
    return @"About";
}

- (UIView *)titleView {
    [[NSBundle mainBundle] loadNibNamed:@"CDXAppAboutSettingsTitleView" owner:self options:nil];
    UIView *view = [[titleView retain] autorelease];
    titleViewVersion.text = CDXApplicationVersion;
    ivar_release_and_clear(titleView);
    ivar_release_and_clear(titleViewVersion);
    return view;
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
    }
}

- (void)setBooleanValue:(BOOL)value forSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
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

- (UIImage *)settingsImageForSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return nil;
            break;
    }
}

- (NSObject<CDXSettings> *)settingsSettingsForSettingWithTag:(NSUInteger)tag {
    return self;
}

- (NSString *)urlActionURLForSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return nil;
            break;
        case CDXAppAboutSettingsFeedback:
            return @"mailto:carddecks@0xc0.de?subject=CardDecks " CDXApplicationVersion ": Feedback";
            break;
        case CDXAppAboutSettingsSite:
            return @"http://0xc0.de/CardDecks?m" CDXApplicationVersion "";
            break;
    }
}

- (NSString *)htmlTextValueForSettingWithTag:(NSUInteger)tag {
    switch (tag) {
        default:
            return nil;
            break;
        case CDXAppAboutSettingsReleaseNotes: {
            NSString *folder = [NSHomeDirectory() stringByAppendingPathComponent:@"CardDecks.app"];
            NSString *path = [folder stringByAppendingPathComponent:@"ReleaseNotes.html"];
            NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
            return text;
            break;
        }
        case CDXAppAboutSettingsLegal: {
            NSString *folder = [NSHomeDirectory() stringByAppendingPathComponent:@"CardDecks.app"];
            NSString *path = [folder stringByAppendingPathComponent:@"Legal.html"];
            NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
            return text;
            break;
        }
        case CDXAppAboutSettingsDeviceInfo: {
            NSString *folder = [NSHomeDirectory() stringByAppendingPathComponent:@"CardDecks.app"];
            NSString *path = [folder stringByAppendingPathComponent:@"Template.html"];
            NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
            
            text = [text stringByReplacingOccurrencesOfString:@"$title$" withString:@"Device Information"];
            
            CDXDevice *device = [CDXDevice sharedDevice];
            NSMutableString *content = [[[NSMutableString alloc] init] autorelease];
            [content appendString:@"<table style=\"border-spacing:0px;font-family:Helvetica,sans-serif;font-size:12px;font-weight:700;color:#999999;background-color:#ffffff\">"];
            [content appendFormat:@"<tr><td>%@</td><td>:</td><td>%@</td></tr>\n", @"System version", [device deviceSystemVersionString]];
            [content appendFormat:@"<tr><td>%@</td><td>:</td><td>%@</td></tr>\n", @"Model", [device deviceModel]];
            [content appendFormat:@"<tr><td>%@</td><td>:</td><td>%@</td></tr>\n", @"Machine", [device deviceMachine]];
            [content appendFormat:@"<tr><td>%@</td><td>:</td><td>%@</td></tr>\n", @"Type", [device deviceTypeString]];
            [content appendFormat:@"<tr><td>%@</td><td>:</td><td>%@</td></tr>\n", @"UI idiom", [device deviceUIIdiomString]];
            [content appendFormat:@"<tr><td>%@</td><td>:</td><td>%.1f</td></tr>\n", @"Screen scale", [device deviceScreenScale]];
            [content appendFormat:@"<tr><td>%@</td><td>:</td><td>%@</td></tr>\n", @"Graphics effects", [device useReducedGraphicsEffects] ? @"reduced" : @"full"];
            [content appendFormat:@"<tr><td>%@</td><td>:</td><td>%@</td></tr>\n", @"Rendering mode", [device useImageBasedRendering] ? @"image" : @"direct"];
            [content appendFormat:@"<tr><td>%@</td><td>:</td><td>%@</td></tr>\n", @"Twitter integration", [device hasTwitterIntegration] ? @"yes" : @"no"];
            [content appendFormat:@"<tr><td>%@</td><td>:</td><td>%@</td></tr>\n", @"Adaptive status bar", [device hasAdaptiveStatusBar] ? @"yes" : @"no"];
            [content appendString:@"</table>"];
            text = [text stringByReplacingOccurrencesOfString:@"$content$" withString:content];
            
            return text;
            break;
        }
    }
}

@end

