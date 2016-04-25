//
//  LWScanQRCollectionViewCell.h
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LWScanQRModel;

// ====================================================================================================================================================================
@interface LWScanQRCollectionViewCell : UICollectionViewCell

/** 图片 */
@property (nonatomic,strong) UIImageView    *     imageView;
/** 说明 */
@property (nonatomic,strong) UILabel        *     titelLabel;
/** 模型数据 */
@property (nonatomic,strong) LWScanQRModel    *     model;

@end

// ====================================================================================================================================================================