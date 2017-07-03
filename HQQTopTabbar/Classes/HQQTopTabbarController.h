//
//  HQQTopTabbarViewController.h
//  iosapp
//
//  Created by 黄强强 on 17/5/22.
//  Copyright © 2017年 黄强强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQQTopTabbar.h"

@interface HQQTopTabbarController : UIViewController

@property (nonatomic, strong) HQQTopTabbar *tabbar;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong, readonly) NSMutableArray<UIViewController *> *childControllers;

- (void)addChildVC:(UIViewController *)childController;
@end



//@interface UIViewController (UITopTabBarControllerItem)
//
//@property(nonatomic, readonly, strong) HQQTopTabbarController *topTabBarController;
//
//@end
