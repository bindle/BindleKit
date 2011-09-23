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


#pragma mark - Private UIViewController Category Declaration
@interface UIViewController (BKSplitViewControllerInternal)

- (void) setBKParentViewController:(UIViewController *)viewController;

@end


#pragma mark - Private BKSplitViewController Category Declaration
@interface BKSplitViewController ()

- (UIView *) sliderViewWithFrame:(CGRect)sliderFrame;

- (void) arrangeViewsWithAnimations:(BOOL)useAnimations;
- (void) arrangeBothViewsHorizontally:(BOOL)animate;
- (void) arrangeSingleViewHorizontally:(BOOL)animate;

@end


# pragma mark - BKSplitViewController Class Implementation
@implementation BKSplitViewController

// Properties common with UISplitViewController
@synthesize delegate;
@synthesize viewControllers = controllers;

// Properties specific to BKSplitViewController
@synthesize minimumViewSize;
@synthesize splitPoint;
@synthesize reverseViewOrder;
@synthesize enableTouchToResize;
@synthesize displayBothViews;
@synthesize enableAnimations;
@synthesize hideSlider;
@synthesize sliderSize;


- (void) dealloc
{
   [controllers      release];
   [sliderView       release];

   [super dealloc];

   return;
}


- (void) didReceiveMemoryWarning
{
   NSUInteger pos;

   [super didReceiveMemoryWarning];

   // passses warning to child controllers
   if ((controllers))
      for(pos = 0; pos < [controllers count]; pos++)
         [[controllers objectAtIndex:pos] didReceiveMemoryWarning];

   // nothing is left to do if view is currently loaded
   if (self.isViewLoaded == YES)
      return;

   // free root view
   self.view = nil;

   // free slider view
   [sliderView release];
   sliderView = nil;

   return;
}


- (id) init
{
   UIViewController * controller0;
   UIViewController * controller1;

   // generates an assertion if code is not running on an iPad
   NSAssert(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad),
      @"'BKSplitViewController is only supported when running under UIUserInterfaceIdiomPad'");

   if ((self = [super init]) == nil)
      return(self);

   // sets default values for split view controller
   minimumViewSize        = CGSizeMake(0, 0);
   splitPoint             = CGPointMake(320, 320);
   spliderIsMoving        = NO;
   sliderSize             = CGSizeMake(20, 20);
   hideSlider             = NO;
   enableAnimations       = YES;

   // creates initial controllers
   controller0 = [[UIViewController alloc] init];
   controller1 = [[UIViewController alloc] init];
   controllers = [[NSArray alloc] initWithObjects:controller0, controller1, nil];
   [controller0 release];
   [controller1 release];

   return(self);
}


#pragma mark - Properties getters/setters

- (void) setDisplayBothViews:(BOOL)aBool
{
   if (aBool == displayBothViews)
      return;
   displayBothViews = aBool;
   [self arrangeViewsWithAnimations:enableAnimations];
   return;
}


- (void) setHideSlider:(BOOL)aBool
{
   hideSlider = aBool;
   [self arrangeViewsWithAnimations:enableAnimations];
   return;
}


- (void) setSplitPoint:(CGPoint)aPoint
{
   splitPoint = aPoint;
   [self arrangeViewsWithAnimations:enableAnimations];
   return;
}


- (void) setMinimumViewSize:(CGSize)aSize
{
   CGRect  aFrame;
   CGFloat limit;

   // determines screen's limit
   aFrame = [[UIScreen mainScreen] applicationFrame];
   limit  = (aFrame.size.width < aFrame.size.height) ? aFrame.size.width : aFrame.size.height;

   // adjusts minimum view width
   if (((aSize.width*2) + sliderSize.width) <= limit)
      minimumViewSize.width = aSize.width;
   else
      minimumViewSize.width = (limit - sliderSize.width) / 2;

   // adjusts minimum view height
   if (((aSize.height*2) + sliderSize.width) <= limit)
      minimumViewSize.height = aSize.height;
   else
      minimumViewSize.height = (limit - sliderSize.height) / 2;

   [self arrangeViewsWithAnimations:enableAnimations];

   return;
}


