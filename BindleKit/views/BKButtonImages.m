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
 *  BKButtonImages.h - Creates button images
 */
#import "BKButtonImages.h"

#define BKButtonImagesSelectSize   4.0
#define BKButtonImagesBorderSize   1.5
#define BKButtonImagesCornerRadius 7.0


@interface BKButtonImages ()
- (CGContextRef) createContext;
- (CGImageRef) drawNormalImage;
- (CGImageRef) drawPushedImage;
@end

@implementation BKButtonImages

- (void) dealloc
{
   if ((normalCGImage))
      CGImageRelease(normalCGImage);
   if ((pushedCGImage))
      CGImageRelease(pushedCGImage);

   CGColorSpaceRelease(color);

   [super dealloc];

   return;
}


- (id) init
{
   if ((self = [self initWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]) == nil)
      return(self);
   return(self);
}


+ (id) imagesWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
   return([[[BKButtonImages alloc] initWithRed:red green:green blue:blue alpha:alpha] autorelease]);
}


- (id) initWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue
   alpha:(CGFloat)anAlpha
{
   if ((self = [super init]) == nil)
      return(self);

   red   = aRed;
   green = aGreen;
   blue  = aBlue;
   alpha = anAlpha;

   borderRed   = 0.0;
   borderGreen = 0.0;
   borderBlue  = 0.0;
   borderAlpha = alpha;

   size  = CGSizeMake(50, 44);

   // creates color space
   color = CGColorSpaceCreateDeviceRGB();

   return(self);
}


- (void) borderWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue
   alpha:(CGFloat)anAlpha
{
   if ((normalCGImage))
      CGImageRelease(normalCGImage);
   pushedCGImage = nil;
   if ((pushedCGImage))
      CGImageRelease(pushedCGImage);
   pushedCGImage = nil;

   borderRed   = aRed;
   borderGreen = aGreen;
   borderBlue  = aBlue;
   borderAlpha = anAlpha;

   return;
}


- (void) fillWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue
   alpha:(CGFloat)anAlpha
{
   if ((normalCGImage))
      CGImageRelease(normalCGImage);
   pushedCGImage = nil;
   if ((pushedCGImage))
      CGImageRelease(pushedCGImage);
   pushedCGImage = nil;

   red   = aRed;
   green = aGreen;
   blue  = aBlue;
   alpha = anAlpha;

   return;
}


#pragma mark - Draws images

- (CGContextRef) createContext
{
   CGFloat         minx;
   CGFloat         midx;
   CGFloat         maxx;
	CGFloat         miny;
   CGFloat         midy;
   CGFloat         maxy;

   // create initial drawing context
   context = CGBitmapContextCreate
   (
      NULL,                           // pointer where drawing is rendered
      size.width,                     // The width, in pixels, of the bitmap
      size.height,                    // The height, in pixels, of the bitmap
      8,                              // bits to use for each component of a pixel
      (size.width * 4),               // bytes of memory to use per row of the bitmap
      color,                          // The color space to use for the bitmap context
      kCGImageAlphaPremultipliedLast  // Specify whether the bitmap contains alpha
   );
   if (!(context))
      return(nil);

   // sets colors
   CGContextSetRGBStrokeColor(context, 0.0,   0.0,  0.0, alpha);
   CGContextSetRGBFillColor(context,   red, green, blue, alpha);

   // calculates points around button
   minx    = 2;
   midx    = (size.width/2);
   maxx    = size.width-2;
	miny    = 2;
   midy    = (size.height/2);
   maxy    = size.height-2;

   // draws path for border
   CGContextMoveToPoint(context,   minx, midy);
   CGContextAddArcToPoint(context, minx, miny, midx, miny, BKButtonImagesCornerRadius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, BKButtonImagesCornerRadius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, BKButtonImagesCornerRadius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, BKButtonImagesCornerRadius);
	CGContextClosePath(context);
   CGContextSaveGState(context);

   // draws border around button
   CGContextSetLineWidth(context, BKButtonImagesBorderSize);
   CGContextDrawPath(context, kCGPathStroke);

   // draws path for gradient
   CGContextMoveToPoint(context,   minx, midy);
   CGContextAddArcToPoint(context, minx, miny, midx, miny, BKButtonImagesCornerRadius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, BKButtonImagesCornerRadius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, BKButtonImagesCornerRadius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, BKButtonImagesCornerRadius);
	CGContextClosePath(context);
   CGContextSaveGState(context);
   CGContextClip(context);

   return(context);
}


