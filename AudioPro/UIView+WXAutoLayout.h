//
//  UIView+WXAutoLayout.h
//  WXStatisticsPanel
//
//  Created by tianlong on 2018/8/24.
//  Copyright © 2018年 tianlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WXAutoLayout)

/*
 自动缩放
 用法：
 self.view.AutoFitWidth(100);
 self.view.FreeAutoFitHeight(CGSizeMake(375, 667),100);
 */

#pragma mark - 设计参照标准：手机：375x667 iPad：768x1024
- (CGFloat(^)(CGFloat design))AutoFitTop;
- (CGFloat(^)(CGFloat design))AutoFitLeft;
- (CGFloat(^)(CGFloat design))AutoFitRight;
- (CGFloat(^)(CGFloat design))AutoFitWidth;
- (CGFloat(^)(CGFloat design))AutoFitHeight;
- (CGFloat(^)(CGFloat design))AutoFitBottom;
- (CGFloat(^)(CGFloat design))AutoFitFontSize;

#pragma mark - 自定义设计参照标准
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitWidth;
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitHeight;
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitTop;
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitBottom;
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitLeft;
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitRight;
- (CGFloat(^)(CGSize referSize, CGFloat design))FreeAutoFitFontSize;


/** 根据传入的参照标准获取宽度缩放比例 */
- (CGFloat(^)(CGFloat refer))AutoFitWidthScale;
/** 根据传入的参考标准获取高度缩放比例 */
- (CGFloat(^)(CGFloat refer))AutoFitHeightScale;
/** 获取当前屏幕宽度 */
- (CGFloat)WXGetCurrentScreenWidth;
/** 获取当前屏幕高度 */
- (CGFloat)WXGetCurrentScreenHeight;
/** 获取视图保护区域 */
- (UIEdgeInsets)WXGetViewSafeAreaInsets;
/** 是否是横屏 */
- (BOOL)WXISLandscape;
- (BOOL)WXISIphoneX;
@end
