//
//  PopListSelectView.h
//  SchoMe
//
//  Created by stoneli on 15/5/5.
//  Copyright (c) 2015年 stoneli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CourseListMode = 10, //课时
} PopListMode;

@interface PopListSelectView : UIView<UITextFieldDelegate>
@property (strong, nonatomic) void (^sendSelectBlock)(NSArray *date, NSInteger index);
@property (nonatomic,strong) NSArray *date;
@property (nonatomic,strong) UIView *parentView;
@property (nonatomic,strong) NSString *cellNibName;
@property (nonatomic,strong) UIView *upView;
@property (nonatomic,strong) UIView *downView;
@property (nonatomic,strong) UITableViewCell *superCell;
@property (nonatomic,strong) UITableView *theTableView;
@property (nonatomic,assign) BOOL showTextField;
@property (nonatomic) PopListMode mode;

- (void)show:(CGFloat)x with:(CGFloat)y visualEffect:(BOOL)effect;

- (void)close;

- (void)showFromBottomWIthView:(UIView*)v visualEffect:(BOOL)effect;

- (void)showCenterView:(UIView *)v visualEffect:(BOOL)effect;

- (void)showFromBottomToBottomWIthView:(UIView*)v visualEffect:(BOOL)effect ;
@end
