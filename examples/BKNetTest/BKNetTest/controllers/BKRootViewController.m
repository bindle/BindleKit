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

@synthesize logs;
@synthesize networkReachability;
@synthesize logsViewController;


#pragma mark - Creating and Initializing a BKNetworkReachability

- (void) dealloc
{
   return;
}


- (void) didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];    
   if ((logsViewController))
   {
      if (!(logsViewController.isViewLoaded))
      {
         logsViewController = nil;
         return;
      };
      if (!(logsViewController.view.superview))
      {
         logsViewController = nil;
         return;
      };
   };

   return;
}


- (id) initWithStyle:(UITableViewStyle)style
{

   if ((self = [super initWithStyle:style]) == nil)
      return(self);

   @autoreleasepool
   {
      redImage   = [UIImage imageNamed:@"red.png"];
      greenImage = [UIImage imageNamed:@"green.png"];
      useFlagNames = NO;

      barButtonItemLogs  = [[UIBarButtonItem alloc] initWithTitle:@"Logs" style:UIBarButtonItemStyleBordered target:self action:@selector(openLogs:)];
      barButtonItemFlags = [[UIBarButtonItem alloc] initWithTitle:@"Show Flags" style:UIBarButtonItemStyleBordered target:self action:@selector(displayFlags:)];
      barButtonItemHost  = [[UIBarButtonItem alloc] initWithTitle:@"Hostname" style:UIBarButtonItemStyleBordered target:self action:@selector(changeHostname:)];
      barButtonItemFlex  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
      barButtonItemLegal = [[UIBarButtonItem alloc] initWithTitle:@"Legal" style:UIBarButtonItemStyleBordered target:self action:@selector(displayCopyright:)];

      barButtonItemFlags.possibleTitles = [NSSet setWithObjects:@"Show Flags", @"Show Names", nil];

      prompt = [[BKPromptView alloc] initWithTitle:@"New Hostname" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
      prompt.textField.clearButtonMode        = UITextFieldViewModeWhileEditing;
      prompt.textField.autocorrectionType     = FALSE;
      prompt.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
      prompt.textField.keyboardType           = UIKeyboardTypeURL;
   };

   return(self);
}


#pragma mark - View lifecycle

- (void) viewDidLoad
{
   NSMutableArray  * barButtons;

   [super viewDidLoad];

   // Uncomment the following line to preserve selection between presentations.
   //self.clearsSelectionOnViewWillAppear = NO;

   barButtons = [[NSMutableArray alloc] initWithCapacity:2];
   [barButtons addObject:barButtonItemLogs];
   [barButtons addObject:barButtonItemFlags];
   if (networkReachability.hostname != nil)
      [barButtons addObject:barButtonItemHost];
   [barButtons addObject:barButtonItemFlex];
   [barButtons addObject:barButtonItemLegal];
   self.toolbarItems = barButtons;

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
      cell.textLabel.adjustsFontSizeToFitWidth = YES;
      cell.selectionStyle = UITableViewCellSelectionStyleGray;
   };

   image = nil;

   // display reachability flags
   cell.detailTextLabel.text = nil;
   switch(indexPath.row)
   {
      case 0:
      cell.textLabel.text       = ((useFlagNames)) ? @"kSCNetworkReachabilityFlagsReachable" : @"Reachable";
      cell.detailTextLabel.text = @"R";
      image = networkReachability.reachable ? greenImage : redImage;
      break;

      case 1:
      cell.textLabel.text       = ((useFlagNames)) ? @"kSCNetworkReachabilityFlagsIsWWAN" : @"Using WWAN";
      cell.detailTextLabel.text = @"W";
      image = networkReachability.isWWAN ? greenImage : redImage;
      break;

      case 2:
      cell.textLabel.text       = ((useFlagNames)) ? @"kSCNetworkReachabilityFlagsTransientConnection" : @"Transient Connection";
      cell.detailTextLabel.text = @"t";
      image = networkReachability.transientConnection ? greenImage : redImage;
      break;

      case 3:
      cell.textLabel.text       = ((useFlagNames)) ? @"kSCNetworkReachabilityFlagsConnectionRequired" : @"Connection Required";
      cell.detailTextLabel.text = @"c";
      image = networkReachability.connectionRequired ? greenImage : redImage;
      break;

      case 4:
      cell.textLabel.text       = ((useFlagNames)) ? @"kSCNetworkReachabilityFlagsConnectionOnTraffic" : @"Connection On Traffic";
      cell.detailTextLabel.text = @"C";
      image = networkReachability.connectionOnTraffic ? greenImage : redImage;
      break;

      case 5:
      cell.textLabel.text       = ((useFlagNames)) ? @"kSCNetworkReachabilityFlagsInterventionRequired" : @"Intervention Required";
      cell.detailTextLabel.text = @"i";
      image = networkReachability.interventionRequired ? greenImage : redImage;
      break;

      case 6:
      cell.textLabel.text       = ((useFlagNames)) ? @"kSCNetworkReachabilityFlagsConnectionOnDemand" : @"Connection On Demand";
      cell.detailTextLabel.text = @"D";
      image = networkReachability.connectionOnDemand ? greenImage : redImage;
      break;

      case 7:
      cell.textLabel.text       = ((useFlagNames)) ? @"kSCNetworkReachabilityFlagsIsLocalAddress" : @"Local Address";
      cell.detailTextLabel.text = @"l";
      image = networkReachability.isLocalAddress ? greenImage : redImage;
      break;

      case 8:
      cell.textLabel.text       = ((useFlagNames)) ? @"kSCNetworkReachabilityFlagsIsDirect" : @"Is Direct";
      cell.detailTextLabel.text = @"d";
      image = networkReachability.isDirect ? greenImage : redImage;
      break;

      default:
      cell.textLabel.text       = nil;
      cell.detailTextLabel.text = nil;
      break;
   };

   if ((useFlagNames))
      cell.detailTextLabel.text = nil;

   imageView = [[UIImageView alloc] initWithImage:image];
   cell.accessoryView = imageView;

   return(cell);
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   UIAlertView * infoAlert;
   NSString    * alertTitle;
   NSString    * alertMessage;

   [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

   switch(indexPath.row)
   {
      case 0:
      alertTitle   = @"Reachable";
      alertMessage = @"The specified node name or address can be reached using the current network configuration.";
      break;

      case 1:
      alertTitle   = @"Using WWAN";
      alertMessage = @"The specified node name or address can be reached via a cellular connection, such as EDGE or GPRS.";
      break;

      case 2:
      alertTitle   = @"Transient Connection";
      alertMessage = @"The specified node name or address can be reached via a transient connection, such as PPP.";
      break;

      case 3:
      alertTitle   = @"Connection Required";
      alertMessage = @"The specified node name or address can be reached using the current network configuration, but a connection must first be established.";
      break;

      case 4:
      alertTitle   = @"Connection On Traffic";
      alertMessage = @"The specified node name or address can be reached using the current network configuration, but a connection must first be established. Any traffic directed to the specified name or address will initiate the connection.";
      break;

      case 5:
      alertTitle   = @"Intervention Required";
      alertMessage = @"The specified node name or address can be reached using the current network configuration, but a connection must first be established.\n\nIn addition, some form of user intervention will be required to establish this connection, such as providing a password, an authentication token, etc.\n\nCurrently, this flag is returned only when there is a dial-on-traffic configuration (kSCNetworkReachabilityFlagsConnectionOnTraffic), an attempt to connect has already been made, and when some error (such as no dial tone, no answer, bad password, etc.) occurred during the automatic connection attempt. In this case the PPP controller stops attempting to establish a connection until the user has intervened.";
      break;

      case 6:
      alertTitle   = @"Connection On Demand";
      alertMessage = @"The specified node name or address can be reached using the current network configuration, but a connection must first be established. The connection will be established \"On Demand\" by the CFSocketStream programming interface (see CFStream Socket Additions for information on this). Other functions will not establish the connection.";
      break;

      case 7:
      alertTitle   = @"Local Address";
      alertMessage = @"The specified node name or address is one that is associated with a network interface on the current system.";
      break;

      case 8:
      alertTitle   = @"Is Direct";
      alertMessage = @"Network traffic to the specified node name or address will not go through a gateway, but is routed directly to one of the interfaces in the system.";
      break;

      default:
      alertTitle   = @"Unknown Option";
      alertMessage = @"Unknown option";
      break;
   };

   infoAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
   [infoAlert show];

   return;
}


#pragma mark - UIBarButtonItem targets

- (void) changeHostname:(UIBarButtonItem *)sender
{
   prompt.textField.text = networkReachability.hostname;
   prompt.textField.placeholder = networkReachability.hostname;
   [prompt show];
   return;
}


- (void) dismissLegal:(UIBarButtonItem *)sender
{
   [self dismissModalViewControllerAnimated:YES];
   return;
}


- (void) displayCopyright:(UIBarButtonItem *)sender
{
   UIBarButtonItem        * dismissButton;
   BKPackageController    * pkgController;
   UINavigationController * navController;

   @autoreleasepool
   {
      dismissButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissLegal:)];

      pkgController = [[BKPackageController alloc] initWithStyle:UITableViewStyleGrouped];
      pkgController.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
      pkgController.navigationItem.rightBarButtonItem = dismissButton;

      navController = [[UINavigationController alloc] initWithRootViewController:pkgController];

      [self presentModalViewController:navController animated:YES];
   };

   return;
}


