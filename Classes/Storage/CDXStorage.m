//
//
// CDXStorage.m
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

#import "CDXStorage.h"
#import <sys/time.h>

#undef ql_component
#define ql_component lcl_cCDXStorage


@implementation CDXStorage

+ (NSDictionary *)readDictionaryFromFile:(NSString *)file {
    qltrace(@"file %@", file);
    
    // create the file name
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", file];
    
    // first, look in 'Documents' folder
    {
        NSString *folder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *path = [folder stringByAppendingPathComponent:fileName];
        qltrace(@"path1 %@", path);
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dictionary != nil) {
            return dictionary;
        }
    }
    
    // second, look in application bundle
    {
        NSString *folder = [NSHomeDirectory() stringByAppendingPathComponent:@"CardDecks2.app"];
        NSString *path = [folder stringByAppendingPathComponent:fileName];
        qltrace(@"path2 %@", path);
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dictionary != nil) {
            return dictionary;
        }
    }
    
    return nil;
}

+ (void)writeDictionary:(NSDictionary *)dictionary toFile:(NSString *)file {
    qltrace(@"file %@", file);
    
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", file];
    
    // update file in 'Documents' folder
    NSString *folder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [folder stringByAppendingPathComponent:fileName];
    qltrace(@"path %@", path);
    
    [dictionary writeToFile:path atomically:YES];        
}

+ (NSString *)fileWithSuffix:(NSString *)suffix {
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



