//
//
// CDXDevice.m
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

#import "CDXDevice.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation CDXDevice

@synthesize deviceType;
@synthesize deviceUIIdiom;
@synthesize useReducedGraphicsEffects;

synthesize_singleton(sharedDevice, CDXDevice);

- (id)init {
    if ((self = [super init])) {
        CGFloat deviceScreenScale = [[UIScreen mainScreen] scale];
        useReducedGraphicsEffects = NO;
        UIDevice* device = [UIDevice currentDevice];
        NSString *deviceModel = [device model];
        deviceModel = [deviceModel lowercaseString];
        if ([deviceModel hasSuffix:@"simulator"]) {
            deviceType = CDXDeviceTypeSimulator;
        } else if ([deviceModel isEqualToString:@"iphone"]) {
            deviceType = CDXDeviceTypeiPhone;
            useReducedGraphicsEffects = (deviceScreenScale <= 1.0);
        } else if ([deviceModel isEqualToString:@"ipod touch"]) {
            deviceType = CDXDeviceTypeiPodTouch;
            useReducedGraphicsEffects = (deviceScreenScale <= 1.0);
        } else if ([deviceModel isEqualToString:@"ipad"]) {
            deviceType = CDXDeviceTypeiPad;
            useReducedGraphicsEffects = (deviceScreenScale <= 1.0);
        }
        UIUserInterfaceIdiom userInterfaceIdiom = [device userInterfaceIdiom];
        if (userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            deviceUIIdiom = CDXDeviceUIIdiomPad;
        } else {
            deviceUIIdiom = CDXDeviceUIIdiomPhone;
        }
        qltrace(@"%@ %d %d", deviceModel, deviceType, deviceUIIdiom);
    }
    return self;
}

- (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end

