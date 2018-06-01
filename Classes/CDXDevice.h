//
//
// CDXDevice.h
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
    CDXDeviceTypeUnknown = 0,
    CDXDeviceTypeSimulator,
    CDXDeviceTypeiPhone,
    CDXDeviceTypeiPodTouch,
    CDXDeviceTypeiPad,
    CDXDeviceTypeCount
} CDXDeviceType;

typedef enum {
    CDXDeviceUIIdiomPhone = 0,
    CDXDeviceUIIdiomPad = 1,
} CDXDeviceUIIdiom;

@interface CDXDevice : NSObject {
    
@protected
    CDXDeviceType deviceType;
    CDXDeviceUIIdiom deviceUIIdiom;
    
}

@property (nonatomic, readonly) NSString* deviceModel;
@property (nonatomic, readonly) NSString* deviceMachine;

@property (nonatomic, readonly) CDXDeviceType deviceType;
@property (nonatomic, readonly) NSString* deviceTypeString;
@property (nonatomic, readonly) CDXDeviceUIIdiom deviceUIIdiom;
@property (nonatomic, readonly) NSString* deviceUIIdiomString;
@property (nonatomic, readonly) CGFloat deviceScreenScale;
@property (nonatomic, readonly) CGSize deviceScreenSize;

@property (nonatomic, readonly) NSString* deviceSystemVersionString;

@property (nonatomic, readonly) BOOL useImageBasedRendering;
@property (nonatomic, readonly) BOOL useLargeTitles;

- (void)vibrate;

declare_singleton(sharedDevice, CDXDevice);

@end

