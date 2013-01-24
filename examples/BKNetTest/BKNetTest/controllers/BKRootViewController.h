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
 *  BKRootViewController.h - Root view controller for Reachability
 */

#import <UIKit/UIKit.h>
#import <BindleKit/BindleKit.h>

#import "BKLogViewController.h"

@interface BKRootViewController : UITableViewController <BKPromptViewDelegate>
{
   BOOL                     useFlagNames;
   BKPromptView           * prompt;
   UIBarButtonItem        * barButtonItemLogs;
   UIBarButtonItem        * barButtonItemFlags;
   UIBarButtonItem        * barButtonItemHost;
   UIBarButtonItem        * barButtonItemFlex;
   UIBarButtonItem        * barButtonItemLegal;
   UIImage                * redImage;
   UIImage                * greenImage;
   NSMutableArray         * logs;
   UINavigationController * logsViewController;
   BKNetworkReachability  * networkReachability;
}

@property (nonatomic, readonly) UINavigationController * logsViewController;
@property (nonatomic, assign) BKNetworkReachability    * networkReachability;
@property (nonatomic, assign) NSMutableArray           * logs;

- (void) updateToolbar;
- (void) changeHostname:(UIBarButtonItem *)sender;
- (void) displayFlags:(UIBarButtonItem *)sender;
- (void) openLogs:(UIBarButtonItem *)sender;

@end
