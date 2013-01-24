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
 *  BKNetworkReachability.h - Wrapper class for SCNetworkReachability
 */
#import "BKNetworkReachability.h"

#import <CoreFoundation/CoreFoundation.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>


#if (!(TARGET_OS_IPHONE))
#define kSCNetworkReachabilityFlagsIsWWAN 0
#endif


#pragma mark - Private BKNetworkReachability Category Declaration
@interface BKNetworkReachability ()

@property (nonatomic, assign) SCNetworkReachabilityFlags reachabilityFlags;

- (int) networkReachabilityFlagsFormat:(char *)str length:(unsigned long)size
   flags:(SCNetworkReachabilityFlags)flags;

@end


#pragma mark - BKNetworkReachability Class Implementation
@implementation BKNetworkReachability

// monitoring information
@synthesize reachabilityFlags;

// notification information
@synthesize logUpdates;
@synthesize notificationString;

// host information
@synthesize hostname;


#pragma mark - Creating and Initializing a BKNetworkReachability

- (void) dealloc
{
   // stops notifier
   [self stopNotifier];

   // monitoring information
   if ((reachabilityRef))
      CFRelease(reachabilityRef);

   return;
}


- (id) initWithHostName:(NSString *)newHostname
{
   if ((self = [super init]) == nil)
      return(self);

   @autoreleasepool
   {
      hostname        = newHostname;
      notifierOn      = NO;
      linkLocalRef    = NO;
      reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [newHostname UTF8String]);
   };

   return(self);
}


- (id) initWithAddress:(struct sockaddr_in *)hostAddress
{
   if ((self = [super init]) == nil)
      return(self);

   notifierOn      = NO;
   linkLocalRef    = NO;
   reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);

   return(self);
}


- (id) initForInternetConnection
{
   struct sockaddr_in zeroAddress;
   bzero(&zeroAddress, sizeof(zeroAddress));
   zeroAddress.sin_len    = sizeof(zeroAddress);
   zeroAddress.sin_family = AF_INET;
   return([self initWithAddress:&zeroAddress]);
}


- (id) initForLinkLocal
{
   struct sockaddr_in localWifiAddress;

   bzero(&localWifiAddress, sizeof(localWifiAddress));
   localWifiAddress.sin_len         = sizeof(localWifiAddress);
   localWifiAddress.sin_family      = AF_INET;
   localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);

   if ((self = [self initWithAddress:&localWifiAddress]) == nil)
      return(nil);

   linkLocalRef = YES;

   return(self);
}


+ (BKNetworkReachability *) reachabilityWithHostName:(NSString *)newHostname
{
   return([[BKNetworkReachability alloc] initWithHostName:newHostname]);
}


+ (BKNetworkReachability *) reachabilityWithAddress:(struct sockaddr_in *)hostAddress
{
   return([[BKNetworkReachability alloc] initWithAddress:hostAddress]);
}


+ (BKNetworkReachability *) reachabilityForInternetConnection
{
   return([[BKNetworkReachability alloc] initForInternetConnection]);
}


+ (BKNetworkReachability *) reachabilityForLinkLocal
{
   return([[BKNetworkReachability alloc] initForLinkLocal]);
}


#pragma mark - Getter methods

