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
 *  @file BindleKit/classes/models/BKMemoryCache.m Caches objects in memory
 */
#import "BKMemoryCache.h"

@interface  BKMemoryCache ()
- (id)   initAsRegistry;
- (void) pruneRegistry;
@end


#pragma mark -
@implementation BKMemoryCache

static BKMemoryCache * BKMemoryCacheRegistery;

#pragma mark - Internal State Variables

- (void) dealloc
{
   [cacheData release];
   [self unregisterToReceiveMemoryWarning];
   [super dealloc];
   return;
}


- (id) init
{
   if ((self = [super init]) == nil)
      return(self);

   receiveMemoryWarnings  = NO;
   cacheData              = nil;

   return(self);
}


- (id) initAsRegistry
{
   if ((self = [self init]) ==nil)
      return(nil);
   isRegistry = YES;
   [self registerToReceiveMemoryWarning];
   return(self);
}


#pragma mark - Cache registery methods

+ (NSInteger) countRegisteredCache:(NSString *)name
{
   NSUInteger count;
   [BKMemoryCache initializeCacheRegistry];
   @synchronized(BKMemoryCacheRegistery)
   {
      count = [[BKMemoryCacheRegistery objectForKey:name] count];
   };
   return(count);
}


+ (void) initializeCacheRegistry
{
   if (BKMemoryCacheRegistery != nil)
      return;
   BKMemoryCacheRegistery = [[BKMemoryCache alloc] initAsRegistry];
   return;
}


+ (id) objectForKey:(NSString *)key inRegisteredCache:(NSString *)name
{
   id object;
   [BKMemoryCache initializeCacheRegistry];
   @synchronized(BKMemoryCacheRegistery)
   {
      object = [[BKMemoryCacheRegistery objectForKey:name] objectForKey:key];
   };
   return(object);
}


+ (void) pruneCacheRegistry
{
   [BKMemoryCache initializeCacheRegistry];
   [BKMemoryCacheRegistery pruneRegistry];
   return;
}


+ (void) pruneRegisteredCache:(NSString *)name
{
   [BKMemoryCache initializeCacheRegistry];
   @synchronized(BKMemoryCacheRegistery)
   {
       [[BKMemoryCacheRegistery objectForKey:name] pruneCache];
   };
   return;
}


+ (void) registerCacheWithName:(NSString *)name
{
   BKMemoryCache * cache;
   [BKMemoryCache initializeCacheRegistry];
   @synchronized(BKMemoryCacheRegistery)
   {
      cache = [[BKMemoryCache alloc] init];
      if ([BKMemoryCacheRegistery objectForKey:name] == nil)
         [BKMemoryCacheRegistery setObject:cache forKey:name];
      [cache release];
   };
   return;
}


+ (void) removeObjectForKey:(NSString *)key inRegisteredCache:(NSString *)name
{
   [BKMemoryCache initializeCacheRegistry];
   @synchronized(BKMemoryCacheRegistery)
   {
      [[BKMemoryCacheRegistery objectForKey:name] removeObjectForKey:key];
   };
   return;
}


+ (void) setObject:(id)object forKey:(NSString *)key inRegisteredCache:(NSString *)name
{
   [BKMemoryCache initializeCacheRegistry];
   @synchronized(BKMemoryCacheRegistery)
   {
      [[BKMemoryCacheRegistery objectForKey:name] setObject:object forKey:key];
   };
   return;
}


+ (void) unregisterCacheWithName:(NSString *)name
{
   [BKMemoryCache initializeCacheRegistry];
   @synchronized(BKMemoryCacheRegistery)
   {
      [BKMemoryCacheRegistery removeObjectForKey:name];
   };
   return;
}


+ (id) valueForKey:(NSString *)key inRegisteredCache:(NSString *)name
{
   return([BKMemoryCache objectForKey:key inRegisteredCache:name]);
}


#pragma mark - Cache methods

