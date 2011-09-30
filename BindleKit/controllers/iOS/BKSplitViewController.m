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

// view lifecycle (divider views)
- (UIImage *) dividerBackgroundImage:(CGSize)imageSize;
- (UIImageView *) dividerImageView:(CGSize)imageSize;
- (void) loadDividerView;

// subview layout methods
- (void) layoutViewsWithAnimations:(BOOL)useAnimations;
- (void) willLayoutSplitViews:(UIInterfaceOrientation)orientation;
- (void) layoutSingleView;
- (void) layoutSplitViews;
- (void) didLayoutSplitViews;

// animation delegate
- (void) beginAnimations:animationID context:animationContext;
- (void) commitAnimations;
- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished
         context:(void *)context;

// popover manager methods
- (void) dismissPopoverControllerAnimated:(BOOL)animate;
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
@synthesize dividePoint;
@synthesize dividerSize;
@synthesize dividerHidden;
@synthesize minimumViewSize;
@synthesize viewOrderReversed;
@synthesize bothViewsDisplayed;
@synthesize userInteractionEnabled;
@synthesize animationsEnabled;
@synthesize viewLayout;


#pragma mark - Creating and Initializing a BKSplitViewController

- (void) dealloc
{
   [controllers      release];
   [barButton        release];
   [dividerHorzView   release];
   [dividerVertView   release];
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

   // free horizontal divider view if not visible
   if (!(dividerHorzView.superview))
   {
      [dividerHorzView release];
      dividerHorzView = nil;
   };

   // free vertical divider view if not visible
   if (!(dividerVertView.superview))
   {
      [dividerVertView release];
      dividerVertView = nil;
   };

   // nothing is left to do if view is currently loaded
   if (self.isViewLoaded == YES)
      return;

   // free root view
   self.view = nil;

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

   // creates initial controllers
   controller0 = [[UIViewController alloc] init];
   controller1 = [[UIViewController alloc] init];
   controllers = [[NSArray alloc] initWithObjects:controller0, controller1, nil];
   [controller0 release];
   [controller1 release];

   // sets default values for split view controller
   [self setDefaults];

   return(self);
}


#pragma mark - Properties getters/setters

- (void) setBothViewsDisplayed:(BOOL)aBool
{
   if (aBool == bothViewsDisplayed)
      return;
   bothViewsDisplayed = aBool;
   [self layoutViewsWithAnimations:animationsEnabled];
   return;
}


- (void) setDefaults
{
   minimumViewSize        = CGSizeMake(0, 0);
   dividePoint            = CGPointMake(320, 320);
   dividerIsMoving        = NO;
   dividerSize            = CGSizeMake(20, 20);
   dividerHidden          = NO;
   animationsEnabled      = YES;
   viewLayout             = BKSplitViewLayoutHorizontally;
   [self layoutViewsWithAnimations:animationsEnabled];
   return;
}


- (void) setDividePoint:(CGPoint)aPoint
{
   if ( (aPoint.x == dividePoint.x) &&
        (aPoint.y == dividePoint.y) )
      return;
   dividePoint = aPoint;
   [self layoutViewsWithAnimations:animationsEnabled];
   return;
}


- (void) setDividerHidden:(BOOL)aBool
{
   if (aBool == dividerHidden)
      return;
   dividerHidden = aBool;
   [self layoutViewsWithAnimations:animationsEnabled];
   return;
}


- (void) setMinimumViewSize:(CGSize)aSize
{
   CGRect  aFrame;
   CGFloat limit;

   // exits if value is already set
   if ( (aSize.width == minimumViewSize.width) &&
        (aSize.height == minimumViewSize.height) )
      return;

   // determines screen's limit
   aFrame = [[UIScreen mainScreen] applicationFrame];
   limit  = (aFrame.size.width < aFrame.size.height) ? aFrame.size.width : aFrame.size.height;

   // adjusts minimum view width
   if (((aSize.width*2) + dividerSize.width) <= limit)
      minimumViewSize.width = aSize.width;
   else
      minimumViewSize.width = (limit - dividerSize.width) / 2;

   // adjusts minimum view height
   if (((aSize.height*2) + dividerSize.width) <= limit)
      minimumViewSize.height = aSize.height;
   else
      minimumViewSize.height = (limit - dividerSize.height) / 2;

   [self layoutViewsWithAnimations:animationsEnabled];

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
   [self layoutViewsWithAnimations:NO];

   return;
}


