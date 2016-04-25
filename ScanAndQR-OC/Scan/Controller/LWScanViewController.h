//
//  LWScanViewController.h
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/24.
//  Copyright © 2016年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWScanView.h"
@class LWScanViewStyle;
// ====================================================================================================================================================================

@interface LWScanViewController : UIViewController


@property (nonatomic,assign) LWScanViewStyle   * scanViewStyle;
/** 扫码当前图片 */
@property (nonatomic,strong) UIImage    *     scanImage;
/** 是否开启区域识别功能 */
@property (nonatomic,assign) BOOL       isOpenInterestRect;
/** 是否开启闪光灯 */
@property (nonatomic,assign) BOOL       isOpenFlash;
/** 打开相册 */
- (void)openLocalPhotoAlbum;
/** 开关闪光灯 */
- (void)openOrCloseFlash;


@end

// ====================================================================================================================================================================
