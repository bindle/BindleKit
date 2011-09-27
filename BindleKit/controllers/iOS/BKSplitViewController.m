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
@interface BKSplitViewController () <UIPopoverControllerDelegate>

- (UIView *) sliderViewWithFrame:(CGRect)sliderFrame;

// subview manager methods
- (void) arrangeViewsWithAnimations:(BOOL)useAnimations;
- (void) arrangeBothViewsHorizontallyWithAnimations:(BOOL)animate;
- (void) arrangeSingleViewHorizontallyWithAnimations:(BOOL)animate;
- (void) didLayoutSplitViews;

// animation delegate

- (void) beginAnimations:animationID context:animationContext;
- (void) commitAnimations;
- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished
         context:(void *)context;

// popover manager methods
- (void) displayPopoverControllerFromSender:(id)sender;
- (void) loadPopoverController;
- (void) unloadPopoverController;

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
   [barButton        release];
   [sliderView       release];
   [popoverController release];

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

   // check for array of view controllers
   NSAssert((viewControllers != nil),
      @"BKSplitViewControllers viewControllers cannot be set to nil.");

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

   // load popoverController
   [self loadPopoverController];

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


#pragma mark - View lifecycle (interface rotatations)

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

   if ((popoverController))
      if (popoverController.popoverVisible == YES)
         [popoverController dismissPopoverAnimated:NO];

   if (  (displayBothViews == YES) ||
         (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
         (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) )
   {
      [self unloadPopoverController];
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


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
   [self didLayoutSplitViews];
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
      [self arrangeBothViewsHorizontallyWithAnimations:animate];
   else if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
      [self arrangeSingleViewHorizontallyWithAnimations:animate];
   else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
      [self arrangeSingleViewHorizontallyWithAnimations:animate];
   else
      [self arrangeBothViewsHorizontallyWithAnimations:animate];

   return;
}


- (void) arrangeBothViewsHorizontallyWithAnimations:(BOOL)animate
{
   NSAutoreleasePool * pool;
   UIView * view0;
   UIView * view1;
   CGRect   aFrame;
   CGSize   frameSize;
   CGFloat  limit;
   CGFloat  adjustmentForSlider;
   CGFloat  frameX;
   CGFloat  frameY;
   CGFloat  frameWidth;
   CGFloat  frameHeight;

   pool = [[NSAutoreleasePool alloc] init];

   frameSize = self.view.bounds.size;

   // notifies delegate that master view is about to be displayed
   [self unloadPopoverController];

   // retrieves views in user defined order
   if (!(reverseViewOrder))
   {
      view0 = [[controllers objectAtIndex:0] view];
      view1 = [[controllers objectAtIndex:1] view];
   } else {
      view0 = [[controllers objectAtIndex:1] view];
      view1 = [[controllers objectAtIndex:0] view];
   };

   // adjusts left (view0) view's width to a minimum of minimumViewSize.width
   if (splitPoint.x < (minimumViewSize.width + (sliderSize.width/2)))
      splitPoint.x = minimumViewSize.width + (sliderSize.width/2);

   // adjusts right (view1) view's width to a minimum of minimumViewSize.width
   limit = (frameSize.width < frameSize.height) ? frameSize.width : frameSize.height;
   if (splitPoint.x > (limit - minimumViewSize.width - (sliderSize.width/2)))
      splitPoint.x = limit - minimumViewSize.width - (sliderSize.width/2);

   // adjusts rounded corners depending on the slider view status
   if ((hideSlider == YES) && (view0.layer.cornerRadius != 5))
   {
      view0.layer.cornerRadius = 5;
      view1.layer.cornerRadius = 5;
   };
   if ((hideSlider == NO) && (view0.layer.cornerRadius != 0))
   {
      view0.layer.cornerRadius = 0;
      view1.layer.cornerRadius = 0;
   };

   // begin animations
   if ((animate))
      [self beginAnimations:nil context:nil];

   // positions slider view if marked as visible
   adjustmentForSlider = 0;
   if (hideSlider == NO)
   {
      adjustmentForSlider = (sliderSize.width/2);
      frameX      = splitPoint.x - adjustmentForSlider;
      frameY      = 0;
      frameWidth  = sliderSize.width;
      frameHeight = frameSize.height;
      aFrame      = CGRectMake(frameX, frameY, frameWidth, frameHeight);
      if (!(sliderView))
         sliderView = [[self sliderViewWithFrame:aFrame] retain];
      sliderView.frame = aFrame;
      if (!(sliderView.superview))
      {
         [self.view addSubview:sliderView];
         [self.view sendSubviewToBack:sliderView];
      };
      [sliderView layoutSubviews];
   };

   // positions left view
   frameX      = 0;
   frameY      = 0;
   frameWidth  = splitPoint.x-adjustmentForSlider;
   frameHeight = frameSize.height;
   view0.frame = CGRectMake(frameX, frameY, frameWidth, frameHeight);
   view0.autoresizingMask   = UIViewAutoresizingFlexibleRightMargin |
                              UIViewAutoresizingFlexibleHeight;
   if (view0.superview != self.view)
      [self.view addSubview:view0];
   [view0 layoutSubviews];

   // positions right view
   if (!(adjustmentForSlider))
      adjustmentForSlider = 1;
   frameX      = splitPoint.x + adjustmentForSlider;
   frameY      = 0;
   frameWidth  = frameSize.width - splitPoint.x - adjustmentForSlider;
   frameHeight = frameSize.height;
   view1.frame = CGRectMake(frameX, frameY, frameWidth, frameHeight);
   view1.autoresizingMask   = UIViewAutoresizingFlexibleHeight |
                              UIViewAutoresizingFlexibleWidth;
   if (view1.superview != self.view)
      [self.view addSubview:view1];
   [view1 layoutSubviews];

   // commits animation to be run
   if ((animate))
      [self commitAnimations];

   [pool release];

   return;
}


- (void) arrangeSingleViewHorizontallyWithAnimations:(BOOL)animate
{
   UIView           * aView;

   // begin animations
   if ((animate))
      [self beginAnimations:nil context:nil];

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
      [self commitAnimations];

   return;
}


- (void) didLayoutSplitViews
{
   UIViewController * aController;
   BOOL               removeView;

   // determines if master view should be removed
   aController = [controllers objectAtIndex:0];
   if (displayBothViews == YES)
      removeView = NO;
   else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
      removeView = NO;
   else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
      removeView = NO;
   else if (aController.view.superview != self.view)
      removeView = NO;
   else
      removeView  = YES;

   // removes master view
   if (removeView == YES)
   {
      [aController.view removeFromSuperview];
      [self loadPopoverController];
   };

   // determines if slider view should be removed
   if (hideSlider == YES)
      removeView = YES;
   else if (displayBothViews == YES)
      removeView = NO;
   else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
      removeView = NO;
   else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
      removeView = NO;
   else
      removeView  = YES;

   // removes slider view
   if (removeView == YES)
      if ((sliderView))
         if ((sliderView.superview))
            [sliderView removeFromSuperview];

   return;
}


#pragma mark - animation delegate

- (void) beginAnimations:animationID context:animationContext
{
   [UIView beginAnimations:animationID context:nil];
   [UIView setAnimationDelegate:self];
   [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
   return;
}


- (void) commitAnimations
{
   [UIView commitAnimations];
   return;
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
   [self didLayoutSplitViews];
   return;
}


#pragma mark - popover manager methods

- (void) displayPopoverControllerFromSender:(id)sender
{
   UIViewController * aController;

   aController = [controllers objectAtIndex:0];

   if (!(popoverController))
      return;

   // dismisses popover controller if already visible
   if (popoverController.isPopoverVisible)
   {
      [popoverController dismissPopoverAnimated:YES];
      return;
   };

   // notifies delegate that the view will be displayed
   [delegate splitViewController:self
             popoverController:popoverController
             willPresentViewController:aController];

   // presents popover with master view
   [popoverController presentPopoverFromBarButtonItem:barButton
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                      animated:YES];

   return;
}


- (void) loadPopoverController
{
   UIViewController * aController;

   aController = [controllers objectAtIndex:0];

   if ((popoverController))
      return;

   // allocates new popover controller
   popoverController = [[UIPopoverController alloc]
                       initWithContentViewController:aController];

   // allocates bar button item
   barButton = [[UIBarButtonItem alloc]
               initWithTitle:nil
               style:UIBarButtonItemStylePlain
               target:self
               action:@selector(displayPopoverControllerFromSender:)];

   // notifies delegate that controller has been added to popover controller
   [delegate splitViewController:self
             willHideViewController:aController
             withBarButtonItem:barButton
             forPopoverController:popoverController];

   return;
}


- (void) unloadPopoverController
{
   UIViewController * aController;

   if (!(popoverController))
      return;

   aController = [controllers objectAtIndex:0];

   // dismisses popover controller view
   if (popoverController.popoverVisible != YES)
      [popoverController presentPopoverFromRect:CGRectZero inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
   [popoverController dismissPopoverAnimated:NO];

   // informs delegate that controller's view will be shown
   [delegate splitViewController:self
             willShowViewController:aController
             invalidatingBarButtonItem:barButton];

   // frees popoverController
   [popoverController release];
   popoverController = nil;

   // frees bar button item
   [barButton release];
   barButton = nil;

   // sets controller's parentController to self again
   [aController setBKParentViewController:self];

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