- (void) setViewLayout:(BKSplitViewLayout)layout
{
   if (layout == viewLayout)
      return;
   viewLayout      = layout;
   dividerIsMoving = NO;
   [self layoutViewsWithAnimations:animationsEnabled];
   return;
}


- (void) setViewOrderReversed:(BOOL)aBool
{
   CGSize frameSize;

   frameSize = self.view.bounds.size;
   if (aBool != viewOrderReversed)
   {
      // calculates new position of the divider/dividePoint
      dividePoint = CGPointMake(frameSize.width-dividePoint.x,
                                frameSize.height-dividePoint.y);
   };

   viewOrderReversed = aBool;

   [self layoutViewsWithAnimations:animationsEnabled];

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
   self.view = rootView;
   [rootView   release];

   // load popoverController
   [self loadPopoverController];

   // arranges views
   [self layoutSplitViews];

   return;
}


- (void)viewDidUnload
{
   [super viewDidUnload];
   return;
}


#pragma mark - view lifecycle (divider views)

// generates divider background image for divider views
- (UIImage *) dividerBackgroundImage:(CGSize)imageSize
{
   CGColorSpaceRef    color;
   CGContextRef       context;
   CGGradientRef      gradient;
   CGPoint            start;
   CGPoint            stop;
   CGImageRef         cgImage;
   UIImage          * uiImage;
   CGFloat            components[8] = { 0.988, 0.988, 0.988, 1.0,  // light
                                        0.875, 0.875, 0.875, 1.0 }; // dark

   color = CGColorSpaceCreateDeviceRGB();

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
   if (imageSize.height > imageSize.width)
   {
      start = CGPointMake(1, 0);
      stop  = CGPointMake(imageSize.width-1, 0);
   } else {
      start = CGPointMake(0, imageSize.height-1);
      stop  = CGPointMake(0, 1);
   };
   gradient = CGGradientCreateWithColorComponents(color, components, NULL, 2);
   CGContextDrawLinearGradient(context, gradient, start, stop,  0);
   CGGradientRelease(gradient);

   // Creates Image
   cgImage = CGBitmapContextCreateImage(context);
   uiImage = [UIImage imageWithCGImage:cgImage];

   // frees resources
   CGImageRelease(cgImage);
   CGContextRelease(context);
   CGColorSpaceRelease(color);

   return(uiImage);
}


// generates divider image views for divider views
- (UIImageView *) dividerImageView:(CGSize)imageSize
{
   UIImage * bgImage;

   bgImage = [self dividerBackgroundImage:imageSize];

   return([[[UIImageView alloc] initWithImage:bgImage] autorelease]);
}


// loads divider view
- (void) loadDividerView
{
   NSAutoreleasePool * pool;
   CGSize              boundsSize;
   CGSize              imageSize;

   pool = [[NSAutoreleasePool alloc] init];

   boundsSize       = self.view.bounds.size;

   // calculates image size
   if (viewLayout == BKSplitViewLayoutHorizontally)
      imageSize = CGSizeMake(dividerSize.width, boundsSize.height);
   else
      imageSize = CGSizeMake(boundsSize.width, dividerSize.height);

   // retrieves horizontal divider
   if (viewLayout == BKSplitViewLayoutHorizontally)
   {
      if (!(dividerHorzView))
         dividerHorzView = [[self dividerImageView:imageSize] retain];
      dividerView = dividerHorzView;
      if ((dividerVertView.superview))
         [dividerVertView removeFromSuperview];
   };

   // retrieves vertical divider
   if (viewLayout == BKSplitViewLayoutVertically)
   {
      if (!(dividerVertView))
         dividerVertView = [[self dividerImageView:imageSize] retain];
      dividerView = dividerVertView;
      if ((dividerHorzView.superview))
         [dividerHorzView removeFromSuperview];
   };

   [pool release];

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
   [self willLayoutSplitViews:toInterfaceOrientation];
   return;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
   [self layoutSplitViews];
   return;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
   [self didLayoutSplitViews];
   return;
}


