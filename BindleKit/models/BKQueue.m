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
 *  @file BindleKit/classes/models/BKQueue.h Creates a FIFO data structure
 */
#import "BKQueue.h"

@interface BKQueue ()
- (void) initializeDataSet;
@end


#pragma mark -
@implementation BKQueue

- (void) dealloc
{
   [dataset release];
   [super dealloc];
   return;
}


- (id) init
{
   if ((self = [super init]) == nil)
      return(self);
   return(self);
}


- (void) initializeDataSet
{
   @synchronized(self)
   {
      if (!(dataset))
         dataset = [[NSMutableArray alloc] initWithCapacity:1];
   };
   return;
}


#pragma mark - Queue operations

- (NSUInteger) count
{
   NSUInteger count;
   count = 0;
   @synchronized(self)
   {
      if ((dataset))
         count = [dataset count];
   };
   return(count);
}


- (BOOL) empty
{
   BOOL empty;
   empty = YES;
   @synchronized(self)
   {
      if ([self count] > 0)
         empty = NO;
   };
   return(empty);
}


- (id) front
{
   id anObject;
   anObject = nil;
   @synchronized(self)
   {
      if ((dataset))
         anObject = [[dataset objectAtIndex:0] retain];
   };
   return([anObject autorelease]);
}


- (id) pop
{
   id anObject;
   anObject = nil;
   @synchronized(self)
   {
      if ((dataset))
      {
         anObject = [[dataset objectAtIndex:0] retain];
         [dataset removeObjectAtIndex:0];
      };
   };
   return([anObject autorelease]);
}


- (void) push:(id)anObject
{
   @synchronized(self)
   {
      if (!(dataset))
         [self initializeDataSet];
      [dataset addObject:anObject];
   };
   return;
}


- (NSUInteger) size
{
   return([self count]);
}

@end