- (void) displayFlags:(UIBarButtonItem *)sender
{
   if ((useFlagNames))
   {
      useFlagNames = NO;
      sender.title = @"Show Flags";
   }
   else
   {
      useFlagNames = YES;
      sender.title = @"Show Names";
   };
   [self.tableView reloadData];
   return;
}


- (void) openLogs:(UIBarButtonItem *)sender
{
   BKLogViewController * controller;


   controller = [[BKLogViewController alloc] initWithStyle:UITableViewStyleGrouped];
   controller.logs = logs;
   controller.title = [NSString stringWithFormat:@"%@ Logs", self.title];

   logsViewController = [[UINavigationController alloc] initWithRootViewController:controller];


   [self presentModalViewController:logsViewController animated:YES];

   return;
}


#pragma mark - BKPromptView delegate

- (void) updateToolbar
{
   NSMutableArray  * barButtons;

   if (([self.toolbarItems count] == 5) && (networkReachability.hostname != nil))
      return;

   if (self.isViewLoaded == NO)
      return;
   if (self.tableView.superview == nil)
      return;

   barButtons = [[NSMutableArray alloc] initWithCapacity:2];
   [barButtons addObject:barButtonItemLogs];
   [barButtons addObject:barButtonItemFlags];
   if (networkReachability.hostname != nil)
      [barButtons addObject:barButtonItemHost];
   [barButtons addObject:barButtonItemFlex];
   [barButtons addObject:barButtonItemLegal];
   self.toolbarItems = barButtons;

   return;
}


- (void) promptView:(BKPromptView *)promptView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
   NSObject * logEntry;

   if ([promptView.textField.text length] == 0)
      return;
   networkReachability.hostname = promptView.textField.text;

   logEntry = [logs objectAtIndex:([logs count] - 1)];
   [logs removeAllObjects];
   [logs addObject:logEntry];

   return;
}


@end