- (BOOL) connectionOnDemand
{
   SCNetworkReachabilityFlags flags = self.reachabilityFlags;
   return((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0);
}


- (BOOL) connectionOnTraffic
{
   SCNetworkReachabilityFlags flags = self.reachabilityFlags;
   return((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0);
}


- (BOOL) connectionRequired
{
   SCNetworkReachabilityFlags flags = self.reachabilityFlags;
   return((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
}


- (BOOL) interventionRequired
{
   SCNetworkReachabilityFlags flags = self.reachabilityFlags;
   return((flags & kSCNetworkReachabilityFlagsInterventionRequired) != 0);
}


- (BOOL) isDirect
{
   SCNetworkReachabilityFlags flags = self.reachabilityFlags;
   return((flags & kSCNetworkReachabilityFlagsIsDirect) != 0);
}


- (BOOL) isLocalAddress
{
   SCNetworkReachabilityFlags flags = self.reachabilityFlags;
   return((flags & kSCNetworkReachabilityFlagsIsLocalAddress) != 0);
}


- (BOOL) isWWAN
{
   SCNetworkReachabilityFlags flags = self.reachabilityFlags;
   return((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0);
}


- (BOOL) reachable
{
   SCNetworkReachabilityFlags flags = self.reachabilityFlags;
   return((flags & kSCNetworkReachabilityFlagsReachable) != 0);
}


- (SCNetworkReachabilityFlags) reachabilityFlags
{
   SCNetworkReachabilityFlags flags;

   @synchronized(self)
   {
      if ((notifierOn))
         return(reachabilityFlags);
      if (!(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)))
         bzero(&flags, sizeof(SCNetworkReachabilityFlags));
      reachabilityFlags = flags;
   };

   return(flags);
}


- (BOOL) transientConnection
{
   SCNetworkReachabilityFlags flags = self.reachabilityFlags;
   return((flags & kSCNetworkReachabilityFlagsTransientConnection) != 0);
}


#pragma mark - Setter methods

- (void) setHostname:(NSString *)newHostname
{
   BOOL restartNotifier;

   NSAssert((newHostname != nil), @"hostname must not be nil");

   linkLocalRef = NO;
   hostname     = newHostname;

   restartNotifier = NO;
   if ((notifierOn))
   {
      [self stopNotifier];
      restartNotifier = YES;
   };

   @autoreleasepool
   {
      if ((reachabilityRef))
         CFRelease(reachabilityRef);
      reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
   };

   if ((restartNotifier))
      [self startNotifier];

   return;
}


#pragma mark - manage notifications

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void * info)
{
   BKNetworkReachability * reachability;

   @autoreleasepool
   {
      reachability                   = (__bridge BKNetworkReachability *) info;
      reachability.reachabilityFlags = flags;

      if ((reachability.logUpdates))
         [reachability logNetworkReachabilityFlags];

      [[NSNotificationCenter defaultCenter] postNotificationName:BKNetworkReachabilityNotification object:reachability];
      if ((reachability.notificationString))
         [[NSNotificationCenter defaultCenter] postNotificationName:reachability.notificationString object:reachability];
   };

   return;
}


- (BOOL) startNotifier
{
   SCNetworkReachabilityFlags    flags;
   SCNetworkReachabilityContext  context = {0, (__bridge void *)(self), NULL, NULL, NULL};

   @synchronized(self)
   {
      // exits if already sending notifications
      if ((notifierOn))
         return(YES);

      // assigns a client which receives callbacks when the reachability changes.
      if (!(SCNetworkReachabilitySetCallback(reachabilityRef, ReachabilityCallback, &context)))
         return(NO);

      // schedules the specified network target with the specified run loop and mode
      if (!(SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)))
         return(NO);

      // retrieves current reachbility flags and stores them for access
      if (!(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)))
         bzero(&flags, sizeof(SCNetworkReachabilityFlags));
      reachabilityFlags = flags;

      notifierOn = YES;
   };

   // logs current flags
   if ((self.logUpdates))
      [self logNetworkReachabilityFlags];

   // sends notification with current status
   [[NSNotificationCenter defaultCenter] postNotificationName:BKNetworkReachabilityNotification object:self];
   if ((notificationString))
      [[NSNotificationCenter defaultCenter] postNotificationName:notificationString object:self];

   return(YES);
}


- (void) stopNotifier
{
   @synchronized(self)
   {
      if (!(reachabilityRef))
         return;
      SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
      notifierOn = NO;
   };
   return;
}


#pragma mark - Network Flag Handling

- (void) logNetworkReachabilityFlags
{
   SCNetworkReachabilityFlags flags = self.reachabilityFlags;
   char str[1024];

   [self networkReachabilityFlagsFormat:str length:1024L flags:flags];
   if (!(notificationString))
      NSLog(@"Reachability: %s", str);
   if ((notificationString))
      NSLog(@"Reachability: %s (%@)", str, notificationString);

   return;
}


- (int) networkReachabilityFlagsFormat:(char *)str length:(unsigned long)size
   flags:(SCNetworkReachabilityFlags)flags
{
   int len;
   len = snprintf(str, size, "%c%c %c%c%c%c%c%c%c",
      (flags & kSCNetworkReachabilityFlagsReachable)              ? 'R' : '-',
      (flags & kSCNetworkReachabilityFlagsIsWWAN)                 ? 'W' : '-',

      (flags & kSCNetworkReachabilityFlagsTransientConnection)    ? 't' : '-',
      (flags & kSCNetworkReachabilityFlagsConnectionRequired)     ? 'c' : '-',
      (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)    ? 'C' : '-',
      (flags & kSCNetworkReachabilityFlagsInterventionRequired)   ? 'i' : '-',
      (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)     ? 'D' : '-',
      (flags & kSCNetworkReachabilityFlagsIsLocalAddress)         ? 'l' : '-',
      (flags & kSCNetworkReachabilityFlagsIsDirect)               ? 'd' : '-'
   );
   return(len);
}


- (NSString *) stringForNetworkReachabilityFlags
{
   char                         str[1024];
   NSString                   * logString;
   SCNetworkReachabilityFlags   flags;

   flags = self.reachabilityFlags;

   [self networkReachabilityFlagsFormat:str length:1024L flags:flags];
   logString = [NSString stringWithFormat:@"%s", str];

   return(logString);
}


@end
