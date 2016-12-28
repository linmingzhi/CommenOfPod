//
//  CommonCode.m
//  CommonCode
//
//  Created by 李力卓 on 14-1-15.
//  Copyright (c) 2014年 李力卓. All rights reserved.
//

#import "CommonCode.h"

@implementation CommonCode

+(UITextField*)makeTextFieldWithFrame:(CGRect)frame borderStyle:(UITextBorderStyle)style font:(UIFont*)font adjusts:(BOOL)isAdjust minSize:(float)minSize clearMode:(UITextFieldViewMode)clearMode keyboardType:(UIKeyboardType)keyType autoCorrect:(UITextAutocorrectionType)autoCorrect autoCapital:(UITextAutocapitalizationType)autoCapital returnKey:(UIReturnKeyType)returnKey delegateTo:(id)className placeHolder:(NSString*)placeHolder
{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.borderStyle = style;
    textField.font = font;
    textField.adjustsFontSizeToFitWidth = isAdjust;
    textField.minimumFontSize = minSize;
    textField.clearButtonMode = clearMode;
    textField.keyboardType = keyType;
    textField.autocorrectionType = autoCorrect;
    textField.placeholder = placeHolder;
    textField.autocapitalizationType = autoCapital;
    textField.returnKeyType = returnKey;
    textField.delegate = className;
    return textField;
}

+(UIButton*)makeButtonWithFranme:(CGRect)frame imageName:(NSString*)imageName Title:(NSString*)title target:(id)target Action:(SEL)action type:(UIButtonType)btnType titleColor:(UIColor*)color btnTag:(int)tag titleFont:(UIFont *)font user:(BOOL)userEnable
{
    UIButton*button=[UIButton buttonWithType:btnType];
    button.frame=frame;
    button.tag = tag;
    button.userInteractionEnabled = userEnable;
    button.titleLabel.font = font;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // [button setBackgroundColor:[UIColor whiteColor]];
    return button;
}

+(UILabel*)makeLabelWithFrame:(CGRect)frame fone:(UIFont*)font Text:(NSString*)text numOfLine:(int)num textAligment:(NSTextAlignment)aligment backColor:(UIColor*)backColor textColor:(UIColor*)textColor labelTag:(int)tag
{
    UILabel*label=[[UILabel alloc]init];
    label.frame=frame;
    label.font=font;
    label.tag = tag;
    label.numberOfLines = num;
    label.textAlignment = aligment;
    label.text=text;
    label.textColor = textColor;
    label.backgroundColor =backColor;
    return label ;
    
}

+(UIView*)makeViewWithFrame:(CGRect)frame backColor:(UIColor*)color viewTag:(int)tag
{
    UIView*view=[[UIView alloc]init];
    view.frame=frame;
    view.tag = tag;
    view.backgroundColor = color;
    return view ;
}

+(UIImageView*)makeImageViewWithFrame:(CGRect)frame imageName:(NSString*)imageName backColor:(UIColor*)backColor
{
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:frame];
    imageview.image=[UIImage imageNamed:imageName];
    imageview.userInteractionEnabled=YES;
    imageview.backgroundColor = backColor;
    return imageview  ;
}

+(UIScrollView*)makeScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size isPage:(BOOL)isPage horizonIndicator:(BOOL)horizon verticalIndicator:(BOOL)vertical backColor:(UIColor*)backColor
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    
    scrollView.pagingEnabled = isPage;
    scrollView.contentSize = size;
    scrollView.showsHorizontalScrollIndicator = horizon;
    scrollView.showsVerticalScrollIndicator = vertical;
    scrollView.scrollsToTop = NO;
    scrollView.backgroundColor = backColor;
    return scrollView;
}

+(UIPageControl*)makePageControlWithFrame:(CGRect)frame numOfPage:(int)num currentPage:(int)currentPage
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:frame];
    pageControl.numberOfPages = num;
    pageControl.currentPage = currentPage;
    return pageControl ;
}

+(UISlider*)makeSliderWithFrame:(CGRect)rect AndImage:(UIImage*)image
{
    UISlider *slider = [[UISlider alloc]initWithFrame:rect];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [slider setThumbImage:[UIImage imageNamed:@"qiu"] forState:UIControlStateNormal];
    slider.maximumTrackTintColor = [UIColor grayColor];
    slider.minimumTrackTintColor = [UIColor yellowColor];
    slider.continuous = YES;
    slider.enabled = YES;
    return slider ;
}

