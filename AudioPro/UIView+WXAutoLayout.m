//
//  UIView+WXAutoLayout.m
//  WXStatisticsPanel
//
//  Created by tianlong on 2018/8/24.
//  Copyright © 2018年 tianlong. All rights reserved.
//

#import "UIView+WXAutoLayout.h"



@implementation UIView (WXAutoLayout)

/**
 以手机为例，设计以参考 竖屏：375x667 横屏：667x375
 竖屏：
 手机宽度 ：375 = 缩放后宽度 ：设计宽度
 手机高度 ：667 = 缩放后高度 ：设计高度
 水平间距 ：375 = 缩放后间距 ：设计间距
 垂直间距 ：667 = 缩放后间距 ：设计间距
 
 横屏
 手机宽度 ：667 = 缩放后宽度 ：设计宽度
 手机高度 ：375 = 缩放后高度 ：设计高度
 水平间距 ：667 = 缩放后间距 ：设计间距
 垂直间距 ：375 = 缩放后间距 ：设计间距
 */

#pragma mark - 固定参照标准
/** 宽度 */
- (CGFloat(^)(CGFloat design))AutoFitWidth {
    return ^(CGFloat design) {
        CGFloat finalValue = 0.0f;
        if ([self WXISIPAD]) {
            finalValue = self.AutoFitWidthScale([self WXISLandscape] ? 1024 : 768) * design;
        }else {
            finalValue = self.AutoFitWidthScale([self WXISLandscape] ? 667 : 375) * design;
        }
        return finalValue;
    };
}

/** 高度 */
- (CGFloat(^)(CGFloat design))AutoFitHeight {
    return ^(CGFloat design) {
        CGFloat finalValue = 0.0f;
        if ([self WXISIPAD]) {
            finalValue = self.AutoFitHeightScale([self WXISLandscape] ? 768 : 1024) * design;
        }else {
            finalValue = self.AutoFitHeightScale([self WXISLandscape] ? 375 : 667) * design;
        }
        return finalValue;
    };
}

/** 顶间距 */
- (CGFloat(^)(CGFloat design))AutoFitTop {
    return ^(CGFloat design) {
        CGFloat finalValue = self.AutoFitHeight(design);
        return finalValue;
    };
}

/** 左间距 */
- (CGFloat(^)(CGFloat design))AutoFitLeft {
    return ^(CGFloat design) {
        CGFloat finalValue = self.AutoFitWidth(design);
        return finalValue;
    };
}

/** 底间距 */
- (CGFloat(^)(CGFloat design))AutoFitBottom {
    return ^(CGFloat design) {
        CGFloat finalValue = self.AutoFitHeight(design);
        return finalValue;
    };
}

/** 右间距 */
- (CGFloat(^)(CGFloat design))AutoFitRight {
    return ^(CGFloat design) {
        CGFloat finalValue = self.AutoFitWidth(design);
        return finalValue;
    };
}

- (CGFloat(^)(CGFloat design))AutoFitFontSize {
    return ^(CGFloat design) {
        CGFloat finalValue = (self.AutoFitWidth(design) + self.AutoFitHeight(design))*0.5;
        return finalValue;
    };
}


#pragma mark - 自定义参照标准
/** 自定义参照尺寸-宽度 */
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitWidth {
    return ^(CGSize referSize, CGFloat design) {
        CGFloat referW      = [self WXISLandscape] ? MAX(referSize.width, referSize.height) : MIN(referSize.width, referSize.height);
        CGFloat scale       = self.AutoFitWidthScale(referW);
        CGFloat finalValue  = scale * design;
        return finalValue;
    };
}

/** 自定义参照尺寸-高度 */
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitHeight {
    return ^(CGSize referSize, CGFloat design) {
        CGFloat referH      = [self WXISLandscape] ? MIN(referSize.width, referSize.height) : MAX(referSize.width, referSize.height);
        CGFloat scale       = self.AutoFitHeightScale(referH);
        CGFloat finalValue  = scale * design;
        return finalValue;
    };
}

/** 自定义参照尺寸-顶间距 */
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitTop {
    return ^(CGSize referSize, CGFloat design) {
        return self.FreeAutoFitHeight(referSize,design);
    };
}

/** 自定义参照尺寸-底间距 */
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitBottom {
    return ^(CGSize referSize, CGFloat design) {
        return self.FreeAutoFitHeight(referSize,design);
    };
}


