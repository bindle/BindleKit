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
 *  Class contain matched information for POSIX regular expressions.
 */

#import <Foundation/Foundation.h>
#import <regex.h>

@interface BKPosixRegmatch : NSObject
{
   // string information
   NSString   * _string;
   NSString   * _subString;
   NSRange      _range;
};

/// @name Object Management Methods
- (id) initWithRange:(NSRange)range andString:(NSString *)string;
- (id) initWithRange:(NSRange)range andUTF8String:(const char *)string;
- (id) initWithRegmatch:(regmatch_t)regmatch andString:(NSString *)string;
- (id) initWithRegmatch:(regmatch_t)regmatch andUTF8String:(const char *)string;
+ (id) matchWithRange:(NSRange)range andString:(NSString *)string;
+ (id) matchWithRange:(NSRange)range andUTF8String:(const char *)string;
+ (id) matchWithRegmatch:(regmatch_t)regmatch andString:(NSString *)string;
+ (id) matchWithRegmatch:(regmatch_t)regmatch andUTF8String:(const char *)string;


#pragma mark - Compared String
/// @name String Information

/// The original string used to match the regular expression.
@property (nonatomic, readonly) NSString   * fullString;

/// The sub-string from the original which matched the regular expression.
@property (nonatomic, readonly) NSString   * subString;


#pragma mark - Match Parameters
/// @name Match Parameters

/// The starting index of the sub-string within the original string.
@property (nonatomic, readonly) NSUInteger   startOfMatch;

/// The ending index of the sub-string within the original string.
@property (nonatomic, readonly) NSUInteger   endOfMatch;

/// The range of the sub-string within the original string.
@property (nonatomic, readonly) NSRange      range;


#pragma mark - Comparing Matches
/// @name Comparing Matches

/// Compares two objects using the range of the matched sub-strings.
///
/// This method is used for sorting the results of a regular expression by
/// the location of the matched sub-strings.
/// @param match The object to compare with the receiver.
- (NSComparisonResult) rangeCompare:(BKPosixRegmatch *)match;

/// Compares two objects using the matched sub-strings for comparison.
///
/// This method is used for sorting the results of a regular expression by
/// the comparison of the matched sub-strings.
/// @param match The object to compare with the receiver.
- (NSComparisonResult) subStringCompare:(BKPosixRegmatch *)match;

@end
