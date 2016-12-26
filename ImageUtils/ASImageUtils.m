// Copyright (c) Airsource Ltd. 2009-2010.
// 
// Airsource hereby grants to the user a worldwide, irrevocable,
// royalty-free, non-exclusive license to use this pre-existing
// intellectual property component for their own business purposes,
// limited in extent to that which is needed for the user to exploit work
// results completed by Airsource.
//
// If you have received this component apart from work produced by
// Airsource you are not authorised to use this component in your
// software. Please contact Airsource on consulting@airsource.co.uk in
// order to discuss your intended use.
//
// Any unauthorised copying of this file constitutes an infringement
// of copyright. All rights reserved.

#import "ASImageUtils.h"

#import "AirsourceChecks.h"

// What we always wanted.
// Does not include the relevant translations, which are size-dependent.
static CGAffineTransform const transformForImageOrientation[] = {
    [UIImageOrientationUp]={1,0,0,1,0,0},
    [UIImageOrientationDown]={-1,0,0,-1,0,0},
    [UIImageOrientationLeft]={0,-1,1,0,0,0},
    [UIImageOrientationRight]={0,1,-1,0,0,0},
    [UIImageOrientationUpMirrored]={-1,0,0,1,0,0},
    [UIImageOrientationDownMirrored]={1,0,0,-1,0,0},
    [UIImageOrientationLeftMirrored]={0,1,1,0,0,0},
    [UIImageOrientationRightMirrored]={0,-1,-1,0,0,0},
};

// Image orientation is non-commutative.
// Indexed by the UIImageOrientation enum. Order is U D L R UM DM LM RM.
// Use something like orientationMultTab[first][second].
// The quick sanity check is that orientationMultTab[UM][x] = xM.
static UIImageOrientation const orientationMultTab[8][8]={
    {0,1,2,3,4,5,6,7,},
    {1,0,3,2,5,4,7,6,},
    {2,3,1,0,7,6,4,5,},
    {3,2,0,1,6,7,5,4,},
    {4,5,6,7,0,1,2,3,},
    {5,4,7,6,1,0,3,2,},
    {6,7,5,4,3,2,0,1,},
    {7,6,4,5,2,3,1,0,},
};


UIColor * rgb(int r, int g, int b)
{
	return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1];
}

UIColor * rgbA(int r, int g, int b, float a)
{
	return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

UIColor * rgbweb(int rgbval)
{
    return rgb((rgbval>>16)&0xFF,(rgbval>>8)&0xFF,(rgbval>>0)&0xFF);
}

CGFloat valueFromColor(UIColor * uicolor, int idx)
{
    CGFloat red, green, blue, alpha;
    red = green = blue = alpha = 0.0f;
    CGColorRef color = [uicolor CGColor];
    int numComponents = CGColorGetNumberOfComponents(color);
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }
    
    switch (idx) {
        case 0:
            return red;
        case 1:
            return green;
        case 2:
            return blue;
        case 3:
            return alpha;
    }
    return 0;
}

CGFloat rValueFromColor(UIColor * uicolor)
{
    return valueFromColor(uicolor, 0);
}

CGFloat gValueFromColor(UIColor * uicolor)
{
    return valueFromColor(uicolor, 1);
}

CGFloat bValueFromColor(UIColor * uicolor)
{
    return valueFromColor(uicolor, 2);
}

