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
 *  BKButtonOptions.h - Demostrates BKButton options
 */

#import "BKButtonOptions.h"

#define BKIndexPrefixStart       1
#define BKIndexRedButton         (0 + BKIndexPrefixStart)
#define BKIndexPurpleButton      (1 + BKIndexPrefixStart)
#define BKIndexBlueButton        (2 + BKIndexPrefixStart)
#define BKIndexMagentaButton     (3 + BKIndexPrefixStart)
#define BKIndexCyanButton        (4 + BKIndexPrefixStart)
#define BKIndexYellowButton      (5 + BKIndexPrefixStart)
#define BKIndexGreenButton       (6 + BKIndexPrefixStart)
#define BKIndexOrangeButton      (7 + BKIndexPrefixStart)
#define BKIndexBrownButton       (8 + BKIndexPrefixStart)
#define BKIndexWhiteButton       (9 + BKIndexPrefixStart)
#define BKIndexLightGrayButton   (10 + BKIndexPrefixStart)
#define BKIndexGrayButton        (11 + BKIndexPrefixStart)
#define BKIndexDarkGrayButton    (12 + BKIndexPrefixStart)
#define BKIndexBlackButton       (13 + BKIndexPrefixStart)

@implementation BKButtonOptions

- (void) dealloc
{
   [redSlider    release];
   [greenSlider  release];
   [blueSlider   release];
   [alphaSlider  release];
   [customButton release];

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

   self.title = @"BKButton Demo";

   redSlider   = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
   greenSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
   blueSlider  = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
   alphaSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];

   redSlider.value   = ((CGFloat)((BKButtonColorGreen >> 16) & 0xFF)) / 255.0;
   greenSlider.value = ((CGFloat)((BKButtonColorGreen >>  8) & 0xFF)) / 255.0;
   blueSlider.value  = ((CGFloat)((BKButtonColorGreen >>  0) & 0xFF)) / 255.0;
   alphaSlider.value = 1.0;

   [redSlider   addTarget:self action:@selector(updatedSliderValue:) forControlEvents:UIControlEventValueChanged];
   [greenSlider addTarget:self action:@selector(updatedSliderValue:) forControlEvents:UIControlEventValueChanged];
   [blueSlider  addTarget:self action:@selector(updatedSliderValue:) forControlEvents:UIControlEventValueChanged];
   [alphaSlider addTarget:self action:@selector(updatedSliderValue:) forControlEvents:UIControlEventValueChanged];


   customButton = [[BKButton buttonWithRGB:BKButtonColorGreen] retain];
   [customButton setTitle:@"Generate" forState:UIControlStateNormal];

   [pool release];

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
   return(15);
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   switch(section)
   {
      case 0:
      return(@"Custom Color");

//      case 1:
//      return(@"Preset Colors");

      default:
      return(nil);
   };
   return(nil);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // Return the number of rows in the section.
   if (section == 0)
      return(6);
   return(2);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString        * buttonTitle;
   BKButtonImages  * images;
   UITableViewCell * cell;
   UIButton        * button;

   if (indexPath.section == 0)
   {
      cell = [tableView dequeueReusableCellWithIdentifier:@"BKButtonOptionsSlider"];
      if (cell == nil)
      {
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BKButtonOptionsSlider"] autorelease];
         cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
      };
      cell.accessoryView        = nil;
      cell.detailTextLabel.text = nil;
      cell.textLabel.text       = nil;
   }
   else if (indexPath.row == 1)
   {
      cell = [tableView dequeueReusableCellWithIdentifier:@"BKButtonOptionsDesc"];
      if (cell == nil)
      {
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BKButtonOptionsDesc"] autorelease];
         cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
      };
   }
   else
   {
      cell = [tableView dequeueReusableCellWithIdentifier:@"BKButtonOptionsButton"];
      if (cell == nil)
      {
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BKButtonOptionsButton"] autorelease];
         button = [BKButton redButton];
         button.frame = CGRectMake(0, 0, 120, 40);
         [button addTarget:self action:@selector(generateCustomButton:) forControlEvents:UIControlEventTouchUpInside];
         [button setTitle:@"BKButton" forState:UIControlStateNormal];
         cell.accessoryView = button;
      };
   };

   button      = nil;
   buttonTitle = nil;

   switch(indexPath.section)
   {
      case 0:
      cell.detailTextLabel.text = nil;
      switch(indexPath.row)
      {
         case 0:
         cell.textLabel.text = @"Red";
         cell.accessoryView = redSlider;
         return(cell);

         case 1:
         cell.textLabel.text = @"Green";
         cell.accessoryView = greenSlider;
         return(cell);

         case 2:
         cell.textLabel.text = @"Blue";
         cell.accessoryView = blueSlider;
         return(cell);

         case 3:
         cell.textLabel.text = @"Alpha";
         cell.accessoryView = alphaSlider;
         return(cell);

         case 4:
         customButton.tag = -1;
         customButton.frame = CGRectMake(0, 0, 150, 40);
         [customButton addTarget:self action:@selector(generateCustomButton:) forControlEvents:UIControlEventTouchUpInside];
         cell.accessoryView = customButton;
         cell.textLabel.text = @"customButton";
         return(cell);

         default:
         cell.detailTextLabel.text = [self customButtonText];
         return(cell);
      };
      break;

      case BKIndexRedButton:
      buttonTitle = @"redButton";
      cell.tag = BKButtonColorRed;
      break;

      case BKIndexPurpleButton:
      buttonTitle = @"purpleButton";
      cell.tag = BKButtonColorPurple;
      break;

      case BKIndexBlueButton:
      buttonTitle = @"blueButton";
      cell.tag = BKButtonColorBlue;
      break;

      case BKIndexMagentaButton:
      buttonTitle = @"magentaButton";
      cell.tag = BKButtonColorMagenta;
      break;

      case BKIndexCyanButton:
      buttonTitle = @"cyanButton";
      cell.tag = BKButtonColorCyan;
      break;

      case BKIndexYellowButton:
      buttonTitle = @"yellowButton";
      cell.tag = BKButtonColorYellow;
      break;

      case BKIndexGreenButton:
      buttonTitle = @"greenButton";
      cell.tag = BKButtonColorGreen;
      break;

      case BKIndexOrangeButton:
      buttonTitle = @"orangeButton";
      cell.tag = BKButtonColorOrange;
      break;

      case BKIndexBrownButton:
      buttonTitle = @"brownButton";
      cell.tag = BKButtonColorBrown;
      break;

      case BKIndexWhiteButton:
      buttonTitle = @"whiteButton";
      cell.tag = BKButtonColorWhite;
      break;

      case BKIndexLightGrayButton:
      buttonTitle = @"lightGrayButton";
      cell.tag = BKButtonColorLightGray;
      break;

      case BKIndexGrayButton:
      buttonTitle = @"grayButton";
      cell.tag = BKButtonColorGray;
      break;

      case BKIndexDarkGrayButton:
      buttonTitle = @"darkGrayButton";
      cell.tag = BKButtonColorDarkGray;
      break;

      case BKIndexBlackButton:
      buttonTitle = @"blackButton";
      cell.tag = BKButtonColorBlack;
      break;

      default:
      break;
   };

   if (indexPath.row == 0)
   {
      cell.textLabel.text = buttonTitle;
      button = (UIButton *)cell.accessoryView;
      button.tag = cell.tag;
      images = [[BKButtonImages alloc] initWithRGB:button.tag];
      [button setBackgroundImage:[images createUIImageForState:BKButtonImageStateNormal]      forState:UIControlStateNormal];
      [button setBackgroundImage:[images createUIImageForState:BKButtonImageStateHighlighted] forState:UIControlStateHighlighted];
      [images release];
   } else {
      cell.detailTextLabel.text = [NSString stringWithFormat:@"+ (UIButton *) [BKButton %@]", buttonTitle];
   };

   return(cell);
}


