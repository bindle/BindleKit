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
 *  BKPromptView.m - Prompt for user text
 */
#import "BKPromptView.h"


#pragma mark - Private UIAlertView Category Declaration
@interface UIAlertView (BKPromptView)

@property (nonatomic, readonly) UITextField * textField;

- (void) addTextFieldWithValue:(NSString *)value label:(NSString *)label;

@end


# pragma mark - BKPromptView Class Implementation
@implementation BKPromptView

@synthesize delegate = promptDelegate;


- (void) dealloc
{
   [super dealloc];
   return;
}


- (id) initWithTitle:(NSString *)title message:(NSString *)message
   delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitles:(NSString *)otherButtonTitles, ...
{
   va_list    args;
   NSString * string;

   if ((self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil]) == nil)
      return(self);

   [super setDelegate:self];
   promptDelegate = delegate;

   // adds variadic arguments to otherButtonTitles
   va_start(args, otherButtonTitles);
   for(string = otherButtonTitles; string != nil; string = va_arg(args, NSString *))
      [self addButtonWithTitle:string];

   [self addTextFieldWithValue:nil label:nil];

   return(self);
}


#pragma mark - Getter methods

- (id) delegate
{
   return(promptDelegate);
}


- (void) setDelegate:(id)delegate
{
   promptDelegate = delegate;
}


- (UITextField *) textField
{
   return([super textField]);
}


#pragma mark - UIAlertView delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if (([promptDelegate respondsToSelector:@selector(promptView:clickedButtonAtIndex:)]))
      [promptDelegate promptView:self clickedButtonAtIndex:buttonIndex];
   return;
}


- (void) didPresentAlertView:(UIAlertView *)alertView
{
   if (([promptDelegate respondsToSelector:@selector(didPresentPromptView:)]))
      [promptDelegate didPresentPromptView:self];
   return;
}


- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
   if (([promptDelegate respondsToSelector:@selector(promptView:didDismissWithButtonIndex:)]))
      [promptDelegate promptView:self didDismissWithButtonIndex:buttonIndex];
   return;
}


- (void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
   if (([promptDelegate respondsToSelector:@selector(promptView:willDismissWithButtonIndex:)]))
      [promptDelegate promptView:self willDismissWithButtonIndex:buttonIndex];
   return;
}


- (void) alertViewCancel:(UIAlertView *)alertView
{
   if (([promptDelegate respondsToSelector:@selector(promptViewCancel:)]))
      [promptDelegate promptViewCancel:self];
   return;
}


- (void) willPresentAlertView:(UIAlertView *)alertView
{
   if (([promptDelegate respondsToSelector:@selector(promptViewCancel:)]))
      [promptDelegate promptViewCancel:self];
   return;
}


@end
