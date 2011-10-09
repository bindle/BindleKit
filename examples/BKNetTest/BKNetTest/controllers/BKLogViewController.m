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
 *  BKLogViewController.m - Log view controller for Reachability
 */
#import "BKLogViewController.h"

@implementation BKLogViewController

@synthesize logs;


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
   NSAutoreleasePool * pool;

   if ((self = [super initWithStyle:style]) == nil)
      return(self);

   pool = [[NSAutoreleasePool alloc] init];

   [pool release];

   return(self);
}


#pragma mark - View lifecycle

- (void) viewDidLoad
{
   UIBarButtonItem * barButtonItem;

   [super viewDidLoad];

   // Uncomment the following line to preserve selection between presentations.
   // self.clearsSelectionOnViewWillAppear = NO;

   // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
   barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeLogs:)];
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
   [super viewDidAppear:animated];
   [self.tableView reloadData];
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


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return([logs count]+1);
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.row < [logs count])
      return(tableView.rowHeight - 6.0);
   return(tableView.rowHeight);
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell * cell;

   // creates re-usable cell
   if (indexPath.row == [logs count])
   {
      cell = [tableView dequeueReusableCellWithIdentifier:@"cellButton"];
      if (cell == nil)
      {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellButton"];
         cell.selectionStyle = UITableViewCellSelectionStyleGray;
         cell.textLabel.textAlignment = UITextAlignmentCenter;
         cell.textLabel.text          = @"Clear Logs";
         [cell autorelease];
      };
      return(cell);
   };

   cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
   if (cell == nil)
   {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell autorelease];
   };
   cell.detailTextLabel.text = [logs objectAtIndex:indexPath.row];

   return(cell);
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSAutoreleasePool * pool;
   NSString          * logEntry;
   NSIndexSet        * indexSet;

   pool = [[NSAutoreleasePool alloc] init];

   [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

   logEntry = [[[logs objectAtIndex:([logs count] - 1)] retain] autorelease];
   [logs removeAllObjects];
   [logs addObject:logEntry];

   indexSet = [[NSIndexSet alloc] initWithIndex:0];
   [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
   [indexSet release];

   [pool release];

   return;
}


#pragma mark - UIBarButtonItem targets

- (void) closeLogs:(UIBarButtonItem *)sender
{
   [self dismissModalViewControllerAnimated:YES];
   return;
}


@end
