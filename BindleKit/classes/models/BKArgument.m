/*
 *  Bindle Binaries Objective-C Kit
 *  Copyright (c) 2011, Bindle Binaries
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
 *  @file BindleKit/classes/models/BKArgument.m Contains array of arguments
 */

#import "BKArgument.h"

@implementation BKArgument

@synthesize argumentName;
@synthesize argumentType;

#pragma mark - Argument management methods

+ (id) argumentWithName:(NSString *)aName
{
   BKArgument * argument;
   argument = [[BKArgument alloc] initWithName:aName];
   return([argument autorelease]);
}


+ (id) argumentWithName:(NSString *)aName andSubName:(NSString *)aSubName
{
   BKArgument * argument;
   argument = [[BKArgument alloc] initWithName:aName andSubName:aSubName];
   return([argument autorelease]);
}


- (void) dealloc
{
   [argumentName         release];
   [argumentSubArguments release];
   [super dealloc];
   return;
}


- (id)init
{
   if ((self = [super init]) == nil)
      return(self);

   return(self);
}


- (id) initWithName:(NSString *)aName
{
   if ((self = [self init]) == nil)
      return(self);
   self.argumentName = aName;
   return(self);
}


- (id) initWithName:(NSString *)aName andSubName:(NSString *)aSubName
{
   BKArgument * anArgument;
   if ((self = [self initWithName:aName]) == nil)
      return(self);

   [self initializeSubArguments];

   anArgument = [[BKArgument alloc] initWithName:aSubName];
   [argumentSubArguments addObject:anArgument];
   [anArgument release];

   return(self);
}


- (void) initializeSubArguments
{
   @synchronized(self)
   {
      if (argumentSubArguments !=nil)
         return;
      argumentSubArguments = [[NSMutableArray alloc] initWithCapacity:1];
   };
   return;
}


#pragma mark - Value management methods

- (void) addSubArgument:(BKArgument *)anArgument
{
   [self initializeSubArguments];
   @synchronized(self)
   {
      [argumentSubArguments addObject:anArgument];
   };
   return;
}


- (BKArgument *) addSubArgumentWithName:(NSString *)aName
{
   BKArgument * anArgument;
   [self initializeSubArguments];
   anArgument = [BKArgument argumentWithName:aName];
   @synchronized(self)
   {
      [argumentSubArguments addObject:anArgument];
   };
   return(anArgument);
}


- (BKArgument *) addSubArgumentWithName:(NSString *)aName andSubName:(NSString *)aSubName
{
   BKArgument * anArgument;
   [self initializeSubArguments];
   anArgument = [BKArgument argumentWithName:aName andSubName:aSubName];
   @synchronized(self)
   {
      [argumentSubArguments addObject:anArgument];
   };
   return(anArgument);
}


- (NSUInteger) count
{
   NSUInteger count;
   [self initializeSubArguments];
   @synchronized(self)
   {
      count = [argumentSubArguments count];
   };
   return(count);
}


- (void) removeSubArgument:(BKArgument *)anArgument
{
   [self initializeSubArguments];
   @synchronized(self)
   {
      [argumentSubArguments removeObject:anArgument];
   };
   return;
}


- (void) removeSubArgumentAtIndex:(NSUInteger)index
{
   NSUInteger count;
   [self initializeSubArguments];
   @synchronized(self)
   {
      count = [argumentSubArguments count];
      if (index < count)
         [argumentSubArguments removeObjectAtIndex:index];
   };
   return;
}


- (void) removeSubArgumentWithName:(NSString *)aName
{
   BKArgument * anArgument;
   NSUInteger   count;
   NSUInteger   pos;
   [self initializeSubArguments];
   @synchronized(self)
   {
      count = [argumentSubArguments count];
      for(pos = 0; pos < count; pos++)
      {
         anArgument = [argumentSubArguments objectAtIndex:pos];
         if ([anArgument.argumentName isEqual:aName])
         {
            [argumentSubArguments removeObjectAtIndex:pos];
            pos--;
         };
      };
   };
   return;
}


- (void) resetSubArguments
{
   @synchronized(self)
   {
      [argumentSubArguments release];
      argumentSubArguments = nil;
   };
   return;
}



- (BKArgument *) subArgumentAtIndex:(NSUInteger)index
{
   BKArgument * anArgument;
   [self initializeSubArguments];
   @synchronized(self)
   {
      anArgument = [[argumentSubArguments objectAtIndex:index] retain];
   };
   return([anArgument autorelease]);
}


- (NSString *) subArgumentNameAtIndex:(NSUInteger)index
{
   BKArgument * anArgument;
   NSString   * aName ;
   [self initializeSubArguments];
   @synchronized(self)
   {
      anArgument = [argumentSubArguments objectAtIndex:index];
      aName = [anArgument.argumentName retain];
   };
   return([aName autorelease]);
}

@end