- (NSInteger) count
{
   NSInteger cacheCount;
   @synchronized(self)
   {
      cacheCount = [cacheData count];
   };
   return(cacheCount);
}


- (id) objectForKey:(NSString *)key
{
   id value;

   value = nil;

   if (key == nil)
      return(value);

   @synchronized(self)
   {
      if (cacheData != nil)
         value = [[cacheData objectForKey:key] retain];
   };

   return([value autorelease]);
}


- (void) pruneCache
{
   NSUInteger          pos;
   NSString          * key;
   id                  value;
   NSArray           * keys;
   NSAutoreleasePool * pool;

   pool = [[NSAutoreleasePool alloc] init];

   @synchronized(self)
   {
      // nothing to do if cache dictionary does not exist
      if (cacheData != nil)
      {
         // list of keys to check
         keys = [cacheData allKeys];

         // if remove if value of key is only retained by cache
         for(pos = 0; pos < [keys count]; pos++)
         {
            key   = [keys objectAtIndex:pos];
            value = [cacheData objectForKey:key];
            if ([value retainCount] < 2)
               [cacheData removeObjectForKey:key];
         };

         // remove dictionary if no values are present
         if ([cacheData count] == 0)
         {
            [cacheData release];
            cacheData = nil;
         };
      };
   };

   [pool release];

   return;
}


- (void) pruneRegistry
{
   NSUInteger          pos;
   NSArray           * names;
   NSString          * name;
   BKMemoryCache     * cache;
   NSAutoreleasePool * pool;

   pool = [[NSAutoreleasePool alloc] init];

   @synchronized(self)
   {
      // nothing to do if cache dictionary does not exist
      if (cacheData != nil)
      {
         // list of keys to check
         names = [cacheData allKeys];

         // prunes caches and removes if no objects are found
         for(pos = 0; pos < [names count]; pos++)
         {
            name   = [names objectAtIndex:pos];
            cache  = [cacheData objectForKey:name];
            [cache pruneCache];
            if ([cache count] == 0)
               [cacheData removeObjectForKey:name];
         };

         // remove dictionary if no values are present
         if ([cacheData count] == 0)
         {
            [cacheData release];
            cacheData = nil;
         };
      };
   };

   [pool release];

   return;
}


- (void) removeObjectForKey:(NSString *)key
{
   if (key == nil)
      return;

   @synchronized(self)
   {
      if (cacheData != nil)
         [cacheData removeObjectForKey:key];
   };

   return;
}


- (void) setObject:(id)object forKey:(NSString *)key
{
   if (object == nil)
      return;

   @synchronized(self)
   {
      if (cacheData == nil)
         cacheData = [[NSMutableDictionary alloc] initWithCapacity:1];
      [cacheData setObject:object forKey:key];
   };

   return;
}


- (id) valueForKey:(NSString *)key
{
   return([self objectForKey:key]);
}


# pragma mark - handles notifications

- (void) didReceiveMemoryWarning:(NSNotification *)notification
{
   notification = nil;
   if (isRegistry == YES)
      [self pruneRegistry];
   else
      [self pruneCache];
   return;
}


- (void) registerToReceiveMemoryWarning
{
#ifndef TARGET_OS_MAC
   NSNotificationCenter * defaultCenter;

   defaultCenter = [NSNotificationCenter defaultCenter];

   @synchronized(self)
   {
      if (receiveMemoryWarnings == NO)
      {
         [defaultCenter addObserver:self
                        selector:@selector(didReceiveMemoryWarning:)
                        name:UIApplicationDidReceiveMemoryWarningNotification
                        object:nil];
         receiveMemoryWarnings = YES;
      };
   };
#endif
   return;
}


- (void) unregisterToReceiveMemoryWarning
{
#ifndef TARGET_OS_MAC
   @synchronized(self)
   {
      if (receiveMemoryWarnings == YES)
      {
         [[NSNotificationCenter defaultCenter] removeObserver:self];
         receiveMemoryWarnings = NO;
      };
   };
#endif
   return;
}


@end
