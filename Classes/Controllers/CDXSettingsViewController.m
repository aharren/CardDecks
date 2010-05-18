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


@implementation CDXSettingsViewController

- (id)initWithSettings:(NSObject<CDXSettings> *)aSettings {
    if ((self = [super initWithNibName:@"CDXSettingsView" bundle:nil])) {
        ivar_assign_and_retain(settings, aSettings);
    }
    return self;
}

- (void)dealloc {
    ivar_release_and_clear(settingsTableView);
    ivar_release_and_clear(settingsNavigationItem);
    ivar_release_and_clear(settings);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    settingsNavigationItem.title = [settings title];
}

- (void)viewDidUnload {
    ivar_release_and_clear(settingsTableView);
    ivar_release_and_clear(settingsNavigationItem);
    [super viewDidUnload];
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
    [settings setBooleanValue:cellSwitch.on forSettingWithTag:cellSwitch.tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifierDefault = @"DefaultCell";
    static NSString *reuseIdentifierBoolean = @"BooleanCell";
    
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
    }
}

- (IBAction)closeButtonPressed {
    [self dismissModalViewControllerAnimated:YES];
}

@end

