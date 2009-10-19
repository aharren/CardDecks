//
//
// CDXStorage.m
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

#import "CDXStorage.h"
#import <sys/time.h>


@implementation CDXStorage

#define LogFileComponent lcl_cCDXStorage

static NSMutableArray *_deferredUpdates = nil;
static NSMutableArray *_deferredRemoves = nil;

+ (void)initialize {
    LogInvocation();
    
    _deferredUpdates = [[NSMutableArray alloc] init];
    _deferredRemoves = [[NSMutableArray alloc] init];
}

+ (NSDictionary *)readAsDictionary:(NSString *)storageName {
    LogInvocation(@"%@", storageName);
    
    // create the file name
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", storageName];
    
    // first, look in 'Documents' folder
    {
        NSString *folder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *path = [folder stringByAppendingPathComponent:fileName];
        LogDebug(@"path1 %@", path);
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dictionary != nil) {
            return dictionary;
        }
    }
    
    // second, look in application bundle
    {
        NSString *folder = [NSHomeDirectory() stringByAppendingPathComponent:@"CardDecks.app"];
        NSString *path = [folder stringByAppendingPathComponent:fileName];
        LogDebug(@"path2 %@", path);
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dictionary != nil) {
            return dictionary;
        }
    }
    
    return nil;
}

+ (void)update:(NSObject<CDXStorageable> *)object deferred:(BOOL)deferred {
    LogInvocation(@"%@:%d", [object storageName], deferred);
    
    if (object == nil) {
        return;
    }
    
    [object retain];
    
    if (deferred) {
        [CDXStorage cancelDeferred:object];
        [_deferredUpdates addObject:object];
    } else {
        NSString *fileName = [NSString stringWithFormat:@"%@.plist", [object storageName]];        
        
        // update file in 'Documents' folder
        NSString *folder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *path = [folder stringByAppendingPathComponent:fileName];
        LogDebug(@"path %@", path);
        
        [[object stateAsDictionary] writeToFile:path atomically:YES];        
    }
    
    [object release];
}

+ (void)remove:(NSObject<CDXStorageable> *)object deferred:(BOOL)deferred {
    LogInvocation(@"%@:%d", [object storageName], deferred);
    
    if (object == nil) {
        return;
    }
    
    [object retain];
    
    if (deferred) {
        [CDXStorage cancelDeferred:object];
        [_deferredRemoves addObject:object];
    } else {
        NSString *fileName = [NSString stringWithFormat:@"%@.plist", [object storageName]];
        
        // update file in 'Documents' folder
        NSString *folder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *path = [folder stringByAppendingPathComponent:fileName];
        LogDebug(@"path %@", path);
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
    
    [object release];
}

+ (void)drainDeferred:(NSObject<CDXStorageable> *)object {
    LogInvocation(@"%@ (updates:%d removes:%d)", [object storageName], [_deferredUpdates count], [_deferredRemoves count]);
    
    [object retain];
    
    NSString *storageName = [object storageName];
    NSUInteger indexPlus1;
    
    indexPlus1 = [_deferredUpdates count];
    for (;indexPlus1 > 0; indexPlus1--) {
        NSObject<CDXStorageable> *object = (NSObject<CDXStorageable> *)[_deferredUpdates objectAtIndex:indexPlus1-1];
        if (storageName == nil || [[object storageName] isEqualToString:storageName]) {
            [CDXStorage update:object deferred:NO];
            [_deferredUpdates removeObjectAtIndex:indexPlus1-1];
        }
    }
    if ([_deferredUpdates count] == 0) {
        [_deferredUpdates release];
        _deferredUpdates = [[NSMutableArray alloc] init];
    }
    
    indexPlus1 = [_deferredRemoves count];
    for (;indexPlus1 > 0; indexPlus1--) {
        NSObject<CDXStorageable> *object = (NSObject<CDXStorageable> *)[_deferredRemoves objectAtIndex:indexPlus1-1];
        if (storageName == nil || [[object storageName] isEqualToString:storageName]) {
            [CDXStorage remove:object deferred:NO];
            [_deferredRemoves removeObjectAtIndex:indexPlus1-1];
        }
    }
    if ([_deferredRemoves count] == 0) {
        [_deferredRemoves release];
        _deferredRemoves = [[NSMutableArray alloc] init];
    }
    
    [object release];
}

+ (void)cancelDeferred:(NSObject<CDXStorageable> *)object {
    LogInvocation(@"%@", [object storageName]);
    
    [object retain];
    
    NSString *storageName = [object storageName];
    NSUInteger indexPlus1;
    
    indexPlus1 = [_deferredUpdates count];
    for (;indexPlus1 > 0; indexPlus1--) {
        NSObject<CDXStorageable> *object = (NSObject<CDXStorageable> *)[_deferredUpdates objectAtIndex:indexPlus1-1];
        if ([[object storageName] isEqualToString:storageName]) {
            [_deferredUpdates removeObjectAtIndex:indexPlus1-1];
        }
    }
    
    indexPlus1 = [_deferredRemoves count];
    for (;indexPlus1 > 0; indexPlus1--) {
        NSObject<CDXStorageable> *object = (NSObject<CDXStorageable> *)[_deferredRemoves objectAtIndex:indexPlus1-1];
        if ([[object storageName] isEqualToString:storageName]) {
            [_deferredRemoves removeObjectAtIndex:indexPlus1-1];
        }
    }
    
    [object release];
}

+ (NSString *)storageNameWithSuffix:(NSString *)suffix {
    struct timeval now;
    struct tm now_tm;
    
    gettimeofday(&now, NULL);
    localtime_r(&now.tv_sec, &now_tm);
    return [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d%06d%@", 
            now_tm.tm_year + 1900,
            now_tm.tm_mon + 1,
            now_tm.tm_mday,
            now_tm.tm_hour,
            now_tm.tm_min,
            now_tm.tm_sec,
            now.tv_usec,
            suffix];
}

@end

