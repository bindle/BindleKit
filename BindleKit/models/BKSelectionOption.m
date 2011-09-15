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
 *  BKSelectionOption.m - Option data for Selelection
 */
#import "BKSelectionOption.h"

@implementation BKSelectionOption

@synthesize value;
@synthesize description;


- (void) dealloc
{
   self.value       = nil;
   self.description = nil;
   [super dealloc];
   return;
}


- (id) initWithValue:(id)aValue andDescription:(NSString *)aDescription
{
   if ((self = [super init]) == nil)
      return(self);
   self.value       = aValue;
   self.description = aDescription;
   return(self);
}


+ (id) optionWithValue:(id)aValue andDescription:(NSString *)aDescription
{
   BKSelectionOption * option;
   option = [[BKSelectionOption alloc] initWithValue:aValue andDescription:aDescription];
   return([option autorelease]);
}


+ (NSString *) descriptionForValue:(id)value inArray:(NSArray *)array
{
   BKSelectionOption * option;
   NSUInteger          pos;

   for(pos = 0; pos < [array count]; pos++)
   {
      option = [array objectAtIndex:pos];
      if ([option isKindOfClass:[BKSelectionOption class]])
         if ([value isEqual:[option value]])
            return([option description]);
   };

   return(nil);
}


+ (id) valueForDescription:(NSString *)description inArray:(NSArray *)array
{
   BKSelectionOption * option;
   NSUInteger          pos;

   for(pos = 0; pos < [array count]; pos++)
   {
      option = [array objectAtIndex:pos];
      if ([option isKindOfClass:[BKSelectionOption class]])
         if ([description isEqual:[option description]])
            return([option value]);
   };

   return(nil);
}


@end