- (void) setReverseViewOrder:(BOOL)aBool
{
   CGSize frameSize;

   frameSize = self.view.bounds.size;
   if (aBool != reverseViewOrder)
   {
      // calculates new position of the slider/splitPoint
      splitPoint = CGPointMake(frameSize.width-splitPoint.x,
                               frameSize.height-splitPoint.y);
   };

   reverseViewOrder = aBool;

   [self arrangeViewsWithAnimations:enableAnimations];

   return;
}


- (void) setViewControllers:(NSArray *)viewControllers
{
   NSUInteger         pos;
   UIViewController * aController;

   // if new view controllers are not available, remove old views and exit
   if (!(viewControllers))
   {
      // removes self as parentController
      if ((controllers))
      {
         for(pos = 0; pos < [controllers count]; pos++)
            [[controllers objectAtIndex:pos] setBKParentViewController:nil];
      };

      // removes child controllers
      [controllers release];
      controllers = nil;

      // removes subviews from self.view (in theory no view should be left)
      if (self.isViewLoaded == YES)
         while([self.view.subviews count] > 0)
            [[self.view.subviews objectAtIndex:0] removeFromSuperview];
      return;
   };

   // removes old Views from superview
   if ((controllers))
   {
      for(pos = 0; pos < [controllers count]; pos++)
      {
         // retrieves old controller
         aController = [controllers objectAtIndex:pos];

         // determines if old controller is in new list of controllers
         if (!([viewControllers containsObject:aController]))
         {
            // remove old controller's view if old controller is not in new list 
            if (aController.isViewLoaded == YES)
               [aController.view removeFromSuperview];

            // removes self as parentController of old controller
            [aController setBKParentViewController:nil];
         };
      };
   };

   // assigns new UIViewControllers
   [controllers release];
   controllers = [[NSArray alloc] initWithArray:viewControllers];

   // sets parent controller
   for(pos = 0; pos < [controllers count]; pos++)
      [[controllers objectAtIndex:pos] setBKParentViewController:self];

   // arranges views
   [self arrangeViewsWithAnimations:enableAnimations];

   return;
}


#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
   CGRect   aFrame;
   UIView * rootView;

   // creates root view
   aFrame = [[UIScreen mainScreen] applicationFrame];
   rootView                       = [[UIView alloc] initWithFrame:aFrame];
   rootView.backgroundColor       = [UIColor blackColor];
   rootView.autoresizesSubviews   = TRUE;
   rootView.autoresizingMask      = UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight;
   self.view = rootView;
   [rootView   release];

   // arranges views
   [self arrangeViewsWithAnimations:NO];

   return;
}


// generates slider/divider view
- (UIView *) sliderViewWithFrame:(CGRect)sliderFrame
{
   CGSize             imageSize;
   CGColorSpaceRef    color;
   CGContextRef       context;
   CGGradientRef      gradient;
   CGPoint            start;
   CGPoint            stop;
   CGImageRef         cgImage;
   UIImage          * uiImage;
   UIImageView      * imageView;
   CGFloat            components[8] = { 0.988, 0.988, 0.988, 1.0,  // light
                                        0.875, 0.875, 0.875, 1.0 }; // dark

   imageSize.width  = sliderFrame.size.width;
   imageSize.height = sliderFrame.size.height;
   color            = CGColorSpaceCreateDeviceRGB();

   // creates color context
   context = CGBitmapContextCreate
   (
      NULL,                          // data
      imageSize.width,               // width
      imageSize.height,              // height
      8,                             // bits per component (1 byte per componet)
      (imageSize.width * 4),         // bytes per row (4 componets per pixel)
      color,                         // color space
      kCGImageAlphaPremultipliedLast // bitmap info
   );

   // creates path (drawing area) for gradient and background color
   CGContextDrawPath(context, kCGPathStroke);
   CGContextMoveToPoint(context, 0, 0);
   CGContextAddLineToPoint(context, imageSize.width, 0);
   CGContextAddLineToPoint(context, imageSize.width, imageSize.height);
   CGContextAddLineToPoint(context, 0, imageSize.height);
   CGContextAddLineToPoint(context, 0, 0);
	CGContextClosePath(context);

   // fill in background color
   CGContextSetRGBStrokeColor(context, 0.700, 0.700, 0.700, 1.0);
	CGContextSetRGBFillColor(context,   0.700, 0.700, 0.700, 1.0);
   CGContextSetLineWidth(context, 0);
   CGContextFillPath(context);

   // creates gradient
   start = CGPointMake(1, 0);
   stop  = CGPointMake(imageSize.width-1, 0);
   gradient = CGGradientCreateWithColorComponents(color, components, NULL, 2);
   CGContextDrawLinearGradient(context, gradient, start, stop,  0);
   CGGradientRelease(gradient);

   // Creates Image
   cgImage = CGBitmapContextCreateImage(context);
   uiImage = [UIImage imageWithCGImage:cgImage];
   uiImage = [uiImage stretchableImageWithLeftCapWidth:1 topCapHeight:1];

   // frees resources
   CGImageRelease(cgImage);
   CGContextRelease(context);
   CGColorSpaceRelease(color);

   // creates view
   imageView = [[UIImageView alloc] initWithImage:uiImage];
   imageView.frame            = sliderFrame;
   imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
                                UIViewAutoresizingFlexibleHeight;

   return([imageView autorelease]);
}


