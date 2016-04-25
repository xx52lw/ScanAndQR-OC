//
//  LWScanViewStyle.m
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import "LWScanViewStyle.h"
// ====================================================================================================================================================================
@implementation LWScanViewStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.outRetangColorRed   = 0.0f;
        self.outRetangColorGreen = 0.0f;
        self.outRetangColorBlue  = 0.0f;
        self.outRetangColorAlpa  = 0.5f;
        self.needShowRetangle    = YES;
        self.whRatio             = 1.0f;
        self.retangLineColor     = [UIColor whiteColor];
        self.offsetX             = 0.0f;
        self.lrMarign            = 60.0f;
        self.animationStyle      = LWScanViewAnimationStyle_LineMove;
        self.angleStyle          = LWScanViewAngleStyle_Outer;
        self.angeleColor         = [UIColor colorWithRed:0/255.0f green:167/255.0f blue:231/255.0f alpha:1.0f];
        self.angleSize           = CGSizeMake(24.0f, 24.0f);
        self.angleLineWidth      = 7.0f;
    }
    return self;
}

@end
// ====================================================================================================================================================================
