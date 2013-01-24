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
   int              regexFlags;
   NSMutableArray * subExpressions;

   // matches
   NSMutableArray * matches;

   // error reporting
   NSString       * errorMessage;
   NSInteger        errorCode;
}


#pragma mark - Object Management Methods
/// @name Object Management Methods

/// Initialize a new object using a provided pattern.
/// @param pattern Regular expression used to initialize object.
- (id) initWithPattern:(NSString *)pattern;

/// Initialize a new object using a provided pattern.
/// @param pattern Regular expression used to initialize object.
/// @param options Is the bitwise OR of zero or more flags. See `-options` for
/// poossible values.
- (id) initWithPattern:(NSString *)pattern andOptions:(int)options;

/// Creates a new object using a provided pattern.
/// @param pattern Regular expression used to initialize object.
+ (id) expressionWithPattern:(NSString *)pattern;

/// Creates a new object using a provided pattern.
/// @param pattern Regular expression used to initialize object.
/// @param options Is the bitwise OR of zero or more flags. See `-options` for
/// poossible values.
+ (id) expressionWithPattern:(NSString *)pattern andOptions:(int)options;


#pragma mark - Common Patterns
/// @name Common Patterns

/// Initializes an object using a pattern to match IPv4 addresses.
- (id) initWithIPv4AddressPattern;

/// Initializes an object using a pattern to match IPv6 addresses.
- (id) initWithIPv6AddressPattern;

/// Creates an object using a pattern to match IPv4 addresses.
+ (id) expressionWithIPv4AddressPattern;

/// Creates an object using a pattern to match IPv6 addresses.
+ (id) expressionWithIPv6AddressPattern;


#pragma mark - Regular Expressions
/// @name Regular Expressions

/// options is the bitwise OR of zero or more optional flags.
///
/// See regex(3) man page for a detailed explanation of regular expression flags.
///
/// Flag           | Description
/// ---------------|-------------
/// `REG_EXTENDED` | Compile modern regular expressions.
/// `REG_BASIC`    | Compile obsolete regular expressions.
/// `REG_NOSPEC`   | Compile with recognition of all special characters turned off.
/// `REG_ICASE`    | Compile for matching that ignores upper/lower case distinctions.
/// `REG_NOSUB`    | Compile for matching that need only report success or failure.
/// `REG_NEWLINE`  | Compile for newline-sensitive matching.
@property (nonatomic, assign)   int   options;

/// The string containing the regular expression.
@property (nonatomic, strong) NSString * pattern;

/// The sub-expressions contained, if any, within -pattern.
@property (nonatomic, readonly) NSArray * subExpressions;


#pragma mark - Matches
/// @name Matches

/// The resulting matches and sub-matches from executing a regular expression.
/// @return Returns an array containing `BKPosixRegmatch` objects.
@property (nonatomic, readonly) NSArray * matches;


#pragma mark - Error Reporting
/// @name Error Reporting

/// The error message returned by a regular expression.
@property (nonatomic, readonly) NSString * errorMessage;

/// The error code returned by a regular expression.
@property (nonatomic, readonly) NSInteger errorCode;


#pragma mark - Compare Strings
/// @name Compare Strings

/// Executes the POSIX regular expression
///
/// Matches the compiled regulare expression aganst the provided string NSString
/// object.
/// @param string String to be matched by regulare expression.
/// @return Returns `FALSE` if a match is not found.  If a match is found,
/// `-matches` is populated and this method returns `TRUE`.
- (BOOL) executeWithString:(NSString *)string;

/// Executes the POSIX regular expression
///
/// Matches the compiled regulare expression aganst the provided string.
/// @param string String to be matched by regulare expression.
/// @return Returns `FALSE` if a match is not found.  If a match is found,
/// `-matches` is populated and this method returns `TRUE`.
- (BOOL) executeWithUTF8String:(const char *)string;

@end
