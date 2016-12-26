//
//  PopBaseView.m
//  gongHuo
//
//  Created by 悦厚 on 26/11/16.
//  Copyright © 2016年 zhm. All rights reserved.
//

#import "PopBaseView.h"

@implementation PopBaseView{
   
}



- (instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
      _maskView = [UIButton buttonWithType:UIButtonTypeCustom];
      _maskView.frame = [UIScreen mainScreen].bounds;
      _maskView.backgroundColor = [UIColor blackColor];
      [_maskView addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
   }
   return self;
}

- (void)show
{
   
   [self animationWithView:self duration:0.3];
   _maskView.alpha= 0;
   [UIView animateWithDuration:0.25 animations:^{
      _maskView.alpha = 0.5;
   }];
   
   [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
   [[UIApplication sharedApplication].keyWindow addSubview:self];
   self.center = [UIApplication sharedApplication].keyWindow.center;
}

- (void)hidden
{   [_maskView removeFromSuperview];
   [self removeFromSuperview];
}

- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
   
   CAKeyframeAnimation * animation;
   animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
   animation.duration = duration;
   animation.removedOnCompletion = NO;
   
   animation.fillMode = kCAFillModeForwards;
   
   NSMutableArray *values = [NSMutableArray array];
   [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
   [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
   //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
   [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
   
   animation.values = values;
   animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
   
   [view.layer addAnimation:animation forKey:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
