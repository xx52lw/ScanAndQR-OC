//
//  LWScanView.h
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LWScanViewStyle;

// =================================================================================================================================================================
@interface LWScanView : UIView

/**
 *   初始化扫描区域显示效果
 *
 * @param frame  位置和大小
 * @param style  类型
 *
 * return instancetype 返回类型
 */
- (instancetype)initWithFrame:(CGRect)frame style:(LWScanViewStyle *)style;
/** 
 *   设置启动中文提示
 *
 * @param text  提示内容
 *
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
 * @parma style 效果界面参数
 *
 * @parma 识别区域
 */
+ (CGRect)getScanRectWithPreView:(UIView *)view style:(LWScanViewStyle *)style;

@end
// =================================================================================================================================================================
