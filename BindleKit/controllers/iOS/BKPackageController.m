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
 *  BKPackageController.m - Manges the displaying of license information
 */
#import "BKPackageController.h"


#import <BindleKit/models/BKVersion.h>


@implementation BKPackageController

#pragma mark - Object Management Methods

- (void) dealloc
{
   // package information
   [packages release];

   // alerts
   [alert       release];
   [alertPackge release];

   [super dealloc];

   return;
}


- (void) didReceiveMemoryWarning
{
   // Releases the view if it doesn't have a superview.
   [super didReceiveMemoryWarning];

   // frees alert
   [alert release];
   alert = nil;

   return;
}


- (id) init
{
   if ((self = [self initWithStyle:UITableViewStyleGrouped]) == nil)
      return(self);
   return(self);
}


- (id) initWithStyle:(UITableViewStyle)style
{
   BKPackage * package;

   if ((self = [super initWithStyle:style]) == nil)
      return(self);

   package  = [[BKVersion alloc] initWithBindleKit];
   packages = [[NSMutableArray alloc] initWithCapacity:1];
   [packages addObject:package];
   [package release];

   return(self);
}


#pragma mark - View lifecycle

- (void) viewDidLoad
{
   [super viewDidLoad];
   return;
}


- (void) viewDidUnload
{
   [super viewDidUnload];
   return;
}


- (void) viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   return;
}


- (void) viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
   return;
}


- (void) viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
   return;
}


- (void) viewDidDisappear:(BOOL)animated
{
   [super viewDidDisappear:animated];
   return;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return(YES);
}


#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
   return([packages count]);
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   return([[packages objectAtIndex:section] packageName]);
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return(3);
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   BKPackage * package;
   UIFont    * font;
   CGSize      size;

   switch(indexPath.row)
   {
      case 2:
      package     = [packages objectAtIndex:indexPath.section];
      font        = [UIFont fontWithName:@"Courier" size:10];
      size.width  = (self.tableView.bounds.size.width * 0.85);
      size.height = 999999;
      size = [package.packageLicense sizeWithFont:font constrainedToSize:size];
      return(size.height+10);

      default:
      break;
   };

   return(44.0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell               * cell;
   BKPackage                     * package;
   NSString                      * rowText;
   NSString                      * rowDetail;
   UITableViewCellAccessoryType    rowAcessory;

   if ( (indexPath.row == 0) || (indexPath.row == 1) )
   {
      cell = [tableView dequeueReusableCellWithIdentifier:@"DataCell"];
      if (cell == nil)
      {
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DataCell"] autorelease];
         cell.selectionStyle                            = UITableViewCellSelectionStyleNone;
         cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
         cell.detailTextLabel.numberOfLines             = 1;
         cell.detailTextLabel.minimumFontSize           = 8;

      };
   } else {
      cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
      if (cell == nil)
      {
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextCell"] autorelease];
         cell.selectionStyle                 = UITableViewCellSelectionStyleNone;
         cell.textLabel.font                 = [UIFont fontWithName:@"Courier" size:10];
         cell.textLabel.numberOfLines        = 0;
         cell.textLabel.lineBreakMode        = UILineBreakModeWordWrap;
      };
   };

   package     = [packages objectAtIndex:indexPath.section];
   rowText     = nil;
   rowDetail   = nil;
   rowAcessory = UITableViewCellAccessoryNone;

   switch(indexPath.row)
   {
      case 0:
      rowText   = @"Version";
      rowDetail = package.packageVersion;
      break;

      case 1:
      rowText      = @"Website";
      rowDetail    = package.packageWebsite;
      rowAcessory  = UITableViewCellAccessoryDisclosureIndicator;
      break;

      case 2:
      rowText = package.packageLicense;
      break;

      default:
      break;
   };

   cell.textLabel.text       = rowText;
   cell.detailTextLabel.text = rowDetail;
   cell.accessoryType        = rowAcessory;

   return(cell);
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString    * alertTitle;

   switch([indexPath row])
   {
      case 1:
      // saves package
      [alertPackge release];
      alertPackge = [[packages objectAtIndex:indexPath.section] retain];
      alertTitle = [[NSString alloc] initWithFormat:@"Open the website for %@?", alertPackge.packageName];
   
      // free old alert
      [alert dismissWithClickedButtonIndex:0 animated:YES];
      [alert release];

      // create alert
      alert = [[UIAlertView alloc] initWithTitle:@"Open Webpage"
         message:alertTitle 
         delegate:self
         cancelButtonTitle:@"No"
         otherButtonTitles:@"Yes", nil];
      [alert show];
      [alert release];
      [alertTitle release];
      break;

      default:
      break;
   };
   return;
}


#pragma mark - UIAlertView delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   NSAutoreleasePool * pool;

   pool = [[NSAutoreleasePool alloc] init];

   // opens website
   if (alert.cancelButtonIndex != buttonIndex)
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertPackge.packageWebsite]];

   // frees alert
   [alert       release];
   [alertPackge release];
   alert       = nil;
   alertPackge = nil;

   [pool release];

   return;
}


#pragma mark - package management methods

- (void) addPackage:(BKPackage *)package
{
   [packages addObject:package];
   return;
}


- (void) insertPackage:(BKPackage *)package atIndex:(NSUInteger)index
{
   [packages insertObject:package atIndex:index];
   return;
}


- (void) removeAllPackages
{
   [packages removeAllObjects];
   return;
}


- (void) removeLastPackage
{
   [packages removeLastObject];
   return;
}


- (void) removePackageAtIndex:(NSUInteger)index
{
   [packages removeObjectAtIndex:index];
   return;
}


#pragma mark - package query methods

- (NSUInteger)  count
{
   return([packages count]);
}


- (BKPackage *) lastPackage
{
   return([packages lastObject]);
}


- (BKPackage *) packageAtIndex:(NSUInteger)index
{
   return([packages objectAtIndex:index]);
}


@end
