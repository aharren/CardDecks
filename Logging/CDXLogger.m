//
//
// CDXLogger.m
//
//
// Copyright (c) 2009-2014 Arne Harren <ah@0xc0.de>
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

#import "lcl.h"
#include <sys/time.h>


@implementation CDXLogger

+ (void)logWithIdentifier:(const char *)identifier_c
                    level:(const char *)level_c
                 function:(const char *)function_c
                   format:(NSString *)format, ... {
    // get the message
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    // get current time
    struct timeval now;
    struct tm now_tm;
    const int time_c_len = 24;
    char time_c[time_c_len];
    gettimeofday(&now, NULL);
    localtime_r(&now.tv_sec, &now_tm);
    snprintf(time_c, sizeof(time_c), "%02d:%02d:%02d.%03d",
             now_tm.tm_hour,
             now_tm.tm_min,
             now_tm.tm_sec,
             now.tv_usec / 1000);
    
    // write the message
    fprintf(stderr, "%s %s %-12s %s %s\n",
            time_c,
            level_c,
            identifier_c,
            function_c,
            [message UTF8String]);
    
    [message release];
}

@end

