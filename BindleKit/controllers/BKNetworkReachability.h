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
 *  BKNetworkReachability.m - Wrapper class for SCNetworkReachability
 */


#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <netinet6/in6.h>

#define BKNetworkReachabilityNotification @"BKNetworkReachabilityNotification"

@interface BKNetworkReachability: NSObject
{
   // monitoring information
   BOOL                         linkLocalRef;
   SCNetworkReachabilityRef     reachabilityRef;
   SCNetworkReachabilityFlags   reachabilityFlags;

   // notification information
   BOOL                         notifierOn;
   BOOL                         logUpdates;
   NSString                   * notificationString;

   // host information
   NSString                   * hostname;
}

/// @name Creating and Initializing a BKNetworkReachability object
- (id) initWithHostName:(NSString *)hostName;
- (id) initWithAddress:(struct sockaddr_in *)hostAddress;
- (id) initForInternetConnection;
- (id) initForLinkLocal;
+ (BKNetworkReachability *) reachabilityWithHostName:(NSString *)hostName;
+ (BKNetworkReachability *) reachabilityWithAddress:(struct sockaddr_in *)hostAddress;
+ (BKNetworkReachability *) reachabilityForInternetConnection;
+ (BKNetworkReachability *) reachabilityForLinkLocal;

// @name monitoring information
@property (nonatomic, readonly) SCNetworkReachabilityFlags reachabilityFlags;
@property (nonatomic, readonly) BOOL       connectionOnDemand;
@property (nonatomic, readonly) BOOL       connectionOnTraffic;
@property (nonatomic, readonly) BOOL       connectionRequired;
@property (nonatomic, readonly) BOOL       interventionRequired;
@property (nonatomic, readonly) BOOL       isDirect;
@property (nonatomic, readonly) BOOL       isLocalAddress;
@property (nonatomic, readonly) BOOL       isWWAN;
@property (nonatomic, readonly) BOOL       reachable;
@property (nonatomic, readonly) BOOL       transientConnection;

/// @name host information
@property (nonatomic, retain)   NSString * hostname;

/// @name Manage Notifications
- (BOOL) startNotifier;
- (void) stopNotifier;
@property (nonatomic, retain)   NSString * notificationString;
@property (assign, readwrite)   BOOL       logUpdates;

/// @name Network Flag Handling
- (void) logNetworkReachabilityFlags;
- (NSString *) stringForNetworkReachabilityFlags;

@end
