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
 *  BKSplitVCOptions.h - Demostrates BKSplitViewController options
 */

#import "BKSplitVCOptions.h"

#define BKControllerMinimumViewSize         0
#define BKControllerReverseViewOrder        1
#define BKControllermasterAlwaysHidden      6
#define BKControllerMasterAlwaysVisible     2
#define BKControllerUserInteractionEnabled  3
#define BKControllerHideDivider             4
#define BKControllerVerticalLayout          5

@implementation BKSplitVCOptions

- (void) dealloc
{
   [minimumViewSize         release];
   [reverseViewOrder        release];
   [masterAlwaysHidden      release];
   [masterAlwaysVisible     release];
   [userInteractionEnabled  release];
   [hideDivider             release];
   [verticalLayout          release];

   [super dealloc];

   return;
}


- (void) didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   return;
}


- (id)initWithStyle:(UITableViewStyle)style
{
   if ((self = [super initWithStyle:style]) == nil)
      return(self);

   self.title = @"BKSplitViewController";

   minimumViewSize = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
   minimumViewSize.tag   = BKControllerMinimumViewSize;
   minimumViewSize.continuous   = NO;
   minimumViewSize.maximumValue = 400;
   minimumViewSize.minimumValue = 0;
   [minimumViewSize addTarget:self action:@selector(updateSVC:) forControlEvents:UIControlEventValueChanged];

   reverseViewOrder       = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
   reverseViewOrder.tag   = BKControllerReverseViewOrder;
   [reverseViewOrder addTarget:self action:@selector(updateSVC:) forControlEvents:UIControlEventValueChanged];

   masterAlwaysHidden       = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
   masterAlwaysHidden.tag   = BKControllermasterAlwaysHidden;
   [masterAlwaysHidden addTarget:self action:@selector(updateSVC:) forControlEvents:UIControlEventValueChanged];

   masterAlwaysVisible       = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
   masterAlwaysVisible.tag   = BKControllerMasterAlwaysVisible;
   [masterAlwaysVisible addTarget:self action:@selector(updateSVC:) forControlEvents:UIControlEventValueChanged];

   userInteractionEnabled = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
   userInteractionEnabled.tag = BKControllerUserInteractionEnabled;
   [userInteractionEnabled addTarget:self action:@selector(updateSVC:) forControlEvents:UIControlEventValueChanged];

   hideDivider            = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
   hideDivider.tag        = BKControllerHideDivider;
   [hideDivider addTarget:self action:@selector(updateSVC:) forControlEvents:UIControlEventValueChanged];

   verticalLayout         = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
   verticalLayout.tag     = BKControllerVerticalLayout;
   [verticalLayout addTarget:self action:@selector(updateSVC:) forControlEvents:UIControlEventValueChanged];

   return(self);
}


#pragma mark - View lifecycle

- (void) loadView
{
   CGRect        aFrame;
   UITableView * tableView;

   aFrame    = [[UIScreen mainScreen] bounds]; 
   tableView = [[UITableView alloc] initWithFrame:aFrame style:UITableViewStyleGrouped];
   tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
   tableView.delegate        = self;
   tableView.dataSource      = self;
   tableView.allowsSelection = NO;

   minimumViewSize.value = self.bkSplitViewController.minimumViewSize.width;

   reverseViewOrder.on        = self.bkSplitViewController.viewOrderReversed;
   masterAlwaysHidden.on      = self.bkSplitViewController.masterAlwaysHidden;
   masterAlwaysVisible.on     = self.bkSplitViewController.masterAlwaysVisible;
   userInteractionEnabled.on  = self.bkSplitViewController.userInteractionEnabled;
   hideDivider.on             = self.bkSplitViewController.dividerHidden;
   verticalLayout.on          = (self.bkSplitViewController.viewLayout == BKSplitViewLayoutVertically);

   self.tableView = tableView;
   [tableView release];

   return;
}


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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return(2);
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   switch(section)
   {
      case 0:
      return(@"Appearance");

      case 1:
      return(@"Behavior");

      default:
      return(nil);
   };
   return(nil);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   switch(section)
   {
      case 0:
      return(4);

      case 1:
      return(3);

      default:
      return(0);
   };
   return(0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell * cell;

   cell = [tableView dequeueReusableCellWithIdentifier:@"BKSplitVCoptions"];
   if (cell == nil)
   {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BKSplitVCoptions"] autorelease];
   };

   switch(indexPath.section)
   {
      case 0:
      switch(indexPath.row)
      {
         case 0:
         cell.textLabel.text = @"Minimum View Size";
         cell.accessoryView = minimumViewSize;
         break;

         case 1:
         cell.textLabel.text = @"Hide Divider Bar";
         cell.accessoryView = hideDivider;
         break;

         case 2:
         cell.textLabel.text = @"Reverse View Order";
         cell.accessoryView = reverseViewOrder;
         break;

         case 3:
         cell.textLabel.text = @"Vertical Layout";
         cell.accessoryView = verticalLayout;
         break;

         default:
         break;
      };
      break;

      case 1:
      switch(indexPath.row)
      {
         case 0:
         cell.textLabel.text = @"User Interaction";
         cell.accessoryView = userInteractionEnabled;
         break;

         case 1:
         cell.textLabel.text = @"Always display Master";
         cell.accessoryView = masterAlwaysVisible;
         break;

         case 2:
         cell.textLabel.text = @"Always hide Master";
         cell.accessoryView = masterAlwaysHidden;
         break;

         default:
         break;
      };
      break;

      default:
      break;
   };

   return(cell);
}


#pragma mark - UIController delegate

- (void) updateSVC:(UIControl *)sender
{
   UISlider * slider;
   UISwitch * toggle;

   switch(sender.tag)
   {
      case BKControllerMinimumViewSize:
      slider = (UISlider *) sender;
      self.bkSplitViewController.minimumViewSize = CGSizeMake(slider.value, slider.value);
      break;

      case BKControllerReverseViewOrder:
      toggle = (UISwitch *) sender;
      self.bkSplitViewController.viewOrderReversed = toggle.on;
      break;

      case BKControllermasterAlwaysHidden:
      toggle = (UISwitch *) sender;
      self.bkSplitViewController.masterAlwaysHidden = toggle.on;
      break;

      case BKControllerMasterAlwaysVisible:
      toggle = (UISwitch *) sender;
      self.bkSplitViewController.masterAlwaysVisible = toggle.on;
      break;

      case BKControllerUserInteractionEnabled:
      toggle = (UISwitch *) sender;
      self.bkSplitViewController.userInteractionEnabled = toggle.on;
      break;

      case BKControllerHideDivider:
      toggle = (UISwitch *) sender;
      self.bkSplitViewController.dividerHidden = toggle.on;
      break;

      case BKControllerVerticalLayout:
      toggle = (UISwitch *) sender;
      self.bkSplitViewController.viewLayout = toggle.on ? BKSplitViewLayoutVertically : BKSplitViewLayoutHorizontally;
      break;

      default:
      break;
   };
   return;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // Navigation logic may go here. Create and push another view controller.
   /*
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   [detailViewController release];
   */
}

@end
