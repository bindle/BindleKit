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
 *  @file BindleKit/categories/BKStringCrypto.m expands NSString
 */

#import "BKStringDigest.h"
#import <inttypes.h>
#import <string.h>
#import <strings.h>
#define COMMON_DIGEST_FOR_OPENSSL 1
#import <CommonCrypto/CommonDigest.h>

const char LBBase64Table[] =
{
   'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
   'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
   'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
   'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
   'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
   'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
   'w', 'x', 'y', 'z', '0', '1', '2', '3',
   '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSString (BKStringDigest)

- (NSString *) stringHashWithCrypt
{
   NSString          * hashString;
   NSString          * saltString;
   char                salt[3];

   salt[0] = LBBase64Table[arc4random()%64];
   salt[1] = LBBase64Table[arc4random()%64];
   salt[2] = '\0';

   saltString = [[NSString alloc] initWithUTF8String:salt];
   hashString = [self stringHashWithCryptWithSalt:saltString];

   [saltString release];

   return(hashString);
}


- (NSString *) stringHashWithCryptWithSalt:(NSString *)saltString
{
   NSAutoreleasePool * pool;
   const char        * salt;
   const char        * key;
   char              * hash;
   NSString          * hashString;

   pool       = [[NSAutoreleasePool alloc] init];

   key        = [self UTF8String];
   salt       = [saltString UTF8String];
   hash       = crypt(key, salt);
   hashString = [[NSString alloc] initWithUTF8String:hash];

   [pool release];

   return([hashString autorelease]);
}


- (NSString *) stringHashWithMD2
{
   NSAutoreleasePool * pool;
   NSString          * string;
   const char        * input;
   uint8_t             hash[MD2_DIGEST_LENGTH];
   char                cString[(MD2_DIGEST_LENGTH*2)+6];
   char                buff[5];
   unsigned            u;

   pool = [[NSAutoreleasePool alloc] init];

   // hashes input
   input = [self UTF8String];
   CC_MD2((uint8_t *)input, (CC_LONG)strlen(input), hash);

   // converts to ASCII
   cString[0] = '\0';
   for(u = 0; u < MD2_DIGEST_LENGTH; u++)
   {
      snprintf(buff, 5, "%02X", hash[u]);
      strcat(cString, buff);
   };

   // creates new NSString object of hash
   string = [[NSString alloc] initWithUTF8String:cString];

   [pool release];

   return([string autorelease]);
}


- (NSString *) stringHashWithMD4
{
   NSAutoreleasePool * pool;
   NSString          * string;
   const char        * input;
   uint8_t             hash[MD4_DIGEST_LENGTH];
   char                cString[(MD4_DIGEST_LENGTH*2)+6];
   char                buff[5];
   unsigned            u;

   pool = [[NSAutoreleasePool alloc] init];

   // hashes input
   input = [self UTF8String];
   CC_MD4((uint8_t *)input, (CC_LONG)strlen(input), hash);

   // converts to ASCII
   cString[0] = '\0';
   for(u = 0; u < MD2_DIGEST_LENGTH; u++)
   {
      snprintf(buff, 5, "%02X", hash[u]);
      strcat(cString, buff);
   };

   // creates new NSString object of hash
   string = [[NSString alloc] initWithUTF8String:cString];

   [pool release];

   return([string autorelease]);
}


- (NSString *) stringHashWithMD5
{
   NSAutoreleasePool * pool;
   NSString          * string;
   const char        * input;
   uint8_t             hash[MD5_DIGEST_LENGTH];
   char                cString[(MD5_DIGEST_LENGTH*2)+6];
   char                buff[5];
   unsigned            u;

   pool = [[NSAutoreleasePool alloc] init];

   // hashes input
   input = [self UTF8String];
   CC_MD5((uint8_t *)input, (CC_LONG)strlen(input), hash);

   // converts to ASCII
   cString[0] = '\0';
   for(u = 0; u < MD5_DIGEST_LENGTH; u++)
   {
      snprintf(buff, 5, "%02X", hash[u]);
      strcat(cString, buff);
   };

   // creates new NSString object of hash
   string = [[NSString alloc] initWithUTF8String:cString];

   [pool release];

   return([string autorelease]);
}


- (NSString *) stringHashWithSHA1
{
   NSAutoreleasePool * pool;
   NSString          * string;
   const char        * input;
   uint8_t             hash[SHA_DIGEST_LENGTH];
   char                cString[(SHA_DIGEST_LENGTH*2)+7];
   char                buff[5];
   unsigned            u;

   pool = [[NSAutoreleasePool alloc] init];

   // hashes input
   input = [self UTF8String];
   CC_SHA1((uint8_t *)input, (CC_LONG)strlen(input), hash);

   // converts to ASCII
   cString[0] = '\0';
   for(u = 0; u < SHA_DIGEST_LENGTH; u++)
   {
      snprintf(buff, 5, "%02X", hash[u]);
      strcat(cString, buff);
   };

   // creates new NSString object of hash
   string = [[NSString alloc] initWithUTF8String:cString];

   [pool release];

   return([string autorelease]);
}


- (NSString *) stringHashWithSHA256
{
   NSAutoreleasePool * pool;
   NSString          * string;
   const char        * input;
   uint8_t             hash[SHA256_DIGEST_LENGTH];
   char                cString[(SHA256_DIGEST_LENGTH*2)+9];
   char                buff[5];
   unsigned            u;

   pool = [[NSAutoreleasePool alloc] init];

   // hashes input
   input = [self UTF8String];
   CC_SHA256((uint8_t *)input, (CC_LONG)strlen(input), hash);

   // converts to ASCII
   cString[0] = '\0';
   for(u = 0; u < SHA256_DIGEST_LENGTH; u++)
   {
      snprintf(buff, 5, "%02X", hash[u]);
      strcat(cString, buff);
   };

   // creates new NSString object of hash
   string = [[NSString alloc] initWithUTF8String:cString];

   [pool release];

   return([string autorelease]);
}


@end
