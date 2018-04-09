//
//
// CDXDevice.m
//
//
// Copyright (c) 2009-2015 Arne Harren <ah@0xc0.de>
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

#import "CDXDevice.h"
#import "CDXMacros.h"
#import <AudioToolbox/AudioToolbox.h>
#import <sys/types.h>
#import <sys/sysctl.h>


@implementation CDXDevice

@synthesize deviceModel;
@synthesize deviceMachine;
@synthesize deviceType;
@synthesize deviceTypeString;
@synthesize deviceUIIdiom;
@synthesize deviceUIIdiomString;
@synthesize deviceScreenScale;
@synthesize deviceScreenSize;
@synthesize deviceSystemVersionString;
@synthesize useImageBasedRendering;

synthesize_singleton(sharedDevice, CDXDevice);

static NSString* CDXDeviceGetSystemInformationByName(const char* name) {
    size_t bufferSize;
    if (sysctlbyname(name, NULL, &bufferSize, NULL, 0) != 0) {
        return nil;
    }
    
    char *buffer = malloc(bufferSize);
    NSString *value = nil;
    if (sysctlbyname(name, buffer, &bufferSize, NULL, 0) == 0) {
        value = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    
    return value;
}

- (id)init {
    if ((self = [super init])) {
        deviceType = CDXDeviceTypeUnknown;
        deviceScreenScale = [[UIScreen mainScreen] scale];
        deviceScreenSize = [[UIScreen mainScreen] nativeBounds].size;
        ivar_assign_and_copy(deviceSystemVersionString, [[UIDevice currentDevice] systemVersion]);
        
        UIDevice* device = [UIDevice currentDevice];
        ivar_assign_and_copy(deviceModel, [[device model] lowercaseString]);
        ivar_assign_and_copy(deviceMachine, [CDXDeviceGetSystemInformationByName("hw.machine") lowercaseString]);
        
        // set type of device
        if ([deviceModel hasSuffix:@"simulator"]) {
            deviceType = CDXDeviceTypeSimulator;
            ivar_assign_and_copy(deviceTypeString, @"simulator");
        } else if ([deviceModel isEqualToString:@"iphone"]) {
            deviceType = CDXDeviceTypeiPhone;
            ivar_assign_and_copy(deviceTypeString, @"iphone");
        } else if ([deviceModel isEqualToString:@"ipod touch"]) {
            deviceType = CDXDeviceTypeiPodTouch;
            ivar_assign_and_copy(deviceTypeString, @"ipod touch");
        } else if ([deviceModel isEqualToString:@"ipad"]) {
            deviceType = CDXDeviceTypeiPad;
            ivar_assign_and_copy(deviceTypeString, @"ipad");
        } else {
            deviceType = CDXDeviceTypeUnknown;
            ivar_assign_and_copy(deviceTypeString, @"unknown");
        }
        
        // set UI idiom
        if ([device userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            deviceUIIdiom = CDXDeviceUIIdiomPad;
            ivar_assign_and_copy(deviceUIIdiomString, @"pad");
        } else {
            deviceUIIdiom = CDXDeviceUIIdiomPhone;
            ivar_assign_and_copy(deviceUIIdiomString, @"phone");
        }
        
        // use image-based rendering on devices with non-retina displays, and
        // first-retina-generations of iPhone and iPod
        useImageBasedRendering = (deviceScreenScale <= 1.0) || ([deviceMachine hasPrefix:@"iphone3,"]) || ([deviceMachine hasPrefix:@"ipod4,"]);
        
        qltrace(@"%@ %@ %d %d %f %f-%f %@ %d", deviceModel, deviceMachine, deviceType, deviceUIIdiom, deviceScreenScale, deviceScreenSize.width, deviceScreenSize.height, deviceSystemVersionString, useImageBasedRendering ? 1 : 0);
    }
    return self;
}

- (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end