UIColor * AlphaColor(UIColor * uicolor, CGFloat alpha)
{
    CGFloat red = rValueFromColor(uicolor);
    CGFloat green = gValueFromColor(uicolor);
    CGFloat blue = bValueFromColor(uicolor);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@implementation UIImage(ASImageUtils)

#pragma mark orientation stuff

+(CGAffineTransform)affineTransformFromOrientation:(UIImageOrientation)orientation size:(CGSize)s
{
    CGAffineTransform t = transformForImageOrientation[orientation];
    CGRect outputRectBeforeTranslation = CGRectApplyAffineTransform((CGRect){{0,0},s}, t);
    t.tx = -outputRectBeforeTranslation.origin.x;
    t.ty = -outputRectBeforeTranslation.origin.y;
    return t;
}

+(BOOL)orientationIsLandscape:(UIImageOrientation)imageOrientation
{
    return imageOrientation == UIImageOrientationLeft
            || imageOrientation == UIImageOrientationLeftMirrored
            || imageOrientation == UIImageOrientationRight
            || imageOrientation == UIImageOrientationRightMirrored;
}

/**
** Returns a UIImage like the original image, after transforming it with the given orientation.
** Does NOT guarantee to set the output image orientation.
** Not as efficient as it ought to be (because there's no [UIImage imageWithCGImage:orientation:]).
** Tested UIImageScalingExtension_testInCtx() below, with square and non-square images.
*/
- (UIImage*) imageByTransformingWithOrientation:(UIImageOrientation)orientation
{
    if (orientation == UIImageOrientationUp)
    {
        // Retain+autorelease to prevent nasty surprises.
        return [[self retain] autorelease];
    }

#if !Airsource_iPhoneOS_Min(4_0)
    if ([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)])
#endif
    {
        // Apparently this is broken for non-unit scales on some OS versions.
        if (self.scale == 1)
        {
            UIImageOrientation combinedOrientation = orientationMultTab[self.imageOrientation][orientation];
            return [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:combinedOrientation];
        }
    }

    CGSize s = self.size;
    CGAffineTransform t = transformForImageOrientation[orientation];
    CGRect outputRectBeforeTranslation = CGRectApplyAffineTransform((CGRect){{0,0},s}, t);
    t.tx = -outputRectBeforeTranslation.origin.x;
    t.ty = -outputRectBeforeTranslation.origin.y;
#if !Airsource_iPhoneOS_Min(4_0)
    assert([NSThread isMainThread]);
#endif
    // TODO: tchan: There ought to be a nicer way to do this, but this code is neater than the switch statement.
    UIGraphicsBeginImageContext(outputRectBeforeTranslation.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(ctx, t);
    [self drawInRect:(CGRect){{0,0},s}];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

#pragma mark cropping stuff

-(UIImage*)subimageWithRect:(CGRect)r
{
    UIImageOrientation orientation = self.imageOrientation;
    if (orientation == UIImageOrientationUp)
    {
#if !Airsource_iPhoneOS_Min(4_0)
        if (![UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)])
        {
            return [UIImage imageWithCGImage:ASCFAutorelease(CGImageCreateWithImageInRect(self.CGImage, r))];
        }
#endif
        // tchan: This can be extended to support other orientations via a different transform, except it doesn't work on some OS versions?
        CGFloat scale = self.scale;
        CGAffineTransform t = CGAffineTransformMakeScale(scale,scale);
        CGImageRef cgImage = ASCFAutorelease(CGImageCreateWithImageInRect(self.CGImage, CGRectApplyAffineTransform(r, t)));
        return [UIImage imageWithCGImage:cgImage scale:scale orientation:orientation];
    }

#if !Airsource_iPhoneOS_Min(4_0)
    if (!&UIGraphicsBeginImageContextWithOptions)
    {
        UIGraphicsBeginImageContext(r.size);
    }
    else
#endif
    {
        CGFloat scale = self.scale;
        UIGraphicsBeginImageContextWithOptions(r.size, NO, scale);
    }

    [self drawInRect:(CGRect){{-r.origin.x,-r.origin.y},self.size}];

    UIImage * ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

-(UIImage*)subimageByCroppingWithInsets:(UIEdgeInsets)insets
{
    CGRect r = {{0,0},self.size};
    return [self subimageWithRect:UIEdgeInsetsInsetRect(r, insets)];
}

#pragma mark masking stuff

-(UIImage*)imageByMaskingWithMask:(UIImage*)mask
{
    UIImage * ret = nil;
    CGRect r = {{0,0},self.size};

#if !Airsource_iPhoneOS_Min(4_0)
    if (!&UIGraphicsBeginImageContextWithOptions)
    {
        assert([NSThread isMainThread]);
        UIGraphicsBeginImageContext(r.size);
    }
    else
#endif
    {
        // Use the maximum scale, so we can mask a scale 1 image with a scale 2 mask (e.g. what the home screen does).
        // Also allows us to mask a scale 2 image with a scale 1 mask, if we ever decide to do this in the future.
        // TODO: tchan: Is this right?
        UIGraphicsBeginImageContextWithOptions(r.size, NO, MAX(self.scale, mask.scale));
    }

    [self drawInRect:r];
    [mask drawInRect:r blendMode:kCGBlendModeDestinationIn alpha:1];
    ret = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return ret;
}

-(UIImage*)imageByFillingWithColor:(UIColor*)aColor
{
    UIImage *ret = nil;
    CGRect r = {{0,0},self.size};

#if !Airsource_iPhoneOS_Min(4_0)
    if (!&UIGraphicsBeginImageContextWithOptions)
    {
        assert([NSThread isMainThread]);
        UIGraphicsBeginImageContext(r.size);
    }
    else
#endif
    {
        UIGraphicsBeginImageContextWithOptions(r.size, NO, self.scale);
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [aColor CGColor]);
    CGContextFillRect(ctx, r);
    
    [self drawInRect:r blendMode:kCGBlendModeDestinationIn alpha:1];
    ret = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (self.leftCapWidth || self.topCapHeight)
    {
        ret = [ret stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    }
    
    return ret;
}


-(UIImage*)imageByDarkeningWithAlpha:(CGFloat)aAlpha
{
    UIImage *ret = nil;
    CGRect r = {{0,0},self.size};
    
#if !Airsource_iPhoneOS_Min(4_0)
    if (!&UIGraphicsBeginImageContextWithOptions)
    {
        assert([NSThread isMainThread]);
        UIGraphicsBeginImageContext(r.size);
    }
    else
#endif
    {
        UIGraphicsBeginImageContextWithOptions(r.size, NO, self.scale);
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    CGContextFillRect(ctx, r);
    
    [self drawInRect:r blendMode:kCGBlendModeSourceIn alpha:aAlpha];
    ret = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (self.leftCapWidth || self.topCapHeight)
    {
        ret = [ret stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    }
    
    return ret;
}

#pragma mark image generation

+(UIImage *)transparentPixelImage
{
    assert([NSThread isMainThread]);
    static UIImage * transparentPixelImage;
    if (!transparentPixelImage)
    {
        transparentPixelImage = [[self singlePixelImageWithColor:nil] retain];
    }
    return transparentPixelImage;
}

+(UIImage *)singlePixelImageWithColor:(UIColor *)c
{
    return [self rectImageWithColor:c size:(CGSize){1,1} scale:1];
}

+(UIImage *)rectImageWithColor:(UIColor *)c size:(CGSize)s scale:(CGFloat)scale
{
#if !Airsource_iPhoneOS_Min(4_0)
    assert([NSThread isMainThread]);
#endif
    if (CGSizeEqualToSize(s, CGSizeZero))
    {
        return nil;
    }
    CGRect r = {{0,0},s};
    if (scale == 0 && CGRectEqualToRect(r,CGRectIntegral(r)))
    {
        // If the rect is already integral (i.e. s is integreal), default to scale 1.
        scale = 1;
    }
#if !Airsource_iPhoneOS_Min(4_0)
    if (!&UIGraphicsBeginImageContextWithOptions)
    {
        assert(scale == 0 || scale == 1);
        UIGraphicsBeginImageContext(r.size);
    }
    else
#endif
    {
        CGFloat alpha = c ? CGColorGetAlpha(c.CGColor) : 0;
        BOOL opaque = (alpha == 1);
        UIGraphicsBeginImageContextWithOptions(r.size, opaque, scale);
    }
    if (c)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, c.CGColor);
        CGContextFillRect(ctx, r);
    }
	UIImage * ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return ret;
}

+(UIImage*)stretchableRoundedRectWithRadius:(CGFloat)r scale:(CGFloat)scale color:(UIColor*)color
{
    return [UIImage stretchableRoundedRectWithRadius:r scale:scale color:color borderColor:nil borderWidth:0.0f];
}

+(UIImage*)stretchableRoundedRectWithRadius:(CGFloat)r scale:(CGFloat)scale color:(UIColor*)color  borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth
{
    UIImage * ret = nil;
    CGFloat wh = ceilf(r+borderWidth)*2+1;

#if Airsource_iPhoneOS_Min(4_0)
    bool const supports_4_0 = 1;
#else
    bool const supports_4_0 = (bool)&UIGraphicsBeginImageContextWithOptions;
#endif

    CGContextRef ctx = NULL;

    if (supports_4_0)
    {
        UIGraphicsBeginImageContextWithOptions((CGSize){wh,wh}, NO, scale);
        ctx = UIGraphicsGetCurrentContext();
    }
    else
    {
        // UIGraphicsBeginImageContext() isn't thread-safe except in 4.0+
        // http://developer.apple.com/iphone/library/releasenotes/General/WhatsNewIniPhoneOS/Articles/iPhoneOS4.html#//apple_ref/doc/uid/TP40009559-SW29
        assert(scale == 0 || scale == 1);
        CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
        if (cs)
        {
            ctx = CGBitmapContextCreate(NULL, wh, wh, 8, 0, cs, kCGImageAlphaPremultipliedLast);
            CFRelease(cs);
        }
        if (!ctx)
        {
            return NULL;
        }
    }
    
    // half border width
    CGFloat hbw = borderWidth;
    
    // Start at (hopefully) one of the arc endpoints.
    CGContextMoveToPoint(ctx,  hbw,r+hbw);
    CGContextAddArcToPoint(ctx, hbw,hbw,    wh-hbw,hbw,  r);
    CGContextAddArcToPoint(ctx, wh-hbw,hbw,   wh-hbw,wh-hbw, r);
    CGContextAddArcToPoint(ctx, wh-hbw,wh-hbw,  hbw,wh-hbw,  r);
    CGContextAddArcToPoint(ctx, hbw,wh-hbw,   hbw,hbw,   r);
    CGContextClosePath(ctx);

    CGContextSetFillColorWithColor(ctx, [(color?:[UIColor blackColor]) CGColor]);
    CGPathDrawingMode mode = kCGPathFill;
    if (borderWidth > 0.0f)
    {
        CGContextSetStrokeColorWithColor(ctx, [(borderColor?:[UIColor blackColor]) CGColor]);
        CGContextSetLineWidth(ctx, borderWidth);
        mode = kCGPathFillStroke;
    }
    CGContextDrawPath(ctx, mode);

    if (supports_4_0)
    {
        ret = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        // Grab the image.
        CGImageRef im = CGBitmapContextCreateImage(ctx);
        if (im)
        {
            ret = [UIImage imageWithCGImage:im];
            CFRelease(im);
        }
        CFRelease(ctx);
    }
    
    ret = [ret stretchableImageWithLeftCapWidth:wh/2 topCapHeight:wh/2];
    return ret;
}

-(UIImage*)imageWithTitle:(NSString *)title edgeInsets:(UIEdgeInsets)edgeInsets color:(UIColor *)color
{
    CGSize aSize = self.size;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    {
        UIColor * cr = [UIColor clearColor];
        CGContextSetFillColorWithColor(context, cr.CGColor);
        CGRect frame = CGRectMake(0, 0, aSize.width, aSize.height);
        if (!UIEdgeInsetsEqualToEdgeInsets(edgeInsets, UIEdgeInsetsZero)) {
            frame.origin.x += edgeInsets.left;
            frame.origin.y += edgeInsets.top;
            frame.size.width -= (edgeInsets.left + edgeInsets.right);
            frame.size.height -= (edgeInsets.top + edgeInsets.bottom);
        }
        CGContextFillRect(context, frame);
        [self drawAtPoint:CGPointZero];
        
        cr = color;//[UIColor darkGrayColor];
        CGContextSetFillColorWithColor(context, cr.CGColor);
        frame.origin.y += aSize.height/2 - 6;
        [title drawInRect:frame withFont:[UIFont systemFontOfSize:14] lineBreakMode:0 alignment:NSTextAlignmentCenter];
    }
    UIImage * retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

-(UIImage*)imageWithTitle:(NSString *)title
{
    return [self imageWithTitle:title edgeInsets:UIEdgeInsetsZero color:[UIColor darkGrayColor]];
}

+(UIImage*)imageNamed:(NSString *)name withTitle:(NSString *)title
{
    UIImage * retImage = [UIImage imageNamed:name];
    if (!retImage)
        return nil;
    
    return [retImage imageWithTitle:title];
}

-(UIImage*)imageWithImage:(NSString *)fgName atPoint:(CGPoint)point
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    CGRect r = {{0, 0}, self.size};
    [self drawInRect:r];
    
    UIImage * fgImage = [UIImage imageNamed:fgName];
    if (fgImage)
    {
        r.origin = point;
        r.size = fgImage.size;
        [fgImage drawInRect:r];
    }
    
    UIImage * retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

+(UIImage*)imageNamed:(NSString *)bgName withImage:(NSString *)fgName atPoint:(CGPoint)point
{
    UIImage * retImage = [UIImage imageNamed:bgName];
    if (!retImage)
        return nil;
    return [retImage imageWithImage:fgName atPoint:point];
}

+(UIImage*)imageNamed:(NSString *)name ifNotExistCreateImageWithSize:(CGSize)defaultSize topColor:(UIColor *)aTopColor bottomColor:(UIColor *)aBottomColor
{
    UIImage * retImage = [UIImage imageNamed:name];
    if (retImage)
        return retImage;
    
    //NSString * missingText = name;
    //if not exist, new a empty image
    UIGraphicsBeginImageContext(defaultSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //write file name into image
    {
        CGFloat red     = rValueFromColor(aTopColor);
        CGFloat green   = gValueFromColor(aTopColor);
        CGFloat blue    = bValueFromColor(aTopColor);
        CGFloat deltaRed    = (rValueFromColor(aBottomColor) - red)  /defaultSize.height;
        CGFloat deltaGreen  = (gValueFromColor(aBottomColor) - green)/defaultSize.height;
        CGFloat deltaBlue   = (bValueFromColor(aBottomColor) - blue) /defaultSize.height;
        
        CGRect frame = CGRectMake(0, 0, defaultSize.width, 1);
        for (NSInteger i=0; i<defaultSize.height; i++) {

            UIColor * cr = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0f];
            
            CGContextSetFillColorWithColor(context, cr.CGColor);
            CGContextFillRect(context, frame);
            
            [cr release];
            
            red += deltaRed;
            green += deltaGreen;
            blue += deltaBlue;

            frame = CGRectOffset(frame, 0, 1);
        }
        
        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
        //[missingText drawAtPoint:CGPointMake(2, 2) withFont:[UIFont systemFontOfSize:10]];
        [name drawAtPoint:CGPointMake(1, 1) withFont:[UIFont systemFontOfSize:10]];
    }
    
    retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

+(UIImage*)imageNamed:(NSString *)name ifNotExistCreateImageWithSize:(CGSize)defaultSize color:(UIColor *)aColor
{
    UIImage * retImage = [UIImage imageNamed:name];
    if (retImage)
        return retImage;
    
    //NSString * missingText = name;
    //if not exist, new a empty image
    UIGraphicsBeginImageContext(defaultSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //write file name into image
    {
        UIColor * cr = aColor;
        CGContextSetFillColorWithColor(context, cr.CGColor);
        CGRect frame = CGRectMake(0, 0, defaultSize.width, defaultSize.height);
        CGContextFillRect(context, frame);
        
        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
        //[missingText drawAtPoint:CGPointMake(2, 2) withFont:[UIFont systemFontOfSize:10]];
        [name drawAtPoint:CGPointMake(1, 1) withFont:[UIFont systemFontOfSize:10]];
    }
    
    retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

+(UIImage*)imageNamed:(NSString *)name 
ifNotExistCreateImageWithSize:(CGSize)defaultSize 
          centerColor:(UIColor *)aCenterColor 
           outerColor:(UIColor *)aOuterColor
{
    UIImage * retImage = [UIImage imageNamed:name];
    if (retImage)
        return retImage;

    CGFloat aDiameter = MAX(defaultSize.width, defaultSize.height);
    aDiameter = aDiameter * 1.5;
    CGFloat aRadius = aDiameter/2;
    CGSize aSize = CGSizeMake(aDiameter, aDiameter);
    
    //if not exist, new a empty image
    UIGraphicsBeginImageContext(aSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //write file name into image
//    {
        CGFloat red     = rValueFromColor(aOuterColor);
        CGFloat green   = gValueFromColor(aOuterColor);
        CGFloat blue    = bValueFromColor(aOuterColor);
        CGFloat deltaRed    = (rValueFromColor(aCenterColor) - red)  /aRadius;
        CGFloat deltaGreen  = (gValueFromColor(aCenterColor) - green)/aRadius;
        CGFloat deltaBlue   = (bValueFromColor(aCenterColor) - blue) /aRadius;
        
        CGRect frame = CGRectMake(0, 0, aDiameter, aDiameter);
        for (NSInteger i=0; i<aRadius; i++) 
        {
            UIColor * cr = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0f];
            
            CGContextSetFillColorWithColor(context, cr.CGColor);
            CGContextFillEllipseInRect(context, frame);
            
            [cr release];
            
            red += deltaRed;
            green += deltaGreen;
            blue += deltaBlue;
            
            frame = CGRectInset(frame, 1, 1);
        }
        
        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
        [name drawAtPoint:CGPointMake(frame.origin.x - 10, frame.origin.y-5) withFont:[UIFont systemFontOfSize:10]];
//    }
    
    retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    frame.origin.x -= defaultSize.width/2;
    frame.origin.y -= defaultSize.height/2;
    frame.size = defaultSize;
    return [retImage subimageWithRect:frame];
}

+(UIImage*)stretchableColor:(UIColor*)color
{
    //NSString * missingText = name;
    //if not exist, new a empty image
    UIGraphicsBeginImageContext(CGSizeMake(2.f, 2.f));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * cr = color;
    CGContextSetFillColorWithColor(context, cr.CGColor);
    CGRect frame = CGRectMake(0, 0, 2, 2);
    CGContextFillRect(context, frame);
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [retImage stretchableImageWithLeftCapWidth:1 topCapHeight:1];
}

+(UIImage*)imageNamed:(NSString *)name ifNotExistCreateImageWithSize:(CGSize)defaultSize
{
    return [UIImage imageNamed:name ifNotExistCreateImageWithSize:defaultSize color:[UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1.0f]];
}

-(UIImage*)imageInflate:(CGSize)aSize mode:(UIViewContentMode)aMode
{
    UIImage * retImage = self;
    UIGraphicsBeginImageContextWithOptions(aSize, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    {
        UIColor * cr = [UIColor clearColor];
        CGContextSetFillColorWithColor(context, cr.CGColor);
        CGRect frame = CGRectMake(0, 0, aSize.width, aSize.height);
        CGContextFillRect(context, frame);
        
        CGRect thumbnailRect = CGRectZero;
        switch (aMode)
        {
            case UIViewContentModeTop:
                thumbnailRect.origin.x = (aSize.width - retImage.size.width)/2;
                break;
            case UIViewContentModeBottom:
                thumbnailRect.origin.x = (aSize.width - retImage.size.width)/2;
                thumbnailRect.origin.y = (aSize.height - retImage.size.height);
                break;
            case UIViewContentModeCenter:
            default:
                thumbnailRect.origin.x = (aSize.width - retImage.size.width)/2;
                thumbnailRect.origin.y = (aSize.height - retImage.size.height)/2;
        }
        thumbnailRect.size = retImage.size;
        
        [retImage drawInRect:thumbnailRect];
    }
    retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

+(UIImage*)imageNamed:(NSString *)name inSize:(CGSize)aSize mode:(UIViewContentMode)aMode
{
    UIImage * retImage = [UIImage imageNamed:name];
    if (!retImage)
        return nil;
    
    UIGraphicsBeginImageContext(aSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    {
        UIColor * cr = [UIColor clearColor];
        CGContextSetFillColorWithColor(context, cr.CGColor);
        CGRect frame = CGRectMake(0, 0, aSize.width, aSize.height);
        CGContextFillRect(context, frame);
        
        CGRect thumbnailRect = CGRectZero;
        switch (aMode)
        {
            case UIViewContentModeTop:
                thumbnailRect.origin.x = (aSize.width - retImage.size.width)/2;
                break;
            case UIViewContentModeBottom:
                thumbnailRect.origin.x = (aSize.width - retImage.size.width)/2;
                thumbnailRect.origin.y = (aSize.height - retImage.size.height);
                break;
            case UIViewContentModeCenter:
            default:
                thumbnailRect.origin.x = (aSize.width - retImage.size.width)/2;
                thumbnailRect.origin.y = (aSize.height - retImage.size.height)/2;
        }
        thumbnailRect.size = retImage.size;
        
        [retImage drawInRect:thumbnailRect];
    }
    retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

+(UIImage*)imageNamed:(NSString *)name inSize:(CGSize)aSize
{
    return [self imageNamed:name inSize:aSize mode:UIViewContentModeCenter];
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;        
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
    {
        CGFloat heightFactor = targetHeight / height;
        
        scaleFactor = heightFactor; // scale to fit width
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
    }       
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        NSLog(@"could not scale image");
    
    UIGraphicsEndImageContext();
    return newImage;
}

#if 0
+(UIImage*)imageNamed:(NSString *)name gridSize:(CGSize)aSize lineColor:(UIColor*)aColor
{
    UIImage * retImage = [UIImage imageNamed:name];
    if (!retImage)
        return nil;
    
    UIGraphicsBeginImageContext(retImage.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //write grid line into image
    {
        [retImage drawInRect:CGRectMake(0, 0, retImage.size.width, retImage.size.height)];

        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGContextSetRGBFillColor(context, 1.0f, 0.0f, 0.0f, 1.0f);
        for (NSUInteger row = 0; row < retImage.size.height / aSize.height; row++)
        {
            CGContextMoveToPoint(context, 0, row * aSize.height);
            CGContextAddLineToPoint(context, retImage.size.width, row * aSize.height);

            NSString * str = [NSString stringWithFormat:@"%d", row];
            [str drawAtPoint:CGPointMake(10, row * aSize.height) withFont:[UIFont systemFontOfSize:6]];
        }
        for (NSUInteger col = 0; col < retImage.size.width / aSize.width; col++)
        {
            CGContextMoveToPoint(context, col * aSize.width, 0);
            CGContextAddLineToPoint(context, col * aSize.width, retImage.size.height);
            
            NSString * str = [NSString stringWithFormat:@"%d", col];
            [str drawAtPoint:CGPointMake(col * aSize.width, 10) withFont:[UIFont systemFontOfSize:6]];
        }
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);
        CGContextStrokePath(UIGraphicsGetCurrentContext());    
    }
    
    retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}
#endif

-(UIImage *)imageWithColor:(UIColor *)color {
    // load the image
    
    UIImage *img = self;
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}
@end

#if 0
@implementation UIImage(generate_orientationMultTab)

+(void)load
{
    printf("static UIImageOrientation const orientationMultTab[8][8]={\n");
    for (UIImageOrientation a = 0; a < 8; a++)
    {
        printf("    {");
        for (UIImageOrientation b = 0; b < 8; b++)
        {
            CGAffineTransform t = CGAffineTransformConcat(transformForImageOrientation[a],transformForImageOrientation[b]);
            UIImageOrientation i;
            for (i = 0; i < 8; i++)
            {
                if (CGAffineTransformEqualToTransform(t, transformForImageOrientation[i]))
                {
                    break;
                }
            }
            assert(i<8);
            printf("%d,",(int)i);
        }
        printf("}\n");
    }
    printf("}\n");
}

@end
#endif

#if 0
#include <objc/runtime.h>
void UIImageScalingExtension_testInCtx(CGContextRef ctx)
{
    UIGraphicsPushContext(ctx);
    UIImage * img = [UIImage imageNamed:@"UIImageOrientationUp.jpg"];
    CGRect r = {CGPointZero, img.size};
    CGFloat maxdim = MAX(r.size.width, r.size.height)+1;
    for (int i = 0; i < 8; i++)
    {
        UIImage * imgT = [img imageTransformedWithOrientation:i];
        r.size = imgT.size;
        [imgT drawInRect:r];
        r.origin.x += maxdim;
    }
    img = [UIImage imageWithCGImage:img.CGImage];
    r.origin.x = 0;
    r.origin.y += r.size.height;
    // Somehow, passing a pointer in the outValue param doesn't work, so we need to use ivar_getOffset().
    Ivar imgFlagsIvar = object_getInstanceVariable(img, "_imageFlags", NULL);
    NSCAssert(imgFlagsIvar,@"");
    __typeof__(img->_imageFlags) * imgFlags = (void*)((unsigned char*)img + ivar_getOffset(imgFlagsIvar));
    for (UIImageOrientation i = 0; i < 8; i++)
    {
        imgFlags->imageOrientation = i;
        NSCAssert(img.imageOrientation == i, @"");
        r.size = img.size;
        [img drawInRect:r];
        r.origin.x += maxdim;
    }
    UIGraphicsPopContext();
}
#endif

#if 0
// A quick test for the new transform table.
@implementation UIImage(test_transformForImageOrientation)
+(void)load
{
    CGSize s = {123,456};
    for (UIImageOrientation orientation = 0; orientation < 8; orientation++)
    {
        CGAffineTransform t;
        switch (orientation) {
        case UIImageOrientationUp:
            t = (CGAffineTransform){1,0,0,1,0,0};
            break;
        case UIImageOrientationDown:   // 180 deg rotation
            t = (CGAffineTransform){-1,0,0,-1,s.width,s.height};
            break;
        case UIImageOrientationLeft:   // 90 deg CCW
            t = (CGAffineTransform){0,-1,1,0,0,s.width};
            break;
        case UIImageOrientationRight:   // 90 deg CW
            t = (CGAffineTransform){0,1,-1,0,s.height,0};
            break;
        case UIImageOrientationUpMirrored:    // as above but image mirrored along other axis. horizontal flip
            t = (CGAffineTransform){-1,0,0,1,s.width,0};
            break;
        case UIImageOrientationDownMirrored:  // horizontal flip
            t = (CGAffineTransform){1,0,0,-1,0,s.height};
            break;
        case UIImageOrientationLeftMirrored:  // vertical flip
            t = (CGAffineTransform){0,1,1,0,0,0};
            break;
        case UIImageOrientationRightMirrored: // vertical flip
            t = (CGAffineTransform){0,-1,-1,0,s.height,s.width};
            break;
        default:
            abort();
        }
        CGAffineTransform t2 = [UIImage transformForOrientation:orientation size:s];
        if (!CGAffineTransformEqualToTransform(t,t2))
        {
            abort();
        }
    }
    ASDevLog(@"Good!");
}
@end
#endif
