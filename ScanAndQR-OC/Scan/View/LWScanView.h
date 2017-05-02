//
//  LWScanView.h
//  OCScanAndQR
//
//  Created by 张星星 on 17/4/23.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>

// =================================================================================================================================================================
@interface LWScanView : UIView

/**
 *   初始化扫描区域显示效果
 *
 * @param frame   位置和大小
 * @param bgImage  扫描框
 * @param animationImage  扫描动画线
 * return instancetype 返回类型
 */
- (instancetype)initWithFrame:(CGRect)frame withBgImage:(UIImage *)bgImage withAnimationImage:(UIImage *)animationImage;
/** 
 *   设置启动中文提示
 *
 * @param text  提示内容
 */
- (void)startDeviceReadyingWithText:(NSString *)text;
/** 设备启动完成 */
- (void)stopDeviceReadying;
/** 开始扫描动画 */
- (void)startScanAnimation;
/** 结束扫描动画 */
- (void)stopScanAniamtion;
/*
 *  获取矩形框内的识别区域
 *
 * @param view 视频流显示UIView
 * @parma 识别区域
 */
- (CGRect)getScanRectWithPreView:(UIView *)view;

/** 扫描视图 */
@property (nonatomic, strong) UIImageView *scanBgImageView;


@end
// =================================================================================================================================================================
