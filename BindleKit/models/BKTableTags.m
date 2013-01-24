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
 *  BKTableTags.m - Stores section and row tag information for UITableViews
 */
#import "BKTableTags.h"


@implementation BKTableTags

#pragma mark - Object Management Methods

- (void) dealloc
{
   // table information
   [sectionTags release];
   [sectionRows release];

   [super dealloc];

   return;
}


- (id) init
{
   if ((self = [super init]) == nil)
      return(self);

   // table information
   sectionTags = [[NSMutableArray alloc] initWithCapacity:1];
   sectionRows = [[NSMutableArray alloc] initWithCapacity:1];

   return(self);
}


#pragma mark - table tag management

- (void) removeAllTags
{
   [sectionTags removeAllObjects];
   [sectionRows removeAllObjects];
   return;
}


#pragma mark - section management

- (NSInteger) addSectionWithTag:(NSInteger)sectionTag
{
   NSNumber       * tagNumber;
   NSMutableArray * rowTags;

   // adds tag to sectionTags
   tagNumber = [[NSNumber alloc] initWithLong:sectionTag];
   [sectionTags addObject:tagNumber];
   [tagNumber release];

   // adds array of row tags for section
   rowTags = [[NSMutableArray alloc] initWithCapacity:1];
   [sectionRows addObject:rowTags];
   [rowTags release];

   return([sectionRows count] - 1);
}


- (NSInteger) indexOfSectionTag:(NSInteger)sectionTag
{
   NSNumber   * tagNumber;
   NSUInteger   index;

   tagNumber = [[NSNumber alloc] initWithLong:sectionTag];
   index     = [sectionTags indexOfObject:tagNumber];
   [tagNumber release];

   return(index);
}


- (NSInteger) sectionCount
{
   return([sectionRows count]);
}


- (NSInteger)  sectionTagAtIndex:(NSInteger)index
{
   NSAssert(([sectionTags count] > index), @"section index exceeds bounds");
   return([[sectionTags objectAtIndex:index] intValue]);
}


#pragma mark - row management

- (NSInteger) addRowWithTagInLastSection:(NSInteger)rowTag
{
   NSInteger count;

   NSAssert(([sectionRows count] > 0), @"must have at least one section");

   count = [sectionRows count];
   return([self addRowWithTag:rowTag inSection:(count-1)]);
}


- (NSInteger) addRowWithTag:(NSInteger)rowTag inSection:(NSInteger)section
{
   NSNumber       * tagNumber;
   NSMutableArray * rowTags;

   NSAssert(([sectionRows count] > section), @"section index exceeds bounds");

   tagNumber = [[NSNumber alloc] initWithLong:rowTag];
   rowTags   = [sectionRows objectAtIndex:section];
   [rowTags addObject:tagNumber];
   [tagNumber release];

   return([rowTags count] - 1);
}


- (NSInteger) indexofRowTag:(NSInteger)rowTag inSection:(NSInteger)section
{
   NSNumber       * tagNumber;
   NSUInteger       index;
   NSMutableArray * rowTags;

   NSAssert(([sectionRows count] > section), @"section index exceeds bounds");

   tagNumber = [[NSNumber alloc] initWithLong:rowTag];
   rowTags   = [sectionRows objectAtIndex:section];
   index     = [rowTags indexOfObject:tagNumber];
   [tagNumber release];

   return(index);
}


- (NSInteger) rowCountInSection:(NSInteger)section
{
   NSMutableArray * rowTags;
   NSAssert(([sectionRows count] > section), @"section index exceeds bounds");
   rowTags = [sectionRows objectAtIndex:section];
   return([rowTags count]);
}


- (NSInteger) rowTagAtIndex:(NSInteger)index inSection:(NSInteger)section
{
   NSMutableArray * rowTags;
   NSAssert(([sectionRows count] > section), @"section index exceeds bounds");
   rowTags = [sectionRows objectAtIndex:section];
   NSAssert(([rowTags count] > index), @"row tag index exceeds bounds");
   return([[rowTags objectAtIndex:index] intValue]);
}


- (NSInteger) rowTagAtIndexPath:(NSIndexPath *)indexPath
{
   NSInteger        section;
   NSInteger        row;
   NSMutableArray * rowTags;

   section = [indexPath indexAtPosition:0];
   row     = [indexPath indexAtPosition:1];

   NSAssert(([sectionRows count] > section), @"section index exceeds bounds");
   rowTags = [sectionRows objectAtIndex:section];
   NSAssert(([rowTags count] > row), @"row tag index exceeds bounds");

   return([[rowTags objectAtIndex:row] intValue]);
}


@end
