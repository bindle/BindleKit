/*
 *  Bindle Binaries Objective-C Kit
 *  Copyright (c) 2011, 2012 Bindle Binaries
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
 *  BKCatalogMenu.m - Main menu for examples
 */
#import "BKCatalogMenu.h"

#import "BKNumberController.h"
#import "BKButtonOptions.h"
#import "BKSplitVCOptions.h"
#import "BKPromptViewOptions.h"

#define BKCatalogMenuCellButton       0
#define BKCatalogMenuCellSelection    1
#define BKCatalogMenuCellPromptView   2
#define BKCatalogMenuCellSplitView    3

#define BKCatalogMenuCellCount        3

@implementation BKCatalogMenu


- (void) dealloc
{
   [super dealloc];
   return;
}


- (void) didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   return;
}


- (id) initWithStyle:(UITableViewStyle)style
{
   if ((self = [super initWithStyle:style]) == nil)
      return(self);
   return(self);
}


#pragma mark - View lifecycle

- (void) viewDidLoad
{
   [super viewDidLoad];

   // Uncomment the following line to preserve selection between presentations.
   // self.clearsSelectionOnViewWillAppear = NO;

   // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
   // self.navigationItem.rightBarButtonItem = self.editButtonItem;

   return;
}


- (void) viewDidUnload
{
   [super viewDidUnload];
   // Release any retained subviews of the main view.
   // e.g. self.myOutlet = nil;
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
   // Return YES for supported orientations
   return(YES);
}


#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
   return(1);
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if ([BKDevice userInterfaceIdiom] == BKUserInterfaceIdiomPhone)
      return(BKCatalogMenuCellCount);
   return(BKCatalogMenuCellCount+1);
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *CellIdentifier = @"Cell";

   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   if (cell == nil)
   {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
   };

   cell.tag = indexPath.row;
   switch(indexPath.row)
   {
      case BKCatalogMenuCellSplitView:
      cell.textLabel.text = @"BKSplitViewController";
      break;

      case BKCatalogMenuCellButton:
      cell.textLabel.text = @"BKButton";
      break;

      case BKCatalogMenuCellSelection:
      cell.textLabel.text = @"BKSelectionController";
      break;

      case BKCatalogMenuCellPromptView:
      cell.textLabel.text = @"BKPromptView";
      break;

      default:
      cell.textLabel.text = @"Test Controller";
      break;
   };

   return(cell);
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   UIViewController       * controller;
   NSArray                * viewControllers;
   UINavigationController * navigation;

   if ((popoverController))
      if ((popoverController.isPopoverVisible))
         [popoverController dismissPopoverAnimated:YES];

   switch(indexPath.row)
   {
      case BKCatalogMenuCellButton:
      controller = [[BKButtonOptions alloc] init];
      break;

      case BKCatalogMenuCellSelection:
      controller = [[BKNumberController alloc] init];
      break;

      case BKCatalogMenuCellSplitView:
      controller = [[BKSplitVCOptions alloc] init];
      break;

      case BKCatalogMenuCellPromptView:
      controller = [[BKPromptViewOptions alloc] init];
      break;

      default:
      controller = [[BKNumberController alloc] init];
      break;
   };

   // if an iPhone, push new controller onto navigation stack
   if ([BKDevice userInterfaceIdiom] == BKUserInterfaceIdiomPhone)
   {
      [self.navigationController pushViewController:controller animated:YES];
      [controller release];
      return;
   };

   // sets up navigation controller for detail
   navigation     = [[UINavigationController alloc] initWithRootViewController:controller];
   controller.navigationItem.leftBarButtonItem = barButton;

   // adds views to splitview controllers
   viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, navigation, nil];
   self.bkSplitViewController.viewControllers = viewControllers;

   [controller release];
   [navigation release];
   [viewControllers release];

   return;
}


#pragma mark - UISplitViewController delegate methods

- (void) splitViewController:(BKSplitViewController*)svc
         willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem*)barButtonItem
         forPopoverController:(UIPopoverController*)pc
{
   id                       controller;
   UINavigationController * navigationController;
   UIViewController       * detailController;

   controller = [svc.viewControllers objectAtIndex:1];
   detailController = controller;
   if (([controller isKindOfClass:[UINavigationController class]]))
   {
      navigationController = controller;
      detailController = navigationController.topViewController;
   };

   popoverController = pc;
   barButton         = barButtonItem;

   [barButtonItem setTitle:@"Menu"];

   detailController.navigationItem.leftBarButtonItem = barButton;

   return;
}


- (void) splitViewController:(BKSplitViewController*)svc
         willShowViewController:(UIViewController *)aViewController
         invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
   id                       controller;
   UINavigationController * navigationController;
   UIViewController       * detailController;

   controller = [svc.viewControllers objectAtIndex:1];
   detailController = controller;
   if (([controller isKindOfClass:[UINavigationController class]]))
   {
      navigationController = controller;
      detailController = navigationController.topViewController;
   };

   popoverController = nil;
   barButton         = nil;

   detailController.navigationItem.leftBarButtonItem = barButton;

   return;
}


- (void) splitViewController:(BKSplitViewController*)svc
         popoverController:(UIPopoverController*)pc
         willPresentViewController:(UIViewController *)aViewController
{
   return;
}

@end
