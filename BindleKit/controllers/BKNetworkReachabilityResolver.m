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
 *  This is an internal class which resolves host names to IP addresses for the
 *  BKNetworkReachability class.  The class resolves the name resolution using a
 *  seperate thread to avoid blocking the main thread.
 */

#import "BKNetworkReachabilityResolver.h"

@implementation BKNetworkReachabilityResolver

// host information
@synthesize hostname = _hostname;
@synthesize addreses = _addr;

// error information
@synthesize errorCode    = _errorCode;
@synthesize errorMessage = _errorMessage;


#pragma mark - Object Management Methods

- (void) dealloc
{
   // host information
   if ((_addr))
      freeaddrinfo(_addr);

   return;
}


- (id) initWithHostname:(NSString *)hostname
{
   NSAssert((hostname != nil), @"hostname must not be nil");
   if ((self = [super init]) == nil)
      return(self);

   // host information
   _hostname = [[NSString alloc] initWithString:hostname];
   _addr     = NULL;

   // error information
   _errorCode    = 0;
   _errorMessage = @"success";

   return(self);
}


#pragma mark - non-concurrent tasks

- (void) main
{
   const char        * hostname;
   struct addrinfo     hints;
   struct addrinfo   * hintsp;
   struct addrinfo   * res;

   @autoreleasepool
   {
      hostname = [_hostname UTF8String];

      // configures lookup
      memset(&hints, 0, sizeof(struct addrinfo));
      hints.ai_flags    = AI_V4MAPPED|AI_ALL;
      hints.ai_family   = PF_UNSPEC;
      hints.ai_socktype = 0; // any socket type (STREAM/DGRAM/RAW)
      hints.ai_protocol = 0; // any protocol (UDP/TCP)
      hintsp            = &hints;

      // performs lookup
      if ((_errorCode = getaddrinfo(hostname, NULL, hintsp, &res)))
         _errorMessage = [[NSString alloc] initWithUTF8String:gai_strerror((int)_errorCode)];

      // saves results
      _addr = res;
   };

   return;
}


@end
