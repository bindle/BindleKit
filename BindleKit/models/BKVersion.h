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
 *  Provides library version information.
 *
 *  BKVersion provides API and package information about the Bindle Binaries
 *  Objective-C development kit.
 */

#import <Foundation/Foundation.h>
#import <BindleKit/models/BKPackage.h>

@interface BKVersion : BKPackage

#pragma mark - Object Management Methods
/// @name Object Management Methods

/// Initializes a BKPackage object with information from Bindle Binaries Objective-C Kit.
- (id) initWithBindleKit;

/// Creates a BKPackage object with information from Bindle Binaries Objective-C Kit.
+ (id) packageWithBindleKit;


#pragma mark - API Information methods
/// @name API Information methods
+ (NSUInteger) apiVersionCurrent;
+ (NSUInteger) apiVersionRevision;
+ (NSUInteger) apiVersionAge;
+ (NSString *) apiVersionString;


#pragma mark - Package Information methods
/// @name Package Information methods

/// The Bindle Binaries Objective-C Kit package identifier.
+ (NSString *) packageIdentifier;

/// The Bindle Binaries Objective-C Kit package name.
+ (NSString *) packageName;

/// The Bindle Binaries Objective-C Kit package version.
+ (NSString *) packageVersion;

/// The Bindle Binaries Objective-C Kit package website.
+ (NSString *) packageWebsite;

/// The Bindle Binaries Objective-C Kit package license.
+ (NSString *) packageLicense;

@end