- (CGImageRef) drawNormalImage
{
   CGFloat         components[8];
   CGGradientRef   gradient;
   CGFloat         gradientRadius;
   CGFloat         gradientStartRadius;
   CGFloat         gradientEndRadius;
   CGPoint         gradientStart;
   CGPoint         gradientEnd;

   // create initial context
   if ((context = [self createContext]) == nil)
      return(nil);

   // calculates first color of gradient
   components[0] = ((red   + 0.3516) > 1.0) ? 1.0 : (red   + 0.3516);
   components[1] = ((green + 0.3516) > 1.0) ? 1.0 : (green + 0.3516);
   components[2] = ((blue  + 0.3516) > 1.0) ? 1.0 : (blue  + 0.3516);
   components[3] = alpha;

   // calculates second color of gradient
   components[4] = red;
   components[5] = green;
   components[6] = blue;
   components[7] = alpha;

   // creates gradient
   gradient = CGGradientCreateWithColorComponents(color, components, NULL, 2);

   // calculates gradient path
   gradientRadius       = (size.width * 1.5);
   gradientStartRadius  = (gradientRadius - (size.height * 0.5));
   gradientEndRadius    = gradientRadius;
   gradientStart        = CGPointMake((size.width/2), ((size.height/2)+gradientRadius));
   gradientEnd          = CGPointMake((size.width/2), ((size.height/2)+gradientRadius));

   // draws gradient
   CGContextDrawRadialGradient
   (
      context,             // A Quartz graphics context
      gradient,            // A CGGradient object
      gradientStart,       // The center of the starting circle
      gradientStartRadius, // The radius of the starting circle
      gradientEnd,         // the center of the ending circle
      gradientEndRadius,   // The radius of the ending circle
      kCGGradientDrawsAfterEndLocation|kCGGradientDrawsBeforeStartLocation
   );
   CGGradientRelease(gradient);

   // converts context to image
   normalCGImage = CGBitmapContextCreateImage(context);

   // frees resources
   CGContextRelease(context);
   context = nil;

   return(normalCGImage);
}


- (CGImageRef) drawPushedImage
{
   CGFloat         components[16];
   CGGradientRef   gradient;
   CGPoint         gradientStart;
   CGPoint         gradientEnd;

   // create initial context
   if ((context = [self createContext]) == nil)
      return(nil);

   // calculates first color of gradient
   components[0]  = ((red   - 0.1875) < 0) ? 0.0 : (red   - 0.1875);
   components[1]  = ((green - 0.1875) < 0) ? 0.0 : (green - 0.1875);
   components[2]  = ((blue  - 0.1875) < 0) ? 0.0 : (blue  - 0.1875);
   components[3]  = alpha;

   // calculates second color of gradient
   components[4]  = red;
   components[5]  = green;
   components[6]  = blue;
   components[7]  = alpha;

   // calculates third color of gradient
   components[8]  = red;
   components[9]  = green;
   components[10] = blue;
   components[11] = alpha;

   // calculates fourth color of gradient
   components[12] = ((red   + 0.3516) > 1.0) ? 1.0 : (red   + 0.3516);
   components[13] = ((green + 0.3516) > 1.0) ? 1.0 : (green + 0.3516);
   components[14] = ((blue  + 0.3516) > 1.0) ? 1.0 : (blue  + 0.3516);
   components[15] = alpha;

   // creates gradient
   gradient = CGGradientCreateWithColorComponents(color, components, NULL, 4);

   // calculates gradient path
   gradientStart        = CGPointMake((size.width/2), size.height);
   gradientEnd          = CGPointMake((size.width/2), 0);

   // draws gradient
   CGContextDrawLinearGradient
   (
      context,       // A Quartz graphics context.
      gradient,      // A CGGradient object
      gradientStart, // The starting point of the gradient
      gradientEnd,   // The ending point of the gradient
      0              // Option flags
   );
   CGGradientRelease(gradient);

   // converts context to image
   pushedCGImage = CGBitmapContextCreateImage(context);

   // frees resources
   CGContextRelease(context);
   context = nil;

   return(pushedCGImage);
}


#pragma mark - Creates images for export

- (CGImageRef) createCGImageForState:(BKButtonImageState)state
{
   CGImageRef image;
   image = nil;
   @synchronized(self)
   {
      if (state == BKButtonImageStateNormal)
         if (!(image = normalCGImage))
            if (!(image = [self drawNormalImage]))
               return(nil);
      if (state == BKButtonImageStateHighlighted)
         if (!(image = pushedCGImage))
            if (!(image = [self drawPushedImage]))
               return(nil);
   };
   return(image);
}


#if TARGET_OS_IPHONE
- (UIImage *) createUIImageForState:(BKButtonImageState)state;
{
   CGImageRef   image;
   UIImage    * exportImage;
   @synchronized(self)
   {
      if (!(image = [self createCGImageForState:state]))
         return(nil);
      exportImage = [UIImage imageWithCGImage:image];
   };
   exportImage = [exportImage stretchableImageWithLeftCapWidth:(size.width/2) topCapHeight:(size.height/2)+3];
   return(exportImage);
}
#endif


#if (!(TARGET_OS_IPHONE))
- (NSImage *) createNSImageForState:(BKButtonImageState)state
{
   CGImageRef   image;
   NSImage    * exportImage;
   NSSize       imageSize;
   @synchronized(self)
   {
      imageSize = NSMakeSize(size.width, size.height);
      if (!(image = [self createCGImageForState:state]))
         return(nil);
      exportImage = [[NSImage alloc] initWithCGImage:image size:imageSize];
   };
   return([exportImage autorelease]);
}
#endif

@end
