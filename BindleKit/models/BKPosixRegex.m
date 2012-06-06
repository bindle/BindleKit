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
 *  BKPosixRegex.m - Stores section and row tag information for UITableViews
 */
#import "BKPosixRegex.h"


@interface BKPosixRegex ()

// manages internal state
- (void) regexCompile;

@end


@implementation BKPosixRegex

// Regular expressions information
@synthesize options = regexFlags;
@synthesize pattern = regexString;

// matches
@synthesize matches;

// error reporting
@synthesize errorMessage;
@synthesize errorCode;


#pragma mark - Object Management Methods

- (void) dealloc
{
   // Regular expressions information
   regfree(&regex);
   [regexString release];

   // matches
   [matches release];

   // error reporting
   [errorMessage release];

   [super dealloc];

   return;
}


- (id) init
{
   NSAssert(false, @"use -initWithPattern: or -initWithPattern:andOptions:");
   return(self);
}


- (id) initWithPattern:(NSString *)pattern
{
   return([self initWithPattern:pattern andOptions:REG_EXTENDED|REG_ICASE|REG_NOSUB]);
}


- (id) initWithPattern:(NSString *)pattern andOptions:(NSInteger)options
{
   NSAutoreleasePool * pool;

   NSAssert((pattern != nil), @"pattern is required");
   if ((self = [super init]) == nil)
      return(self);

   pool = [[NSAutoreleasePool alloc] init];

   // Regular expressions information
   regexFlags  = options;
   regexString = [pattern retain];
   [self regexCompile];

   [pool release];

   return(self);
}


+ (id) regexWithPattern:(NSString *)pattern
{
   return([[[BKPosixRegex alloc] initWithPattern:pattern] autorelease]);
}


+ (id) regexWithPattern:(NSString *)pattern andOptions:(NSInteger)options
{
   return([[[BKPosixRegex alloc] initWithPattern:pattern andOptions:options] autorelease]);
}


#pragma mark - Getter/Setter methods

- (void) setOptions:(NSInteger)options
{
   @synchronized(self)
   {
      regexFlags = options;
      [self regexCompile];
   };
   return;
}


- (void) setPattern:(NSString *)pattern
{
   NSAssert((pattern != nil), @"pattern is required");
   @synchronized(self)
   {
      [regexString release];
      regexString = [pattern retain];
      [self regexCompile];
   };
   return;
}


#pragma mark - Manages internal state

- (void) regexCompile
{
   NSInteger           err;
   char                msg[1024];
   NSAutoreleasePool * pool;

   pool = [[NSAutoreleasePool alloc] init];

   @synchronized(self)
   {
      // resets error code
      errorCode = 0;

      // frees old compiled regular expression
      if ((matches))
         regfree(&regex);

      // compiles new regular expression
      if ((err = regcomp(&regex, [regexString UTF8String], regexFlags)))
      {
         regerror(err, &regex, msg, 1023);
         errorCode    = err;
         [errorMessage release];
         errorMessage = [[NSString stringWithUTF8String:msg] retain];
      };

      // resets array of substring matches
      if (!(matches))
         matches = [[NSMutableArray alloc] initWithCapacity:1];
      [matches removeAllObjects];
   };

   [pool release];

   return;
}


#pragma mark - Compare Strings

/// Executes the POSIX regular expression
/// Executes the regulare expression using the provided NSString.
/// @param string        The string used when executing the regular expression.
- (BOOL) executeWithString:(NSString *)string
{
   BOOL                result;
   NSAutoreleasePool * pool;

   pool   = [[NSAutoreleasePool alloc] init];
   result = [self executeWithUTF8String:[string UTF8String]];
   [pool release];

   return(result);
}


/// Executes the POSIX regular expression
/// Executes the regulare expression using the provided UTF8 string.
/// @param string        The string used when executing the regular expression.
- (BOOL) executeWithUTF8String:(const char *)string
{
   NSInteger    err;
   regmatch_t   pmatches[512];
   char         msg[1024];
   NSUInteger   x;
   char         str[2048];
   size_t       strlen;

   @synchronized(self)
   {
      errorCode = 0;

      [matches removeAllObjects];

      if ((err = regexec(&regex, string, 512, pmatches, 0)))
      {
         regerror(err, &regex, msg, 1023);
         errorCode    = err;
         errorMessage = [NSString stringWithUTF8String:msg];
         return(NO);
      };

      for(x = 0; ((x < 512) && (pmatches[x].rm_eo > -1)); x++)
      {
         memset(str, 0, 2048);
         if ((strlen = pmatches[x].rm_eo - pmatches[x].rm_so))
         {
            strncpy(str, &string[pmatches[x].rm_so], ((strlen > 2047) ? 2047 : strlen));
            [matches addObject:[NSString stringWithUTF8String:str]];
         } else {
            [matches addObject:[NSString stringWithUTF8String:str]];
         };
      };
   };

   return(err == 0);
}


#pragma mark - Common Patterns

- (id) initWithIPv4AddressPattern
{
   if ((self = [self initWithPattern:@"^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.|$)){4}$"]) == nil)
      return(self);
   return(self);
}


- (id) initWithIPv6AddressPattern
{
// regex: ^:{0,1}([[:xdigit:]]{1,4}:){0,6}[[:xdigit:]]{0,4}:([[:xdigit:]]{1,4}:){0,7}[[:xdigit:]]{0,4}$
//   1: ::  ==>  found
//   2: ::1  ==>  found
//   3: 2001:470:b:84a::69  ==>  found
//   4: 2001:470:b:84a::69:69  ==>  found
//   5: ::2001:470:b:84a:69:69  ==>  found
//   6: fe80:0:0:0:204:61ff:fe9d:f156  ==>  found
//   7: :::  ==> not found
//   8: deaf  ==> not found
//   9: 2001:470:b:84a:::69  ==> not found
//

   if ((self = [self initWithPattern:@"^:{0,1}([[:xdigit:]]{1,4}:){0,6}[[:xdigit:]]{0,4}:([[:xdigit:]]{1,4}:){0,7}[[:xdigit:]]{0,4}$"]) == nil)
      return(self);
   return(self);
}


+ (id) regexWithIPv4AddressPattern
{
   return([[[BKPosixRegex alloc] initWithIPv4AddressPattern] autorelease]);
}


+ (id) regexWithIPv6AddressPattern
{
   return([[[BKPosixRegex alloc] initWithIPv6AddressPattern] autorelease]);
}


@end
