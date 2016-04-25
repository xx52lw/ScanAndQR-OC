//
//  LWScanLineAnimation.h
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>
// ====================================================================================================================================================================
@interface LWScanLineAnimation : UIImageView

/** 
 * 开始扫描动画
 *
 * @param animationFrame 显示扫描的区域
 * @param supView        动画显示的view
 * @param animationImage 动画的图片
 *
 */
- (void)startAnimatingWithFrame:(CGRect)animationFrame inView:(UIView *)superView withImage:(UIImage *)animationImage;

/** 停止动画 */
- (void)stopAnimating;

@end
// ====================================================================================================================================================================
