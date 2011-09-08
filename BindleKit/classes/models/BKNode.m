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
 *  @file BindleKit/classes/models/BKNode.m Contains array of nodes
 */
#import "BKNode.h"

@implementation BKNode

@synthesize nodeName;
@synthesize nodeData;
@synthesize nodeType;

#pragma mark - Node management methods

+ (id) nodeWithName:(NSString *)aName
{
   BKNode * node;
   node = [[BKNode alloc] initWithName:aName];
   return([node autorelease]);
}


+ (id) nodeWithName:(NSString *)aName andSubName:(NSString *)aSubName
{
   BKNode * node;
   node = [[BKNode alloc] initWithName:aName andSubName:aSubName];
   return([node autorelease]);
}


- (void) dealloc
{
   [nodeName         release];
   [nodeSubNodes release];
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
   self.nodeName = aName;
   return(self);
}


- (id) initWithName:(NSString *)aName andSubName:(NSString *)aSubName
{
   BKNode * aNode;
   if ((self = [self initWithName:aName]) == nil)
      return(self);

   [self initializeSubNodes];

   aNode = [[BKNode alloc] initWithName:aSubName];
   [nodeSubNodes addObject:aNode];
   [aNode release];

   return(self);
}


- (void) initializeSubNodes
{
   @synchronized(self)
   {
      if (nodeSubNodes !=nil)
         return;
      nodeSubNodes = [[NSMutableArray alloc] initWithCapacity:1];
   };
   return;
}


#pragma mark - Value management methods

- (void) addSubNode:(BKNode *)aNode
{
   [self initializeSubNodes];
   @synchronized(self)
   {
      [nodeSubNodes addObject:aNode];
   };
   return;
}


- (BKNode *) addSubNodeWithName:(NSString *)aName
{
   BKNode * aNode;
   [self initializeSubNodes];
   aNode = [BKNode nodeWithName:aName];
   @synchronized(self)
   {
      [nodeSubNodes addObject:aNode];
   };
   return(aNode);
}


- (BKNode *) addSubNodeWithName:(NSString *)aName andSubName:(NSString *)aSubName
{
   BKNode * aNode;
   [self initializeSubNodes];
   aNode = [BKNode nodeWithName:aName andSubName:aSubName];
   @synchronized(self)
   {
      [nodeSubNodes addObject:aNode];
   };
   return(aNode);
}


- (NSUInteger) count
{
   NSUInteger count;
   [self initializeSubNodes];
   @synchronized(self)
   {
      count = [nodeSubNodes count];
   };
   return(count);
}


- (void) removeSubNode:(BKNode *)aNode
{
   [self initializeSubNodes];
   @synchronized(self)
   {
      [nodeSubNodes removeObject:aNode];
   };
   return;
}


- (void) removeSubNodeAtIndex:(NSUInteger)index
{
   NSUInteger count;
   [self initializeSubNodes];
   @synchronized(self)
   {
      count = [nodeSubNodes count];
      if (index < count)
         [nodeSubNodes removeObjectAtIndex:index];
   };
   return;
}


- (void) removeSubNodeWithName:(NSString *)aName
{
   BKNode * aNode;
   NSUInteger   count;
   NSUInteger   pos;
   [self initializeSubNodes];
   @synchronized(self)
   {
      count = [nodeSubNodes count];
      for(pos = 0; pos < count; pos++)
      {
         aNode = [nodeSubNodes objectAtIndex:pos];
         if ([aNode.nodeName isEqual:aName])
         {
            [nodeSubNodes removeObjectAtIndex:pos];
            pos--;
         };
      };
   };
   return;
}


- (void) resetSubNodes
{
   @synchronized(self)
   {
      [nodeSubNodes release];
      nodeSubNodes = nil;
   };
   return;
}



- (BKNode *) subNodeAtIndex:(NSUInteger)index
{
   BKNode * aNode;
   [self initializeSubNodes];
   @synchronized(self)
   {
      aNode = [[nodeSubNodes objectAtIndex:index] retain];
   };
   return([aNode autorelease]);
}


- (NSString *) subNodeNameAtIndex:(NSUInteger)index
{
   BKNode     * aNode;
   NSString   * aName ;
   [self initializeSubNodes];
   @synchronized(self)
   {
      aNode = [nodeSubNodes objectAtIndex:index];
      aName = [aNode.nodeName retain];
   };
   return([aName autorelease]);
}

@end
