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
 *  Stores software package information.
 */

#import <Foundation/Foundation.h>

@interface BKPackage : NSObject
{
   // API Information methods
   NSUInteger   apiVersionCurrent;
   NSUInteger   apiVersionRevision;
   NSUInteger   apiVersionAge;
   NSString   * apiVersionString;

   // Package Information methods
   NSString   * packageIdentifier;
   NSString   * packageName;
   NSString   * packageVersion;
   NSString   * packageWebsite;
   NSString   * packageLicense;
}

/// @name  Object Management Methods
- (id) initWithName:(NSString *)name version:(NSString *)version;
+ (id) packageWithName:(NSString *)name version:(NSString *)version;

/// @name API Information methods
@property (nonatomic, assign) NSUInteger   apiVersionCurrent;
@property (nonatomic, assign) NSUInteger   apiVersionRevision;
@property (nonatomic, assign) NSUInteger   apiVersionAge;
@property (nonatomic, retain) NSString   * apiVersionString;
@property (nonatomic, assign) const char * UTF8ApiVersionString;

/// @name Package Information methods
@property (nonatomic, retain) NSString   * packageIdentifier;
@property (nonatomic, retain) NSString   * packageName;
@property (nonatomic, retain) NSString   * packageVersion;
@property (nonatomic, retain) NSString   * packageWebsite;
@property (nonatomic, retain) NSString   * packageLicense;
@property (nonatomic, assign) const char * UTF8PackageIdentifier;
@property (nonatomic, assign) const char * UTF8PackageName;
@property (nonatomic, assign) const char * UTF8PackageVersion;
@property (nonatomic, assign) const char * UTF8PackageWebsite;
@property (nonatomic, assign) const char * UTF8PackageLicense;

@end
