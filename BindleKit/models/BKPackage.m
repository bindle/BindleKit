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
 *  BKPackage.m - stores package information
 */
#import "BKPackage.h"


@implementation BKPackage

// API Information methods
@synthesize apiVersionCurrent;
@synthesize apiVersionRevision;
@synthesize apiVersionAge;
@synthesize apiVersionString;

// Package Information methods
@synthesize packageIdentifier;
@synthesize packageName;
@synthesize packageVersion;
@synthesize packageWebsite;
@synthesize packageLicense;


#pragma mark - Object Management Methods

- (id) initWithName:(NSString *)name version:(NSString *)version
{
   if ((self = [super init]) == nil)
      return(self);
   self.packageName    = name;
   self.packageVersion = version;
   return(self);
}


+ (id) packageWithName:(NSString *)name version:(NSString *)version
{
   return([[BKPackage alloc] initWithName:name version:version]);
}


#pragma mark - Getter/Setter methods

- (const char *) UTF8ApiVersionString
{
   return([apiVersionString UTF8String]);
}


- (void) setUTF8ApiVersionString:(const char *)string
{
   apiVersionString = nil;
   if ((string))
      apiVersionString = [[NSString alloc] initWithUTF8String:string];
   return;
}


- (const char *) UTF8PackageIdentifier
{
   return([packageIdentifier UTF8String]);
}


- (void) setUTF8PackageIdentifier:(const char *)string
{
   packageIdentifier = nil;
   if ((string))
      packageIdentifier = [[NSString alloc] initWithUTF8String:string];
   return;
}


- (const char *) UTF8PackageName
{
   return([packageName UTF8String]);
}


- (void) setUTF8PackageName:(const char *)string
{
   packageName = nil;
   if ((string))
      packageName = [[NSString alloc] initWithUTF8String:string];
   return;
}


- (const char *) UTF8PackageVersion
{
   return([packageVersion UTF8String]);
}


- (void) setUTF8PackageVersion:(const char *)string
{
   packageVersion = nil;
   if ((string))
      packageVersion = [[NSString alloc] initWithUTF8String:string];
   return;
}


- (const char *) UTF8PackageWebsite
{
   return([packageWebsite UTF8String]);
}


- (void) setUTF8PackageWebsite:(const char *)string
{
   packageWebsite = nil;
   if ((string))
      packageWebsite = [[NSString alloc] initWithUTF8String:string];
   return;
}


- (const char *) UTF8PackageLicense
{
   return([packageLicense UTF8String]);
}


- (void) setUTF8PackageLicense:(const char *)string
{
   packageLicense = nil;
   if ((string))
      packageLicense = [[NSString alloc] initWithUTF8String:string];
   return;
}


@end
