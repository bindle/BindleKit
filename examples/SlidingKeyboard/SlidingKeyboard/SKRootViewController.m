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
 *  SKRootViewController.m - root view controller
 */

#import "SKRootViewController.h"

@implementation SKRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
   UILabel * label;
   UIView * aView;
   UIView * accView;

   aView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   aView.backgroundColor = [UIColor lightGrayColor];

   label = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 220, 40)];
   label.text = @"Test";
   [aView addSubview:label];

   accView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
   accView.backgroundColor = [UIColor clearColor];

   textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 150, 220, 40)];
   textField.borderStyle                = UITextBorderStyleRoundedRect;
   textField.adjustsFontSizeToFitWidth  = YES;
   textField.autoresizesSubviews        = YES;
   textField.textColor                  = [UIColor blueColor];
   textField.textAlignment              = UITextAlignmentRight;
   textField.returnKeyType              = UIReturnKeyDone;
   textField.autocapitalizationType     = UITextAutocapitalizationTypeNone;
   textField.autocorrectionType         = UITextAutocorrectionTypeNo;
   textField.clearButtonMode            = UITextFieldViewModeWhileEditing;
   textField.inputAccessoryView         = accView;
   textField.delegate                   = self;
   [aView addSubview:textField];
   [accView release];

   self.view = aView;

   return;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
   [super viewDidLoad];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)viewDidUnload
{
   [super viewDidUnload];
   [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
   [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf
{
   [textField resignFirstResponder];
   return(NO);
}

- (void) keyboardDidHide:(NSNotification *)note
{
   keyboardSuperView = nil;
   return;
}
- (void) keyboardDidShow:(NSNotification *)note
{
   keyboardSuperView  = textField.inputAccessoryView.superview;
   keyboardSuperFrame = textField.inputAccessoryView.superview.frame;
   return;
}


#pragma mark - Responding to Touch Events


// stops tracking touches to divider
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   if ((keyboardSuperView))
      if (keyboardSuperFrame.origin.y != keyboardSuperView.frame.origin.y)
         [textField resignFirstResponder];
   return;
}


// updates divider view position based upon movement of touches
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   UITouch  * touch;
   CGPoint    point;
   CGFloat    updateY;

   if ((touch = [touches anyObject]))
   {
      point   = [touch locationInView:self.view];
      if ((keyboardSuperView))
      {
         updateY = keyboardSuperView.frame.origin.y;
         if (point.y < keyboardSuperFrame.origin.y)
            return;
         if ((point.y > updateY) || (point.y < updateY))
            updateY = point.y;
         if (keyboardSuperView.frame.origin.y != updateY)
            keyboardSuperView.frame = CGRectMake(keyboardSuperFrame.origin.x, point.y, keyboardSuperFrame.size.width, keyboardSuperFrame.size.height);
      };
   };
   return;
}


@end
