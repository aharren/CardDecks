//
//
// CDXSettings.h
//
//
// Copyright (c) 2009-2018 Arne Harren <ah@0xc0.de>
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


typedef enum {
    CDXSettingTypeBoolean,
    CDXSettingTypeEnumeration,
    CDXSettingTypeText,
    CDXSettingTypeSettings,
    CDXSettingTypeURLAction,
    CDXSettingTypeHTMLText,
    CDXSettingTypeCount
} CDXSettingType;


typedef struct {
    NSUInteger tag;
    CDXSettingType type;
    NSString *label;
} CDXSetting;


@protocol CDXSettings

- (NSString *)title;
- (UIView *)titleView;

- (NSUInteger)numberOfGroups;
- (NSString *)titleForGroup:(NSUInteger)group;
- (NSUInteger)numberOfSettingsInGroup:(NSUInteger)group;
- (CDXSetting)settingAtIndex:(NSUInteger)index inGroup:(NSUInteger)group;

- (BOOL)booleanValueForSettingWithTag:(NSUInteger)tag;
- (void)setBooleanValue:(BOOL)value forSettingWithTag:(NSUInteger)tag;

- (NSUInteger)enumerationValueForSettingWithTag:(NSUInteger)tag;
- (void)setEnumerationValue:(NSUInteger)value  forSettingWithTag:(NSUInteger)tag;

- (NSUInteger)enumerationValuesCountForSettingWithTag:(NSUInteger)tag;
- (NSString *)descriptionForEumerationValue:(NSUInteger)value forSettingWithTag:(NSUInteger)tag;

- (NSString *)textValueForSettingWithTag:(NSUInteger)tag;
- (void)setTextValue:(NSString *)value forSettingWithTag:(NSUInteger)tag;

- (UIImage *)settingsImageForSettingWithTag:(NSUInteger)tag;
- (NSObject<CDXSettings> *)settingsSettingsForSettingWithTag:(NSUInteger)tag;

- (NSString *)urlActionURLForSettingWithTag:(NSUInteger)tag;

- (NSString *)htmlTextValueForSettingWithTag:(NSUInteger)tag;

@end

