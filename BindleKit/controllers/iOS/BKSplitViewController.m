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
 *  BKSplitViewController.m - Custom Replacement for UISplitViewController
 */
#import "BKSplitViewController.h"


#import <QuartzCore/QuartzCore.h>


#pragma mark - private methods
@interface BKSplitViewController ()

- (void) arrangeViews;
- (void) arrangeViewsHorizontally;

@end


#pragma mark -
@implementation BKSplitViewController

@synthesize viewControllers = controllers;
@synthesize minimumMasterViewWidth;
@synthesize minimumDetailViewWidth;
@synthesize masterViewWidth;
@synthesize dividerWidth;
@synthesize reverseViewOrder;
@synthesize enableTouchToResize;


- (void) dealloc
{
   [controllers      release];
   [views            release];

   [super dealloc];

   return;
}


- (void) didReceiveMemoryWarning
{
   NSUInteger pos;

   [super didReceiveMemoryWarning];

   for(pos = 0; pos < [controllers count]; pos++)
      [[controllers objectAtIndex:pos] didReceiveMemoryWarning];

   if (self.isViewLoaded == YES)
      return;

   [views release];
   views = nil;

   return;
}


- (id) init
{
   if ((self = [super init]) == nil)
      return(self);

   dividerIsMoving        = NO;
   minimumMasterViewWidth = 150;
   minimumDetailViewWidth = 150;
   masterViewWidth        = minimumMasterViewWidth;
   dividerWidth           = 10;

   return(self);
}


#pragma mark - Properties getters/setters

- (void) setDividerWidth:(CGFloat)aWidth
{
   if (aWidth < 320)
      dividerWidth = aWidth;
   [self arrangeViews];
   return;
}


- (void) setMasterViewWidth:(CGFloat)aWidth
{
   masterViewWidth = aWidth;
   [self arrangeViews];
   return;
}


- (void) setMinimumDetailViewWidth:(CGFloat)aWidth
{
   CGRect  aFrame;
   CGSize  aSize;
   CGFloat limit;

   aFrame = [[UIScreen mainScreen] applicationFrame];
   aSize  = aFrame.size;
   limit  = (aSize.width < aSize.height) ? aSize.width : aSize.height;

   if ((aWidth + dividerWidth + minimumMasterViewWidth) <= limit)
      minimumDetailViewWidth = aWidth;
   if (aWidth < 1)
      minimumDetailViewWidth = 1;

   [self arrangeViews];

   return;
}


- (void) setMinimumMasterViewWidth:(CGFloat)aWidth
{
   CGRect  aFrame;
   CGSize  aSize;
   CGFloat limit;

   aFrame = [[UIScreen mainScreen] applicationFrame];
   aSize  = aFrame.size;
   limit  = (aSize.width < aSize.height) ? aSize.width : aSize.height;

   if ((aWidth + dividerWidth + minimumDetailViewWidth) <= limit)
      minimumMasterViewWidth = aWidth;
   if (aWidth < 1)
      minimumMasterViewWidth = 1;

   [self arrangeViews];

   return;
}


- (void) setViewControllers:(NSArray *)viewControllers
{
   UIViewController * masterController = nil;
   UIViewController * detailController = nil;
   UIView           * masterRootView   = nil;
   UIView           * detailRootView   = nil;

   // retrieves current master and detail view controllers
   if ((controllers))
   {
      masterController = [[controllers objectAtIndex:0] retain];
      detailController = [[controllers objectAtIndex:1] retain];
      [controllers release];
      controllers = nil;
   };

   // if new view controllers are not available, remove old views and exit
   if (!(viewControllers))
   {
      if ((masterController))
      {
         if (masterController.isViewLoaded == YES)
            [masterController.view removeFromSuperview];
         [masterController release];
      };
      if ((detailController))
      {
         if (detailController.isViewLoaded == YES)
            [detailController.view removeFromSuperview];
         [detailController release];
      };
      return;
   };

   // save new view controllers
   controllers = [[NSArray alloc] initWithArray:viewControllers];

   // retrieves root master and detail views
   if ((views))
   {
      masterRootView   = [views objectAtIndex:0];
      detailRootView   = [views objectAtIndex:1];
   };

   // remove old master view if it is not the same as the new view
   if ((masterController))
   {
      if (masterController != [controllers objectAtIndex:0])
         if (masterController.isViewLoaded == YES)
            [masterController.view removeFromSuperview];
      [masterController release];
   };

   // remove old detail view if it is not the same as the new view
   if ((detailController))
   {
      if (detailController != [controllers objectAtIndex:1])
         if (detailController.isViewLoaded == YES)
            [detailController.view removeFromSuperview];
      [detailController release];
   };

   // grab new master and detail view controllers
   masterController = [controllers objectAtIndex:0];
   detailController = [controllers objectAtIndex:1];

   // add new master and detail views to root view
   if ((views))
   {
      // remove views if they are loaded in incorrect super views
      if (masterController.isViewLoaded == YES)
         if (!([masterController.view isDescendantOfView:masterRootView]))
            [masterController.view removeFromSuperview];
      if (detailController.isViewLoaded == YES)
         if (!([detailController.view isDescendantOfView:detailRootView]))
            [detailController.view removeFromSuperview];
   }

   // arranges views
   [self arrangeViews];

   return;
}