#pragma mark - subview layout methods

- (void) layoutViewsWithAnimations:(BOOL)animate
{
   if (!(controllers))
      return;

   if (self.isViewLoaded == NO)
      return;

   // prepares views to be arranged on screen
   [self willLayoutSplitViews:self.interfaceOrientation];

   // begin animations
   if ((animate))
      [self beginAnimations:nil context:nil];

   // arranges views
   [self layoutSplitViews];

   // commits animation to be run
   if ((animate))
      [self commitAnimations];
   else
      [self didLayoutSplitViews];

   return;
}


- (void) willLayoutSplitViews:(UIInterfaceOrientation)orientation
{
   CGSize    frameSize;
   UIView  * masterView;
   CGRect    dividerFrame;
   CGRect    masterFrame;
   CGFloat   dividerOffset;
   CGFloat   fx; // frame X position
   CGFloat   fy; // frame Y position
   CGFloat   fw; // frame width
   CGFloat   fh; // frame height

   frameSize  = self.view.bounds.size;
   masterView = [[controllers objectAtIndex:0] view];

   // dismisses popover controller for transitions
   if (orientation != self.interfaceOrientation)
      [self dismissPopoverControllerAnimated:NO];

   // determines if moving to portrait mode without displaying both views and exits
   if ((bothViewsDisplayed == NO) && (orientation == UIInterfaceOrientationPortrait))
      return;
   if ((bothViewsDisplayed == NO) && (orientation == UIInterfaceOrientationPortraitUpsideDown))
      return;

   // unloads the popover controller if moving to landscape mode
   if (  (bothViewsDisplayed == YES) ||
         (orientation == UIInterfaceOrientationLandscapeLeft) ||
         (orientation == UIInterfaceOrientationLandscapeRight) )
      [self unloadPopoverController];

   // if just an orientation change, add master view to self.view and exit
   if (orientation != self.interfaceOrientation)
   {
      if (masterView.superview != self.view)
      {
         [self.view addSubview:masterView];
         [self.view sendSubviewToBack:masterView];
      };
      return;
   };

   // calculates position of divider view for beginning of animations
   dividerOffset = 0;
   switch(viewLayout)
   {
      // vertical layout (one over the other)
      case BKSplitViewLayoutVertically:
      if (!(dividerHidden))
         dividerOffset = (dividerSize.height/2);
      fx  = 0;
      fy  = dividePoint.y - dividerOffset;
      if (masterView.superview != self.view)
      {
         fy = frameSize.height;
         if (!(viewOrderReversed))
            fy = 0 - dividerSize.height;
      };
      fw  = frameSize.width;
      fh  = dividerSize.height;
      break;

      // horizontal layout (side by side)
      case BKSplitViewLayoutHorizontally:
      default:
      if (!(dividerHidden))
         dividerOffset = (dividerSize.width/2);
      fx  = dividePoint.x - dividerOffset;
      if (masterView.superview != self.view)
      {
         fx = frameSize.width;
         if (!(viewOrderReversed))
            fx = 0 - dividerSize.width;
      };
      fy  = 0;
      fw  = dividerSize.width;
      fh  = frameSize.height;
      break;
   };
   dividerFrame = CGRectMake(fx, fy, fw, fh);

   // calculates position of master view for beginning of animations
   switch(viewLayout)
   {
      // vertical layout (one over the other)
      case BKSplitViewLayoutVertically:
      fx   = 0;
      fy   = frameSize.height + dividerSize.height;
      if (!(viewOrderReversed))
         fy = 0 - dividePoint.y;
      fw   = frameSize.width;
      fh   = dividePoint.y - dividerOffset;
      break;

      // horizontal layout (side by side)
      case BKSplitViewLayoutHorizontally:
      default:
      fx = frameSize.width + dividerSize.width;
      if (!(viewOrderReversed))
         fx = 0 - dividePoint.x;
      fy   = 0;
      fw   = dividePoint.x - dividerOffset;
      fh   = frameSize.height;
      break;
   };
   masterFrame = CGRectMake(fx, fy, fw, fh);

   // positions divider view for beginning of animations
   if (!(dividerHidden))
   {
      [self loadDividerView];
      if (dividerView.superview != self.view)
      {
         dividerView.frame = dividerFrame;
         [self.view addSubview:dividerView];
         [self.view sendSubviewToBack:dividerView];
      };
   };

   // positions master view for beginning of animations
   if (masterView.superview != self.view)
   {
      masterView.frame = masterFrame;
      [self.view addSubview:masterView];
   };

   return;
}


