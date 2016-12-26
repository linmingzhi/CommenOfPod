//
//  PopListSelectView.m
//  SchoMe
//
//  Created by stoneli on 15/5/5.
//  Copyright (c) 2015年 stoneli. All rights reserved.
//

#import "PopListSelectView.h"
//#import "SMNewTaskTableViewCell.h"
#define POPUP_ANIMATION_DURATION 0.5

// 获取物理屏幕宽度
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width

// 获取物理屏幕高度
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@interface PopListSelectView () <UITableViewDelegate> {
    int _showtype;
}
@property (nonatomic,strong) UIView *containView;

@end

@implementation PopListSelectView

/**
 *  释放
 */
- (void)dealloc {
    [self.theTableView removeFromSuperview];
    self.theTableView = nil;
    self.date = nil;
    self.parentView = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        self.theTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.theTableView.autoresizingMask = UIViewAutoresizingNone;
        self.theTableView.showsHorizontalScrollIndicator = NO;
        self.theTableView.showsVerticalScrollIndicator = NO;
        self.theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.theTableView.backgroundColor = [UIColor whiteColor];
        self.theTableView.separatorColor = [UIColor clearColor];
        self.theTableView.delegate = self;
//        self.theTableView.dataSource = self;
    }
    return self;
}

- (void)showFromBottomToBottomWIthView:(UIView*)v visualEffect:(BOOL)effect {
    _showtype = 2;
    self.containView = v;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    CGRect r = v.frame;
    r.origin.y = KScreenHeight;
    r.origin.x = (KScreenWidth - r.size.width)/2;
    [v setFrame:r];
    [self addSubview:v];
    //    UIVisualEffectView *visualEffectView = nil;
    //    if (effect) {
    //        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    //        visualEffectView.frame = self.frame;
    //        visualEffectView.alpha = 0;
    //        [self insertSubview:visualEffectView atIndex:0];
    //    }
    if (self.parentView) {
        [self.parentView addSubview:self];
    }
    else {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;
                
            default:
                break;
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor clearColor];
                         CGRect dialogFrame = CGRectMake((KScreenWidth - r.size.width)/2, KScreenHeight - r.size.height, r.size.width, r.size.height);
                         [v setFrame:dialogFrame];
                         v.layer.opacity = 1.0f;
                         v.layer.transform = CATransform3DMakeScale(1, 1, 1);
                         //                         if (effect) {
                         //                             visualEffectView.alpha = 1.0;
                         //                         }
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
                     }
                     completion:NULL
     ];
}


- (void)showFromBottomWIthView:(UIView*)v visualEffect:(BOOL)effect {
    _showtype = 2;
    self.containView = v;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    CGRect r = v.frame;
    r.origin.y = KScreenHeight;
    r.origin.x = (KScreenWidth - r.size.width)/2;
    [v setFrame:r];
    [self addSubview:v];
    UIVisualEffectView *visualEffectView = nil;
    if (effect) {
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.frame = self.frame;
        visualEffectView.alpha = 0;
        [self insertSubview:visualEffectView atIndex:0];
    }
    if (self.parentView) {
        [self.parentView addSubview:self];
    }
    else {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;
                
            default:
                break;
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor clearColor];
                         CGRect dialogFrame = CGRectMake((KScreenWidth - r.size.width)/2, (KScreenHeight - r.size.height)/2, r.size.width, r.size.height);
                         [v setFrame:dialogFrame];
                         v.layer.opacity = 1.0f;
                         v.layer.transform = CATransform3DMakeScale(1, 1, 1);
                         if (effect) {
                             visualEffectView.alpha = 1.0;
                         }
                     }
                     completion:NULL
     ];
}

