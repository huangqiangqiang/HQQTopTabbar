//
//  HQQTopTabbar.m
//  iosapp
//
//  Created by 黄强强 on 17/5/22.
//  Copyright © 2017年 黄强强. All rights reserved.
//

#import "HQQTopTabbar.h"

#define HQQTopTabbarDefaultDivideColor [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0]


@interface HQQTopTabbar ()
/** 所有的选项按钮 */
@property (nonatomic, strong) NSMutableArray *btns;
/** 选中的带颜色的按钮 */
@property (nonatomic, strong) NSMutableArray *bakBtns;
/** 指示符 */
@property (nonatomic, weak) UIView *indicatorView;

@property (nonatomic, strong) UIView *divide;
@end

@implementation HQQTopTabbar


- (NSMutableArray *)btns
{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)bakBtns
{
    if (!_bakBtns) {
        _bakBtns = [NSMutableArray array];
    }
    return _bakBtns;
}

+ (instancetype)topTabbarWithTitles:(NSArray *)titles
{
    return [[self alloc] initWithTitles:titles];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
        
        [self updateUI:titles];
    }
    return self;
}

- (void)updateUI:(NSArray *)titles
{
    for (NSString *title in titles) {
        [self setupButtonWithTitle:title];
    }
    
    CGFloat w = self.frame.size.width / self.btns.count;
    CGFloat h = self.frame.size.height;
    [self.btns enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.frame = CGRectMake(idx * w, 0, w, h);
    }];
    [self.bakBtns enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.frame = CGRectMake(idx * w, 0, w, h);
    }];
    
    self.divide = [[UIView alloc] init];
    self.divide.backgroundColor = self.divideLineColor ? self.divideLineColor : HQQTopTabbarDefaultDivideColor;
    self.divide.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 0.5);
    [self addSubview:self.divide];
    
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = self.indicatorColor ? self.indicatorColor : [UIColor redColor];
    indicatorView.frame = CGRectMake(0, 0, 0, 3);
    indicatorView.center = CGPointMake(0, self.frame.size.height - indicatorView.frame.size.height / 2);
    [self addSubview:indicatorView];
    self.indicatorView = indicatorView;
    self.showIndicator = YES;
    
    [self animateWithIndicator:0];
}

- (void)setTitles:(NSArray *)titles
{
    [self updateUI:titles];
}


- (void)setupButtonWithTitle:(NSString *)title
{
    UIFont *fontSize = [UIFont systemFontOfSize:13];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = fontSize;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:self.normalColor ? self.normalColor : [UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.tag = self.btns.count;
    
    // 选中的按钮
    UIButton *bakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bakBtn.backgroundColor = [UIColor clearColor];
    [bakBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    bakBtn.titleLabel.font = fontSize;
    [bakBtn setTitle:title forState:UIControlStateNormal];
    [bakBtn setTitleColor:self.selectColor ? self.selectColor : [UIColor darkGrayColor] forState:UIControlStateNormal];
    bakBtn.tag = self.btns.count;
    bakBtn.alpha = 0.0f;
    
    [self addSubview:btn];
    [self addSubview:bakBtn];
    
    [self.btns addObject:btn];
    [self.bakBtns addObject:bakBtn];
}

- (void)setY:(CGFloat)y
{
    self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
}

- (void)setShowIndicator:(BOOL)showIndicator
{
    _showIndicator = showIndicator;
    self.indicatorView.hidden = !showIndicator;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    self.backgroundColor = tintColor;
}

- (void)setDivideLineColor:(UIColor *)divideLineColor
{
    _divideLineColor = divideLineColor;
    self.divide.backgroundColor = divideLineColor;
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    for (UIButton *btn in self.bakBtns) {
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
    }
}

- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    for (UIButton *selectBtn in self.bakBtns) {
        [selectBtn setTitleColor:selectColor forState:UIControlStateNormal];
    }
}

- (void)btnClick:(UIButton *)btn
{
    [self tabbarClickIndex:btn];
}

- (void)tabbarClickIndex:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(topTabbar:didClickButton:atIndex:)]) {
        [self.delegate topTabbar:self didClickButton:btn atIndex:(int)btn.tag];
    }
}

- (void)animateWithIndicator:(CGFloat)offset
{
    if (!self.showIndicator) return;
    
    offset = (offset / self.frame.size.width);
    
    NSArray *ofs = [[NSString stringWithFormat:@"%.2f",offset] componentsSeparatedByString:@"."];
    NSInteger index = [[ofs firstObject] integerValue];
    CGFloat rate = [[NSString stringWithFormat:@"0.%@",[ofs lastObject]] doubleValue];
    
    for (int i = 0; i < index; i++) {
        UIButton *btn = self.btns[i];
        UIButton *bakBtn = self.bakBtns[i];
        btn.alpha = 1.0f;
        bakBtn.alpha = 0.f;
    }
    
    UIButton *prevBtn = nil;
    UIButton *prevBakBtn = nil;
    prevBtn = self.btns[index];
    prevBakBtn = self.bakBtns[index];
    prevBtn.alpha = rate;
    prevBakBtn.alpha = 1 - rate;
    
    CGSize maxSize = CGSizeMake(self.frame.size.width / self.btns.count, MAXFLOAT);
    CGRect frame = [prevBtn.titleLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:prevBtn.titleLabel.font} context:nil];
    CGFloat prevWidth = frame.size.width;
    
    UIButton *nextBtn = nil;
    UIButton *nextBakBtn = nil;
    if (index == self.btns.count - 1) {
        nextBtn = self.btns[index];
        nextBakBtn = self.bakBtns[index];
        
        nextBtn.alpha = rate;
        nextBakBtn.alpha = 1 - rate;
    }else{
        nextBtn = self.btns[index + 1];
        nextBakBtn = self.bakBtns[index + 1];
        
        nextBtn.alpha = 1 - rate;
        nextBakBtn.alpha = rate;
    }
    
    frame = [nextBtn.titleLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nextBtn.titleLabel.font} context:nil];
    CGFloat nextWidth = frame.size.width;
    
    CGFloat indicatorWidth = prevWidth + (nextWidth - prevWidth) * rate;
    self.indicatorView.frame = CGRectMake(self.indicatorView.frame.origin.x, self.indicatorView.frame.origin.y, indicatorWidth, self.indicatorView.frame.size.height);
    self.indicatorView.center = CGPointMake((self.frame.size.width / self.btns.count) / 2 + (self.frame.size.width / self.btns.count) * offset, self.indicatorView.center.y);
}


@end
