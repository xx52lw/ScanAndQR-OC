//
//  LWScanViewStyle.h
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// ====================================================================================================================================================================
/** 扫码区域的动画效果 */
typedef NS_ENUM(NSInteger,LWScanViewAnimationStyle) {
    LWScanViewAnimationStyle_LineMove, // 线条上下移动
    LWScanViewAnimationStyle_NetGrid,  // 网格样式
    LWScanViewAnimationStyle_LineStill,// 线条停止在扫码区域中央
    LWScanViewAnimationStyle_None      // 无动画
};

/** 扫码区域四个角位置类型 */
typedef NS_ENUM(NSUInteger, LWScanViewAngleStyle) {
    LWScanViewAngleStyle_Inner,  // 内嵌，一般不显示矩形框
    LWScanViewAngleStyle_Outer,  // 外嵌，包围矩形框的四个角
    LWScanViewAngleStyle_On,     // 覆盖矩形框的四个角
};
// ====================================================================================================================================================================
@interface LWScanViewStyle : NSObject

/** 扫描区域外的颜色 */
@property (nonatomic, assign) CGFloat outRetangColorRed;
@property (nonatomic, assign) CGFloat outRetangColorGreen;
@property (nonatomic, assign) CGFloat outRetangColorBlue;
@property (nonatomic, assign) CGFloat outRetangColorAlpa;



/** 是否需要绘制扫描的矩形框，默认是YES */
@property (nonatomic,assign,getter=isNeedShowRetangle) BOOL needShowRetangle;
/** 默认扫码区域是正方形，如果不是，设置宽高比, */
@property (nonatomic,assign) CGFloat    whRatio;
/** 矩形框相对中心上下移偏移量，默认是0 */
@property (nonatomic,assign) CGFloat    offsetX;
/** 矩形框的左右边距，默认60.0f */
@property (nonatomic,assign) CGFloat    lrMarign;
/** 矩形线框的颜色 */
@property (nonatomic,strong) UIColor    *     retangLineColor;

/** 四个角的类型 */
@property (nonatomic,assign) LWScanViewAngleStyle angleStyle;
/** 四个角的颜色 */
@property (nonatomic,strong) UIColor    *     angeleColor;
/** 四个角的尺寸 */
@property (nonatomic,assign) CGSize        angleSize;
/** 四角的线宽,默认是6.0f */
@property (nonatomic,assign) CGFloat    angleLineWidth;

/** 扫描动画效果 */
@property (nonatomic,assign) LWScanViewAnimationStyle animationStyle;
/** 动画图片 */
@property (nonatomic,strong) UIImage    *     animationImage;

@end
// ====================================================================================================================================================================