- (void)showFromSelectTableCell:(UITableViewCell*)selectCell
                       withView:(UIView *)superView
                  withTableView:(UITableView*)tableView
                   withDataList:(NSArray *)listData {
    _showtype = 1;
    self.parentView = superView;
    self.date = listData;
    self.superCell = selectCell;
    
    [self.theTableView setFrame:CGRectMake(superView.frame.size.width, 0, 160, superView.frame.size.height)];
    self.upView = [[UIView alloc] initWithFrame:CGRectZero];
    self.downView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.upView];
    [self addSubview:self.downView];
    [self addSubview:self.theTableView];
    
//    UIView *indentyView = [[UIView alloc] init];
//    indentyView.backgroundColor = rgbweb(0xf52636);
//    indentyView.tag = 10001;
//    CGRect r = selectCell.frame;
//    r.size.width = 3.0f;
//    r.origin.y -= tableView.contentOffset.y;
//    [indentyView setFrame:r];
//    [self addSubview:indentyView];
//    
//    self.layer.shouldRasterize = YES;
//    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
//    [self.parentView addSubview:self];
//    
//    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionLayoutSubviews
//                     animations:^{
//                         CGRect r = self.frame;
//                         CGRect rightRect, leftRect, upRect, downRect;
//                         CGRectDivide(r, &rightRect, &leftRect, 160, CGRectMaxXEdge);
//                         rightRect.size.height -= 68.0f;
//                         [self.theTableView setFrame:rightRect];
//                         
//                         CGRectDivide(leftRect, &upRect, &downRect, tableView.frame.origin.y + selectCell.frame.origin.y - tableView.contentOffset.y, CGRectMinYEdge);
//                         CGRectDivide(downRect, &r, &downRect, selectCell.frame.size.height, CGRectMinYEdge);
//                         if (upRect.size.height != 0) {
//                             upRect.size.height += 1;
//                         }
//                         downRect.origin.y -= 1;
//                         
//                         [self.upView setFrame:upRect];
//                         [self.upView setBackgroundColor:[UIColor blackColor]];
//                         self.upView.alpha = 0.5;
//                         [self.downView setFrame:downRect];
//                         self.downView.alpha = 0.5;
//                         [self.downView setBackgroundColor:[UIColor blackColor]];
//                         [self.parentView bringSubviewToFront:self.theTableView];
//                     }
//                     completion:NULL
//     ];
}

- (void)show:(CGFloat)x with:(CGFloat)y visualEffect:(BOOL)effect {
    _showtype = 0;
    CGFloat height = self.date.count * 44 <= 220 ? self.date.count * 44 : 220;
    CGRect dialogFrame = CGRectMake(x, y, 200, height);
    [self.theTableView setFrame:dialogFrame];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self addSubview:self.theTableView];
    UIVisualEffectView *visualEffectView = nil;
    if (effect) {
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.frame = self.frame;
        visualEffectView.alpha = 0;
        [self insertSubview:visualEffectView atIndex:0];
    }
    if (self.parentView) {
        [self.parentView addSubview:self];
    }
    else {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;
                
            default:
                break;
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.theTableView.layer.opacity = 1.0f;
                         self.theTableView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                         if (effect) {
                             visualEffectView.alpha = 1.0;
                         }
                     }
                     completion:NULL
     ];
}

- (void)showCenterView:(UIView *)v visualEffect:(BOOL)effect {
    _showtype = 2;
    self.containView = v;
    self.containView.layer.cornerRadius = 10;
    self.containView.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self addSubview:v];
    UIVisualEffectView *visualEffectView = nil;
    if (effect) {
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.frame = self.frame;
        visualEffectView.alpha = 0;
        [self insertSubview:visualEffectView atIndex:0];
    }
    if (self.parentView) {
        [self.parentView addSubview:self];
    }
    else {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;
                
            default:
                break;
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        v.center = self.center;
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }
    
    CAKeyframeAnimation *alphaAnimation = [self getPositionAnimationForPopup];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects: alphaAnimation, nil];
    group.duration = POPUP_ANIMATION_DURATION;
    group.removedOnCompletion = YES;
    group.fillMode = kCAFillModeForwards;
    [v.layer addAnimation:group forKey:@"hoge"];
}

