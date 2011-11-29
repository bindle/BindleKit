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
 *  BKPromptViewOptions.m - Demostrates BKPromptView options
 */
#import "BKPromptViewOptions.h"

@implementation BKPromptViewOptions


- (void) dealloc
{
   [resultLabel release];
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

   resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
   resultLabel.backgroundColor = [UIColor clearColor];
   resultLabel.textAlignment   = UITextAlignmentRight;

   self.title = @"BKPromptView Demo";

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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
   return(3);
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   return(nil);
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   switch(section)
   {
      case 0:  return(1);
      case 1:  return(2);
      case 2:  return(2);
      default: return(0);
   };
   return(1);
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell * cell;
   UIButton        * button;
   NSString        * sectTitle;
   NSString        * sectDesc;

   // determines text of cells
   switch(indexPath.section)
   {
      case 1:
      sectTitle = @"Text Prompt";
      sectDesc  = @"- (id) initWithTitle: message: delegate: cancelButtonTitle: otherButtonTitles:";
      break;

      case 2:
      sectTitle = @"Password Prompt";
      sectDesc  = @"- (id) initWithTitle: message: delegate: cancelButtonTitle: otherButtonTitles:";
      break;

      default:
      sectTitle = nil;
      sectDesc  = nil;
      break;
   };

   // creates cells
   if (indexPath.section == 0)
   {
      cell = [tableView dequeueReusableCellWithIdentifier:@"BKPromptViewOptionsResult"];
      if (cell == nil)
      {
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BKButtonOptionsSlider"] autorelease];
         cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
      };
      cell.tag                  = indexPath.section;
      cell.accessoryView        = resultLabel;
      cell.textLabel.text       = @"Input";
   }
   else if (indexPath.row == 1)
   {
      cell = [tableView dequeueReusableCellWithIdentifier:@"BKPromptViewOptionsDesc"];
      if (cell == nil)
      {
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BKButtonOptionsDesc"] autorelease];
         cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
      };
      cell.detailTextLabel.text = sectDesc;
   }
   else
   {
      cell = [tableView dequeueReusableCellWithIdentifier:@"BKPromptViewOptionsButton"];
      if (cell == nil)
      {
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BKButtonOptionsButton"] autorelease];
         button = [BKButton grayButton];
         button.frame = CGRectMake(0, 0, 120, 40);
         [button addTarget:self action:@selector(generatePromptView:) forControlEvents:UIControlEventTouchUpInside];
         [button setTitle:@"Show Alert" forState:UIControlStateNormal];
         cell.accessoryView = button;
      };
      button              = (UIButton *)cell.accessoryView;
      button.tag          = indexPath.section;
      cell.textLabel.text = sectTitle;
   };

   return(cell);
}


#pragma mark - UIButton delegates

- (void) generatePromptView:(UIButton *)button
{
   BKPromptView * promptView;

   switch(button.tag)
   {
      case 1:
      promptView = [[BKPromptView alloc] initWithTitle:@"Text Prompt"
         message:nil delegate:self cancelButtonTitle:@"Cancel"
         otherButtonTitles:@"Enter", nil];
      [promptView show];
      [promptView release];
      break;

      case 2:
      promptView = [[BKPromptView alloc] initWithTitle:@"Password Prompt"
         message:nil delegate:self cancelButtonTitle:@"Cancel"
         otherButtonTitles:@"Enter", nil];
      promptView.textField.secureTextEntry = YES;
      [promptView show];
      [promptView release];
      break;

      default:
      break;
   };

   return;
}


#pragma mark - BKPromptView delegate

- (void) promptView:(BKPromptView *)promptView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if (buttonIndex > 0)
      resultLabel.text = promptView.textField.text;
   return;
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   return;
}

@end