- (void)viewDidUnload
{
   [super viewDidUnload];
   return;
}


// delegates (to the detail view) the decision to auto rotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   if (!(controllers))
      return(NO);
   return([[controllers objectAtIndex:1] shouldAutorotateToInterfaceOrientation:interfaceOrientation]);
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
   UIView * aView;

   if (  (displayBothViews == YES) ||
         (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
         (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) )
   {
      aView  = [[controllers objectAtIndex:0] view];
      if (aView.superview != self.view)
      {
         [self.view addSubview:aView];
         [self.view sendSubviewToBack:aView];
      };
   };

   return;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
   [self arrangeViewsWithAnimations:NO];
   return;
}


#pragma mark - subview manager methods

- (void) arrangeViewsWithAnimations:(BOOL)animate
{
   if (!(controllers))
      return;

   if (self.isViewLoaded == NO)
      return;

   if (displayBothViews == YES)
      [self arrangeBothViewsHorizontally:animate];
   else if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
      [self arrangeSingleViewHorizontally:animate];
   else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
      [self arrangeSingleViewHorizontally:animate];
   else
      [self arrangeBothViewsHorizontally:animate];

   return;
}


- (void) arrangeBothViewsHorizontally:(BOOL)animate
{
   NSAutoreleasePool * pool;
   UIView * view0;
   UIView * view1;
   CGRect   sliderFrame;
   CGSize   frameSize;
   CGFloat  limit;
   CGFloat  adjustmentForSlider;
   CGFloat  frameX;
   CGFloat  frameY;
   CGFloat  frameWidth;
   CGFloat  frameHeight;

   pool = [[NSAutoreleasePool alloc] init];

   frameSize = self.view.bounds.size;

   // retrieves views in user defined order
   if (!(reverseViewOrder))
   {
      view0 = [[controllers objectAtIndex:0] view];
      view1 = [[controllers objectAtIndex:1] view];
   } else {
      view0 = [[controllers objectAtIndex:1] view];
      view1 = [[controllers objectAtIndex:0] view];
   };

   // calculates left & right view position adjustments to allow room for sliderView
   adjustmentForSlider = 0;
   if (hideSlider == NO)
      adjustmentForSlider = (sliderSize.width/2);

   // adjusts left (view0) view's width to a minimum of minimumViewSize.width
   if (splitPoint.x < (minimumViewSize.width + (sliderSize.width/2)))
      splitPoint.x = minimumViewSize.width + (sliderSize.width/2);

   // adjusts right (view1) view's width to a minimum of minimumViewSize.width
   limit = (frameSize.width < frameSize.height) ? frameSize.width : frameSize.height;
   if (splitPoint.x > (limit - minimumViewSize.width - (sliderSize.width/2)))
      splitPoint.x = limit - minimumViewSize.width - (sliderSize.width/2);

   // removes slider view if marked as hidden
   if (hideSlider == YES)
   {
      // adjust corners of master & detail views
      if (view0.layer.cornerRadius != 5)
         view0.layer.cornerRadius = 5;
      if (view1.layer.cornerRadius != 5)
         view1.layer.cornerRadius = 5;

      // removes slider view
      if ((sliderView))
         if ((sliderView.superview))
            [sliderView removeFromSuperview];
   };

   // calculates slider view position
   frameX      = splitPoint.x - adjustmentForSlider;
   frameY      = 0;
   frameWidth  = sliderSize.width;
   frameHeight = frameSize.height;
   sliderFrame = CGRectMake(frameX, frameY, frameWidth, frameHeight);

   // adds slider view if marked as visible
   if (hideSlider == NO)
   {
      // adjust corners of master & detail views
      if (view0.layer.cornerRadius != 0)
         view0.layer.cornerRadius = 0;
      if (view0.layer.cornerRadius != 0)
         view1.layer.cornerRadius = 0;

      // adjusts slider view
      if (!(sliderView))
         sliderView = [[self sliderViewWithFrame:sliderFrame] retain];
      if (!(sliderView.superview))
      {
         [self.view addSubview:sliderView];
         [self.view sendSubviewToBack:sliderView];
      };
   };

   // begin animations
   if ((animate))
      [UIView beginAnimations:nil context:nil];

   // positions left view
   if (view0.superview != self.view)
      [self.view addSubview:view0];
   frameX      = 0;
   frameY      = 0;
   frameWidth  = splitPoint.x-adjustmentForSlider;
   frameHeight = frameSize.height;
   view0.frame = CGRectMake(frameX, frameY, frameWidth, frameHeight);
   view0.autoresizingMask   = UIViewAutoresizingFlexibleRightMargin |
                              UIViewAutoresizingFlexibleHeight;

   // positions right view
   if (!(adjustmentForSlider))
      adjustmentForSlider = 1;
   if (view1.superview != self.view)
      [self.view addSubview:view1];
   frameX      = splitPoint.x + adjustmentForSlider;
   frameY      = 0;
   frameWidth  = frameSize.width - splitPoint.x - adjustmentForSlider;
   frameHeight = frameSize.height;
   view1.frame = CGRectMake(frameX, frameY, frameWidth, frameHeight);
   view1.autoresizingMask   = UIViewAutoresizingFlexibleHeight |
                              UIViewAutoresizingFlexibleWidth;

   // positions slider view
   if (hideSlider == NO)
      sliderView.frame = sliderFrame;

   // commits animation to be run
   if ((animate))
      [UIView commitAnimations];

   [pool release];

   return;
}


