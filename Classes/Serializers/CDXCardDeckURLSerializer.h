//
//
// CDXCardDeckURLSerializer.h
//
//
// Copyright (c) 2009-2021 Arne Harren <ah@0xc0.de>
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

#import "CDXCardDeck.h"


@interface CDXCardDeckURLSerializer : NSObject {
    
}

// Deserializes the given URL string into a CDXCardDeck instance.
// Format:
//   string := <deck>[&<card>[&<card>[...]]]
//   deck   := <name>[,[<text-color>][,[<background-color>][,[<orientation>]]]]
//   card   := <text>[,[<text-color>][,[<background-color>][,[<orientation>]]]]
+ (CDXCardDeck *)cardDeckFromVersion1String:(NSString *)string;
// Format:
//   string := <deck>&<default-card>[&<card>[...]]
//   deck   := <name>[,<setting>[,<setting>[...]]]
//   card   := <text>[,[<text-color>][,[<background-color>][,[<orientation>][,[<font-size>]]]]]
+ (CDXCardDeck *)cardDeckFromVersion2String:(NSString *)string;

// Serializes the given CDXCardDeck instance into an URL string.
// Format:
//   string := <deck>&<default-card>[&<card>[...]]
//   deck   := <name>[,<setting>[,<setting>[...]]]
//   card   := <text>[,[<text-color>][,[<background-color>][,[<orientation>][,[<font-size>]]]]]
+ (NSString *)version2StringFromCardDeck:(CDXCardDeck *)cardDeck;

@end

