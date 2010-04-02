//
//
// CDXCard.m
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

#import "CDXCard.h"


@implementation CDXCard

#define LogFileComponent lcl_cCDXCard

@synthesize text = _text;
@synthesize textColor = _textColor;
@synthesize backgroundColor = _backgroundColor;
@synthesize orientation = _orientation;

@synthesize committed = _committed;
@synthesize dirty = _dirty;

- (id)init {
    LogInvocation();
    
    if ((self = [super init])) {
        self.text = @"";
        self.textColor = [CDXColor whiteColor];
        self.backgroundColor = [CDXColor blackColor];
        _orientation = CDXCardOrientationUp;
    }
    return self;
}

- (id)initWithContentsOfDictionary:(NSDictionary *)dictionary {
    LogInvocation();
    
    if ((self = [super init])) {
        LogDebug(@"dictionary %@", dictionary);
        
        NSObject *object;
        
        object = [dictionary objectForKey:@"Text"];
        if (object == nil || ![object isKindOfClass:[NSString class]]) {
            self.text = @"";
        } else {
            self.text = (NSString *)object;
        }
        
        object = [dictionary objectForKey:@"TextColor"];
        if (object == nil || ![object isKindOfClass:[NSString class]]) {
            self.textColor = [CDXColor whiteColor];
        } else {
            self.textColor = [CDXColor cdxColorWithRGBString:(NSString *)object defaulsTo:[CDXColor whiteColor]];
        }
        
        object = [dictionary objectForKey:@"BackgroundColor"];
        if (object == nil || ![object isKindOfClass:[NSString class]]) {
            self.backgroundColor = [CDXColor blackColor];
        } else {
            self.backgroundColor = [CDXColor cdxColorWithRGBString:(NSString *)object defaulsTo:[CDXColor blackColor]];
        }
        
        object = [dictionary objectForKey:@"Orientation"];
        if (object == nil || ![object isKindOfClass:[NSString class]]) {
            self.orientation = CDXCardOrientationUp;
        } else {
            self.orientation = [CDXCardOrientationHelper cardOrientationFromString:(NSString *)object];
        }
        
        _committed = YES;
        _dirty = NO;
    }
    
    return self;
}

- (void)dealloc {
    LogInvocation();
    
    self.text = nil;
    self.backgroundColor = nil;
    self.textColor = nil;
    
    [super dealloc];
}

- (NSDictionary *)stateAsDictionary {
    LogInvocation();
    
    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dictionary setValue:_text forKey:@"Text"];
    [dictionary setValue:[_backgroundColor rgbString] forKey:@"BackgroundColor"];
    [dictionary setValue:[_textColor rgbString] forKey:@"TextColor"];
    [dictionary setValue:[CDXCardOrientationHelper stringFromCardOrientation:_orientation] forKey:@"Orientation"];
    LogDebug(@"dictionary %@", dictionary);
    
    return dictionary;
}

+ (CDXCard *)cardWithContentsOfDictionary:(NSDictionary *)dictionary {
    LogInvocation();
    
    return [[[CDXCard alloc] initWithContentsOfDictionary:dictionary] autorelease];
}

@end

