//
//  LWScanViewController.h
//  OCScanAndQR
//
//  Created by 张星星 on 17/4/24.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>

// ====================================================================================================================================================================

@interface LWScanViewController : UIViewController


/** 扫描框 */
@property (nonatomic, strong) UIImage            *   bgImage;
/** 扫描动画线 */
@property (nonatomic, strong) UIImage            *   animationImage;
/** 是否开启区域识别功能 */
@property (nonatomic,assign) BOOL       isOpenInterestRect;
/** 是否开启闪光灯 */
@property (nonatomic,assign) BOOL       isOpenFlash;
/** 是否需要结果提示 */
@property (nonatomic,assign)BOOL   isPrompt;
/** 打开相册 */
- (void)openLocalPhotoAlbum;
/** 开关闪光灯 */
- (void)openOrCloseFlash;

@end

// ====================================================================================================================================================================
