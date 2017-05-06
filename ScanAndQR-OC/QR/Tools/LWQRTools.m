//
//  LWQRTools.m
//  ScanAndQR-OC
//
//  Created by 张星星 on 2017/5/6.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWQRTools.h"

// ====================================================================================================================================================================
#pragma mark - 生产二维码工具类tools
@interface LWQRTools (tools)

/** 图片添加图片 */
+ (UIImage *)addImageWithOldImage:(UIImage *)oldImage withImage:(UIImage *)image drawInRect:(CGRect)rect;

@end
// ====================================================================================================================================================================
#pragma mark - 生产二维码工具类
@implementation LWQRTools

#pragma mark 创建二维码
+ (UIImage *)createQRWithString:(NSString *)qrString withSize:(CGSize)qrSize {
    return [self createQRWithString:qrString withSize:qrSize withLogoImage:nil withLogoSize:CGSizeZero];
}
#pragma mark 创建二维码 附带logo
+ (UIImage *)createQRWithString:(NSString *)qrString withSize:(CGSize)qrSize withLogoImage:(UIImage *)logoImage withLogoSize:(CGSize)logoSize {
    return [self createQRWithString:qrString withSize:qrSize withQRColor:[UIColor blackColor] qrSizeQRBgColor:[UIColor whiteColor] withLogoImage:logoImage withLogoSize:logoSize];
}
#pragma mark 生成二维码，背景色及二维码颜色
+ (UIImage*)createQRWithString:(NSString*)qrString withSize:(CGSize)qrSize withQRColor:(UIColor*)qrColor qrSizeQRBgColor:(UIColor*)bgColor {
    return [self createQRWithString:qrString withSize:qrSize withQRColor:qrColor qrSizeQRBgColor:bgColor withLogoImage:nil withLogoSize:CGSizeZero];
}
#pragma mark 生成二维码，背景色及二维码颜色 附带logo
+ (UIImage*)createQRWithString:(NSString*)qrString withSize:(CGSize)qrSize withQRColor:(UIColor*)qrColor qrSizeQRBgColor:(UIColor*)bgColor withLogoImage:(UIImage *)logoImage withLogoSize:(CGSize)logoSize {
    if (qrSize.width * qrSize.height <= 0) {
        return [[UIImage alloc] init];
    }
    NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bgColor.CGColor],
                             nil];
    CIImage *qrImage = colorFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(qrSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    CGImageRelease(cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (logoImage != nil && logoSize.width * logoSize.height > 0) {
        if (logoSize.width > qrSize.width / 4) { // 最大四分之一比较合适
            logoSize = CGSizeMake(qrSize.width / 5, (logoSize.height / logoSize.width) * (qrSize.width / 5));
        }
        return [self addImageWithOldImage:codeImage withImage:logoImage drawInRect:CGRectMake((qrSize.width - logoSize.width) / 2, (qrSize.height - logoSize.height) / 2, logoSize.width, logoSize.height)];
    }
    return codeImage;

}

#pragma mark 生成圆角图片
+ (UIImage *)roundedCornerImageWithImage:(UIImage*)image withCornerRadius:(CGFloat)cornerRadius withBoderWidth:(CGFloat)boderWidth withBorderColor:(UIColor *)borderColor {
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    // 防止圆角半径小于0，或者大于宽/高中较小值的一半。
    if (cornerRadius < 0) {
        cornerRadius = 0;
    }
    else if (cornerRadius > MIN(w, h)) {
        cornerRadius = MIN(w, h) / 2;
    }
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, w, h) cornerRadius:cornerRadius];
    path.lineWidth = boderWidth;
    [borderColor set];
    [path fill];
    CGRect imageFrame = CGRectMake(boderWidth, boderWidth, w - boderWidth * 2, h - boderWidth * 2);
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:cornerRadius];
    [path2 addClip];
    [image drawInRect:imageFrame];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
// ====================================================================================================================================================================
#pragma mark - 生产二维码工具类tools
@implementation LWQRTools (tools)
#pragma mark 图片添加图片
+ (UIImage *)addImageWithOldImage:(UIImage *)oldImage withImage:(UIImage *)image drawInRect:(CGRect)rect {
    UIGraphicsBeginImageContext(oldImage.size);
    [oldImage drawInRect:CGRectMake(0, 0, oldImage.size.width, oldImage.size.height)];
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark --UIImage 圆角



@end
// ====================================================================================================================================================================
