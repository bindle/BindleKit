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
 *  BKHash.m - Provides easy way to produce hashes from strings.
 */
#import "BKHash.h"


#import <inttypes.h>
#import <string.h>
#import <strings.h>
#define COMMON_DIGEST_FOR_OPENSSL 1
#import <CommonCrypto/CommonDigest.h>


#pragma mark -
@implementation NSString (BKStringHash)

- (NSString *) stringWithCryptHash
{
   return([BKHash stringWithCryptHashOfString:self]);
}


- (NSString *) stringWithCryptHashWithSalt:(NSString *)salt
{
   return([BKHash stringWithCryptHashOfString:self withSalt:salt]);
}


- (NSString *) stringWithMD2Hash
{
   return([BKHash stringWithMD2HashOfString:self]);
}


- (NSString *) stringWithMD4Hash
{
   return([BKHash stringWithMD4HashOfString:self]);
}


- (NSString *) stringWithMD5Hash
{
   return([BKHash stringWithMD5HashOfString:self]);
}


- (NSString *) stringWithSHA1Hash
{
   return([BKHash stringWithSHA1HashOfString:self]);
}


- (NSString *) stringWithSHA256Hash
{
   return([BKHash stringWithSHA256HashOfString:self]);
}


@end


#pragma mark -
@implementation BKHash

// internal data
@synthesize string = _string;


#pragma mark - Object Management Methods

- (id) initWithString:(NSString *)string
{
   if ((self = [super init]) == nil)
      return(nil);
   _string = [string retain];
   return(self);
}


#pragma mark - Hashes for BKHash string

- (NSString *) stringWithCryptHash
{
   NSString          * hashString;
   NSString          * saltString;
   char                salt[3];
   const char          b64Table[] =
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

   salt[0] = b64Table[arc4random()%64];
   salt[1] = b64Table[arc4random()%64];
   salt[2] = '\0';

   saltString = [[NSString alloc] initWithUTF8String:salt];
   hashString = [_string stringWithCryptHashWithSalt:saltString];

   [saltString release];

   return(hashString);
}


- (NSString *) stringWithCryptHashWithSalt:(NSString *)saltString
{
   NSAutoreleasePool * pool;
   const char        * salt;
   const char        * key;
   char              * hash;
   NSString          * hashString;

   pool       = [[NSAutoreleasePool alloc] init];

   key        = [_string UTF8String];
   salt       = [saltString UTF8String];
   hash       = crypt(key, salt);
   hashString = [[NSString alloc] initWithUTF8String:hash];

   [pool release];

   return([hashString autorelease]);
}


- (NSString *) stringWithMD2Hash
{
   NSAutoreleasePool * pool;
   NSString          * hashString;
   const char        * input;
   uint8_t             hash[MD2_DIGEST_LENGTH];
   char                cString[(MD2_DIGEST_LENGTH*2)+6];
   char                buff[5];
   unsigned            u;

   pool = [[NSAutoreleasePool alloc] init];

   // hashes input
   input = [_string UTF8String];
   CC_MD2((uint8_t *)input, (CC_LONG)strlen(input), hash);

   // converts to ASCII
   cString[0] = '\0';
   for(u = 0; u < MD2_DIGEST_LENGTH; u++)
   {
      snprintf(buff, 5, "%02X", hash[u]);
      strcat(cString, buff);
   };

   // creates new NSString object of hash
   hashString = [[NSString alloc] initWithUTF8String:cString];

   [pool release];

   return([hashString autorelease]);
}


- (NSString *) stringWithMD4Hash
{
   NSAutoreleasePool * pool;
   NSString          * hashString;
   const char        * input;
   uint8_t             hash[MD4_DIGEST_LENGTH];
   char                cString[(MD4_DIGEST_LENGTH*2)+6];
   char                buff[5];
   unsigned            u;

   pool = [[NSAutoreleasePool alloc] init];

   // hashes input
   input = [_string UTF8String];
   CC_MD4((uint8_t *)input, (CC_LONG)strlen(input), hash);

   // converts to ASCII
   cString[0] = '\0';
   for(u = 0; u < MD2_DIGEST_LENGTH; u++)
   {
      snprintf(buff, 5, "%02X", hash[u]);
      strcat(cString, buff);
   };

   // creates new NSString object of hash
   hashString = [[NSString alloc] initWithUTF8String:cString];

   [pool release];

   return([hashString autorelease]);
}


