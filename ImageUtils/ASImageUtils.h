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

#import <UIKit/UIKit.h>

UIColor * rgb(int r, int g, int b);
UIColor * rgbA(int r, int g, int b, float a);
UIColor * rgbweb(int rgbval);
CGFloat valueFromColor(UIColor * uicolor, int idx);
CGFloat rValueFromColor(UIColor * uicolor);
CGFloat gValueFromColor(UIColor * uicolor);
CGFloat bValueFromColor(UIColor * uicolor);
UIColor * AlphaColor(UIColor * uicolor, CGFloat alpha);

@interface UIImage(ASImageUtils)

// Orientation transforms.
+(CGAffineTransform)affineTransformFromOrientation:(UIImageOrientation)orientation size:(CGSize)size;
-(UIImage*) imageByTransformingWithOrientation:(UIImageOrientation)orientation;

// Uses CGImageCreateWithImageInRect() where easily possible.
-(UIImage*)subimageWithRect:(CGRect)r;
-(UIImage*)subimageByCroppingWithInsets:(UIEdgeInsets)insets;

// Some masks.
-(UIImage*)imageByMaskingWithMask:(UIImage*)mask;
-(UIImage*)imageByFillingWithColor:(UIColor*)aColor;
-(UIImage*)imageByDarkeningWithAlpha:(CGFloat)aAlpha;

// Programmatically-generated single-pixel images.
+(UIImage*)transparentPixelImage;
+(UIImage*)singlePixelImageWithColor:(UIColor*)c;
+(UIImage *)rectImageWithColor:(UIColor *)c size:(CGSize)s scale:(CGFloat)scale;

+(UIImage*)stretchableColor:(UIColor*)color;
// Programmatically-generated images (e.g. to make masks).
+(UIImage*)stretchableRoundedRectWithRadius:(CGFloat)r scale:(CGFloat)scale color:(UIColor*)color;
+(UIImage*)stretchableRoundedRectWithRadius:(CGFloat)r scale:(CGFloat)scale color:(UIColor*)color borderColor:(UIColor*)borderColor borderWidth:(CGFloat)width;

+(UIImage*)imageNamed:(NSString *)name withTitle:(NSString *)title;
-(UIImage*)imageWithTitle:(NSString *)title;
-(UIImage*)imageWithTitle:(NSString *)title edgeInsets:(UIEdgeInsets)edgeInsets color:(UIColor *)color;

+(UIImage*)imageNamed:(NSString *)name ifNotExistCreateImageWithSize:(CGSize)defaultSize;
+(UIImage*)imageNamed:(NSString *)name ifNotExistCreateImageWithSize:(CGSize)defaultSize topColor:(UIColor *)aTopColor bottomColor:(UIColor *)aBottomColor;
+(UIImage*)imageNamed:(NSString *)name ifNotExistCreateImageWithSize:(CGSize)defaultSize color:(UIColor *)aColor;

+(UIImage*)imageNamed:(NSString *)name inSize:(CGSize)aSize;
+(UIImage*)imageNamed:(NSString *)name inSize:(CGSize)aSize mode:(UIViewContentMode)aMode;

+(UIImage*)imageNamed:(NSString *)bgName withImage:(NSString *)fgName atPoint:(CGPoint)point;
-(UIImage*)imageWithImage:(NSString *)fgName atPoint:(CGPoint)point;
-(UIImage *)imageWithColor:(UIColor *)color;

-(UIImage*)imageInflate:(CGSize)aSize mode:(UIViewContentMode)aMode;

//+(UIImage*)imageNamed:(NSString *)name gridSize:(CGSize)aSize lineColor:(UIColor*)aColor;
+(UIImage*)imageNamed:(NSString *)name ifNotExistCreateImageWithSize:(CGSize)defaultSize centerColor:(UIColor *)aCenterColor outerColor:(UIColor *)aOuterColor;

+(BOOL)orientationIsLandscape:(UIImageOrientation)imageOrientation;

-(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
