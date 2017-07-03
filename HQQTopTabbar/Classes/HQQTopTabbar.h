//
//  HQQTopTabbar.h
//  iosapp
//
//  Created by 黄强强 on 17/5/22.
//  Copyright © 2017年 黄强强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQQTopTabbar;

@protocol HQQTopTabbarDelegate <NSObject>
- (void)topTabbar:(HQQTopTabbar *)topTabbar didClickButton:(UIButton *)btn atIndex:(int)index;
@end

@interface HQQTopTabbar : UIView

+ (instancetype)topTabbarWithTitles:(NSArray *)titles;

- (void)setTitles:(NSArray *)titles;

- (void)setY:(CGFloat)y;

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *divideLineColor;


@property (nonatomic, assign) BOOL showIndicator;

/**
 *  指示器的动画
 *
 *  @param offset scrollview的偏移量
 */
- (void)animateWithIndicator:(CGFloat)offset;

@property (nonatomic, weak) id<HQQTopTabbarDelegate> delegate;
@end