#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
   CGRect   aFrame;
   UIView * rootView;
   UIView * masterView;
   UIView * detailView;

   if ((views))
   {
      [self arrangeViews];
      return;
   };

   // creates root view
   aFrame = [[UIScreen mainScreen] applicationFrame];
   rootView                       = [[UIView alloc] initWithFrame:aFrame];
   rootView.backgroundColor       = [UIColor blackColor];
   rootView.autoresizesSubviews   = TRUE;
   rootView.autoresizingMask      = UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight;
   self.view = rootView;
   [rootView   release];

   // creates master view
   aFrame = CGRectMake(5,5,5,5);
   masterView                     = [[UIView alloc] initWithFrame:aFrame];
   masterView.backgroundColor     = [UIColor whiteColor];
   masterView.layer.cornerRadius  = 5;
   masterView.autoresizesSubviews = TRUE;
   masterView.clipsToBounds       = YES;
   masterView.autoresizingMask    = UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleHeight;

   // creates detail view
   aFrame = CGRectMake(20,5,5,5);
   detailView                     = [[UILabel alloc] initWithFrame:aFrame];
   detailView.backgroundColor     = [UIColor whiteColor];
   detailView.layer.cornerRadius  = 5;
   detailView.autoresizesSubviews = TRUE;
   masterView.clipsToBounds       = YES;
   detailView.autoresizingMask    = UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight;


   // saves views for later use
   views = [[NSArray alloc] initWithObjects:masterView, detailView, nil];
   [masterView release];
   [detailView release];

   // arranges views
   [self.view addSubview:[views objectAtIndex:0]];
   [self.view addSubview:[views objectAtIndex:1]];

   [self arrangeViews];

   return;
}


- (void)viewDidUnload
{
   [super viewDidUnload];
   [views release];
   views = nil;
   return;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   if (!(controllers))
      return(YES);
   return([[controllers objectAtIndex:1] shouldAutorotateToInterfaceOrientation:interfaceOrientation]);
}


#pragma mark - subview manager methods

- (void) arrangeViews
{
   CGRect             aFrame;
   UIViewController * masterController;
   UIViewController * detailController;
   UIView           * masterRootView;
   UIView           * detailRootView;

   if (!(views))
      return;

   masterRootView   = [views objectAtIndex:0];
   detailRootView   = [views objectAtIndex:1];

   if ((controllers))
   {
      // retrieves controllers
      masterController = [controllers objectAtIndex:0];
      detailController = [controllers objectAtIndex:1];

      // adds content to master root view if content does not exist
      if (!([masterController.view isDescendantOfView:masterRootView]))
      {
         aFrame = CGRectMake( masterRootView.frame.origin.x,
                              masterRootView.frame.origin.y,
                              masterController.view.frame.size.width,
                              masterController.view.frame.size.height);
         masterRootView.frame = aFrame;
         [masterRootView addSubview:masterController.view];
      };

      // adds content to detail root view if content does not exist
      if (!([detailController.view isDescendantOfView:detailRootView]))
      {
         aFrame = CGRectMake( detailRootView.frame.origin.x,
                              detailRootView.frame.origin.y,
                              detailController.view.frame.size.width,
                              detailController.view.frame.size.height);
         detailRootView.frame = aFrame;
         [detailRootView addSubview:detailController.view];
      };
   };

   [self arrangeViewsHorizontally];
   return;
}


- (void) arrangeViewsHorizontally
{
   CGRect   aFrame;
   UIView * masterRootView;
   UIView * detailRootView;

   if (!(views))
      return;

   masterRootView   = [views objectAtIndex:0];
   detailRootView   = [views objectAtIndex:1];

   aFrame = self.view.bounds;

   // adjusts master's view width to a minimum of minimumMasterViewWidth
   if (masterViewWidth < minimumMasterViewWidth)
      masterViewWidth = minimumMasterViewWidth;

   // adjusts detail's view width to a minimum of minimumDetailViewWidth
   if (masterViewWidth > (aFrame.size.width - minimumDetailViewWidth - 1))
      masterViewWidth = aFrame.size.width - minimumDetailViewWidth - 1;

   // adjusts master view
   masterRootView.frame = CGRectMake(  0,
                                       aFrame.origin.y,
                                       masterViewWidth,
                                       aFrame.size.height);

   // adjusts detail view
   detailRootView.frame = CGRectMake(  masterViewWidth + 1,
                                       aFrame.origin.y,
                                       aFrame.size.width - masterViewWidth - 1,
                                       aFrame.size.height);

   return;
}


#pragma mark - Responding to Touch Events

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch  * touch;
   CGPoint    currPt;

   if (!(enableTouchToResize))
      return;

   touch = [touches anyObject];

	if (touch)
   {
      currPt  = [touch locationInView:self.view];
      if ( (currPt.x >= (masterViewWidth - (dividerWidth/2))) &&
           (currPt.x <= (masterViewWidth + (dividerWidth/2))) )
         dividerIsMoving = YES;
   };

   return;
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	dividerIsMoving = NO;
   return;
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch  * touch;
   CGPoint    point;

   if (dividerIsMoving == NO)
      return;

   touch = [touches anyObject];

	if (touch)
   {
      point           = [touch locationInView:self.view];
      masterViewWidth = point.x;
      [self arrangeViews];
   };
   return;
}

@end
