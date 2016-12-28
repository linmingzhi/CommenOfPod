//
//  CommonCode.h
//  CommonCode
//
//  Created by 李力卓 on 14-1-15.
//  Copyright (c) 2014年 李力卓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#import "MJRefreshComponent.h"
//#import "MJRefreshNormalHeader.h"
//#import "MJRefreshAutoNormalFooter.h"

#define CommonFont 14
#define CommonLineColor KColor(246, 246, 246, 1.0)

@interface CommonCode : NSObject

+(UIButton*)makeButtonWithFranme:(CGRect)frame imageName:(NSString*)imageName Title:(NSString*)title target:(id)target Action:(SEL)action type:(UIButtonType)btnType titleColor:(UIColor*)color btnTag:(int)tag titleFont:(UIFont *)font user:(BOOL)userEnable;

+(UILabel*)makeLabelWithFrame:(CGRect)frame fone:(UIFont*)font Text:(NSString*)text numOfLine:(int)num textAligment:(NSTextAlignment)aligment backColor:(UIColor*)backColor textColor:(UIColor*)textColor labelTag:(int)tag;

+(UIView*)makeViewWithFrame:(CGRect)frame backColor:(UIColor*)color viewTag:(int)tag;

+(UIImageView*)makeImageViewWithFrame:(CGRect)frame imageName:(NSString*)imageName backColor:(UIColor*)backColor;

+(UITextField*)makeTextFieldWithFrame:(CGRect)frame borderStyle:(UITextBorderStyle)style font:(UIFont*)font adjusts:(BOOL)isAdjust minSize:(float)minSize clearMode:(UITextFieldViewMode)clearMode keyboardType:(UIKeyboardType)keyType autoCorrect:(UITextAutocorrectionType)autoCorrect autoCapital:(UITextAutocapitalizationType)autoCapital returnKey:(UIReturnKeyType)returnKey delegateTo:(id)className placeHolder:(NSString*)placeHolder;

+(UIScrollView*)makeScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size isPage:(BOOL)isPage horizonIndicator:(BOOL)horizon verticalIndicator:(BOOL)vertical backColor:(UIColor*)backColor;

+(UIPageControl*)makePageControlWithFrame:(CGRect)frame numOfPage:(int)num currentPage:(int)currentPage;

+(UISlider*)makeSliderWithFrame:(CGRect)rect AndImage:(UIImage*)image;

+(UITableView*)maketableWithFrame:(CGRect)rect tableStyle:(UITableViewStyle)tableStyle separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle delegateTo:(id)className backColor:(UIColor*)backColor;

//+(NSDictionary *)getDateFromUrl:(NSURL *)url;
+(UIButton*)makeButtonWithFranme:(CGRect)frame imageName:(NSString*)imageName Title:(NSString*)title target:(id)target Action:(SEL)action type:(UIButtonType)btnType titleColor:(UIColor*)color;

+ (NSAttributedString *)setLabelTextColor1:(UIColor*)color1 andColor2:(UIColor*)color2 part1String:(NSString *)string1 part2String:(NSString *)string2 andFont1:(UIFont*)font1 andFont2:(UIFont*)font2;

+ (NSMutableAttributedString *)attributedColor:(UIColor*)color String:(NSString *)string Font:(float)font ;

+ (UIViewController*)viewController:(UIView *)currentView;

+ (UIImage*) createImageWithColor: (UIColor*) color;

//+ (void)showMessage:(NSString *)message;

+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV;

//+ (MJRefreshNormalHeader *)tableviewHeader:(MJRefreshComponentRefreshingBlock)refreshingBlock;
//+ (MJRefreshAutoNormalFooter *)tableviewFooter:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@end
