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
 *  BKRootViewController.h - Root view controller for Reachability
 */
#import "BKRootViewController.h"

#define kSectionFlags    0

# pragma mark - BKRootViewController Class Implementation
@implementation BKRootViewController

@synthesize networkReachability;


#pragma mark - Creating and Initializing a BKNetworkReachability

- (void) dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self name:networkReachability.notificationString object:nil];
   [logs release];
   [super dealloc];
   return;
}


- (void) didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];    
   if ((logsViewController))
   {
      if (!(logsViewController.isViewLoaded))
      {
         [logsViewController release];
         logsViewController = nil;
         return;
      };
      if (!(logsViewController.view.superview))
      {
         [logsViewController release];
         logsViewController = nil;
         return;
      };
   };

   return;
}


- (id) initWithStyle:(UITableViewStyle)style
{
   NSAutoreleasePool * pool;

   if ((self = [super initWithStyle:style]) == nil)
      return(self);

   pool = [[NSAutoreleasePool alloc] init];

   logs       = [[NSMutableArray alloc] initWithCapacity:1];
   redImage   = [[UIImage imageNamed:@"red.png"] retain];
   greenImage = [[UIImage imageNamed:@"green.png"] retain];

   [pool release];

   return(self);
}


#pragma mark - View lifecycle

- (void) viewDidLoad
{
   UIBarButtonItem * barButtonItem;

   [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] postNotificationName:networkReachability.notificationString object:networkReachability];

   // Uncomment the following line to preserve selection between presentations.
   // self.clearsSelectionOnViewWillAppear = NO;

   // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
   barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logs" style:UIBarButtonItemStyleBordered target:self action:@selector(openLogs:)];
   self.navigationItem.rightBarButtonItem = barButtonItem;
   [barButtonItem release];

   return;
}


- (void) viewDidUnload
{
   [super viewDidUnload];
   // Release any retained subviews of the main view.
   // e.g. self.myOutlet = nil;
   return;
}


- (void) viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   return;
}


- (void) viewDidAppear:(BOOL)animated
{
   NSMutableIndexSet * indexSet;
   [super viewDidAppear:animated];
   indexSet = [[NSMutableIndexSet alloc] initWithIndex:kSectionFlags];
   [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
   [indexSet release];
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
   return(1);
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   return(nil);
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return(9);
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return(tableView.rowHeight - 6.0);
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell * cell;
   UIImage         * image;
   UIImageView     * imageView;

   // creates re-usable cell
   cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
   if (cell == nil)
   {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell autorelease];
   };

   image = nil;

   // display reachability flags
   cell.detailTextLabel.text = nil;
   switch(indexPath.row)
   {
      case 0:
      cell.textLabel.text       = @"Reachable";
      cell.detailTextLabel.text = @"R";
      image = networkReachability.reachable ? greenImage : redImage;
      break;

      case 1:
      cell.textLabel.text       = @"Using WWAN";
      cell.detailTextLabel.text = @"W";
      image = networkReachability.isWWAN ? greenImage : redImage;
      break;

      case 2:
      cell.textLabel.text       = @"Transient Connection";
      cell.detailTextLabel.text = @"t";
      image = networkReachability.transientConnection ? greenImage : redImage;
      break;

      case 3:
      cell.textLabel.text       = @"Connection Required";
      cell.detailTextLabel.text = @"c";
      image = networkReachability.connectionRequired ? greenImage : redImage;
      break;

      case 4:
      cell.textLabel.text       = @"Connection On Traffic";
      cell.detailTextLabel.text = @"C";
      image = networkReachability.connectionOnTraffic ? greenImage : redImage;
      break;

      case 5:
      cell.textLabel.text       = @"Intervention Required";
      cell.detailTextLabel.text = @"i";
      image = networkReachability.interventionRequired ? greenImage : redImage;
      break;

      case 6:
      cell.textLabel.text       = @"Connection On Demand";
      cell.detailTextLabel.text = @"D";
      image = networkReachability.connectionOnDemand ? greenImage : redImage;
      break;

      case 7:
      cell.textLabel.text       = @"Local Address";
      cell.detailTextLabel.text = @"l";
      image = networkReachability.isLocalAddress ? greenImage : redImage;
      break;

      case 8:
      cell.textLabel.text       = @"Is Direct";
      cell.detailTextLabel.text = @"d";
      image = networkReachability.isDirect ? greenImage : redImage;
      break;

      default:
      cell.textLabel.text       = nil;
      cell.detailTextLabel.text = nil;
      break;
   };

   imageView = [[UIImageView alloc] initWithImage:image];
   cell.accessoryView = imageView;
   [imageView release];

   return(cell);
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   return;
}


#pragma mark - NSNotification targets

- (void) startNotifier
{
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityUpdate:) name:networkReachability.notificationString object:nil];
   [networkReachability startNotifier];
   return;
}


- (void) networkReachabilityUpdate:(NSNotification *)note
{
   NSAutoreleasePool * pool;
   NSString          * logEntry;
   NSMutableIndexSet * indexSet;

   if ([note object] != networkReachability)
      return;

   pool = [[NSAutoreleasePool alloc] init];

   logEntry = [networkReachability stringForNetworkReachabilityFlags];
   [logs addObject:logEntry];

   indexSet = [[NSMutableIndexSet alloc] initWithIndex:kSectionFlags];
   [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
   [indexSet release];

   if ((logsViewController))
      [(UITableView *) [[logsViewController.viewControllers objectAtIndex:0] view] reloadData];

   [pool release];

   return;
}


#pragma mark - UIBarButtonItem targets

- (void) openLogs:(UIBarButtonItem *)sender
{
   BKLogViewController * controller;

   if (!(logsViewController))
   {
      controller = [[BKLogViewController alloc] initWithStyle:UITableViewStyleGrouped];
      controller.logs = logs;
      controller.title = [NSString stringWithFormat:@"%@ Logs", self.title];

      logsViewController = [[UINavigationController alloc] initWithRootViewController:controller];
      [controller release];
   };

   [self presentModalViewController:logsViewController animated:YES];

   return;
}


@end
