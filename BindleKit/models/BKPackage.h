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

#pragma mark - Object Management Methods
/// @name  Object Management Methods

/// Initializes a package object.
/// @param name The name of the package.
/// @param version The referenced version of the package.
- (id) initWithName:(NSString *)name version:(NSString *)version;

/// Creates a package object.
/// @param name The name of the package.
/// @param version The referenced version of the package.
+ (id) packageWithName:(NSString *)name version:(NSString *)version;


#pragma mark - API Information methods
/// @name API Information methods
@property (nonatomic, assign) NSUInteger   apiVersionCurrent;
@property (nonatomic, assign) NSUInteger   apiVersionRevision;
@property (nonatomic, assign) NSUInteger   apiVersionAge;
@property (nonatomic, strong) NSString   * apiVersionString;
@property (nonatomic, assign) const char * UTF8ApiVersionString;


#pragma mark - Package Information methods
/// @name Package Information methods

/// The dot notated identifier of the package.
@property (nonatomic, strong) NSString   * packageIdentifier;

/// The name of the package.
@property (nonatomic, strong) NSString   * packageName;

/// The referenced version of the package.
@property (nonatomic, strong) NSString   * packageVersion;

/// The website of the package, if available.
@property (nonatomic, strong) NSString   * packageWebsite;

/// The license of the package.
@property (nonatomic, strong) NSString   * packageLicense;

/// The UTF8 string of the identifier of the package.
@property (nonatomic, assign) const char * UTF8PackageIdentifier;

/// The UTF8 string name of the package.
@property (nonatomic, assign) const char * UTF8PackageName;

/// The UTF8 string of referenced version of the package.
@property (nonatomic, assign) const char * UTF8PackageVersion;

/// The UTF8 string of the website of the package, if available.
@property (nonatomic, assign) const char * UTF8PackageWebsite;

/// The UTF8 string of the license of the package, if available.
@property (nonatomic, assign) const char * UTF8PackageLicense;

@end
