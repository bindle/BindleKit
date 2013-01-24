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

#import <QuartzCore/QuartzCore.h>

@implementation BKActivityDisplayController

// internal information
@synthesize visible;


#pragma mark - Object Management Methods

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
   self.backgroundColor     = [UIColor clearColor];
   self.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin |
                              UIViewAutoresizingFlexibleRightMargin |
                              UIViewAutoresizingFlexibleBottomMargin |
                              UIViewAutoresizingFlexibleTopMargin;

   // creates background view
   bezel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 106, 106)];
   bezel.backgroundColor     = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
   bezel.autoresizingMask    =   UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleRightMargin |
                                 UIViewAutoresizingFlexibleBottomMargin |
                                 UIViewAutoresizingFlexibleTopMargin;
   bezel.layer.cornerRadius  = 9;
   bezel.clipsToBounds       = YES;
   bezel.layer.borderColor   = [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.80] CGColor];
   bezel.layer.borderWidth   = 1.0;
   [self addSubview:bezel];

   // creates activity label
   textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 100)];
   textLabel.adjustsFontSizeToFitWidth = YES;
   textLabel.textColor           = [UIColor whiteColor];
   textLabel.textAlignment       = UITextAlignmentCenter;
   textLabel.minimumFontSize     = 10;
   textLabel.font                = [textLabel.font fontWithSize:20];
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


- (NSString *) text
{
   return(textLabel.text);
}


- (void) setText:(NSString *)string
{
   // changes saved title
   if ( ((string)) && ((textLabel.text)) )
      if (([string isEqualToString:textLabel.text]))
         return;
   textLabel.text = string;

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

   // adjusts size/position of background
   size.width   = (activityIndicator.frame.size.width * 4.0);
   size.height  = size.width;
   bezel.frame  = CGRectMake(0, 0, size.width, size.height);
   bezel.center = center;

   // adjusts position of textLabel within self
   if (([textLabel.text length]))
   {
      size.width       = bezel.frame.size.width - 12;
      size.height      = activityIndicator.frame.size.height;
      textLabel.frame  = CGRectMake(0, 0, size.width, size.height);
      offset           = (activityIndicator.frame.size.height / 2) + 2;
      textLabel.center = CGPointMake(center.x, center.y + offset);
   };

   // adjusts position of activityIndicator within self
   offset = 0;
   if (([textLabel.text length]))
      offset = (textLabel.frame.size.height / 2) + 2;
   activityIndicator.center = CGPointMake(center.x, center.y - offset);

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
