//
//  LWQRTools.h
//  ScanAndQR-OC
//
//  Created by 张星星 on 2017/5/6.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// ====================================================================================================================================================================
#pragma mark - 生产二维码工具类
@interface LWQRTools : NSObject

/** 创建二维码 */
+ (UIImage *)createQRWithString:(NSString *)qrString withSize:(CGSize)qrSize;
/** 创建二维码 附带logo */
+ (UIImage *)createQRWithString:(NSString *)qrString withSize:(CGSize)qrSize withLogoImage:(UIImage *)logoImage withLogoSize:(CGSize)logoSize;
/** 生成二维码，背景色及二维码颜色 */
+ (UIImage*)createQRWithString:(NSString*)qrString withSize:(CGSize)qrSize withQRColor:(UIColor*)qrColor withBgColor:(UIColor*)bgColor;
/** 生成二维码，背景色及二维码颜色 附带logo */
+ (UIImage*)createQRWithString:(NSString*)qrString withSize:(CGSize)qrSize withQRColor:(UIColor*)qrColor withBgColor:(UIColor*)bgColor withLogoImage:(UIImage *)logoImage withLogoSize:(CGSize)logoSize;
/** 生成条形码 */
+ (UIImage *)createGenerator:(NSString *)generatorString withSize:(CGSize)generatorgSize;
/** 生成条形码 背景色及条形码颜色*/
+ (UIImage *)createGenerator:(NSString *)generatorString withSize:(CGSize)generatorgSize withColor:(UIColor*)color withBgColor:(UIColor*)bgColor;
/** 生成圆角图片 */
+ (UIImage *)roundedCornerImageWithImage:(UIImage*)image withCornerRadius:(CGFloat)cornerRadius withBoderWidth:(CGFloat)boderWidth withBorderColor:(UIColor *)borderColor;

@end
// ====================================================================================================================================================================
