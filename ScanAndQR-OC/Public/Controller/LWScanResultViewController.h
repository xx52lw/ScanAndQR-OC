//
//  LWScanResultViewController.h
//  ScanAndQR-OC
//
//  Created by liwei on 2017/5/2.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWScanResultViewController : UIViewController

/** 扫码字符串 */
@property (nonatomic,copy) NSString     *       scanResultString;
/** 扫码图像 */
@property (nonatomic,strong) UIImage    *     scanResultImage;
/** 扫码的类型 */
@property (nonatomic,copy) NSString     *       scanResultType;

@end
