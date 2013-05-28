/*
 *  Bindle Binaries Objective-C Kit
 *  Copyright (c) 2013 Bindle Binaries
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
#import "BKLoggerController.h"
#import "BKLogger.h"

@interface BKLoggerController ()
@end


@implementation BKLoggerController

// log state
@synthesize log = _log;

// app information
@synthesize appBuild      = _appBuild;
@synthesize appExecutable = _appExecutable;
@synthesize appName       = _appName;
@synthesize appVersion    = _appVersion;


#pragma mark - Object Management Methods

- (void) dealloc
{
   // log state
   self.log = nil;

   return;
}


- (void) didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
   return;
}


- (id) initWithLogger:(BKLogger *)log
{
   if ((self = [super init]) == nil)
      return(self);

   // log state
   self.log = log;

   // app information
   _appName       = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
   _appVersion    = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
   _appBuild      = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
   _appExecutable = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];

   return(self);
}


#pragma mark - log state

- (void) setLog:(BKLogger *)log
{
   _log = log;
   [self receiveReloadButton:nil];
   return;
}


#pragma mark - View Lifecycle

- (void) loadView
{
   _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
   _textView.autoresizesSubviews  = YES;
   _textView.editable             = NO;
   //_textView.font                 = [UIFont fontWithName:@"Monaco" size:_logView.font.pointSize];
   _textView.autoresizingMask     = UIViewAutoresizingFlexibleHeight |
                                    UIViewAutoresizingFlexibleWidth;
   self.view = _textView;

   return;
}


- (void) viewDidLoad
{
   UIBarButtonItem * barButton;
   UIBarButtonItem * fixSpaceButton;
   UIBarButtonItem * flexSpaceButton;
   NSMutableArray  * barButtons;

   [super viewDidLoad];

   // dismiss button
   barButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(receiveDoneButton:)];
   self.navigationItem.leftBarButtonItem = barButton;

   // creates toolbar
   barButtons           = [[NSMutableArray alloc] initWithCapacity:3];
   flexSpaceButton      = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
   fixSpaceButton       = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace    target:nil action:NULL];
   fixSpaceButton.width = 20;
   [barButtons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(receiveReloadButton:)]];
   [barButtons addObject:flexSpaceButton];
   [barButtons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(receiveSendButton:)]];
   [barButtons addObject:flexSpaceButton];
   [barButtons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(receiveClearButton:)]];
   [barButtons addObject:flexSpaceButton];
   [barButtons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(receiveTopButton:)]];
   [barButtons addObject:fixSpaceButton];
   [barButtons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(receiveBottomButton:)]];
   self.toolbarItems = barButtons;

   return;
}


- (void) viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   [self.navigationController setToolbarHidden:NO];
   return;
}


- (void) viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
   [self receiveReloadButton:nil];
   return;
}


#pragma mark - UIBarButtonItem targets

- (void) receiveDoneButton:(UIBarButtonItem *)barButton
{
   [self dismissViewControllerAnimated:YES completion:NULL];
   return;
}


- (void) receiveReloadButton:(UIBarButtonItem *)barButton
{
   NSData     * data;
   NSUInteger   length;

   if (!(self.isViewLoaded))
      return;

   data = _log.history;
   length  = (data.length < 1024) ? data.length : 1024;
   if ((_logData))
      if (data.length == _logData.length)
         if (!(strncmp(data.bytes, _logData.bytes, length)))
            return;

   _logDate = _log.dateString;
   _logData = data;
   _textView.text = [[NSString alloc] initWithData:_logData encoding:NSUTF8StringEncoding];
   [self receiveBottomButton:nil];

   return;
}


- (void) receiveSendButton:(UIBarButtonItem *)barButton
{
   MFMailComposeViewController * composer;
   NSString                    * fileName;
   NSString                    * subject;
   NSString                    * body;

   // creates filename & subject
   fileName = [NSString stringWithFormat:@"%@.log", _appExecutable];
   subject  = [NSString stringWithFormat:@"%@ Debug Log (%@)", _appName, _logDate];
   body     = [NSString stringWithFormat:@"App Name: %@<br/>App Version: %@<br/>App Build: %@<br/>App Executable: %@<br/>", _appName, _appVersion, _appBuild, _appExecutable];

   // creates composer
   composer = [[MFMailComposeViewController alloc] init];
   [composer setMailComposeDelegate:self];
   [composer setSubject:subject];
   [composer setMessageBody:body isHTML:YES];
   [composer addAttachmentData:_logData mimeType:@"text/plain" fileName:fileName];

   // displays composer
   [self presentModalViewController:composer animated:YES];

   return;
}


- (void) receiveClearButton:(UIBarButtonItem *)barButton
{
   [_log resetHistory];
   [self receiveReloadButton:nil];
   return;
}


- (void) receiveTopButton:(UIBarButtonItem *)barButton
{
   CGPoint bottomOffset;
   bottomOffset = CGPointMake(_textView.contentOffset.x, 0);
   [_textView setContentOffset:bottomOffset animated:NO];
   return;
}


- (void) receiveBottomButton:(UIBarButtonItem *)barButton
{
   CGPoint bottomOffset;
   if (_textView.contentSize.height > _textView.bounds.size.height)
   {
      bottomOffset = CGPointMake(_textView.contentOffset.x, _textView.contentSize.height - _textView.bounds.size.height);
      [_textView setContentOffset:bottomOffset animated:NO];
   };
   return;
}


#pragma mark - MFMailComposeViewController delegate

- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
   [controller dismissViewControllerAnimated:YES completion:NULL];
   return;
}



@end
