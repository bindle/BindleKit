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
/**
 *  Creates a custom UIButton with images from BKButtonImages.
 *
 *  BKButton is a convenience class for creating UIButtons which have colored
 *  graphics depicting the button's states.
 */


#import <UIKit/UIKit.h>


enum
{
   BKButtonColorBlack           = 0x000000,
   BKButtonColorBlue            = 0x000070,
   BKButtonColorBrown           = 0x825533,
   BKButtonColorCyan            = 0x00FFFF,
   BKButtonColorDarkGray        = 0x3D4347,
   BKButtonColorGreen           = 0x006600,
   BKButtonColorGray            = 0x5D6367,
   BKButtonColorLightGray       = 0x7D8387,
   BKButtonColorMagenta         = 0xFF00FF,
   BKButtonColorOrange          = 0xFF6600,
   BKButtonColorPurple          = 0x800080,
   BKButtonColorRed             = 0xAA0000,
   BKButtonColorWhite           = 0xE0E0E0,
   BKButtonColorYellow          = 0xEECC33
};
typedef NSUInteger BKButtonColor;


@interface BKButton : UIButton

/// @name Creating a Button
+ (UIButton *) buttonWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
   alpha:(CGFloat)alpha;
+ (UIButton *) buttonWithRGB:(NSInteger)rgb;
+ (UIButton *) buttonWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha;

/// @name Creating a Button with standard colors
+ (UIButton *) blackButton;
+ (UIButton *) blueButton;
+ (UIButton *) brownButton;
+ (UIButton *) cyanButton;
+ (UIButton *) darkGrayButton;
+ (UIButton *) grayButton;
+ (UIButton *) greenButton;
+ (UIButton *) lightGrayButton;
+ (UIButton *) magentaButton;
+ (UIButton *) orangeButton;
+ (UIButton *) purpleButton;
+ (UIButton *) redButton;
+ (UIButton *) whiteButton;
+ (UIButton *) yellowButton;

/// @name Creating a Button with standard colors and alpha channels
+ (UIButton *) blackButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) blueButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) brownButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) cyanButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) darkGrayButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) grayButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) greenButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) lightGrayButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) magentaButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) orangeButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) purpleButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) redButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) whiteButtonWithAlpha:(CGFloat)alpha;
+ (UIButton *) yellowButtonWithAlpha:(CGFloat)alpha;

@end