- (void) layoutSingleView
{
   UIView  * view0;
   UIView  * view1;
   CGSize    frameSize;
   CGFloat   fx; // frame X position
   CGFloat   fy; // frame Y position
   CGFloat   fw; // frame width
   CGFloat   fh; // frame height
   CGFloat   dividerOffset;
   CGRect    dividerFrame;
   CGRect    frame0;

   frameSize  = self.view.bounds.size;
   view0      = [[controllers objectAtIndex:0] view];
   view1      = [[controllers objectAtIndex:1] view];

   // calculates position of divider view for beginning of animations
   dividerOffset = 0;
   switch(viewLayout)
   {
      // vertical layout (one over the other)
      case BKSplitViewLayoutVertically:
      if (!(dividerHidden))
         dividerOffset = (dividerSize.height/2);
      fx  = 0;
      fy = frameSize.height;
      if (!(viewOrderReversed))
         fy = 0 - dividerSize.height;
      fw  = frameSize.width;
      fh  = dividerSize.height;
      break;

      // horizontal layout (side by side)
      case BKSplitViewLayoutHorizontally:
      default:
      if (!(dividerHidden))
         dividerOffset = (dividerSize.width/2);
      fx = frameSize.width;
      if (!(viewOrderReversed))
         fx = 0 - dividerSize.width;
      fy  = 0;
      fw  = dividerSize.width;
      fh  = frameSize.height;
      break;
   };
   dividerFrame = CGRectMake(fx, fy, fw, fh);

   // calculates position of master view for beginning of animations
   switch(viewLayout)
   {
      // vertical layout (one over the other)
      case BKSplitViewLayoutVertically:
      fx   = 0;
      fy   = frameSize.height + dividerSize.height;
      if (!(viewOrderReversed))
         fy = 0 - dividePoint.y;
      fw   = frameSize.width;
      fh   = dividePoint.y - dividerOffset;
      break;

      // horizontal layout (side by side)
      case BKSplitViewLayoutHorizontally:
      default:
      fx = frameSize.width + dividerSize.width;
      if (!(viewOrderReversed))
         fx = 0 - dividePoint.x;
      fy   = 0;
      fw   = dividePoint.x - dividerOffset;
      fh   = frameSize.height;
      break;
   };
   frame0 = CGRectMake(fx, fy, fw, fh);

   // positions detail view
   view1.frame = self.view.bounds;
   if (view1.superview != self.view)
      [self.view addSubview:view1];
   [self.view bringSubviewToFront:view1];

   // positions detail view
   if (view0.superview == self.view)
   {
      view0.frame = frame0;
      [self.view sendSubviewToBack:view0];
   };

   // positions divider view
   if (dividerView.superview == self.view)
   {
      dividerView.frame = dividerFrame;
      [self.view sendSubviewToBack:dividerView];
   };

   return;
}


