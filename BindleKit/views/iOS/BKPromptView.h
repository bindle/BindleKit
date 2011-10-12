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
 *  BKPromptView.h - Prompt for user text
 */

#import <UIKit/UIKit.h>


@class BKPromptView;


# pragma mark - BKPromptViewDelegate Protocol Declaration
@protocol BKPromptViewDelegate <NSObject>

/// @name Responding to Actions
- (void) promptView:(BKPromptView *)promptView clickedButtonAtIndex:(NSInteger)buttonIndex;

/// @name Customizing Behavior
- (void) willPresentPromptView:(BKPromptView *)promptView;
- (void) didPresentPromptView:(BKPromptView *)promptView;
- (void) promptView:(BKPromptView *)promptView willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void) promptView:(BKPromptView *)promptView didDismissWithButtonIndex:(NSInteger)buttonIndex;

/// @name Canceling
- (void) promptViewCancel:(BKPromptView *)promptView;

@end


# pragma mark - BKPromptView Class Declaration
@interface BKPromptView : UIAlertView
{
   id promptDelegate;
}

/// @name Configuring the text field
@property (nonatomic, readonly) UITextField * textField;

/// @name Creating Alert Views
- (id) initWithTitle:(NSString *)title message:(NSString *)message
   delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitles:(NSString *)otherButtonTitles, ...
   NS_REQUIRES_NIL_TERMINATION;

@end

