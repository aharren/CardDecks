//
//
// CDXSettingsViewController.m
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

#import "CDXSettingsViewController.h"
#import "CDXKeyboardExtensions.h"
#import "CDXSymbolsKeyboardExtension.h"


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
        NSArray *paths = [NSArray arrayWithObjects:
                          [NSIndexPath indexPathForRow:value inSection:0],
                          indexPath,
                          nil];
        [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end


@interface CDXSettingsMainViewController : UITableViewController {
    
@protected
    NSObject<CDXSettings> *settings;
    
}

@end


@implementation CDXSettingsMainViewController

- (id)initWithSettings:(NSObject<CDXSettings> *)aSettings {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        ivar_assign(settings, aSettings);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.tableView.tableHeaderView = [settings titleView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[CDXSymbolsKeyboardExtension sharedSymbolsKeyboardExtension] reset];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setResponder:nil keyboardExtensions:nil];
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
    self.tableView.scrollEnabled = NO;
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
    NSArray *extensions = [NSArray arrayWithObjects:
                           [CDXSymbolsKeyboardExtension sharedSymbolsKeyboardExtension],
                           nil];
    [[CDXKeyboardExtensions sharedKeyboardExtensions] setResponder:cellText keyboardExtensions:extensions];
}

- (void)textValueChanged:(UITextField *)cellText {
    qltrace();
    self.tableView.scrollEnabled = YES;
    [settings setTextValue:cellText.text forSettingWithTag:cellText.tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifierDefault = @"DefaultCell";
    static NSString *reuseIdentifierBoolean = @"BooleanCell";
    static NSString *reuseIdentifierEnumeration = @"EnumerationCell";
    static NSString *reuseIdentifierText = @"TextCell";
    static NSString *reuseIdentifierSettings = @"SettingsCell";
    static NSString *reuseIdentifierURLAction = @"URLActionCell";
    
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
            cell.selectionStyle = self.tableView.scrollEnabled ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
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
                cellText = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 24)] autorelease];
                [cellText addTarget:self action:@selector(textStartedEditing:) forControlEvents:UIControlEventEditingDidBegin];
                [cellText addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
                [cellText addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingDidEndOnExit];
                cellText.clearButtonMode = UITextFieldViewModeWhileEditing;
                cellText.textColor = cell.detailTextLabel.textColor;
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
            cell.selectionStyle = self.tableView.scrollEnabled ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
            cell.tag = setting.tag;
            cell.textLabel.text = setting.label;
            cell.imageView.image = [settings settingsImageForSettingWithTag:setting.tag];
            return cell;
        }
        case CDXSettingTypeURLAction: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierURLAction];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierURLAction] autorelease];
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
            }
            cell.selectionStyle = self.tableView.scrollEnabled ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
            cell.tag = setting.tag;
            cell.textLabel.text = setting.label;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.tableView.scrollEnabled) {
        return;
    }
    
    CDXSetting setting = [settings settingAtIndex:indexPath.row inGroup:indexPath.section];
    switch (setting.type) {
        default: {
            break;
        }
        case CDXSettingTypeEnumeration: {
            UITableViewController *vc = [[[CDXSettingsEnumerationViewController alloc] initWithSettings:settings setting:setting] autorelease];
            vc.title = setting.label;
            [[self navigationController] pushViewController:vc animated:YES];
            break;
        }
        case CDXSettingTypeSettings: {
            NSObject<CDXSettings> *s = [settings settingsSettingsForSettingWithTag:setting.tag];
            if (s != nil) {
                UITableViewController *vc = [[[CDXSettingsMainViewController alloc] initWithSettings:s] autorelease];
                [[self navigationController] pushViewController:vc animated:YES];
            }
            break;
        }
        case CDXSettingTypeURLAction: {
            NSString *url = [settings urlActionURLForSettingWithTag:setting.tag];
            if (url != nil) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            }
            break;
        }
    }
}

@end


@implementation CDXSettingsViewController

- (id)initWithSettings:(NSObject<CDXSettings> *)aSettings {
    if ((self = [super init])) {
        ivar_assign_and_retain(settings, aSettings);
        UITableViewController *vc = [[[CDXSettingsMainViewController alloc] initWithSettings:settings] autorelease];
        vc.title = [settings title];
        vc.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                                 initWithTitle:@"Done"
                                                 style:UIBarButtonItemStyleDone
                                                 target:self
                                                 action:@selector(closeButtonPressed)]
                                                autorelease];
        vc.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc]
                                                initWithTitle:@"Settings"
                                                style:UIBarButtonItemStylePlain
                                                target:nil
                                                action:nil]
                                               autorelease];
        [self pushViewController:vc animated:NO];
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(settings);
    [super dealloc];
}

- (IBAction)closeButtonPressed {
    [self dismissModalViewControllerAnimated:YES];
}

@end

