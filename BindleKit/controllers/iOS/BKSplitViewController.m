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

- (UIView *) sliderViewWithFrame:(CGRect)sliderFrame;

- (void) arrangeViews;
- (void) arrangeViewsHorizontally;

@end


#pragma mark -
@implementation BKSplitViewController

@synthesize viewControllers = controllers;
@synthesize minimumViewSize;
@synthesize splitPoint;
@synthesize reverseViewOrder;
@synthesize enableTouchToResize;
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

   for(pos = 0; pos < [controllers count]; pos++)
      [[controllers objectAtIndex:pos] didReceiveMemoryWarning];

   if (self.isViewLoaded == YES)
      return;

   return;
}


- (id) init
{
   if ((self = [super init]) == nil)
      return(self);

   minimumViewSize        = CGSizeMake(0, 0);
   splitPoint             = CGPointMake(320, 320);
   spliderIsMoving        = NO;
   sliderSize             = CGSizeMake(20, 20);
   hideSlider             = NO;

   return(self);
}


#pragma mark - Properties getters/setters

- (void) setSplitPoint:(CGPoint)aPoint
{
   splitPoint = aPoint;
   [self arrangeViews];
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

   [self arrangeViews];

   return;
}


- (void) setViewControllers:(NSArray *)viewControllers
{
   NSUInteger         pos;
   UIViewController * aController;

   // if new view controllers are not available, remove old views and exit
   if (!(viewControllers))
   {
      [controllers release];
      controllers = nil;
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
         aController = [controllers objectAtIndex:pos];
         if (!([viewControllers containsObject:aController]))
            if (aController.isViewLoaded == YES)
               [aController.view removeFromSuperview];
      };
   };

   // assigns new UIViewControllers
   [controllers release];
   controllers = [[NSArray alloc] initWithArray:viewControllers];

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
   [self arrangeViews];

   return;
}


- (UIView *) sliderViewWithFrame:(CGRect)sliderFrame
{
   CGSize                   imageSize;
   CGColorSpaceRef          color;
   CGContextRef             context;
   CGFloat                  components[8] = { 0.988, 0.988, 0.988, 1.0,  // light
                                              0.875, 0.875, 0.875, 1.0 }; // dark
   CGGradientRef            gradient;
   CGPoint                  start;
   CGPoint                  stop;
   CGImageRef               cgImage;
   UIImage                * uiImage;
   UIImageView            * imageView;

   imageSize.width  = sliderFrame.size.width;
   imageSize.height = 1;
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
   CGContextSaveGState(context);

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
	CGContextRestoreGState(context);
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   if (!(controllers))
      return(YES);
   return([[controllers objectAtIndex:1] shouldAutorotateToInterfaceOrientation:interfaceOrientation]);
}


#pragma mark - subview manager methods

- (void) arrangeViews
{
   if (!(controllers))
      return;

   [self arrangeViewsHorizontally];

   return;
}


- (void) arrangeViewsHorizontally
{
   CGRect   aFrame;
   CGSize   frameSize;
   CGFloat  limit;
   UIView * aView;
   CGFloat  adjustmentForSlider;
   CGFloat  frameX;
   CGFloat  frameY;
   CGFloat  frameWidth;
   CGFloat  frameHeight;
   NSAutoreleasePool * pool;

   if (self.isViewLoaded == NO)
      return;

   if (!(controllers))
      return;

   pool = [[NSAutoreleasePool alloc] init];

   frameSize = self.view.bounds.size;

   adjustmentForSlider = 0;
   if (hideSlider == NO)
      adjustmentForSlider = (sliderSize.width/2);

   // adjusts master's view width to a minimum of minimumViewSize.width
   if (splitPoint.x < (minimumViewSize.width + (sliderSize.width/2)))
      splitPoint.x = minimumViewSize.width + (sliderSize.width/2);

   // adjusts detail's view width to a minimum of minimumViewSize.width
   limit = (frameSize.width < frameSize.height) ? frameSize.width : frameSize.height;
   if (splitPoint.x > (limit - minimumViewSize.width - (sliderSize.width/2)))
      splitPoint.x = limit - minimumViewSize.width - (sliderSize.width/2);

   // adjusts master view
   aView = [[controllers objectAtIndex:0] view];
   if (aView.superview != self.view)
      [self.view addSubview:aView];
   frameX      = 0;
   frameY      = 0;
   frameWidth  = splitPoint.x-adjustmentForSlider;
   frameHeight = frameSize.height;
   aView.frame = CGRectMake(frameX, frameY, frameWidth, frameHeight);
   if (hideSlider == YES)
      aView.layer.cornerRadius = 5;
   else
      aView.layer.cornerRadius = 0;
   aView.clipsToBounds      = YES;
   aView.autoresizingMask   = UIViewAutoresizingFlexibleRightMargin |
                              UIViewAutoresizingFlexibleHeight;

   // adjusts detail view
   aView = [[controllers objectAtIndex:1] view];
   if (aView.superview != self.view)
      [self.view addSubview:aView];
   if (!(adjustmentForSlider))
      adjustmentForSlider = 1;
   frameX      = splitPoint.x + adjustmentForSlider;
   frameY      = 0;
   frameWidth  = frameSize.width - splitPoint.x - adjustmentForSlider;
   frameHeight = frameSize.height;
   aView.frame = CGRectMake(frameX, frameY, frameWidth, frameHeight);
   if (hideSlider == YES)
      aView.layer.cornerRadius = 5;
   else
      aView.layer.cornerRadius = 0;
   aView.clipsToBounds      = YES;
   aView.autoresizingMask   = UIViewAutoresizingFlexibleHeight |
                              UIViewAutoresizingFlexibleWidth;

   // removes slider if it is hidden
   if (hideSlider == YES)
   {
      if ((hideSlider))
      {
         [sliderView removeFromSuperview];
         [sliderView release];
         sliderView = nil;
      };
      [pool release];
      return;
   };

   // arranges slider
   frameX      = splitPoint.x - adjustmentForSlider;
   frameY      = 0;
   frameWidth  = sliderSize.width;
   frameHeight = frameSize.height;
   aFrame = CGRectMake(frameX, frameY, frameWidth, frameHeight);
   if (!(sliderView))
   {
      sliderView = [[self sliderViewWithFrame:aFrame] retain];
      [self.view addSubview:sliderView];
   };
   sliderView.frame = aFrame;

   [pool release];

   return;
}


#pragma mark - Responding to Touch Events

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


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	spliderIsMoving = NO;
   return;
}


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
      [self arrangeViews];
   };
   return;
}

@end
