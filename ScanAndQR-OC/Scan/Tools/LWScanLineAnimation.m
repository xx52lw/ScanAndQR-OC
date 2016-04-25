//
//  LWScanLineAnimation.m
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import "LWScanLineAnimation.h"
static CGFloat margin = 5.0f;     // 动画线距扫描区域的间距
// ===================================================================================================================================================================
#pragma mark - 线性动画的View的私有属性和方法
@interface LWScanLineAnimation ()

/** 执行动画的区域 */
@property (nonatomic,assign) CGRect       animationRect;
/** 是否正在执行动画 */
@property (nonatomic,assign) BOOL         isAnimationing;
/** 向下执行动画 */
@property (nonatomic,assign) BOOL         isAnimationDown;

@end
// ===================================================================================================================================================================
#pragma mark - 线性动画的View的tools方法
@interface LWScanLineAnimation (tools)

- (void)beginAnimationing;     // 开启动画

@end
// ===================================================================================================================================================================
#pragma mark - 线性动画的View
@implementation LWScanLineAnimation

#pragma mark 重写dealloc方法
- (void)dealloc
{
    [self stopAnimating];
}

#pragma mark 开始扫描动画
- (void)startAnimatingWithFrame:(CGRect)animationFrame inView:(UIView *)superView withImage:(UIImage *)animationImage
{
    if (self.isAnimationing == YES || superView == nil)
        return;
    self.isAnimationing = YES;
    self.animationRect = animationFrame;
    self.isAnimationDown = YES;
    CGFloat x = animationFrame.origin.x + margin;
    CGFloat w = animationFrame.size.width - margin * 2;
    CGFloat y = CGRectGetMidY(animationFrame);
    CGFloat h = 2.0f;
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(x, y, w, h);
    [superView addSubview:self];
    
    [self beginAnimationing];
}

#pragma mark  停止动画
- (void)stopAnimating
{
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
@implementation LWScanLineAnimation (tools)

#pragma mark 开启动画
- (void)beginAnimationing
{
    if (self.isAnimationing == NO)
        return;
    self.isAnimationing = NO;
    CGFloat y = self.animationRect.origin.y + margin;
    CGFloat x = self.animationRect.origin.x + margin;
    CGFloat w = self.animationRect.size.width - margin * 2;
    CGFloat h = margin * 2;
    self.frame = CGRectMake(x, y, w, h);
    self.alpha = 0.0f;
    self.hidden = NO;
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.5f animations:^{
        wself.alpha = 1.0f;
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:2.0f animations:^{
           wself.frame = CGRectMake(x, y + (self.animationRect.size.height - margin), w, margin);
       } completion:^(BOOL finished) {
           wself.alpha = 0.0f;
           [wself performSelector:@selector(beginAnimationing) withObject:nil afterDelay:0.3f];
       }];
    }];
}

@end

// ===================================================================================================================================================================