#pragma mark - UISlider delegate

- (NSString *) customButtonText
{
   NSString          * text;
   text = [NSString stringWithFormat:
      @"+ (id) [BKButton buttonWithRed:%1.3f green:%1.3f blue:%1.3f alpha:%1.3f]",
      redSlider.value, greenSlider.value, blueSlider.value, alphaSlider.value];
   return(text);
}


- (void) updatedSliderValue:(UISlider *)slider
{
   NSAutoreleasePool * pool;
   NSIndexPath       * indexPath;
   NSUInteger          indexes[2];
   UITableViewCell   * cell;

   pool = [[NSAutoreleasePool alloc] init];

   indexes[0] = 0;
   indexes[1] = 5;

   indexPath  = [NSIndexPath indexPathWithIndexes:indexes length:2];
   cell       = [self.tableView cellForRowAtIndexPath:indexPath];

   cell.detailTextLabel.text = [self customButtonText];

   [pool release];

   return;
}


#pragma mark - UIButton delegates

- (void) generateCustomButton:(UIButton *)button
{
   BKButtonImages * images;

   if (button.tag != -1)
   {
      [UIView beginAnimations:nil context:nil];
      redSlider.value   = ((CGFloat)((button.tag >> 16) & 0xff)) / 255.0;
      greenSlider.value = ((CGFloat)((button.tag >>  8) & 0xff)) / 255.0;
      blueSlider.value  = ((CGFloat)((button.tag >>  0) & 0xff)) / 255.0;
      [self updatedSliderValue:nil];
      [UIView commitAnimations];
   };

   images = [BKButtonImages alloc];
   images = [images initWithRed:redSlider.value green:greenSlider.value blue:blueSlider.value alpha:alphaSlider.value];
   [customButton setBackgroundImage:[images createUIImageForState:BKButtonImageStateNormal]      forState:UIControlStateNormal];
   [customButton setBackgroundImage:[images createUIImageForState:BKButtonImageStateHighlighted] forState:UIControlStateHighlighted];
   [images release];

   return;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   return;
}

@end
