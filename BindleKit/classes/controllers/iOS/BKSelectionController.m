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
/**
 *  @file BindleKit/classes/controllers/BKSelectionOption.m Selelection controller for iOS
 */
#import "BKSelectionController.h"


@interface  BKSelectionController ()
- (void) setupForPad;
- (void) setupForPhone;
- (void) removeSelectionViewFromSuperView;
- (void) barButtonItemTarget:(id)sender;
@end


#pragma mark -
@implementation BKSelectionController

@synthesize delegate;
@synthesize tag;
@synthesize title;
@synthesize selectedIndex;
@synthesize isPresented;


- (void) dealloc
{
   [self dismissSelectionAnimated:NO];

   // common state variables
   [listOfOptions release];

   // iPad state variables
   [tableViewController release];
   [popoverController   release];

   // iPhone state variables
   [actionSheet release];
   [pickerView release];
   [navigationBar release];

   [super dealloc];

   return;
}


- (id) initWithRootController:(UIViewController *)aController
{
   UIDevice * device;

   if ((self = [super init]) == nil)
      return(self);

   selectedIndex  = BKSelectionIndexNone;
   rootController = aController;
   listOfOptions  = [[NSMutableArray alloc] initWithCapacity:3];

   device = [UIDevice currentDevice];
   if ([device respondsToSelector:@selector(userInterfaceIdiom)])
      userInterfaceIdiom = device.userInterfaceIdiom;

   if (userInterfaceIdiom == UIUserInterfaceIdiomPad)
      [self setupForPad];
   else
      [self setupForPhone];

   return(self);
}


- (void) setTitle:(NSString *)aTitle
{
   [title release];
   title = [aTitle retain];
   navigationBar.topItem.title = aTitle;
   return;
}


- (void) setupForPad
{
   CGRect        aFrame;
   UITableView * aView;

   // creates UITableView
   aFrame = [[UIScreen mainScreen] bounds];
   aView  = [[UITableView alloc] initWithFrame:aFrame style:UITableViewStyleGrouped];
   aView.separatorStyle      = UITableViewCellSeparatorStyleNone;
   aView.autoresizingMask    = UIViewAutoresizingFlexibleWidth |
                               UIViewAutoresizingFlexibleHeight;
   aView.autoresizesSubviews = TRUE;
   aView.dataSource          = self;
   aView.delegate            = self;

   // creates UITableViewController
   tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
   tableViewController.clearsSelectionOnViewWillAppear = YES;
   tableViewController.tableView                       = aView;
   [aView release];

   // create popover
   popoverController = [[UIPopoverController alloc] initWithContentViewController:tableViewController];
	popoverController.delegate = self;

   return;
}


- (void) setupForPhone
{
   CGRect              aFrame;
   UINavigationItem  * navigationItem;
   UIBarButtonItem   * doneButton;

   // creates action sheet
   actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                          delegate:nil
                                          cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
   aFrame = [[UIScreen mainScreen] bounds];
   [actionSheet setBounds:CGRectMake(0, 0, aFrame.size.width, aFrame.size.height)];
   [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];


   // creates navigation bar
   aFrame     = CGRectMake(0, 0, actionSheet.frame.size.width, 50);
   navigationBar = [[UINavigationBar alloc] initWithFrame:aFrame];
   navigationBar.tintColor     = [UIColor grayColor];
   [actionSheet addSubview:navigationBar];

   // creates navigation item for navigation bar
   navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
   [navigationBar pushNavigationItem:navigationItem animated:NO];
   [navigationItem release];

   // creates done button
   doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(barButtonItemTarget:)];
   navigationBar.topItem.rightBarButtonItem = doneButton;
   [doneButton release];

   // creates picker
   aFrame     = CGRectMake(0, navigationBar.frame.size.height, 0, 0);
   pickerView = [[UIPickerView alloc] initWithFrame:aFrame];
   pickerView.delegate                = self;
   pickerView.dataSource              = self;
   pickerView.showsSelectionIndicator = YES;
   [actionSheet addSubview:pickerView];

   return;
}


#pragma mark - Options management methods

- (void) addDescription:(NSString *)aDescription
{
   [self addValue:nil withDescription:aDescription];
   return;
}


