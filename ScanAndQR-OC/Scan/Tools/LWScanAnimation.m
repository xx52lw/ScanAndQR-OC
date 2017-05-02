//
//  LWScanAnimation.m
//  OCScanAndQR
//
//  Created by 张星星 on 17/4/23.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWScanAnimation.h"
static CGFloat margin = 5.0f;     // 动画线距扫描区域的间距
// ===================================================================================================================================================================
#pragma mark - 线性动画的View的私有属性和方法
@interface LWScanAnimation ()

/** 执行动画的区域 */
@property (nonatomic,assign) CGRect       animationRect;
/** 是否正在执行动画 */
@property (nonatomic,assign) BOOL         isAnimationing;
/** 向下执行动画 */
@property (nonatomic,assign) BOOL         isAnimationDown;

@end
// ===================================================================================================================================================================
#pragma mark - 线性动画的View的tools方法
@interface LWScanAnimation (tools)

- (void)beginAnimationing;     // 开启动画

@end
// ===================================================================================================================================================================
#pragma mark - 线性动画的View
@implementation LWScanAnimation

#pragma mark 重写dealloc方法
- (void)dealloc {
    [self stopAnimating];
}

#pragma mark 开始扫描动画
- (void)startAnimatingWithFrame:(CGRect)animationFrame inView:(UIView *)superView withImage:(UIImage *)animationImage {
    if (self.isAnimationing == YES || superView == nil)
        return;
    self.image = animationImage;
    self.isAnimationing = YES;
    self.animationRect = animationFrame;
    self.isAnimationDown = YES;
    CGFloat h = animationImage.size.height;
    CGFloat w = animationImage.size.width;
    CGFloat x = CGRectGetMidX(self.animationRect) - w / 2;
    CGFloat y = CGRectGetMinY(self.animationRect) - h;
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(x, y, w, h);
    [superView addSubview:self];
    
    [self beginAnimationing];
}

#pragma mark  停止动画
- (void)stopAnimating {
    if (self.isAnimationing == YES) {
        self.isAnimationing = NO;
        self.hidden = YES;
        [self removeFromSuperview];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
// ===================================================================================================================================================================
#pragma mark - 线性动画的View的tools方法实现
@implementation LWScanAnimation (tools)

#pragma mark 开启动画
- (void)beginAnimationing {
    if (self.isAnimationing == NO)
        return;
    CGFloat x = self.frame.origin.x;
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGFloat y = CGRectGetMinY(self.animationRect) - h;
    self.frame = CGRectMake(x, y, w, h);
    self.alpha = 0.0f;
    self.hidden = NO;
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.5f animations:^{
        wself.alpha = 1.0f;
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:2.0f animations:^{
           wself.frame = CGRectMake(x, CGRectGetMaxY(self.animationRect) - h, w, h);
       } completion:^(BOOL finished) {
           wself.alpha = 0.0f;
           [wself performSelector:@selector(beginAnimationing) withObject:nil afterDelay:0.3f];
       }];
    }];
}

@end

// ===================================================================================================================================================================
