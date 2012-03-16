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
 *  BKNumberController.h - Displays a number
 */

#import "BKNumberController.h"

@implementation BKNumberController

@synthesize numberView;


- (void) dealloc
{
   [numberView release];
   [super dealloc];
   return;
}


- (void) didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   return;
}


- (id) init
{
   if ((self = [super init]) == nil)
      return(self);
   return(self);
}


#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void) loadView
{
   CGRect aFrame;
   UIButton * aButton;
   UIView   * aView;

   // root view
   aFrame     = [[UIScreen mainScreen] bounds];
   aView      = [[UIView alloc] initWithFrame:aFrame];
   aView.autoresizesSubviews = TRUE;
   aView.backgroundColor = [UIColor grayColor];

   // reset button
   aFrame = CGRectMake(CGRectGetMidX(aFrame)-70, 50, 140, 44);
   //aButton                  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   aButton                  = [BKButton redButton];
   aButton.frame            = aFrame;
   aButton.tag              = 1;
   aButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                              UIViewAutoresizingFlexibleRightMargin |
                              UIViewAutoresizingFlexibleBottomMargin;
   [aButton setTitle:@"Reset Position" forState:UIControlStateNormal];
   [aButton addTarget:self action:@selector(buttonTargetLogFrame:) forControlEvents:UIControlEventTouchUpInside];
   [aView addSubview:aButton];

   // hide slider button
   aFrame = CGRectMake(CGRectGetMidX(aFrame)-70, 100, 140, 44);
   aButton                  = [BKButton darkGrayButton];
   aButton.frame            = aFrame;
   aButton.tag              = 2;
   aButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                              UIViewAutoresizingFlexibleRightMargin |
                              UIViewAutoresizingFlexibleBottomMargin;
   [aButton setTitle:@"Hide Slider" forState:UIControlStateNormal];
   [aButton addTarget:self action:@selector(buttonTargetLogFrame:) forControlEvents:UIControlEventTouchUpInside];
   [aView addSubview:aButton];

   // reverse view button
   aFrame = CGRectMake(CGRectGetMidX(aFrame)-70, 150, 140, 44);
   aButton                  = [BKButton grayButton];
   aButton.frame            = aFrame;
   aButton.tag              = 3;
   aButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                              UIViewAutoresizingFlexibleRightMargin |
                              UIViewAutoresizingFlexibleBottomMargin;
   [aButton setTitle:@"Reverse Views" forState:UIControlStateNormal];
   [aButton addTarget:self action:@selector(buttonTargetLogFrame:) forControlEvents:UIControlEventTouchUpInside];
   [aView addSubview:aButton];

   // hide master button
   aFrame = CGRectMake(CGRectGetMidX(aFrame)-70, 200, 140, 44);
   aButton                  = [BKButton greenButton];
   aButton.frame            = aFrame;
   aButton.tag              = 4;
   aButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                              UIViewAutoresizingFlexibleRightMargin |
                              UIViewAutoresizingFlexibleBottomMargin;
   [aButton setTitle:@"Show Master" forState:UIControlStateNormal];
   [aButton addTarget:self action:@selector(buttonTargetLogFrame:) forControlEvents:UIControlEventTouchUpInside];
   [aView addSubview:aButton];

   // label
   aFrame     = CGRectMake(0, 250, aView.frame.size.width, 100);
   numberView = [[UILabel alloc] initWithFrame:aFrame];
   //numberView.backgroundColor     = [UIColor blueColor];
   numberView.autoresizingMask    = UIViewAutoresizingFlexibleWidth | 
                                    UIViewAutoresizingFlexibleBottomMargin;
   numberView.autoresizesSubviews = TRUE;
   numberView.textAlignment       = UITextAlignmentCenter;
   numberView.text                = @"Test Bed";
   numberView.textColor           = [UIColor blackColor];
   numberView.font                = [UIFont boldSystemFontOfSize:25];
   numberView.adjustsFontSizeToFitWidth = YES;
   [aView addSubview:numberView];

   // saves root view
   self.view  = aView;
   [aView release];

   return;
}


- (void) viewWillAppear:(BOOL)animated
{
   NSLog(@"detail: viewWillAppear");
   return;
}


- (void) viewWillDisappear:(BOOL)animated
{
   NSLog(@"detail: viewWillDisappear");
   return;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
   [super viewDidLoad];
   return;
}
*/


- (void)viewDidUnload
{
   [super viewDidUnload];
   return;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return(YES);
}


#pragma mark - UIButton target
- (void) buttonTargetLogFrame:(UIButton *)sender
{
   BKSplitViewController * splitViewController;

   if (!(splitViewController = (BKSplitViewController *)self.splitViewController))
      return;

   if (!([splitViewController isKindOfClass:[BKSplitViewController class]]))
      return;

   switch(sender.tag)
   {
      case 1:
      if (splitViewController.viewLayout == BKSplitViewLayoutVertically)
         splitViewController.viewLayout = BKSplitViewLayoutHorizontally;
      else
         splitViewController.viewLayout = BKSplitViewLayoutVertically;
      return;

      case 2:
      if (splitViewController.dividerHidden)
      {
         splitViewController.dividerHidden = NO;
         [sender setTitle:@"Hide Slider" forState:UIControlStateNormal];
      } else {
         splitViewController.dividerHidden = YES;
         [sender setTitle:@"Show Slider" forState:UIControlStateNormal];
      };
      return;

      case 3:
      if (splitViewController.viewOrderReversed)
         splitViewController.viewOrderReversed = NO;
      else
         splitViewController.viewOrderReversed = YES;
      return;
   
      case 4:

      if (splitViewController.masterAlwaysVisible)
      {
         splitViewController.masterAlwaysVisible = NO;
         [sender setTitle:@"Show Master" forState:UIControlStateNormal];
      } else {
         splitViewController.masterAlwaysVisible = YES;
         [sender setTitle:@"Hide Master" forState:UIControlStateNormal];
      };

      return;

      default:
      return;
   };

   return;
}


#pragma mark - UISplitViewController delegate methods

- (void) splitViewController:(BKSplitViewController*)svc
         willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem*)barButtonItem
         forPopoverController:(UIPopoverController*)pc
{
NSLog(@"detail: willHideViewController");
   [barButtonItem setTitle:@"Whiz Bangs"];
   self.navigationItem.leftBarButtonItem = barButtonItem;
}


- (void) splitViewController:(BKSplitViewController*)svc
         willShowViewController:(UIViewController *)aViewController
         invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
NSLog(@"detail: invalidatingBarButtonItem");
   self.navigationItem.leftBarButtonItem = nil;
   return;
}


- (void) splitViewController:(BKSplitViewController*)svc
         popoverController:(UIPopoverController*)pc
         willPresentViewController:(UIViewController *)aViewController
{
NSLog(@"detail: willPresentViewController");
   return;
}

@end
