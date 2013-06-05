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
#import "BKUUID.h"

@implementation BKUUID

#pragma mark - Object Management Methods

- (void) dealloc
{
   CFRelease(_uuid);
   return;
}


- (id) init
{
   if ((self = [super init]) == nil)
      return(self);

   _uuid = CFUUIDCreate(NULL);

   return(self);
}


- (id) initWithCFUUID:(CFUUIDRef)uuidRef;
{
   if ((self = [super init]) == nil)
      return(self);

   CFRetain(uuidRef);
   _uuid = uuidRef;

   return(self);
}


- (id) initWithNSData:(NSData *)data
{
   size_t len;
   uuid_t uuid;

   len = ([data length] > 16) ? 16 : [data length];
   memset(uuid, 0, sizeof(uuid_t));
   memcpy(uuid, [data bytes], len);

   if ((self = [self initWithUUIDBytes:uuid]) == nil)
      return(self);

   return(self);
}


- (id) initWithNSUUID:(NSUUID *)uuid
{
   if ((self = [self initWithUUIDString:[uuid UUIDString]]) == nil)
      return(self);
   return(self);
}


- (id) initWithUUIDBytes:(const uuid_t)uuid
{
   CFUUIDBytes bytes;

   if ((self = [super init]) == nil)
      return(self);

   memset(&bytes, 0, sizeof(CFUUIDBytes));
   bytes.byte0  = uuid[0];
   bytes.byte1  = uuid[1];
   bytes.byte2  = uuid[2];
   bytes.byte3  = uuid[3];
   bytes.byte4  = uuid[4];
   bytes.byte5  = uuid[5];
   bytes.byte6  = uuid[6];
   bytes.byte7  = uuid[7];
   bytes.byte8  = uuid[8];
   bytes.byte9  = uuid[9];
   bytes.byte10 = uuid[10];
   bytes.byte11 = uuid[11];
   bytes.byte12 = uuid[12];
   bytes.byte13 = uuid[13];
   bytes.byte14 = uuid[14];
   bytes.byte15 = uuid[15];

   _uuid = CFUUIDCreateFromUUIDBytes(NULL, bytes);

   return(self);
}


- (id) initWithUUIDString:(NSString *)string
{
   CFStringRef stringRef;

   if ((self = [super init]) == nil)
      return(self);

   stringRef = (__bridge_retained CFStringRef) string;
   _uuid     = CFUUIDCreateFromString(NULL, stringRef);
   CFRelease(stringRef);

   return(self);
}


+ (id) UUID
{
   return([[BKUUID alloc] init]);
}


#pragma mark - Get UUID Values

- (CFUUIDRef) CFUUID
{
   return(_uuid);
}


- (NSData *) UUIDData
{
   uuid_t uuid;
   [self getUUIDBytes:uuid];
   return([[NSData alloc] initWithBytes:uuid length:16]);
}


- (NSUUID *) NSUUID
{
   return([[NSUUID alloc] initWithUUIDString:[self UUIDString]]);
}


- (void) getUUIDBytes:(uuid_t)uuid
{
   CFUUIDBytes bytes;

   bytes = CFUUIDGetUUIDBytes(_uuid);

   memset(uuid, 0, sizeof(uuid_t));
   uuid[0]  = bytes.byte0;
   uuid[1]  = bytes.byte1;
   uuid[2]  = bytes.byte2;
   uuid[3]  = bytes.byte3;
   uuid[4]  = bytes.byte4;
   uuid[5]  = bytes.byte5;
   uuid[6]  = bytes.byte6;
   uuid[7]  = bytes.byte7;
   uuid[8]  = bytes.byte8;
   uuid[9]  = bytes.byte9;
   uuid[10] = bytes.byte10;
   uuid[11] = bytes.byte11;
   uuid[12] = bytes.byte12;
   uuid[13] = bytes.byte13;
   uuid[14] = bytes.byte14;
   uuid[15] = bytes.byte15;

   return;
}


- (NSString *) UUIDString
{   
   return((__bridge_transfer NSString *) CFUUIDCreateString(NULL, _uuid));
}

#pragma mark - Comparisons

- (BOOL) isEqual:(id)object
{
   int      pos;
   uuid_t   uuid1;
   uuid_t   uuid2;

   memset(uuid2, 0, sizeof(uuid_t));

   [self getUUIDBytes:uuid1];

   // converts objects to uuid_t
   if (([object isKindOfClass:[BKUUID class]]))
   {
      [((BKUUID *)self) getUUIDBytes:uuid2];
   }
   else if (([object isKindOfClass:[NSData class]]))
   {
      if (([((NSData *) object) length] > 16))
         return(NO);
      memcpy(uuid2, [((NSData *) object) bytes], [((NSData *) object) length]);
   }
   else if (([object isKindOfClass:[NSString class]]))
   {
      [[[BKUUID alloc] initWithUUIDString:((NSString *) object)] getUUIDBytes:uuid2];
   }
   else if (([object isKindOfClass:[NSUUID class]]))
   {
      if (([((NSData *) object) length] != 16))
         return(NO);
      [((NSUUID *) object) getUUIDBytes:uuid2];
   }
   else
   {
      return(NO);
   };

   // compares two values
   for(pos = 0; pos < 16; pos++)
      if (uuid1[pos] != uuid2[pos])
         return(NO);

   return(YES);
}

@end