- (void) addValue:(id)aValue
{
   [self addValue:aValue withDescription:nil];
   return;
}


- (void) addValue:(id)aValue withDescription:(NSString *)aDescription
{
   BKSelectionOption * option;
   option = [[BKSelectionOption alloc] initWithValue:aValue andDescription:aDescription];
   [listOfOptions addObject:option];
   [option release];
   dataHasChanged = YES;
   return;
}


- (void) addValues:(NSArray *)values withDescriptions:(NSArray *)descriptions
{
   NSUInteger   maxCombined;
   NSUInteger   maxDescription;
   NSUInteger   maxValues;
   NSUInteger   pos;
   id           aValue;
   NSString   * aDescription;

   maxDescription = [descriptions count];
   maxValues      = [values count];
   maxCombined = (maxValues > maxDescription) ? maxDescription : maxValues;

   [listOfOptions removeAllObjects];

   for(pos = 0; pos < maxCombined; pos++)
   {
      aValue       = (pos < maxValues)      ? [values objectAtIndex:pos]       : nil;
      aDescription = (pos < maxDescription) ? [descriptions objectAtIndex:pos] : nil;
      [self addValue:aValue withDescription:aDescription];
   };

   return;
}


- (NSString *) descriptionAtIndex:(NSUInteger)index
{
   if (listOfOptions == nil)
      return(nil);
   if ([listOfOptions count] <= index)
      return(nil);
   return([[listOfOptions objectAtIndex:index] description]);
}


- (NSArray *) options
{
   return(listOfOptions);
}


- (void) resetValues
{
   [listOfOptions removeAllObjects];
   return;
}


- (NSString *) selectedDescription
{
   if (selectedIndex == BKSelectionIndexNone)
      return(nil);
   if (selectedIndex >= [listOfOptions count])
      return(nil);
   return([[listOfOptions objectAtIndex:selectedIndex] description]);
}


- (id) selectedValue
{
   if (selectedIndex == BKSelectionIndexNone)
      return(nil);
   if (selectedIndex >= [listOfOptions count])
      return(nil);
   return([[listOfOptions objectAtIndex:selectedIndex] value]);
}


- (void) setDescriptions:(NSArray *)descriptions
{
   NSUInteger   pos;
   id           desc;
   [listOfOptions removeAllObjects];
   for(pos = 0; pos < [descriptions count]; pos++)
   {
      desc = [descriptions objectAtIndex:pos];
      if ([desc isKindOfClass:[NSString class]])
         [self addValue:desc withDescription:desc];
   };
   return;
};


- (void) setOptions:(NSArray *)newOptions
{
   [listOfOptions removeAllObjects];
   [listOfOptions addObjectsFromArray:newOptions];
   dataHasChanged = YES;
   return;
}


- (void) setSelectedDescription:(NSString *)selectedDescription
{
   NSUInteger   pos;
   NSString   * desc;
   selectedIndex = BKSelectionIndexNone;
   for(pos = 0; pos < [listOfOptions count]; pos++)
   {
      desc = [[listOfOptions objectAtIndex:pos] description];
      if ([desc isEqualToString:selectedDescription])
      {
         selectedIndex = pos;
         return;
      };
   };
   return;
}


- (void) setSelectedValue:(id)selectedValue
{
   NSUInteger   pos;
   id           value;
   selectedIndex = BKSelectionIndexNone;
   for(pos = 0; pos < [listOfOptions count]; pos++)
   {
      value = [[listOfOptions objectAtIndex:pos] value];
      if ([value isEqual:selectedValue])
      {
         selectedIndex = pos;
         return;
      };
   };
   return;
};


- (id) valueAtIndex:(NSUInteger)index
{
   if (listOfOptions == nil)
      return(nil);
   if ([listOfOptions count] <= index)
      return(nil);
   return([[listOfOptions objectAtIndex:index] value]);
}


