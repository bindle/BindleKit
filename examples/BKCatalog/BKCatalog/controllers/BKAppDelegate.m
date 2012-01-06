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
 *  BKAppDelegate.h - App delegate for BKCatalog
 */
#import "BKAppDelegate.h"


@implementation BKAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   UIViewController <UISplitViewControllerDelegate> * masterController;
   UIViewController       * detailController;
   UINavigationController * masterNavigation;
   UINavigationController * detailNavigation;
   UISplitViewController  * splitViewController;
   NSArray                * controllers;

   // creating master view controller
   masterController = [[BKCatalogMenu alloc] initWithStyle:UITableViewStylePlain];
   masterController.title = @"BKCatalog";

   // creating navigation controller
   masterNavigation = [[UINavigationController alloc] initWithRootViewController:masterController];
   masterNavigation.navigationBar.barStyle = UIBarStyleDefault;
   [masterController release];

   // if using iPhone, make visible and exit
   if ([BKDevice userInterfaceIdiom] == BKUserInterfaceIdiomPhone)
   {
      rootController = masterNavigation;
      [self.window addSubview:masterNavigation.view];
      [self.window makeKeyAndVisible];
      return(YES);
   };

   // creating detail view controller
   detailController = [[BKButtonOptions alloc] init];
   detailController.title = @"Selected Value";

   // creating navigation controller
   detailNavigation = [[UINavigationController alloc] initWithRootViewController:detailController];
   detailNavigation.navigationBar.barStyle = UIBarStyleDefault;
   [detailController release];

   // creating split view controller
   splitViewController = [[UISplitViewController alloc] init];
   splitViewController.delegate = masterController;
#ifdef BINDLEKIT_REPLACES_UISPLITVIEWCONTROLLER
   splitViewController.userInteractionEnabled = YES;
   splitViewController.dividerSize            = CGSizeMake(20, 20);
   splitViewController.minimumViewSize        = CGSizeMake(120, 120);
   splitViewController.masterAlwaysDisplayed  = NO;
#endif
   rootController = splitViewController;

   // add subviews to split view controller
   controllers = [[NSArray alloc] initWithObjects:masterNavigation, detailNavigation, nil];
   splitViewController.viewControllers = controllers;
   [controllers release];
   [detailNavigation release];
   [masterNavigation release];

   // add split view controller view to window as root view
   [self.window addSubview:splitViewController.view];
   [self.window makeKeyAndVisible];

   return(YES);
}


- (void)applicationWillResignActive:(UIApplication *)application
{
   /*
    *  Sent when the application is about to move from active to inactive state.
    *  This can occur for certain types of temporary interruptions (such as an
    *  incoming phone call or SMS message) or when the user quits the
    *  application and it begins the transition to the background state. Use
    *  this method to pause ongoing tasks, disable timers, and throttle down
    *  OpenGL ES frame rates. Games should use this method to pause the game.
    */
   return;
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
   /*
    *  Use this method to release shared resources, save user data, invalidate
    *  timers, and store enough application state information to restore your
    *  application to its current state in case it is terminated later. If your
    *  application supports background execution, this method is called instead
    *  of applicationWillTerminate: when the user quits.
    */
   return;
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
   /*
    *  Called as part of the transition from the background to the inactive
    *  state; here you can undo many of the changes made on entering the
    *  background.
    */
   return;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
   /*
    *  Restart any tasks that were paused (or not yet started) while the
    *  application was inactive. If the application was previously in the
    *  background, optionally refresh the user interface.
    */
   return;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
   /*
    *  Called when the application is about to terminate.
    *  Save data if appropriate.
    *
    *  See also applicationDidEnterBackground:.
    */
   return;
}


- (void)dealloc
{
   [rootController   release];
   [_window          release];

   [super dealloc];

   return;
}

@end
