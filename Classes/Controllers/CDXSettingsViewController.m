//
//
// CDXSettingsViewController.m
//
//
// Copyright (c) 2009-2020 Arne Harren <ah@0xc0.de>
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

#import "CDXSettingsViewController.h"
#import "CDXKeyboardExtensions.h"
#import "CDXSymbolsKeyboardExtension.h"
#import "CDXAppSettings.h"
#import "CDXDevice.h"

#undef ql_component
#define ql_component lcl_cController


@interface CDXSettingsEnumerationViewController : UITableViewController {
    
@protected
    NSObject<CDXSettings> *settings;
    CDXSetting setting;
    
}

@end


@implementation CDXSettingsEnumerationViewController

- (id)initWithSettings:(NSObject<CDXSettings> *)aSettings setting:(CDXSetting)aSetting {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        ivar_assign(settings, aSettings);
        setting = aSetting;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 6)] autorelease];
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [settings enumerationValuesCountForSettingWithTag:setting.tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    cell.textLabel.text = [settings descriptionForEumerationValue:indexPath.row forSettingWithTag:setting.tag];
    if (indexPath.row == [settings enumerationValueForSettingWithTag:setting.tag]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger value = [settings enumerationValueForSettingWithTag:setting.tag];
    if (value != indexPath.row) {
        [settings setEnumerationValue:indexPath.row forSettingWithTag:setting.tag];
        NSArray *paths = @[[NSIndexPath indexPathForRow:value inSection:0],
                          indexPath];
        [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end


@interface CDXSettingsHTMLTextViewController : UIViewController {
    
@protected
    NSObject<CDXSettings> *settings;
    CDXSetting setting;
    
    UIWebView *viewWebView;
}

@end


@implementation CDXSettingsHTMLTextViewController

- (id)initWithSettings:(NSObject<CDXSettings> *)aSettings setting:(CDXSetting)aSetting {
    if ((self = [super init])) {
        ivar_assign(settings, aSettings);
        setting = aSetting;
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(viewWebView);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ivar_assign(viewWebView, [[UIWebView alloc] init]);
    [viewWebView loadHTMLString:[settings htmlTextValueForSettingWithTag:setting.tag] baseURL:nil];
    self.view = viewWebView;
}

@end


@interface CDXSettingsMainViewController : UITableViewController {
    
@protected
    NSObject<CDXSettings> *settings;
    BOOL isRootView;
    
}

@end


@implementation CDXSettingsMainViewController

- (id)initWithSettings:(NSObject<CDXSettings> *)aSettings isRootView:(BOOL)aIsRootView {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        ivar_assign(settings, aSettings);
        isRootView = aIsRootView;
    }
    return self;
}

- (IBAction)closeButtonPressed {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.tableView.tableHeaderView = [settings titleView];
    if (!self.tableView.tableHeaderView) {
        self.tableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 6)] autorelease];
        self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    }
    self.navigationItem.title = [settings title];
    if (isRootView && [[CDXDevice sharedDevice] deviceUIIdiom] != CDXDeviceUIIdiomPad) {
        UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc]
                                        initWithTitle:@"Done"
                                        style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(closeButtonPressed)]
                                       autorelease];
        if ([[CDXAppSettings sharedAppSettings] doneButtonOnLeftSide]) {
            self.navigationItem.leftBarButtonItem = doneButton;
            self.navigationItem.rightBarButtonItem = nil;
        } else {
            self.navigationItem.rightBarButtonItem = doneButton;
            self.navigationItem.leftBarButtonItem = nil;
        }
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc]
                                                  initWithTitle:@"Settings"
                                                  style:UIBarButtonItemStylePlain
                                                  target:nil
                                                  action:nil]
                                                 autorelease];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSArray *extensions = @[[CDXSymbolsKeyboardExtension sharedSymbolsKeyboardExtension]];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setResponder:self keyboardExtensions:extensions];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setEnabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[CDXKeyboardExtensions sharedKeyboardExtensions] removeResponder];
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [settings numberOfGroups];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [settings numberOfSettingsInGroup:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [settings titleForGroup:section];
}

- (void)booleanValueChanged:(UISwitch *)cellSwitch {
    qltrace();
    [settings setBooleanValue:cellSwitch.on forSettingWithTag:cellSwitch.tag];
}

- (void)textStartedEditing:(UITextField *)cellText {
    qltrace();
    NSArray *extensions = @[[CDXSymbolsKeyboardExtension sharedSymbolsKeyboardExtension]];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setResponder:cellText keyboardExtensions:extensions];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setEnabled:YES];
}

