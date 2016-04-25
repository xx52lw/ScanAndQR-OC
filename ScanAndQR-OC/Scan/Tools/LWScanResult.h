//
//  LWScanResult.h
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/24.
//  Copyright © 2016年 LW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// ====================================================================================================================================================================

@interface LWScanResult : NSObject

/** 扫码字符串 */
@property (nonatomic,copy) NSString     *       scanResultString;
/** 扫码图像 */
@property (nonatomic,strong) UIImage    *     scanResultImage;
/** 扫码的类型 */
@property (nonatomic,copy) NSString     *       scanResultType;

@end
// ====================================================================================================================================================================

