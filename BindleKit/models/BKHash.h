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
/**
 *  Provides easy way to produce hashes from NSString objects.
 */

#import <Foundation/Foundation.h>

#pragma mark -
@interface NSString (BKStringHash)

/// Provides a crypt hash of the receiver's data.
- (NSString *) stringWithCryptHash;

/// Provides a crypt hash of the receiver's data.
/// @param salt The salt used by the crypt operation
- (NSString *) stringWithCryptHashWithSalt:(NSString *)salt;

/// Provides a MD2 hash of the receiver's data.
- (NSString *) stringWithMD2Hash;

/// Provides a MD4 hash of the receiver's data.
- (NSString *) stringWithMD4Hash;

/// Provides a MD5 hash of the receiver's data.
- (NSString *) stringWithMD5Hash;

/// Provides a SHA1 hash of the receiver's data.
- (NSString *) stringWithSHA1Hash;

/// Provides a SHA256 hash of the receiver's data.
- (NSString *) stringWithSHA256Hash;

@end

#pragma mark -
@interface BKHash : NSObject
{
   // internal data
   NSString * _string;
}

@property (nonatomic, strong) NSString * string;

/// @name Object Management Methods
- (id) initWithString:(NSString *)string;

/// @name Hashes for BKHash string
- (NSString *) stringWithCryptHash;
- (NSString *) stringWithCryptHashWithSalt:(NSString *)salt;
- (NSString *) stringWithMD2Hash;
- (NSString *) stringWithMD4Hash;
- (NSString *) stringWithMD5Hash;
- (NSString *) stringWithSHA1Hash;
- (NSString *) stringWithSHA256Hash;

/// @name Hashes for external strings
+ (NSString *) stringWithCryptHashOfString:(NSString *)string;
+ (NSString *) stringWithCryptHashOfString:(NSString *)string withSalt:(NSString *)salt;
+ (NSString *) stringWithMD2HashOfString:(NSString *)string;
+ (NSString *) stringWithMD4HashOfString:(NSString *)string;
+ (NSString *) stringWithMD5HashOfString:(NSString *)string;
+ (NSString *) stringWithSHA1HashOfString:(NSString *)string;
+ (NSString *) stringWithSHA256HashOfString:(NSString *)string;

@end
