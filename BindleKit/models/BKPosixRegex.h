/*
 *  Bindle Binaries Objective-C Kit
 *  Copyright (c) 2012, Bindle Binaries
 *
 *  @BINDLE_BINARIES_BSD_LICENSE_START@
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are
 *  met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Bindle Binaries nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 *  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 *  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 *  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL BINDLE BINARIES BE LIABLE FOR
 *  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 *  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 *  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 *  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 *  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 *  SUCH DAMAGE.
 *
 *  @BINDLE_BINARIES_BSD_LICENSE_END@
 */
/**
 *  Objective-C wrapper for POSIX regular expressions using NSString.
 */

#import <Foundation/Foundation.h>
#import <regex.h>

@interface BKPosixRegex : NSObject
{
   // Regular expressions information
   regex_t          regex;
   NSString       * regexString;
   NSInteger        regexFlags;

   // matches
   NSMutableArray * matches;

   // error reporting
   NSString       * errorMessage;
   NSInteger        errorCode;
}

// Regular expressions information
@property (nonatomic, assign)  NSInteger   options;
@property (nonatomic, retain)  NSString  * pattern;

// matches
@property (nonatomic, readonly) NSArray   * matches;

// error reporting
@property (nonatomic, readonly) NSString  * errorMessage;
@property (nonatomic, readonly) NSInteger   errorCode;

/// @name Object Management Methods
- (id) initWithPattern:(NSString *)pattern;
- (id) initWithPattern:(NSString *)pattern andOptions:(NSInteger)options;
+ (id) regexWithPattern:(NSString *)pattern;
+ (id) regexWithPattern:(NSString *)pattern andOptions:(NSInteger)options;

/// @name Compare Strings
- (BOOL) executeWithString:(NSString *)string;
- (BOOL) executeWithUTF8String:(const char *)string;

/// @name Common Patterns
- (id) initWithIPv4AddressPattern;
- (id) initWithIPv6AddressPattern;
- (id) regexWithIPv4AddressPattern;
- (id) regexWithIPv6AddressPattern;

@end