- (void) arrangeSingleViewHorizontally:(BOOL)animate
{
   UIView * aView;

   // begin animations
   if ((animate))
      [UIView beginAnimations:nil context:nil];

   // positions detail view
   aView = [[controllers objectAtIndex:1] view];
   if (aView.superview != self.view)
      [self.view addSubview:aView];
   [self.view bringSubviewToFront:aView];
   aView.frame              = self.view.bounds;
   aView.autoresizingMask   = UIViewAutoresizingFlexibleWidth |
                              UIViewAutoresizingFlexibleHeight;

   // commits animation to be run
   if ((animate))
      [UIView commitAnimations];

   return;
}


#pragma mark - Responding to Touch Events

// begins tracking touches to slider
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch  * touch;
   CGPoint    currPt;

   if (!(enableTouchToResize))
      return;

	if ((touch = [touches anyObject]))
   {
      currPt  = [touch locationInView:self.view];
      if ( (currPt.x >= (splitPoint.x - (sliderSize.width/2))) &&
           (currPt.x <= (splitPoint.x + (sliderSize.width/2))) )
         spliderIsMoving = YES;
   };

   return;
}


// stops tracking touches to slider
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	spliderIsMoving = NO;
   return;
}


// updates slider view position based upon movement of touches
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch  * touch;
   CGPoint    point;

   if (spliderIsMoving == NO)
      return;

	if ((touch = [touches anyObject]))
   {
      point           = [touch locationInView:self.view];
      splitPoint.x    = point.x;
      [self arrangeViewsWithAnimations:NO];
   };
   return;
}

@end


#pragma mark - Public UIViewController Category Implementation
@implementation UIViewController (BKSplitViewController)

// updates splitViewController property to include BKSplitViewController
- (UIViewController *) splitViewController
{
   id controller;
   if (!(controller = [self parentViewController]))
      return(nil);
   while ((controller = [controller parentViewController]))
      if ( (([controller isKindOfClass:[BKSplitViewController class]])) ||
           (([controller isKindOfClass:[UISplitViewController class]])) )
         return(controller);
   return(nil);
}

@end


#pragma mark - Private UIViewController Category Implementation
@implementation UIViewController (BKSplitViewControllerInternal)

// allows BKSplitViewController to set itself as the parent of a controller
- (void) setBKParentViewController:(UIViewController *)parent
{
   [self setValue:parent forKey:@"_parentViewController"];
   return;
}

@end
