/*
 *  Bindle Binaries Objective-C Kit
 *  Copyright (c) 2012, Bindle Binaries
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
 *  BKActivityDisplayController.m - Control display of activity monitor
 */
#import "BKActivityDisplayController.h"


@implementation BKActivityDisplayController

// internal information
@synthesize visible;

// user parameters
@synthesize text;


#pragma mark - Object Management Methods

- (void) dealloc
{
   // user parameters
   [text              release];

   // internal views
   [textLabel         release];
   [activityIndicator release];

   [super dealloc];

   return;
}


- (id) init
{
   NSAssert(false, @"use -(id)initWithContentsController:");
   return(nil);
}


- (id) initWithContentsController:(UIViewController *)controller
{
   CGRect aFrame;

   // creates  root view
   aFrame = CGRectMake(0, 0, 320, 320);
   if ((self = [super initWithFrame:aFrame]) == nil)
      return(self);
   self.autoresizesSubviews = YES;
   self.backgroundColor     = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
   self.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin |
                              UIViewAutoresizingFlexibleRightMargin |
                              UIViewAutoresizingFlexibleBottomMargin |
                              UIViewAutoresizingFlexibleTopMargin;

   // creates activity label
   textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 100)];
   textLabel.adjustsFontSizeToFitWidth = YES;
   textLabel.text                = @"Searching...";
   textLabel.textColor           = [UIColor whiteColor];
   textLabel.textAlignment       = UITextAlignmentCenter;
   textLabel.minimumFontSize     = 20;
   textLabel.font                = [textLabel.font fontWithSize:25];
   textLabel.backgroundColor     = [UIColor clearColor];
   textLabel.autoresizingMask    =  UIViewAutoresizingFlexibleLeftMargin |
                                    UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleBottomMargin |
                                    UIViewAutoresizingFlexibleTopMargin;
   [self addSubview:textLabel];

   // creates activity indicator
   activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
   activityIndicator.autoresizingMask   = UIViewAutoresizingFlexibleLeftMargin |
                                          UIViewAutoresizingFlexibleRightMargin |
                                          UIViewAutoresizingFlexibleBottomMargin |
                                          UIViewAutoresizingFlexibleTopMargin;
   [self addSubview:activityIndicator];

   // saves content controller
   contentsController = controller;
   visible            = NO;

   return(self);
}


- (id) initWithFrame:(CGRect)frame
{
   NSAssert(false, @"use -(id)initWithContentsController:");
   return(nil);
}


#pragma mark - Setter/Getter methods

- (UIFont *) font
{
   return(textLabel.font);
}


- (void) setFont:(UIFont *)font
{
   NSAssert(font != nil, @"must provide valid font");
   textLabel.font = font;
   return;
}


- (void) setTex:(NSString *)string
{
   // changes saved title
   [string retain];
   [text release];
   text = string;

   // adjusts view elements
   if ((self.superview))
      [self adjustPositionsToView:self.superview];

   return;
}


#pragma mark - Observing View-Related Changes

- (void) willMoveToSuperview:(UIView *)newSuperview
{
   if (!(newSuperview))
      return;
   [self adjustPositionsToView:newSuperview];
   return;
}


#pragma mark - control activity display

- (void) adjustPositionsToView:(UIView *)view
{
   CGPoint center;
   CGFloat offset;
   CGSize  size;

   if (!(view))
      return;

   // adjusts position of self within view
   self.frame  = view.frame;
   center      = view.center;

   // adjusts size of textlabel
   size            = view.frame.size;
   size.width      = size.width - activityIndicator.frame.size.width - 20;
   size.height     = textLabel.frame.size.height;
   size.width      = [text sizeWithFont:self.font constrainedToSize:size].width;
   textLabel.frame = CGRectMake(0, 0, size.width, size.height);

   // adjusts position of textLabel within self
   offset           = (activityIndicator.frame.size.width / 2) + 2;
   textLabel.center = CGPointMake(center.x + offset, center.y);

   // adjusts position of activityIndicator within self
   offset                   = (textLabel.frame.size.width / 2) + 2;
   activityIndicator.center = CGPointMake(center.x - offset, center.y);

   return;
}


- (void) dismiss
{
   [activityIndicator stopAnimating];
   [self removeFromSuperview];
   visible = NO;
   return;
}


- (void) show
{
   [contentsController.view addSubview:self];
   [contentsController.view bringSubviewToFront:self];
   [activityIndicator startAnimating];
   visible = YES;
   return;
}

@end
