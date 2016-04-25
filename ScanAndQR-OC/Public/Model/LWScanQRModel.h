//
//  LWScanQRModel.h
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWScanQRModel : NSObject

/** 图片名字 */
@property (nonatomic,copy) NSString     *       imageName;
/** 说明 */
@property (nonatomic,copy) NSString     *       title;
/** 执行函数 */
@property (nonatomic,copy) NSString     *       style;

/** 字典转模型 */
+ (NSArray *)scanQRModelArray;

@end
