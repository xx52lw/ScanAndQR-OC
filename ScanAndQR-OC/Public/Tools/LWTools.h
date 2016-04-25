//
//  LWTools.h
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LWTools : NSObject

/** 根据图片名和所在bundle获取图片 */
+ (UIImage *)iamgeName:(NSString *)imageName withBundleName:(NSString *)bundleName;

/** 检查相机或者相册是否可用 */
+ (BOOL)checkCameraOrAblumAuthorityWith:(UIImagePickerControllerSourceType) souceType;

@end
