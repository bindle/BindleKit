/*
 *  Bindle Binaries Objective-C Kit
 *  Copyright (c) 2013 Bindle Binaries
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
 *   BKUUID is a drop-in replacement for NSUUID and is supported on iOS 5 and
 *   and higher.  BKUUID is built around CFUUIDRef which has been available
 *   since iOS 2.0.  BKUUID can be used to convert between CFUUIDRef and
 *   NSUUID objects as well as compare NSString, NSData, and NSUUID objects.
 */

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

@interface BKUUID : NSObject
{
   // object state
   CFUUIDRef    _uuid;
}

#pragma mark - Creating UUIDs
/// @name Creating UUIDs

/// Create and returns a new UUID.
/// @return A new UUID object.
- (id) init;


/// Creates and returns a new UUID with the given CFUUIDRef.
/// @param uuidRef   The CFUUIDRef reference used to create the UUID.
/// @return A new UUID object.
- (id) initWithCFUUID:(CFUUIDRef)uuidRef;


/// Creates and returns a new UUID with the given bytes.
/// @param data   NSData object containing raw UUID bytes to use to create the
///   UUID.
/// @return A new UUID object.
- (id) initWithNSData:(NSData *)data;


/// Creates and returns a new UUID with the given NSUUID.
/// @param uuid   The NSUUID object used to create the UUID.
/// @return A new UUID object.
- (id) initWithNSUUID:(NSUUID *)uuid;


/// Creates and returns a new UUID with the given bytes.
/// @param bytes   Raw UUID bytes to use to create the UUID.
/// @return A new UUID object.
- (id) initWithUUIDBytes:(const uuid_t)bytes;


/// Creates and returns a new UUID from the formatted string.
/// @param string    string containing a UUID. The standard format for UUIDs
///   represented in ASCII is a string punctuated by hyphens, for example
///   68753A44-4D6F-1226-9C60-0050E4C00067.
/// @return A new UUID object.
- (id) initWithUUIDString:(NSString *)string;


/// Create and returns a new UUID.
/// @return A new UUID object.
+ (id) UUID;


#pragma mark - Get UUID Values
/// @name Get UUID Values

/// Creates and returns the UUID as a CFUUIDRef reference.
/// @return A CFUUIDRef reference containing the uuid.
- (CFUUIDRef) CFUUID;


/// Creates and returns the UUID as a NSUUID object.
/// @return A NSUUID object containing the uuid.
- (NSUUID *) NSUUID;


/// Returns the UUIDs bytes.
/// @param uuid  The value of uuid represented as raw bytes.
- (void) getUUIDBytes:(uuid_t)uuid;


/// Returns the UUIDs bytes as a NSData object.
/// @return A NSData object containing the value of uuid represented as raw bytes.
- (NSData *) UUIDData;


/// Returns the UUID as a string.
/// @return A string containing a formatted UUID for example E621E1F8-C36C-495A-93FC-0C247A3E6E5F.
- (NSString *) UUIDString;

@end