- (void)textValueChanged:(UITextField *)cellText {
    qltrace();
    [settings setTextValue:cellText.text forSettingWithTag:cellText.tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifierDefault = @"DefaultCell";
    static NSString *reuseIdentifierBoolean = @"BooleanCell";
    static NSString *reuseIdentifierEnumeration = @"EnumerationCell";
    static NSString *reuseIdentifierText = @"TextCell";
    static NSString *reuseIdentifierSettings = @"SettingsCell";
    static NSString *reuseIdentifierURLAction = @"URLActionCell";
    static NSString *reuseIdentifierHTMLText = @"HTMLTextCell";
    
    CDXSetting setting = [settings settingAtIndex:indexPath.row inGroup:indexPath.section];
    
    switch (setting.type) {
        default: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDefault];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierDefault] autorelease];
            }
            return cell;
        }
        case CDXSettingTypeBoolean: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierBoolean];
            UISwitch *cellSwitch = nil;
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierBoolean] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellSwitch = [[[UISwitch alloc] init] autorelease];
                [cellSwitch addTarget:self action:@selector(booleanValueChanged:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = cellSwitch;
            } else {
                cellSwitch = (UISwitch *)cell.accessoryView;
            }
            cell.tag = setting.tag;
            cell.textLabel.text = setting.label;
            cellSwitch.tag = setting.tag;
            cellSwitch.on = [settings booleanValueForSettingWithTag:setting.tag];
            return cell;
        }
        case CDXSettingTypeEnumeration: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierEnumeration];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifierEnumeration] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.tag = setting.tag;
            cell.textLabel.text = setting.label;
            NSUInteger enumValue = [settings enumerationValueForSettingWithTag:setting.tag];
            cell.detailTextLabel.text = [settings descriptionForEumerationValue:enumValue forSettingWithTag:setting.tag];
            return cell;
        }
        case CDXSettingTypeText: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierText];
            UITextField *cellText = nil;
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifierText] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellText = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 22)] autorelease];
                [cellText addTarget:self action:@selector(textStartedEditing:) forControlEvents:UIControlEventEditingDidBegin];
                [cellText addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
                [cellText addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingDidEndOnExit];
                cellText.clearButtonMode = UITextFieldViewModeWhileEditing;
                cellText.textColor = cell.detailTextLabel.textColor;
                cellText.returnKeyType = UIReturnKeyDone;
                cell.accessoryView = cellText;
            } else {
                cellText = (UITextField *)cell.accessoryView;
            }
            cell.tag = setting.tag;
            cell.textLabel.text = setting.label;
            cellText.tag = setting.tag;
            cellText.text = [settings textValueForSettingWithTag:setting.tag];
            cellText.userInteractionEnabled = YES;
            return cell;
        }
        case CDXSettingTypeSettings: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSettings];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierSettings] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.tag = setting.tag;
            cell.textLabel.text = setting.label;
            cell.imageView.image = [settings settingsImageForSettingWithTag:setting.tag];
            return cell;
        }
        case CDXSettingTypeURLAction: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierURLAction];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierURLAction] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.tag = setting.tag;
            cell.textLabel.text = setting.label;
            return cell;
        }
        case CDXSettingTypeHTMLText: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierHTMLText];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierHTMLText] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.tag = setting.tag;
            cell.textLabel.text = setting.label;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CDXSetting setting = [settings settingAtIndex:indexPath.row inGroup:indexPath.section];
    switch (setting.type) {
        default: {
            break;
        }
        case CDXSettingTypeEnumeration: {
            UIViewController *vc = [[[CDXSettingsEnumerationViewController alloc] initWithSettings:settings setting:setting] autorelease];
            vc.title = setting.label;
            [[self navigationController] pushViewController:vc animated:YES];
            break;
        }
        case CDXSettingTypeText: {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([cell.accessoryView isKindOfClass:[UITextField class]]) {
                UITextField *cellText = (UITextField *)cell.accessoryView;
                [cellText becomeFirstResponder];
            }
        }
        case CDXSettingTypeSettings: {
            NSObject<CDXSettings> *s = [settings settingsSettingsForSettingWithTag:setting.tag];
            if (s != nil) {
                UIViewController *vc = [[[CDXSettingsMainViewController alloc] initWithSettings:s isRootView:NO] autorelease];
                [[self navigationController] pushViewController:vc animated:YES];
            }
            break;
        }
        case CDXSettingTypeURLAction: {
            NSString *url = [settings urlActionURLForSettingWithTag:setting.tag];
            if (url != nil) {
                NSDictionary* options = [[[NSDictionary alloc] init] autorelease];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:options completionHandler:^(BOOL success) {
                }];
            }
            break;
        }
        case CDXSettingTypeHTMLText: {
            UIViewController *vc = [[[CDXSettingsHTMLTextViewController alloc] initWithSettings:settings setting:setting] autorelease];
            vc.title = setting.label;
            [[self navigationController] pushViewController:vc animated:YES];
            break;
        }
    }
}

@end


@implementation CDXSettingsViewController

- (id)initWithSettings:(NSObject<CDXSettings> *)aSettings {
    if ((self = [super init])) {
        ivar_assign_and_retain(settings, aSettings);
        UITableViewController *vc = [[[CDXSettingsMainViewController alloc] initWithSettings:settings isRootView:YES] autorelease];
        [self pushViewController:vc animated:NO];
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(settings);
    [super dealloc];
}

@end