#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return(1);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return([listOfOptions count]);
};


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell * cell;
   id                value;

   if (indexPath.row == selectedIndex)
   {
      cell = [tableView dequeueReusableCellWithIdentifier:@"Selected Cell"];
      if (cell == nil)
      {
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Selected Cell"] autorelease];
         cell.accessoryType       = UITableViewCellAccessoryNone;
         cell.accessoryType       = UITableViewCellAccessoryCheckmark;
         cell.textLabel.textColor = cell.detailTextLabel.textColor;
      };
   } else {
      cell = [tableView dequeueReusableCellWithIdentifier:@"Unselected Cell"];
      if (cell == nil)
      {
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Unselected Cell"] autorelease];
         cell.accessoryType  = UITableViewCellAccessoryNone;
      };
   };

   // assigns title from description if available, or value if of class NSString
   cell.textLabel.text = [[listOfOptions objectAtIndex:indexPath.row] description];
   if (cell.textLabel.text == nil)
   {
      value = [[listOfOptions objectAtIndex:indexPath.row] value];
      if ([value isKindOfClass:[NSString class]])
         cell.textLabel.text = value;
   };

   return(cell);
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   BKSelectionOption * option;

   [self dismissSelectionAnimated:YES];
   [tableViewController.tableView deselectRowAtIndexPath:indexPath animated:YES];

   if (delegate == nil)
      return;

   option = [listOfOptions objectAtIndex:indexPath.row];

   if ([delegate respondsToSelector:@selector(selectionController:clickedDescription:)])
      [delegate selectionController:self clickedDescription:[option description]];

   if ([delegate respondsToSelector:@selector(selectionController:clickedIndex:)])
      [delegate selectionController:self clickedIndex:indexPath.row];

   if ([delegate respondsToSelector:@selector(selectionController:clickedValue:)])
      [delegate selectionController:self clickedValue:[option value]];

   return;
}


#pragma mark - UIPickerView data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   return(1);
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   return([listOfOptions count]);
}


#pragma mark - UIPickerView delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   NSString * aDescription;
   id         aValue;

   aDescription = [[listOfOptions objectAtIndex:row] description];
   if (aDescription == nil)
   {
      aValue = [[listOfOptions objectAtIndex:row] value];
      if ([aValue isKindOfClass:[NSString class]])
         aDescription = aValue;
   };
   return(aDescription);

}


#pragma mark - UIBarButtonItem target

- (void) barButtonItemTarget:(id)sender
{
   NSUInteger          row;
   BKSelectionOption * option;

   [self dismissSelectionAnimated:YES];

   if (delegate == nil)
      return;

   row    = [pickerView selectedRowInComponent:0];
   option = [listOfOptions objectAtIndex:row];

   if ([delegate respondsToSelector:@selector(selectionController:clickedDescription:)])
      [delegate selectionController:self clickedDescription:[option description]];

   if ([delegate respondsToSelector:@selector(selectionController:clickedIndex:)])
      [delegate selectionController:self clickedIndex:row];

   if ([delegate respondsToSelector:@selector(selectionController:clickedValue:)])
      [delegate selectionController:self clickedValue:[option value]];

   return;
}


#pragma mark - BKSelectionController methods

- (void) dismissSelectionAnimated:(BOOL)animated
{
   isPresented = NO;

   // dismiss selection controller on iPad
   if (userInterfaceIdiom == UIUserInterfaceIdiomPad)
   {
      [popoverController dismissPopoverAnimated:animated];
      return;
   };

   // dismiss selection controller on iPhone
   if (userInterfaceIdiom != UIUserInterfaceIdiomPad)
   {
      [actionSheet dismissWithClickedButtonIndex:0 animated:animated];
      return;
   };

   return;
}


- (void) presentSelectionAnimated:(BOOL)animated
{
   CGPoint      aCenter;
   CGRect       aFrame;
   NSUInteger   height;

   if (self.isPresented == YES)
      [self dismissSelectionAnimated:YES];

   lastSender = nil;

   // display selection controller on iPad
   if (userInterfaceIdiom == UIUserInterfaceIdiomPad)
   {
      aCenter = rootController.view.center;
      aFrame  = CGRectMake(aCenter.x, 0, 1, 1);
      [tableViewController.tableView reloadData];
      height  = tableViewController.tableView.rowHeight * [listOfOptions count];
      height += tableViewController.tableView.sectionFooterHeight;
      height += tableViewController.tableView.sectionHeaderHeight;
      popoverController.popoverContentSize = CGSizeMake(320., height);
      [popoverController presentPopoverFromRect:aFrame
                         inView:rootController.view
                         permittedArrowDirections:UIPopoverArrowDirectionUp
                         animated:animated];
   };

   // display selection controller on iPhone
   if (userInterfaceIdiom != UIUserInterfaceIdiomPad)
      [self presentSelectionPhoneIdiomAnimated:animated];

   dataHasChanged = NO;
   isPresented    = YES;

   return;
}