/** 自定义参照尺寸-左间距 */
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitLeft {
    return ^(CGSize referSize, CGFloat design) {
        return self.FreeAutoFitWidth(referSize,design);
    };
}

/** 自定义参照尺寸-右间距 */
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitRight {
    return ^(CGSize referSize, CGFloat design) {
        return self.FreeAutoFitWidth(referSize,design);
    };
}

/** 自定义参照尺寸-字号适配 */
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitFontSize {
    return ^(CGSize referSize, CGFloat design) {
        CGFloat finalValue = (self.FreeAutoFitWidth(referSize,design) + self.FreeAutoFitHeight(referSize,design))*0.5;
        return finalValue;
    };
}



#pragma mark - 宽度系数
- (CGFloat(^)(CGFloat refer))AutoFitWidthScale {
    return ^(CGFloat refer) {
        CGFloat scale = 1.0f;
        if (refer > 0) {
            if ([self WXISIphoneX]) {
                scale = 1.0f;
            }else {
                scale = [self WXGetCurrentScreenWidth] / refer;
            }
        }
        return scale;
    };
}

#pragma mark - 高度系数
- (CGFloat(^)(CGFloat refer))AutoFitHeightScale {
    return ^(CGFloat refer) {
        CGFloat scale = 1.0f;
        if (refer > 0) {
            if ([self WXISIphoneX]) {
                scale = 414/375.0f;
            }else {
                scale = [self WXGetCurrentScreenHeight] / refer;
            }
        }
        return scale;
    };
}


#pragma mark - 获取屏幕当前的宽度
- (CGFloat)WXGetCurrentScreenWidth {
    if (![self WXISIOS8_OR_LATER]) {
        switch ([UIApplication sharedApplication].statusBarOrientation){
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                return [UIScreen mainScreen].bounds.size.width;
                break;
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                return [UIScreen mainScreen].bounds.size.height;
                break;
            default:
                break;
        }
    }else {
        return [UIScreen mainScreen].bounds.size.width;
    }
    return 0;
}


#pragma mark - 获取屏幕当前的高度
- (CGFloat)WXGetCurrentScreenHeight {
    if (![self WXISIOS8_OR_LATER]) {
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                return [UIScreen mainScreen].bounds.size.height;
                break;
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                return [UIScreen mainScreen].bounds.size.width;
                break;
            default:
                break;
        }
    }else {
        return [UIScreen mainScreen].bounds.size.height;
    }
    return 0;
}

#pragma mark - 是否是iPad
- (BOOL)WXISIPAD {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

#pragma mark - 是否是8系统及以后
- (BOOL)WXISIOS8_OR_LATER {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0);
}

#pragma mark - 是否是横屏
- (BOOL)WXISLandscape {
    BOOL isLand = NO;
    switch ([UIApplication sharedApplication].statusBarOrientation){
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            isLand = YES;
            break;
        default:
            break;
    }
    //NSLog(@"现在的手机屏幕方向是：%@",isLand ? @"横屏" : @"竖屏");
    return isLand;
}

#pragma mark - 是否是iPhone X
- (BOOL)WXISIphoneX {
    CGFloat screenWidth = ceil([self WXGetCurrentScreenWidth]);
    CGFloat screenHeight = ceil([self WXGetCurrentScreenHeight]);
    if ((screenWidth == 375 && screenHeight == 812) || (screenWidth == 414 && screenHeight == 896))
    {
        return YES;
    }
    // 横屏
    if ((screenHeight == 375 && screenWidth == 812) || (screenHeight == 414 && screenWidth == 896)) {
        return YES;
    }
    return NO;
}


#pragma mark - iPhone X 保护区域
- (UIEdgeInsets)WXGetViewSafeAreaInsets {
    /**
     有导航栏
     横屏 {32, 44, 21, 44}
     竖屏 {88, 0, 34, 0}
     ---------------------
     没有导航栏
     横屏 {0, 44, 21, 44}
     竖屏  {44, 0, 34, 0}
     */
    UIEdgeInsets insets = UIEdgeInsetsZero;
    UIViewController *vc = [self WXGetCurrentViewController];
    if (@available(iOS 11.0, *)) {
        insets = vc.view.safeAreaInsets;
        //NSLog(@"safeArea = %@",NSStringFromUIEdgeInsets(insets));
        return insets;
    } else {
        return insets;
    }
}

#pragma mark - 获取当前View所在的控制器
- (UIViewController *)WXGetCurrentViewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}


@end
