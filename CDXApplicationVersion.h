//
//
// CDXApplicationVersion.h
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


// Definition of version information (major, minor, etc.).
#define CDXApplicationVersionMajor  2
#define CDXApplicationVersionMinor  0
#define CDXApplicationVersionBuild  0
#define CDXApplicationVersionSuffix "-beta-1"

// NSString with complete version information (<major>.<minor>.<build><suffix>).
#define CDXApplicationVersion                                                  \
    @   _CDXApplicationVersionToString(CDXApplicationVersionMajor)             \
    "." _CDXApplicationVersionToString(CDXApplicationVersionMinor)             \
    "." _CDXApplicationVersionToString(CDXApplicationVersionBuild)             \
    CDXApplicationVersionSuffix

// Helper macros.
#define _CDXApplicationVersionToString( _text)                                 \
    _CDXApplicationVersionToString0(_text)
#define _CDXApplicationVersionToString0(_text)                                 \
    #_text

