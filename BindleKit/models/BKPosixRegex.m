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


#import <BindleKit/models/BKStack.h>
#import <BindleKit/models/BKPosixRegmatch.h>


@interface BKPosixRegex ()

// manages internal state
- (void) regexCompile;

@end


@implementation BKPosixRegex

// Regular expressions information
@synthesize options = regexFlags;
@synthesize pattern = regexString;
@synthesize subExpressions;

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
   [subExpressions release];

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


+ (id) expressionWithPattern:(NSString *)pattern
{
   return([[[BKPosixRegex alloc] initWithPattern:pattern] autorelease]);
}


+ (id) expressionWithPattern:(NSString *)pattern andOptions:(NSInteger)options
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
   NSInteger           i;
   const char        * str;
   NSInteger           err;
   char                msg[1024];
   size_t              len;
   size_t              bol;
   BKStack           * stack;
   NSAutoreleasePool * pool;
   NSRange             range;

   pool = [[NSAutoreleasePool alloc] init];

   @synchronized(self)
   {
      // resets error code
      errorCode = 0;

      // frees old information
      if ((matches))
      {
         regfree(&regex);
         [matches removeAllObjects];
      };
      if ((subExpressions))
         [subExpressions removeAllObjects];

      // compiles new regular expression
      str = [regexString UTF8String];
      if ((err = regcomp(&regex, str, regexFlags)))
      {
         regerror(err, &regex, msg, 1023);
         errorCode    = err;
         [errorMessage release];
         errorMessage = [[NSString stringWithUTF8String:msg] retain];
         [pool release];
         return;
      };

      // allocates arrays
      if (!(matches))
         matches = [[NSMutableArray alloc] initWithCapacity:1];
      if (!(subExpressions))
         subExpressions = [[NSMutableArray alloc] initWithCapacity:1];

      // generates array of sub-expressions
      if (!(err))
      {
         // save initial regex string
         range = NSMakeRange(0, [regexString length]);
         [subExpressions addObject:[BKPosixRegmatch matchWithRange:range
            andString:regexString]];

         // save sub expressions
         stack = [[[BKStack alloc] init] autorelease];
         for(i = 0; i < strlen(str); i++)
         {
            switch(str[i])
            {
               // start of sub expression
               case '(':
               [stack push:[NSNumber numberWithInt:i]]; // saves position of opening parentheses
               break;

               // end of sub expression
               case ')':
               bol   = [[stack pop] intValue]+1;  // retrieves position of opening parentheses
               len   = i - bol;                   // calculates length of subexpression
               len   = (len > 1023) ? 1023 : len; // verifies length is within bounds
               range = NSMakeRange(bol, len);     // create range of sub expression
               [subExpressions addObject:[BKPosixRegmatch matchWithRange:range
                  andString:regexString]];
               break;

               default:
               break;
            };
         };

         // sorts sub expressions
         [subExpressions sortUsingSelector:@selector(rangeCompare:)];
      };
   };

   [pool release];

   return;
}


#pragma mark - Compare Strings

- (BOOL) executeWithString:(NSString *)string
{
   BOOL                result;
   NSAutoreleasePool * pool;

   pool   = [[NSAutoreleasePool alloc] init];
   result = [self executeWithUTF8String:[string UTF8String]];
   [pool release];

   return(result);
}


- (BOOL) executeWithUTF8String:(const char *)string
{
   NSInteger         err;
   regmatch_t        pmatches[64];
   char              msg[1024];
   NSUInteger        x;
   BKPosixRegmatch * match;
   NSAutoreleasePool * pool;

   pool = [[NSAutoreleasePool alloc] init];

   @synchronized(self)
   {
      errorCode = 0;

      [matches removeAllObjects];
      memset(pmatches, 0, sizeof(pmatches));

      if ((err = regexec(&regex, string, 512, pmatches, 0)))
      {
         regerror(err, &regex, msg, 1023);
         errorCode    = err;
         errorMessage = [[NSString stringWithUTF8String:msg] retain];
         [pool release];
         return(NO);
      };

      if ((regexFlags & REG_NOSUB))
         return(YES);

      for(x = 0; ((x < 64) && (x <= regex.re_nsub)); x++)
      {
         match = [BKPosixRegmatch matchWithRegmatch:pmatches[x] andUTF8String:string];
         [matches addObject:match];
      };
   };

   [pool release];

   return(YES);
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

   if ((self = [self initWithPattern:@"^:{0,1}(([[:xdigit:]]{1,4}:){0,6})[[:xdigit:]]{0,4}:(([[:xdigit:]]{1,4}:){0,7})[[:xdigit:]]{0,4}$"]) == nil)
      return(self);
   return(self);
}


+ (id) expressionWithIPv4AddressPattern
{
   return([[[BKPosixRegex alloc] initWithIPv4AddressPattern] autorelease]);
}


+ (id) expressionWithIPv6AddressPattern
{
   return([[[BKPosixRegex alloc] initWithIPv6AddressPattern] autorelease]);
}


@end