- (void) presentSelectionAnimated:(BOOL)animated withSender:(id)sender
{
   NSUInteger   height;

   if (sender == nil)
   {
      [self presentSelectionAnimated:animated];
      return;
   };

   if (self.isPresented == YES)
      [self dismissSelectionAnimated:YES];

   lastSender = (UIView *) sender;

   // display selection controller on iPad
   if (userInterfaceIdiom == UIUserInterfaceIdiomPad)
   {
      [tableViewController.tableView reloadData];
      height  = tableViewController.tableView.rowHeight * [listOfOptions count];
      height += tableViewController.tableView.sectionFooterHeight;
      height += tableViewController.tableView.sectionHeaderHeight;
      popoverController.popoverContentSize = CGSizeMake(320., height);
      [popoverController presentPopoverFromRect:lastSender.frame
                         inView:rootController.view
                         permittedArrowDirections:UIPopoverArrowDirectionRight
                         animated:animated];
   };

   // display selection controller on iPhone
   if (userInterfaceIdiom != UIUserInterfaceIdiomPad)
      [self presentSelectionPhoneIdiomAnimated:animated];

   dataHasChanged = NO;
   isPresented    = YES;

   return;
}


- (void) presentSelectionAnimated:(BOOL)animated withTableViewCell:(UITableViewCell *)sender
{
   CGRect       aFrame;
   NSUInteger   height;

   if (sender == nil)
   {
      [self presentSelectionAnimated:animated];
      return;
   };

   if (self.isPresented == YES)
      [self dismissSelectionAnimated:YES];

   lastSender = (UITableViewCell *) sender;

   // display selection controller on iPad
   if (userInterfaceIdiom == UIUserInterfaceIdiomPad)
   {
      if (dataHasChanged == YES)
         [tableViewController.tableView reloadData];
      aFrame = CGRectMake(sender.detailTextLabel.frame.origin.x,
                          sender.frame.origin.y,
                          sender.detailTextLabel.frame.size.width,
                          sender.frame.size.height);
      height  = tableViewController.tableView.rowHeight * [listOfOptions count];
      height += tableViewController.tableView.sectionFooterHeight;
      height += tableViewController.tableView.sectionHeaderHeight;
      popoverController.popoverContentSize = CGSizeMake(320., height);
      [popoverController presentPopoverFromRect:aFrame
                         inView:rootController.view
                         permittedArrowDirections:UIPopoverArrowDirectionRight
                         animated:animated];
   };

   // display selection controller on iPhone
   if (userInterfaceIdiom != UIUserInterfaceIdiomPad)
      [self presentSelectionPhoneIdiomAnimated:animated];

   dataHasChanged = NO;
   isPresented    = YES;

   return;
}


- (void) presentSelectionPhoneIdiomAnimated:(BOOL)animated
{
   CGRect aFrame;

   aFrame = [[UIScreen mainScreen] bounds];
   if (dataHasChanged == YES)
      [pickerView reloadComponent:0];
   [pickerView selectRow:selectedIndex inComponent:0 animated:NO];
   [actionSheet showInView:rootController.view];
   [actionSheet setBounds:CGRectMake(0, 0, aFrame.size.width, aFrame.size.height)];

   return;
}


- (void) removeSelectionViewFromSuperView
{
   [pickerView removeFromSuperview];
   return;
}


- (void) representSelectionAnimated:(BOOL)animated
{
   if (isPresented == YES)
      [self dismissSelectionAnimated:animated];
   [self presentSelectionAnimated:animated withSender:lastSender];
   return;
}


- (void) representSelectionAnimated:(BOOL)animated withSender:(id)sender
{
   if (isPresented == YES)
      [self dismissSelectionAnimated:animated];
   [self presentSelectionAnimated:animated withSender:sender];
   return;
}


@end