- (CAKeyframeAnimation*)getPositionAnimationForPopup {
    float r1 = 0.4;
    float r2 = 1.2;
    float r3 = 1;
    float r4 = 0.8;
    float r5 = 1;
    
    float horizontalOffset = 0.0;
    float portraitOffset = 0.0;
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D tm1, tm2, tm3, tm4, tm5;
    
    
    horizontalOffset = -horizontalOffset;
    tm1 = CATransform3DMakeTranslation(horizontalOffset* -(1 - r1), -portraitOffset * (1 - r1), 0);
    tm2 = CATransform3DMakeTranslation(horizontalOffset * -(1 - r2), -portraitOffset * (1 - r2), 0);
    tm3 = CATransform3DMakeTranslation(horizontalOffset * -(1 - r3), -portraitOffset * (1 - r3), 0);
    tm4 = CATransform3DMakeTranslation(horizontalOffset * -(1 - r4), -portraitOffset * (1 - r4), 0);
    tm5 = CATransform3DMakeTranslation(horizontalOffset * -(1 - r5), -portraitOffset * (1 - r5), 0);
    
    tm1 = CATransform3DScale(tm1, r1, r1, 1);
    tm2 = CATransform3DScale(tm2, r2, r2, 1);
    tm3 = CATransform3DScale(tm3, r3, r3, 1);
    tm4 = CATransform3DScale(tm4, r4, r4, 1);
    tm5 = CATransform3DScale(tm5, r5, r5, 1);
    
    positionAnimation.values = [NSArray arrayWithObjects:
                                [NSValue valueWithCATransform3D:tm1],
                                [NSValue valueWithCATransform3D:tm2],
                                [NSValue valueWithCATransform3D:tm3],
                                [NSValue valueWithCATransform3D:tm4],
                                [NSValue valueWithCATransform3D:tm5],
                                nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:0.0],
                                  [NSNumber numberWithFloat:0.2],
                                  [NSNumber numberWithFloat:0.4],
                                  [NSNumber numberWithFloat:0.7],
                                  [NSNumber numberWithFloat:1.0],
                                  nil];
    return positionAnimation;

}

- (void)close
{
    [self close:YES];
}

- (void)close:(BOOL)animation
{
    CATransform3D currentTransform = self.theTableView.layer.transform;
    
    CGFloat startRotation = [[self.theTableView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
    
    self.theTableView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    self.theTableView.layer.opacity = 1.0f;
    
    if (animation) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                             if (_showtype == 0) {
                                 self.theTableView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                                 self.theTableView.layer.opacity = 0.0f;
                             }
                             else if (_showtype == 1) {
                                 UIView *v = [self viewWithTag:10001];
                                 v.alpha = 0.0f;
                                 CGRect dialogFrame = CGRectMake(KScreenWidth, 0, 200, KScreenHeight);
                                 [self.theTableView setFrame:dialogFrame];
                                 self.upView.alpha = 0.0f;
                                 self.downView.alpha = 0.0f;
                             }
                             else if (_showtype == 2) {
                                 CGRect r = self.containView.frame;
                                 r.origin.y = KScreenHeight;
                                 [self.containView setFrame:r];
                             }
                         }
                         completion:^(BOOL finished) {
                             for (UIView *v in [self subviews]) {
                                 [v removeFromSuperview];
                             }
                             [self removeFromSuperview];
                         }
         ];
    }else{
        for (UIView *v in [self subviews]) {
            [v removeFromSuperview];
        }
        [self removeFromSuperview];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = self.containView.frame;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if (isInside) {
        return;
    }
    [self close];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self endEditing:YES];
    self.sendSelectBlock(self.date, indexPath.row);
    [self close];
}

#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.date count];
}

#pragma mark-
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    id dic = [self.date objectAtIndex:self.date.count - 1];
    if (_mode == CourseListMode) {
        [dic setObject:[NSString stringWithFormat:@"%d", [textField.text intValue]] forKey:@"CourseNum"];
    }
}

@end
