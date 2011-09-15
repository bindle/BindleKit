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
/*
 *  BKStack.m - Creates a LIFO data structure
 */

#import "BKStack.h"

@implementation BKStack
#pragma mark - Creating and Initializing a Mutable Array

- (void) dealloc
{
   [dataset release];
   [super dealloc];
   return;
}


/// Initializes an instance of BKStack.
/// @return Returns an initialized instance of BKStack.
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


#pragma mark - Adding Objects

/// Pops the top object of the stack and pushes it onto the stack twice.
/// This method retrieves the last object added to the stack and pushes the
/// object onto the stack.  This creates two instances of the object on the
/// stack.
- (void) dup
{
   id anObject;
   @synchronized(self)
   {
      anObject = [self top];
      if ((anObject))
         [self push:anObject];
   };
   return;
}


/// Inserts an object to the top of the stack.
/// @param anObject The object to add to top of stack. This value must not be nil.
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


#pragma mark - Removing Objects

/// Removes the last object added to the stack.
/// The object added to the stack immediatly prior to
/// the removed object becomes the new top of the stack.
/// @return Returns the removed object.
- (id) pop
{
   id         anObject;
   NSUInteger count;
   anObject = nil;
   @synchronized(self)
   {
      if ((dataset))
      {
         count = [dataset count];
         if (count > 0)
         {
            anObject = [[dataset objectAtIndex:(count - 1)] retain];
            [dataset removeObjectAtIndex:(count - 1)];
         };
      };
   };
   return([anObject autorelease]);
}


#pragma mark - Querying a Stack

/// Returns the number of objects currently in the stack.
/// @return The number of objects currently in the stack.
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


/// Returns a BOOL which indicating if the stack currently contains objects.
/// @return Returns `YES` if stack contains objects, `NO` otherwise.
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


/// Returns the last object added to the stack.
/// Returns the last object added to the stack without removing
/// the object from the stack.
/// @return Returns the last object added to the stack.
- (id) top
{
   id         anObject;
   NSUInteger count;
   anObject = nil;
   @synchronized(self)
   {
      if ((dataset))
      {
         count = [dataset count];
         if (count > 0)
            anObject = [[dataset objectAtIndex:(count - 1)] retain];
      };
   };
   return([anObject autorelease]);
}


#pragma mark - Rearranging Content

/// Moves the object at the bottom of the stack to the top of the stack.
/// To fill the gap, all other objects are moved one position closer to the
/// bottom of the stack.
- (void) leftRotate
{
   id anObject;
   NSAutoreleasePool * pool;
   pool = [[NSAutoreleasePool alloc] init];
   @synchronized(self)
   {
      if ([self count] > 1)
      {
         anObject = [dataset objectAtIndex:0];
         [dataset removeObjectAtIndex:0];
         [self push:anObject];
      };
   };
   [pool release];
   return;
}


/// Moves the object at the top of the stack to the bottom of the stack.
/// To create a gap for the object, all other objects are moved one position
/// closer to the top of the stack.
- (void) rightRotate
{
   id anObject;
   NSAutoreleasePool * pool;
   pool = [[NSAutoreleasePool alloc] init];
   @synchronized(self)
   {
      if ([self count] > 1)
      {
         anObject = [self pop];
         [dataset insertObject:anObject atIndex:0];
      };
   };
   [pool release];
   return;
}


/// Switches the position of the top two objects in the stack.
- (void) swap
{
   id object0;
   id object1;
   NSAutoreleasePool * pool;
   pool = [[NSAutoreleasePool alloc] init];
   @synchronized(self)
   {
      if ([self count] > 1)
      {
         object0 = [self pop];
         object1 = [self pop];
         [self push:object1];
         [self push:object0];
      };
   };
   [pool release];
   return;
}

@end
