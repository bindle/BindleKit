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
 *  Generates CGImages to be used as images for UIButtons.
 *
 *  BKButtonImages generates two images based upon input color components. One
 *  image is intended to appear for the UIControlStateNormal state of an
 *  UIButton. The other image is intended to appear for the
 *  UIControlStateHighlighted state of an UIButton.
 */

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif
#if (!(TARGET_OS_IPHONE))
#import <AppKit/AppKit.h>
#endif


enum {
   BKButtonImageStateNormal        = 1,
   BKButtonImageStateHighlighted   = 2
};
typedef NSUInteger BKButtonImageState;


@interface BKButtonImages : NSObject
{
   CGSize            size;
   CGContextRef      context;
   CGFloat           red;
   CGFloat           green;
   CGFloat           blue;
   CGFloat           alpha;
   CGFloat           stokeRed;
   CGFloat           strokeGreen;
   CGFloat           strokeBlue;
   CGFloat           strokeAlpha;

   CGColorSpaceRef   color;
   CGImageRef        normalCGImage;
   CGImageRef        pushedCGImage;
   id                normalImage;
   id                pushedImage;
}

@property (assign, readonly) CGFloat fillRedChannel;
@property (assign, readonly) CGFloat fillGreenChannel;
@property (assign, readonly) CGFloat fillBlueChannel;
@property (assign, readonly) CGFloat fillAlphaChannel;
@property (assign, readonly) CGFloat strokeRedChannel;
@property (assign, readonly) CGFloat strokeGreenChannel;
@property (assign, readonly) CGFloat strokeBlueChannel;
@property (assign, readonly) CGFloat strokeAlphaChannel;

/// @name Creating and Initializing a Button Images
- (id) init;
+ (id) imagesWithRed:(CGFloat)redChannel
       green:(CGFloat)greenChannel
       blue:(CGFloat)blueChannel
       alpha:(CGFloat)alphaChannel;
+ (id) imagesWithRGB:(NSInteger)rgbColor;
+ (id) imagesWithRGB:(NSInteger)rgbColor
       alpha:(CGFloat)alphaChannel;
- (id) initWithRed:(CGFloat)redChannel
       green:(CGFloat)greenChannel
       blue:(CGFloat)blueChannel
       alpha:(CGFloat)alphaChannel;
- (id) initWithRGB:(NSInteger)rgbColor;
- (id) initWithRGB:(NSInteger)rgbColor
       alpha:(CGFloat)alphaChannel;

/// @name Managing Image Colors
- (void) fillWithRed:(CGFloat)redChannel
         green:(CGFloat)greenChannel
         blue:(CGFloat)blueChannel
         alpha:(CGFloat)alphaChannel;
- (void) strokeWithRed:(CGFloat)redChannel
         green:(CGFloat)greenChannel
         blue:(CGFloat)blueChannel
         alpha:(CGFloat)alphaChannel;

/// @name Creates images for export
- (CGImageRef) createCGImageForState:(BKButtonImageState)state;
#if TARGET_OS_IPHONE
- (UIImage *) createUIImageForState:(BKButtonImageState)state;
#endif
#if (!(TARGET_OS_IPHONE))
- (NSImage *) createNSImageForState:(BKButtonImageState)state;
#endif

@end
