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
 *  BKSplitViewController.h - Custom Replacement for UISplitViewController
 */


#import <UIKit/UIKit.h>


# pragma mark - Optionally overrides UISplitViewController
#if BINDLEKIT_REPLACES_UISPLITVIEWCONTROLLER
#ifdef UISplitViewController
#undef UISplitViewController
#endif
#ifdef UISplitViewControllerDelegate
#undef UISplitViewControllerDelegate
#endif
#define UISplitViewController BKSplitViewController
#define UISplitViewControllerDelegate BKSplitViewControllerDelegate
#endif


@class BKSplitViewController;


# pragma mark - BKSplitViewControllerDelegate Protocol Declaration
@protocol BKSplitViewControllerDelegate <NSObject>

- (void) splitViewController:(BKSplitViewController *)svc
         popoverController:(UIPopoverController *)pc
         willPresentViewController:(UIViewController *)aViewController;

- (void) splitViewController:(BKSplitViewController *)svc
         willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem
         forPopoverController:(UIPopoverController *)pc;

- (void) splitViewController:(BKSplitViewController *)svc
         willShowViewController:(UIViewController *)aViewController
         invalidatingBarButtonItem:(UIBarButtonItem *)button;

@end


# pragma mark - BKSplitViewController Class Declaration
@interface BKSplitViewController : UIViewController
{
   // Members common with UISplitViewController
   id <BKSplitViewControllerDelegate> delegate;  // notify of view events
   NSArray * controllers;                        // list of view controllers

   // Members specific to BKSplitViewController
   CGSize    minimumViewSize;                    // minimum width/height each view
   CGPoint   splitPoint;                         // the point which seperates the two views
   CGSize    sliderSize;                         // the minimum size of the slider bar
   BOOL      reverseViewOrder;                   // reverse order that the views are displayed
   BOOL      enableTouchToResize;                // allow views to be resized by sliding
   BOOL      displayBothViews;                   // always display both views (do not hide on in portait mode)
   BOOL      enableAnimations;                   // animate changes when updated by properties
   BOOL      hideSlider;                         // hide slider bar (visual option only, does not affect funcitonality)

   // Members internal to BKSplitViewController
   UIBarButtonItem     * barButton;              // the UIBarButtonItem passed to the delegate
   UIPopoverController * popoverController;      // the UIPopoverController used to display the master view when hidden
   UIView              * sliderView;             // the view used to draw a slider bar
   BOOL                  spliderIsMoving;        // indicates that a user is actively touching the slider bar
   BOOL                  isMasterViewDisplayed;  // used to prevent duplicate messages to the delegate
}

// Properties common with UISplitViewController
@property(nonatomic, assign) id <BKSplitViewControllerDelegate> delegate;
@property(nonatomic, copy)   NSArray * viewControllers;

// Properties specific to BKSplitViewController
@property(nonatomic, assign) CGSize    minimumViewSize;
@property(nonatomic, assign) CGPoint   splitPoint;
@property(nonatomic, assign) CGSize    sliderSize;
@property(nonatomic, assign) BOOL      reverseViewOrder;
@property(nonatomic, assign) BOOL      enableTouchToResize;
@property(nonatomic, assign) BOOL      displayBothViews;
@property(nonatomic, assign) BOOL      enableAnimations;
@property(nonatomic, assign) BOOL      hideSlider;

@end


#pragma mark - Public UIViewController Category Declaration
@interface UIViewController (BKSplitViewController)

@property (nonatomic,readonly,retain) UIViewController * splitViewController; // If the view controller has a split view controller as its ancestor, return it. Returns nil otherwise.

@end
