//
//
// CDXDictionarySerializerUtils.m
//
//
// Copyright (c) 2009-2025 Arne Harren <ah@0xc0.de>
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

#import "CDXDictionarySerializerUtils.h"


@implementation CDXDictionarySerializerUtils

+ (BOOL)dictionary:(NSDictionary *)dictionary hasBoolForKey:(NSString *)key {
    NSObject *object = dictionary[key];
    return (object != nil && [object isKindOfClass:[NSNumber class]]);
}

+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary forKey:(NSString *)key defaultsTo:(NSString *)defaultValue {
    NSObject *object = dictionary[key];
    if (object == nil || ![object isKindOfClass:[NSString class]]) {
        return defaultValue;
    } else {
        return (NSString *)object;
    }
}

+ (BOOL)boolFromDictionary:(NSDictionary *)dictionary forKey:(NSString *)key defaultsTo:(BOOL)defaultValue {
    NSObject *object = dictionary[key];
    if (object == nil || ![object isKindOfClass:[NSNumber class]]) {
        return defaultValue;
    } else {
        return [(NSNumber *)object boolValue] ? YES : NO;
    }
}

+ (NSUInteger)unsignedIntegerFromDictionary:(NSDictionary *)dictionary forKey:(NSString *)key defaultsTo:(NSUInteger)defaultValue {
    NSObject *object = dictionary[key];
    if (object == nil || ![object isKindOfClass:[NSNumber class]]) {
        return defaultValue;
    } else {
        return [(NSNumber *)object unsignedIntegerValue];
    }
}

+ (NSDictionary *)dictionaryFromDictionary:(NSDictionary *)dictionary forKey:(NSString *)key defaultsTo:(NSDictionary *)defaultValue {
    NSObject *object = dictionary[key];
    if (object == nil || ![object isKindOfClass:[NSDictionary class]]) {
        return defaultValue;
    } else {
        return (NSDictionary *)object;
    }
}

+ (void)dictionary:(NSMutableDictionary *)dictionary setObject:(NSObject *)object forKey:(NSString *)key {
    if (object) {
        dictionary[key] = object;
    }
}

@end

