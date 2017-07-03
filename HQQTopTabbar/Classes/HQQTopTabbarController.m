//
//  HQQTopTabbarViewController.m
//  iosapp
//
//  Created by 黄强强 on 17/5/22.
//  Copyright © 2017年 黄强强. All rights reserved.
//

#import "HQQTopTabbarController.h"

@interface HQQTopTabbarController () <HQQTopTabbarDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<UIViewController *> *childControllers;
@end

@implementation HQQTopTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_tabbar == nil || _scrollView == nil) {
        
        [self.view addSubview:self.tabbar];
        NSMutableArray *titles = [NSMutableArray array];
        for (UIViewController *vc in self.childControllers) {
            if (vc.title) {
                [titles addObject:vc.title];
            }
            else{
                [titles addObject:@""];
            }
        }
        [self.tabbar setTitles:titles];
        
        // 创建scrollView
        [self setupScrollView];
    }
    
//    [self topTabbar:self.tabbar didClickButton:nil atIndex:(int)self.selectedIndex];
}

- (void)setupScrollView
{
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO; // 点击状态栏的时候，这个scrollView不会滚动到最顶部
    self.scrollView.contentSize = CGSizeMake(self.childControllers.count * w, 0);
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.scrollView belowSubview:self.tabbar];
    
    // 懒加载子控制器
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
    
    // 第一次进来时选中第几个tabbar
    [self topTabbar:self.tabbar didClickButton:nil atIndex:(int)self.selectedIndex];
}

- (void)addChildVC:(UIViewController *)childController
{
    [self addChildViewController:childController];
    [self.childControllers addObject:childController];
}

#pragma mark - <HQQTopTabbarDelegate>

- (void)topTabbar:(HQQTopTabbar *)topTabbar didClickButton:(UIButton *)btn atIndex:(int)index
{
    CGPoint offset = CGPointMake(index * self.view.frame.size.width, self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>

/**
 在scrollViewDidEndScrollingAnimation方法中懒加载子控制器

 @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 取出子控制器
    UIViewController *vc = self.childControllers[index];
    CGRect frame = vc.view.frame;
    
    frame.origin.x = scrollView.contentOffset.x;
    frame.origin.y = 0;
    frame.size.height = scrollView.frame.size.height;
    
    vc.view.frame = frame;
    
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tabbar animateWithIndicator:scrollView.contentOffset.x];
}

#pragma mark - lazyload

- (HQQTopTabbar *)tabbar
{
    if (!_tabbar) {
        _tabbar = [[HQQTopTabbar alloc] init];
        _tabbar.delegate = self;
        [_tabbar setY:64 - 1];
    }
    return _tabbar;
}

- (NSMutableArray *)childControllers
{
    if (!_childControllers) {
        _childControllers = [NSMutableArray array];
    }
    return _childControllers;
}


@end


