//
//
// CDXMacros.h
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


#define ivar_release_and_clear(_ivar)                                          \
    if (_ivar) {                                                               \
        [_ivar release];                                                       \
    }                                                                          \
    _ivar = nil;                                                               \

#define ivar_assign(_ivar, _value)                                             \
    if (_ivar) {                                                               \
        [_ivar autorelease];                                                   \
    }                                                                          \
    _ivar = _value;                                                            \

#define ivar_assign_and_retain(_ivar, _value)                                  \
    if (_ivar) {                                                               \
        [_ivar autorelease];                                                   \
    }                                                                          \
    _ivar = [_value retain];                                                   \

#define ivar_assign_and_copy(_ivar, _value)                                    \
    if (_ivar) {                                                               \
        [_ivar autorelease];                                                   \
    }                                                                          \
    _ivar = [_value copy];                                                     \

#define ivar_array_release_and_clear(_ivar, _size)                             \
    {                                                                          \
        for (NSUInteger _ivar_idx = 0; _ivar_idx < _size; _ivar_idx++) {       \
            if (_ivar[_ivar_idx]) {                                            \
                [_ivar[_ivar_idx] release];                                    \
            }                                                                  \
            _ivar[_ivar_idx] = nil;                                            \
        }                                                                      \
    }                                                                          \

#define ivar_array_assign(_ivar, _size, _value)                                \
    {                                                                          \
        for (NSUInteger _ivar_idx = 0; _ivar_idx < _size; _ivar_idx++) {       \
            if (_ivar[_ivar_idx]) {                                            \
                [_ivar[_ivar_idx] release];                                    \
            }                                                                  \
            _ivar[_ivar_idx] = _value;                                         \
        }                                                                      \
    }                                                                          \

#define ivar_array_set(_ivar, _size, _value)                                   \
    {                                                                          \
        for (NSUInteger _ivar_idx = 0; _ivar_idx < _size; _ivar_idx++) {       \
            _ivar[_ivar_idx] = _value;                                         \
        }                                                                      \
    }                                                                          \

#define ivar_enum_assign(_ivar, _type, _value)                                 \
    {                                                                          \
        if (_value >= 0 && _value < _type##Count) {                            \
            _ivar = _value;                                                    \
        } else {                                                               \
            _ivar = _type##Default;                                            \
        }                                                                      \
    }                                                                          \

#define declare_singleton(_name, _class)                                       \
                                                                               \
    + (_class *)_name;                                                         \

#define synthesize_singleton(_name, _class)                                    \
                                                                               \
    synthesize_singleton_definition(_name, _class)                             \
                                                                               \
    synthesize_singleton_initialization(_name, _class)                         \
                                                                               \
    synthesize_singleton_methods(_name, _class)                                \

#define synthesize_singleton_definition(_name, _class)                         \
                                                                               \
    static _class *_name = nil;                                                \
                                                                               \
    + (_class *)_name {                                                        \
        return _name;                                                          \
    }                                                                          \

#define synthesize_singleton_initialization_allocate(_name, _class)            \
                                                                               \
    if (!_name) {                                                              \
        _name = [[super allocWithZone:nil] init];                              \
    }                                                                          \

#define synthesize_singleton_initialization(_name, _class)                     \
                                                                               \
    + (void)initialize {                                                       \
        synthesize_singleton_initialization_allocate(_name, _class);           \
    }                                                                          \

#define synthesize_singleton_methods(_name, _class)                            \
                                                                               \
    + (id)allocWithZone:(NSZone *)zone {                                       \
        return [_name retain];                                                 \
    }                                                                          \
                                                                               \
    - (id)copyWithZone:(NSZone *)zone {                                        \
        return self;                                                           \
    }                                                                          \
                                                                               \
    - (id)retain {                                                             \
        return self;                                                           \
    }                                                                          \
                                                                               \
    - (NSUInteger)retainCount {                                                \
        return NSUIntegerMax;                                                  \
    }                                                                          \
                                                                               \
    - (oneway void)release {                                                   \
    }                                                                          \
                                                                               \
    - (id)autorelease {                                                        \
        return self;                                                           \
    }                                                                          \

