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

- (void) addSectionWithTag:(NSInteger)sectionTag
{
   NSNumber       * tagNumber;
   NSMutableArray * rowTags;

   // adds tag to sectionTags
   tagNumber = [[NSNumber alloc] initWithInt:sectionTag];
   [sectionTags addObject:tagNumber];
   [tagNumber release];

   // adds array of row tags for section
   rowTags = [[NSMutableArray alloc] initWithCapacity:1];
   [sectionRows addObject:rowTags];
   [rowTags release];

   return;
}


- (NSUInteger) sectionCount
{
   return([sectionRows count]);
}


- (NSInteger)  sectionTagAtIndex:(NSUInteger)index
{
   NSAssert(([sectionTags count] > 0), @"must have at least one section");
   return([[sectionTags objectAtIndex:index] intValue]);
}


#pragma mark - row management

- (void) addRowWithTagInLastSection:(NSInteger)rowTag
{
   NSUInteger       count;

   NSAssert(([sectionTags count] > 0), @"must have at least one section");

   count = [sectionRows count];
   [self addRowWithTag:rowTag inSection:(count-1)];
   
   return;
}


- (void) addRowWithTag:(NSInteger)rowTag inSection:(NSUInteger)section
{
   NSNumber       * tagNumber;
   NSMutableArray * rowTags;

   NSAssert(([sectionTags count] > 0), @"must have at least one section");

   tagNumber = [[NSNumber alloc] initWithInt:rowTag];
   rowTags   = [sectionRows objectAtIndex:section];
   [rowTags addObject:tagNumber];
   [tagNumber release];

   return;
}


- (NSUInteger) rowCountInSection:(NSUInteger)section
{
   NSMutableArray * rowTags;
   NSAssert(([sectionTags count] > section), @"section index exceeds bounds");
   rowTags = [sectionRows objectAtIndex:section];
   return([rowTags count]);
}


- (NSInteger) rowTagAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
   NSMutableArray * rowTags;
   rowTags = [sectionRows objectAtIndex:section];
   return([[rowTags objectAtIndex:index] intValue]);
}


- (NSInteger) rowTagatIndexPath:(NSIndexPath *)indexPath
{
   NSUInteger section = [indexPath indexAtPosition:0];
   NSUInteger row     = [indexPath indexAtPosition:1];
   return([self rowTagAtIndex:row inSection:section]);
}


@end
