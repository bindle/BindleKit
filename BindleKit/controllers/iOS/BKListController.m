/*
 *  Bindle Binaries Objective-C Kit
 *  Copyright (c) 2012 Bindle Binaries
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
 *  BKListController.m - Generic UItableView for displaying data
 */
#import "BKListController.h"


@implementation BKListController

// delegates
@synthesize delegate;
@synthesize tableDataSource;
@synthesize tableDelegate;

// identity
@synthesize tag;

// data source selectors
@synthesize data;
@synthesize cellTextLabelSelector;
@synthesize cellDetailTextLabelSelector;
@synthesize cellAccessoryViewSelector;
@synthesize cellImageSelector;

// cell appearance
@synthesize cellStyle;
@synthesize cellAccessoryType;
@synthesize cellSelectionStyle;


#pragma mark - Object Management Methods

- (id) initWithStyle:(UITableViewStyle)style
{
   if ((self = [super initWithStyle:style]) == nil)
      return(self);

   // applies defaults
   cellStyle          = UITableViewCellStyleDefault;
   cellAccessoryType  = UITableViewCellAccessoryNone;
   cellSelectionStyle = UITableViewCellSelectionStyleBlue;

   return(self);
}


#pragma mark - Getter/Setter methods

- (void) setTag:(NSInteger)aTag
{
   tag = aTag;
   if ((self.isViewLoaded))
      self.view.tag = tag;
   return;
}


- (void) setTableDataSource:(id<UITableViewDataSource>)object
{
   tableDataSource = object;
   if ((self.isViewLoaded))
      self.tableView.dataSource = object;
   return;
}


- (void) setTableDelegate:(id<UITableViewDelegate>)object
{
   tableDelegate = object;
   if ((self.isViewLoaded))
      self.tableView.delegate = object;
   return;
}


#pragma mark - View lifecycle

- (void) viewDidLoad
{
   self.tableView.dataSource = ((tableDataSource)) ? tableDataSource : self;
   self.tableView.delegate   = ((tableDelegate))   ? tableDelegate   : self;
   [self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   if ((delegate))
      if (([self respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)]))
         return([delegate shouldAutorotateToInterfaceOrientation:interfaceOrientation]);
	return(YES);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return(1);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return([data count]);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   id <NSObject>     item;
   UITableViewCell * cell;

   cell = [tableView dequeueReusableCellWithIdentifier:@"BKListControllerCell"];
   if (!(cell))
   {
      cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:@"BKListControllerCell"];
      cell.accessoryType  = cellAccessoryType;
      cell.selectionStyle = cellSelectionStyle;
   };

   item = [data objectAtIndex:indexPath.row];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
   if ((cellTextLabelSelector))
      if (([item respondsToSelector:cellTextLabelSelector]))
         cell.textLabel.text = [item performSelector:cellTextLabelSelector];
   if ((cellDetailTextLabelSelector))
      if (([item respondsToSelector:cellDetailTextLabelSelector]))
         cell.detailTextLabel.text = [item performSelector:cellDetailTextLabelSelector];
   if ((cellAccessoryViewSelector))
      if (([item respondsToSelector:cellAccessoryViewSelector]))
         cell.accessoryView = [item performSelector:cellAccessoryViewSelector];
   if ((cellImageSelector))
      if (([item respondsToSelector:cellImageSelector]))
         cell.imageView.image = [item performSelector:cellImageSelector];
#pragma clang diagnostic pop

   return cell;
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (([delegate respondsToSelector:@selector(listController:tableView:didSelectRowAtIndexPath:)]))
   {
      [delegate listController:self tableView:tableView didSelectRowAtIndexPath:indexPath];
      return;
   };
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
   return;
}

@end