- (NSString *) stringWithMD5Hash
{
   NSAutoreleasePool * pool;
   NSString          * hashString;
   const char        * input;
   uint8_t             hash[MD5_DIGEST_LENGTH];
   char                cString[(MD5_DIGEST_LENGTH*2)+6];
   char                buff[5];
   unsigned            u;

   pool = [[NSAutoreleasePool alloc] init];

   // hashes input
   input = [_string UTF8String];
   CC_MD5((uint8_t *)input, (CC_LONG)strlen(input), hash);

   // converts to ASCII
   cString[0] = '\0';
   for(u = 0; u < MD5_DIGEST_LENGTH; u++)
   {
      snprintf(buff, 5, "%02X", hash[u]);
      strcat(cString, buff);
   };

   // creates new NSString object of hash
   hashString = [[NSString alloc] initWithUTF8String:cString];

   [pool release];

   return([hashString autorelease]);
}


- (NSString *) stringWithSHA1Hash
{
   NSAutoreleasePool * pool;
   NSString          * hashString;
   const char        * input;
   uint8_t             hash[SHA_DIGEST_LENGTH];
   char                cString[(SHA_DIGEST_LENGTH*2)+7];
   char                buff[5];
   unsigned            u;

   pool = [[NSAutoreleasePool alloc] init];

   // hashes input
   input = [_string UTF8String];
   CC_SHA1((uint8_t *)input, (CC_LONG)strlen(input), hash);

   // converts to ASCII
   cString[0] = '\0';
   for(u = 0; u < SHA_DIGEST_LENGTH; u++)
   {
      snprintf(buff, 5, "%02X", hash[u]);
      strcat(cString, buff);
   };

   // creates new NSString object of hash
   hashString = [[NSString alloc] initWithUTF8String:cString];

   [pool release];

   return([hashString autorelease]);
}


- (NSString *) stringWithSHA256Hash
{
   NSAutoreleasePool * pool;
   NSString          * hashString;
   const char        * input;
   uint8_t             hash[SHA256_DIGEST_LENGTH];
   char                cString[(SHA256_DIGEST_LENGTH*2)+9];
   char                buff[5];
   unsigned            u;

   pool = [[NSAutoreleasePool alloc] init];

   // hashes input
   input = [_string UTF8String];
   CC_SHA256((uint8_t *)input, (CC_LONG)strlen(input), hash);

   // converts to ASCII
   cString[0] = '\0';
   for(u = 0; u < SHA256_DIGEST_LENGTH; u++)
   {
      snprintf(buff, 5, "%02X", hash[u]);
      strcat(cString, buff);
   };

   // creates new NSString object of hash
   hashString = [[NSString alloc] initWithUTF8String:cString];

   [pool release];

   return([hashString autorelease]);
}


#pragma mark - Hashes for external strings

+ (NSString *) stringWithCryptHashOfString:(NSString *)string
{
   BKHash   * hash;
   NSString * hashString;

   hash       = [[BKHash alloc] initWithString:string];
   hashString = [hash stringWithCryptHash];
   [hash release];

   return(hashString);
}


+ (NSString *) stringWithCryptHashOfString:(NSString *)string withSalt:(NSString *)salt
{
   BKHash   * hash;
   NSString * hashString;

   hash       = [[BKHash alloc] initWithString:string];
   hashString = [hash stringWithCryptHashWithSalt:salt];
   [hash release];

   return(hashString);
}


+ (NSString *) stringWithMD2HashOfString:(NSString *)string
{
   BKHash   * hash;
   NSString * hashString;

   hash       = [[BKHash alloc] initWithString:string];
   hashString = [hash stringWithMD2Hash];
   [hash release];

   return(hashString);
}


+ (NSString *) stringWithMD4HashOfString:(NSString *)string
{
   BKHash   * hash;
   NSString * hashString;

   hash       = [[BKHash alloc] initWithString:string];
   hashString = [hash stringWithMD4Hash];
   [hash release];

   return(hashString);
}


+ (NSString *) stringWithMD5HashOfString:(NSString *)string
{
   BKHash   * hash;
   NSString * hashString;

   hash       = [[BKHash alloc] initWithString:string];
   hashString = [hash stringWithMD5Hash];
   [hash release];

   return(hashString);
}


+ (NSString *) stringWithSHA1HashOfString:(NSString *)string
{
   BKHash   * hash;
   NSString * hashString;

   hash       = [[BKHash alloc] initWithString:string];
   hashString = [hash stringWithSHA1Hash];
   [hash release];

   return(hashString);
}


+ (NSString *) stringWithSHA256HashOfString:(NSString *)string
{
   BKHash   * hash;
   NSString * hashString;

   hash       = [[BKHash alloc] initWithString:string];
   hashString = [hash stringWithSHA256Hash];
   [hash release];

   return(hashString);
}


@end
