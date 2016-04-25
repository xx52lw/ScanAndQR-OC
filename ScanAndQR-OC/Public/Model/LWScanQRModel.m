//
//  LWScanQRModel.m
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import "LWScanQRModel.h"

// ====================================================================================================================================================================

@implementation LWScanQRModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray *)scanQRModelArray {
    NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"scanQRList.plist" ofType:nil]];
    NSMutableArray *appArray = [NSMutableArray array];
    for (NSDictionary *dict in dictArray) {
        LWScanQRModel *app = [[self alloc]initWithDict:dict];
        [appArray addObject:app];
    }
    return appArray;
}

@end
// ====================================================================================================================================================================
