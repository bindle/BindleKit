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
/*
 *  Class contain matched information for POSIX regular expressions.
 */
#import "BKPosixRegmatch.h"

@implementation BKPosixRegmatch

// string information
@synthesize fullString = _string;
@synthesize subString  = _subString;

// match information
@synthesize startOfMatch;
@synthesize endOfMatch;
@synthesize range = _range;


#pragma mark - Object Management Methods

- (void) dealloc
{
   // string information
   [_string    release];
   [_subString release];

   [super dealloc];

   return;
}


- (id) initWithRange:(NSRange)range andString:(NSString *)string
{
   if ((self = [super init]) == nil)
      return(self);

   _string    = [string retain];
   _subString = [[string substringWithRange:range] retain];
   _range     = range;

   return(self);
}


- (id) initWithRange:(NSRange)range andUTF8String:(const char *)string
{
   BKPosixRegmatch * match;
   NSString        * str;

   str   = [[NSString alloc] initWithUTF8String:string];
   match = [[BKPosixRegmatch alloc] initWithRange:range andString:str];
   [str release];

   return(match);
}


- (id) initWithRegmatch:(regmatch_t)regmatch andString:(NSString *)string
{
   NSRange range;
   range = NSMakeRange(regmatch.rm_so, (regmatch.rm_eo - regmatch.rm_so));
   return([self initWithRange:range andString:string]);
}


- (id) initWithRegmatch:(regmatch_t)regmatch andUTF8String:(const char *)string
{
   BKPosixRegmatch * match;
   NSString        * str;

   str   = [[NSString alloc] initWithUTF8String:string];
   match = [[BKPosixRegmatch alloc] initWithRegmatch:regmatch andString:str];
   [str release];

   return(match);
}


+ (id) matchWithRange:(NSRange)range andString:(NSString *)string
{
   return([[[BKPosixRegmatch alloc] initWithRange:range andString:string] autorelease]);
}


+ (id) matchWithRange:(NSRange)range andUTF8String:(const char *)string
{
   return([[[BKPosixRegmatch alloc] initWithRange:range andString:[NSString stringWithUTF8String:string]] autorelease]);
}


+ (id) matchWithRegmatch:(regmatch_t)regmatch andString:(NSString *)string
{
   return([[[BKPosixRegmatch alloc] initWithRegmatch:regmatch andString:string] autorelease]);
}


+ (id) matchWithRegmatch:(regmatch_t)regmatch andUTF8String:(const char *)string
{
   return([[[BKPosixRegmatch alloc] initWithRegmatch:regmatch andString:[NSString stringWithUTF8String:string]] autorelease]);
}


#pragma mark - Getter methods

- (NSUInteger) endOfMatch
{
   return(_range.location + _range.length);
}


- (NSRange) range
{
   return(_range);
}


- (NSUInteger) startOfMatch
{
   return(_range.location);
}


#pragma mark - Comparing matches

- (NSComparisonResult) rangeCompare:(BKPosixRegmatch *)match
{
   // compare location
   if (self.range.location < match.range.location)
      return(NSOrderedAscending);
   if (self.range.location > match.range.location)
      return(NSOrderedDescending);

   // compare length
   if (self.range.length < match.range.length)
      return(NSOrderedAscending);
   if (self.range.length > match.range.length)
      return(NSOrderedDescending);

   // admit they are the same
   return(NSOrderedSame);
}


- (NSComparisonResult) subStringCompare:(BKPosixRegmatch *)match
{
   return([self.subString localizedCompare:match.subString]);
}

@end