- (void) layoutSplitViews
{
   UIInterfaceOrientation orientation;
   UIView * view0;
   UIView * view1;
   CGSize   frameSize;
   CGFloat  limit;
   CGFloat  dividerOffset;
   CGFloat   fx; // frame X position
   CGFloat   fy; // frame Y position
   CGFloat   fw; // frame width
   CGFloat   fh; // frame height
   CGRect    frame0;
   CGRect    frame1;
   CGRect    dividerFrame;

   frameSize = self.view.bounds.size;

   // positions detail view in full screen
   orientation = self.interfaceOrientation;
   if ( ((!(bothViewsDisplayed)) && (orientation == UIInterfaceOrientationPortrait)) ||
        ((!(bothViewsDisplayed)) && (orientation == UIInterfaceOrientationPortraitUpsideDown)) )
   {
      [self layoutSingleView];
      return;
   };

   // retrieves views in user defined order
   if (!(viewOrderReversed))
   {
      view0 = [[controllers objectAtIndex:0] view];
      view1 = [[controllers objectAtIndex:1] view];
   } else {
      view0 = [[controllers objectAtIndex:1] view];
      view1 = [[controllers objectAtIndex:0] view];
   };

   // adjusts view sizes to be greater than minimumViewSize
   limit = (frameSize.width < frameSize.height) ? frameSize.width : frameSize.height;
   if (viewLayout == BKSplitViewLayoutHorizontally)
   {
      // adjusts left (view0) view's width to a minimum of minimumViewSize
      if (dividePoint.x < (minimumViewSize.width + (dividerSize.width/2)))
         dividePoint.x = minimumViewSize.width + (dividerSize.width/2);

      // adjusts right (view1) view's width to a minimum of minimumViewSize
      if (dividePoint.x > (limit - minimumViewSize.width - (dividerSize.width/2)))
         dividePoint.x = limit - minimumViewSize.width - (dividerSize.width/2);
   } else {
      // adjusts top (view0) view's height to a minimum of minimumViewSize
      if (dividePoint.y < (minimumViewSize.height + (dividerSize.height/2)))
         dividePoint.y = minimumViewSize.height + (dividerSize.height/2);

      // adjusts bottom (view1) view's height to a minimum of minimumViewSize
      if (dividePoint.y > (limit - minimumViewSize.height - (dividerSize.height/2)))
         dividePoint.y = limit - minimumViewSize.height - (dividerSize.height/2);
   };

   // adjusts rounded corners depending on the divider view status
   if ((dividerHidden == YES) && (view0.layer.cornerRadius != 5))
   {
      view0.layer.cornerRadius = 5;
      view1.layer.cornerRadius = 5;
   };
   if ((dividerHidden == NO) && (view0.layer.cornerRadius != 0))
   {
      view0.layer.cornerRadius = 0;
      view1.layer.cornerRadius = 0;
   };

   // calculates position of divider view
   dividerOffset = 0;
   switch(viewLayout)
   {
      // vertical layout (one over the other)
      case BKSplitViewLayoutVertically:
      if (!(dividerHidden))
         dividerOffset = (dividerSize.height/2);
      fx = 0;
      fy = dividePoint.y - dividerOffset;
      fw = frameSize.width;
      fh = dividerSize.height;
      break;

      // vertical layout (one over the other)
      case BKSplitViewLayoutHorizontally:
      default:
      if (dividerHidden == NO)
         dividerOffset = (dividerSize.width/2);
      fx = dividePoint.x - dividerOffset;
      fy = 0;
      fw = dividerSize.width;
      fh = frameSize.height;
      break;
   };
   dividerFrame = CGRectMake(fx, fy, fw, fh);

   // calculates position of left view
   switch(viewLayout)
   {
      // vertical layout (one over the other)
      case BKSplitViewLayoutVertically:
      fx = 0;
      fy = 0;
      fw = frameSize.width;
      fh = dividePoint.y - dividerOffset;
      break;

      // horizontal layout (side by side)
      case BKSplitViewLayoutHorizontally:
      default:
      fx = 0;
      fy = 0;
      fw = dividePoint.x - dividerOffset;
      fh = frameSize.height;
      break;
   };
   frame0 = CGRectMake(fx, fy, fw, fh);

   // calculates position of right view
   if (!(dividerOffset))
      dividerOffset = 1;
   switch(viewLayout)
   {
      // vertical layout (one over the other)
      case BKSplitViewLayoutVertically:
      fx = 0;
      fy = dividePoint.y + dividerOffset;
      fw = frameSize.width;
      fh = frameSize.height - dividePoint.y - dividerOffset;
      break;

      // horizontal layout (side by side)
      case BKSplitViewLayoutHorizontally:
      default:
      fx = dividePoint.x + dividerOffset;
      fy = 0;
      fw = frameSize.width - dividePoint.x - dividerOffset;
      fh = frameSize.height;
      break;
   };
   frame1 = CGRectMake(fx, fy, fw, fh);

   // positions left view
   view0.frame = frame0;
   if (view0.superview != self.view)
      [self.view addSubview:view0];
   [view0 layoutSubviews];

   // positions divider view if marked as visible
   if (dividerHidden == NO)
   {
      [self loadDividerView];
      dividerView.frame = dividerFrame;
      if (!(dividerView.superview))
      {
         [self.view addSubview:dividerView];
         [self.view sendSubviewToBack:dividerView];
      };
      [dividerView layoutSubviews];
   };

   // positions right view
   view1.frame = frame1;
   if (view1.superview != self.view)
      [self.view addSubview:view1];
   [view1 layoutSubviews];

   return;
}


