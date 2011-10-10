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
 *  BKAppDelegate.m - App delegate for Reachability
 */
#import "BKAppDelegate.h"


@implementation BKAppDelegate


@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   NSAutoreleasePool      * pool;
   NSMutableArray         * controllers;
   BKRootViewController   * rootController;
   UITabBarItem           * tabBarItem;
   UINavigationController * navigationController;
   BKNetworkReachability  * networkReachability;
   UIAlertView            * helpAlert;
   BOOL                     logWithNSLog;

   pool = [[NSAutoreleasePool alloc] init];

   //[[UIApplication  sharedApplication] setNetworkActivityIndicatorVisible:YES];
   //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityUpdate:) name:BKNetworkReachabilityNotification object:nil];

   logWithNSLog = NO;

   controllers = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];

   // create view for "Hostname"
   networkReachability                    = [[BKNetworkReachability alloc] initWithHostName:@"www.apple.com"];
   networkReachability.logUpdates         = logWithNSLog;
   networkReachability.notificationString = @"MyHostname";
   [networkReachability autorelease];
   rootController                         = [[BKRootViewController alloc] initWithStyle:UITableViewStyleGrouped];
   rootController.networkReachability     = networkReachability;
   rootController.title                   = @"Hostname";
   [rootController startNotifier];
   [rootController autorelease];
   tabBarItem                             = [[UITabBarItem alloc] initWithTitle:@"Hostname" image:nil tag:0];
   [tabBarItem autorelease];
   navigationController                   = [[UINavigationController alloc] initWithRootViewController:rootController];
   navigationController.tabBarItem        = tabBarItem;
   [navigationController autorelease];
   [controllers addObject:navigationController];


   // create view for "Internet Connection"
   networkReachability                    = [[BKNetworkReachability alloc] initForInternetConnection];
   networkReachability.logUpdates         = logWithNSLog;
   networkReachability.notificationString = @"MyInternetConnection";
   [networkReachability autorelease];
   rootController                         = [[BKRootViewController alloc] initWithStyle:UITableViewStyleGrouped];
   rootController.networkReachability     = networkReachability;
   rootController.title                   = @"Internet Connection";
   [rootController startNotifier];
   [rootController autorelease];
   tabBarItem                             = [[UITabBarItem alloc] initWithTitle:@"Internet" image:nil tag:0];
   [tabBarItem autorelease];
   navigationController                   = [[UINavigationController alloc] initWithRootViewController:rootController];
   navigationController.tabBarItem        = tabBarItem;
   [navigationController autorelease];
   [controllers addObject:navigationController];


   // create view for "Link Local"
   networkReachability                    = [[BKNetworkReachability alloc] initForLinkLocal];
   networkReachability.logUpdates         = logWithNSLog;
   networkReachability.notificationString = @"MyLinkLocal";
   [networkReachability autorelease];
   rootController                         = [[BKRootViewController alloc] initWithStyle:UITableViewStyleGrouped];
   rootController.networkReachability     = networkReachability;
   rootController.title                   = @"Link Local";
   [rootController startNotifier];
   [rootController autorelease];
   tabBarItem                             = [[UITabBarItem alloc] initWithTitle:@"Local" image:nil tag:0];
   [tabBarItem autorelease];
   navigationController                   = [[UINavigationController alloc] initWithRootViewController:rootController];
   navigationController.tabBarItem        = tabBarItem;
   [navigationController autorelease];
   [controllers addObject:navigationController];


   // create tab bar controller
   tabBarController = [[UITabBarController alloc] init];
   tabBarController.viewControllers = controllers;

   [self.window addSubview:tabBarController.view];
   [self.window makeKeyAndVisible];

   // display help message
   helpAlert = [[UIAlertView alloc] initWithTitle:@"Usage" message:@"Tap a field to display a description of the field's data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
   [helpAlert show];
   [helpAlert release];

   [pool release];

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
   [tabBarController      release];
   [_window               release];

   [super dealloc];

   return;
}


- (void) networkReachabilityUpdate:(NSNotification *)note
{
   //if ([note object] == networkReachability)
   //   [networkReachability logNetworkReachabilityFlags];
   return;
}


@end
