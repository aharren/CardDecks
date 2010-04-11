//
//
// qlog.h
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


//
// qlog -- quick logging macros
//


#define qlcritical(_format, ...)                                               \
    lcl_log(ql_component, lcl_vCritical, _format, ## __VA_ARGS__);

#define qlerror(_format, ...)                                                  \
    lcl_log(ql_component, lcl_vError, _format, ## __VA_ARGS__);

#define qlwarning(_format, ...)                                                \
    lcl_log(ql_component, lcl_vWarning, _format, ## __VA_ARGS__);

#define qlinfo(_format, ...)                                                   \
    lcl_log(ql_component, lcl_vInfo, _format, ## __VA_ARGS__);

#define qldebug(_format, ...)                                                  \
    lcl_log(ql_component, lcl_vDebug, _format, ## __VA_ARGS__);

#define qltrace(_format, ...)                                                  \
    lcl_log(ql_component, lcl_vTrace, _format, ## __VA_ARGS__);