- (void) didLayoutSplitViews
{
   UIViewController * aController;
   BOOL               removeView;

   // determines if master view should be removed
   aController = [controllers objectAtIndex:0];
   if (bothViewsDisplayed == YES)
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

   // determines if divider view should be removed
   if (dividerHidden == YES)
      removeView = YES;
   else if (bothViewsDisplayed == YES)
      removeView = NO;
   else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
      removeView = NO;
   else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
      removeView = NO;
   else
      removeView  = YES;

   // removes divider view
   if (removeView == YES)
      if ((dividerView))
         if ((dividerView.superview))
            [dividerView removeFromSuperview];

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

- (void) dismissPopoverControllerAnimated:(BOOL)animate
{
   if ((popoverController))
      if ((popoverController.isPopoverVisible))
         [popoverController dismissPopoverAnimated:YES];
   return;
}


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

// begins tracking touches to divider
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch  * touch;
   CGPoint    currPt;

   if (!(userInteractionEnabled))
      return;

	if ((touch = [touches anyObject]))
   {
      currPt  = [touch locationInView:self.view];
      if ( (currPt.x >= (dividePoint.x - (dividerSize.width/2))) &&
           (currPt.x <= (dividePoint.x + (dividerSize.width/2))) &&
           (viewLayout == BKSplitViewLayoutHorizontally) )
         dividerIsMoving = YES;
      if ( (currPt.y >= (dividePoint.y - (dividerSize.height/2))) &&
           (currPt.y <= (dividePoint.y + (dividerSize.height/2))) &&
           (viewLayout == BKSplitViewLayoutVertically) )
         dividerIsMoving = YES;
   };

   return;
}


// stops tracking touches to divider
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	dividerIsMoving = NO;
   return;
}


// updates divider view position based upon movement of touches
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch  * touch;
   CGPoint    point;

   if (dividerIsMoving == NO)
      return;

	if ((touch = [touches anyObject]))
   {
      point = [touch locationInView:self.view];
      if (viewLayout == BKSplitViewLayoutHorizontally)
         dividePoint.x = point.x;
      if (viewLayout == BKSplitViewLayoutVertically)
         dividePoint.y = point.y;
      [self layoutViewsWithAnimations:NO];
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