+(UITableView*)maketableWithFrame:(CGRect)rect tableStyle:(UITableViewStyle)tableStyle separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle delegateTo:(id)className backColor:(UIColor*)backColor
{
    UITableView *table = [[UITableView alloc] initWithFrame:rect style:tableStyle];
    table.separatorStyle = separatorStyle;
    table.delegate = className;
    table.dataSource = className;
    table.backgroundColor = backColor;
    return table;
}
+(UIButton*)makeButtonWithFranme:(CGRect)frame imageName:(NSString*)imageName Title:(NSString*)title target:(id)target Action:(SEL)action type:(UIButtonType)btnType titleColor:(UIColor*)color
{
    UIButton*button=[UIButton buttonWithType:btnType];
    button.frame=frame;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // [button setBackgroundColor:[UIColor whiteColor]];
    return button;
}

//label字体的大小，颜色
+ (NSAttributedString *)setLabelTextColor1:(UIColor*)color1 andColor2:(UIColor*)color2 part1String:(NSString *)string1 part2String:(NSString *)string2 andFont1:(UIFont*)font1 andFont2:(UIFont*)font2

{
   //完整字符串
   NSString *completeString = [NSString stringWithFormat:@"%@%@",string1 ,string2];
   
   NSRange stringRange_1 = [completeString rangeOfString:string1];
   
   NSRange stringRange_2 = [completeString rangeOfString:string2];
   
   //初始
   NSMutableAttributedString *dealResultString = [[NSMutableAttributedString alloc] initWithString:completeString];
   
   //字体颜色
   [dealResultString addAttribute:NSForegroundColorAttributeName value:color1 range:stringRange_1];
   
   [dealResultString addAttribute:NSForegroundColorAttributeName value:color2 range:stringRange_2];
   
   //字体大小
   [dealResultString addAttribute:NSFontAttributeName value:font1 range:stringRange_1];
   [dealResultString addAttribute:NSFontAttributeName value:font2 range:stringRange_2];
   return dealResultString;
   
   
}

+ (NSMutableAttributedString *)attributedColor:(UIColor*)color String:(NSString *)string Font:(float)font {
   NSMutableAttributedString *subAttr = [[NSMutableAttributedString alloc] initWithString:string];
   
   [subAttr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length )];
   [subAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, string.length )];
   
   return subAttr;
   
}

+ (UIViewController*)viewController:(UIView *)currentView {
   for (UIView* next = [currentView superview]; next; next = next.superview) {
      UIResponder* nextResponder = [next nextResponder];
      if ([nextResponder isKindOfClass:[UIViewController class]]) {
         return (UIViewController*)nextResponder;
      }
   }
   return nil;
}

+ (UIImage*) createImageWithColor: (UIColor*) color
{
   CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
   UIGraphicsBeginImageContext(rect.size);
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextSetFillColorWithColor(context, [color CGColor]);
   CGContextFillRect(context, rect);
   UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return theImage;
}

+ (void)showMessage:(NSString *)message
{
   
   UIWindow * window = [UIApplication sharedApplication].keyWindow;
   UIView *showview =  [[UIView alloc]init];
   showview.backgroundColor = [UIColor blackColor];
   showview.frame = CGRectMake(1, 1, 1, 1);
   showview.alpha = 0.8f;
   showview.layer.cornerRadius = 5.0f;
   showview.layer.masksToBounds = YES;
   [window addSubview:showview];
   
   UILabel *label = [[UILabel alloc]init];
   /*
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    */
   
   label.frame = CGRectMake(10, 5, [MyTools getWidthWithString:message height:25 font:14].width + 10, 25);
   label.text = message;
   label.textColor = [UIColor whiteColor];
   label.textAlignment = 0;
   label.backgroundColor = [UIColor clearColor];
   label.font = [UIFont boldSystemFontOfSize:14];
   [showview addSubview:label];
   
   
   showview.frame = CGRectMake((KScreenWidth - label.width - 10)/2, CGRectGetHeight(window.frame) - 150, label.width+10, label.height+10);
   [UIView animateWithDuration:5 animations:^{
      showview.alpha = 0;
   } completion:^(BOOL finished) {
      [showview removeFromSuperview];
   }];
   
}//显示正在开发的提示信息

//格式话小数 四舍五入类型
+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
   NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
   
   [numberFormatter setPositiveFormat:format];
   
   return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

+ (MJRefreshNormalHeader *)tableviewHeader:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    
    [header setTitle:@"下拉可以刷新了" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"松开马上刷新了" forState:MJRefreshStateRefreshing];
    [header setTitle:@"正在帮你刷新中" forState:MJRefreshStatePulling];
    
    
    return header;
}

+ (MJRefreshAutoNormalFooter *)tableviewFooter:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
    [footer setTitle:@"上拉可以加载更多数据了" forState:MJRefreshStateWillRefresh];
    [footer setTitle:@"松开马上加载更多数据了" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"正在帮你加载中" forState:MJRefreshStatePulling];
    return footer;
}


@end
