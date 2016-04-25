//
//  LWScanSystem.h
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/24.
//  Copyright © 2016年 LW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LWScanResult;

// ====================================================================================================================================================================

@interface LWScanSystem : NSObject

/**
 @brief   初始化采集相机
 @param preView 视频显示区域
 @param objType 识别码类型：如果为nil，默认支持很多类型
 @param cropRect 识别区域，值CGRectZero 全屏识别
 @param block   识别结果
 @return    LWScanSystem的实例
 */
- (instancetype)initWithPreView:(UIView *)preView ObjectType:(NSArray *)objType cropRect:(CGRect)cropRect success:(void(^)(NSArray<LWScanResult *> *array))block;
/** 
 @brief   设置扫码成功后是否拍照
 @param   isNeedCaptureImage  YES:拍照  NO：不拍照
 */
- (void)setNeedCaptureImage:(BOOL)inNeedCaptureImage;
/** 开始扫码 */
- (void)startScan;
/** 停止扫码 */
- (void)stopScan;
/** 设置闪光灯 */
- (void)setTorch:(BOOL)torch;
/** 开关闪光灯 */
- (void)changeTorch;
/**
 @brief 修改扫码类型：二维码，条形码
 @param objType,类型数组
 */
- (void)changeScanType:(NSArray *)objTypes;

/** 
 @brief  调整摄像头焦距
 @param  scale 系数
 */
- (void)setVideoScale:(CGFloat)scale;

@end
// ====================================================================================================================================================================

