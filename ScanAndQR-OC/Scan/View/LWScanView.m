//
//  LWScanView.m
//  OCScanAndQR
//
//  Created by 张星星 on 17/4/23.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWScanView.h"
#import "LWTools.h"
#import "LWScanAnimation.h"
// =================================================================================================================================================================
#pragma mark - 扫码显示视图私有属性和方法
@interface LWScanView ()

/** 扫描区域 */
@property (nonatomic,assign) CGRect                  scanRetangRect;
/** 线性动画 */
@property (nonatomic,strong) LWScanAnimation  *  scanLineAnimation;
/** 线条在中间位置保持不动 */
@property (nonatomic,strong) UIImageView          *  scanLineStill;
/** 启动相机时 提示文字 */
@property (nonatomic,strong) UILabel              *  labelReadying;
/** 启动相机时 菊花等待 */
@property (nonatomic,strong) UIActivityIndicatorView    * activityView;
/** 扫描框 */
@property (nonatomic, strong) UIImage            *   bgImage;
/** 扫描动画线 */
@property (nonatomic, strong) UIImage            *   animationImage;

@end

// =================================================================================================================================================================
#pragma mark - 扫码显示视图tools方法
@interface LWScanView (tools)

- (void)drawScanRect;  // 绘制扫描区域

@end

// =================================================================================================================================================================
#pragma mark - 扫码显示视图
@implementation LWScanView


- (UIImageView *)scanBgImageView {
    if (_scanBgImageView == nil) {
        _scanBgImageView = [[UIImageView alloc] initWithImage:self.bgImage];
        _scanBgImageView.backgroundColor = [UIColor clearColor];
    }
    return _scanBgImageView;
}

- (instancetype)initWithFrame:(CGRect)frame withBgImage:(UIImage *)bgImage withAnimationImage:(UIImage *)animationImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.bgImage = bgImage;
        self.animationImage = animationImage;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scanBgImageView];
    }
    return self;
}

#pragma mark 重写drawRect:方法
- (void)drawRect:(CGRect)rect {
    [self drawScanRect];
}

#pragma mark -  设置启动中文提示
- (void)startDeviceReadyingWithText:(NSString *)text  {
    // 设备启动状态提醒
    if (self.activityView == nil) {
        // 提示文字
        self.labelReadying = [[UILabel alloc]init];
        self.labelReadying.backgroundColor = [UIColor clearColor];
        self.labelReadying.textColor = [UIColor whiteColor];
        self.labelReadying.font = [UIFont systemFontOfSize:18.0f];
        self.labelReadying.text = text;
        [self.labelReadying sizeToFit];
        [self addSubview:self.labelReadying];
        // 菊花圈
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 30.0f)];
        CGFloat x = (self.frame.size.width - self.activityView.frame.size.width - self.labelReadying.frame.size.width) / 2;
        CGFloat y = CGRectGetMidY(self.frame);
        self.activityView.center = CGPointMake(x, y);
        self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:self.activityView];
        self.labelReadying.center = CGPointMake(CGRectGetMaxX(self.activityView.frame) + self.labelReadying.frame.size.width / 2, self.activityView.center.y);
        // 开始转圈
        [self.activityView startAnimating];
        
    }
}
#pragma mark  设备启动完成
- (void)stopDeviceReadying {
    if (self.activityView != nil) {
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        [self.labelReadying removeFromSuperview];
        self.activityView = nil;
        self.labelReadying = nil;
    }
}
#pragma mark 开始扫描动画
- (void)startScanAnimation {
    if (_scanLineAnimation == nil) {
        _scanLineAnimation = [[LWScanAnimation alloc]init];
        [_scanLineAnimation startAnimatingWithFrame:self.scanRetangRect inView:self withImage:self.animationImage];
    }
}

#pragma mark 结束扫描动画
- (void)stopScanAniamtion {
    if (_scanLineAnimation) {
        [_scanLineAnimation stopAnimating];
        _scanLineAnimation = nil;
    }

}

#pragma mark 获取矩形框内的识别区域
- (CGRect)getScanRectWithPreView:(UIView *)view {

    CGRect scanRetangRect = self.scanRetangRect;

    CGRect interestRect = CGRectZero;
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    CGFloat w = 0.0f;
    CGFloat h = 0.0f;
    CGSize size = view.bounds.size;
    CGFloat p1 = size.height / size.width;
    CGFloat p2 = 1920.0f / 1080.0f; // 使用 1920 * 1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight  = (size.width * 1920.0f) / 1080.0f;
        CGFloat fixPadding = (fixHeight - size.height) * 0.5f; // 修正后填充区域
        y = (scanRetangRect.origin.y + fixPadding) / fixHeight;
        x = scanRetangRect.origin.x / size.width;
        h = scanRetangRect.size.height / fixHeight;
        w = scanRetangRect.size.width / size.width;
        interestRect = CGRectMake(y, x, h, w);  // 输出 AVCapture输出的图片大小都是旋转90°的
    }
    else {
        CGFloat fixWidth  = (size.height * 1080.0f) / 1920.0f;
        CGFloat fixPadding = (fixWidth - size.width) * 0.5f; // 修正后填充区域
        y = scanRetangRect.origin.y / size.height;
        x = (scanRetangRect.origin.x + fixPadding) / fixWidth;
        h = scanRetangRect.size.height / size.height;
        w = scanRetangRect.size.width / fixWidth;
        interestRect = CGRectMake(y, x, h, w);  // 输出 AVCapture输出的图片大小都是旋转90°的
    }
    
    return interestRect;
}

@end
// =================================================================================================================================================================
#pragma mark - 扫码显示视图tools方法实现
@implementation LWScanView (tools)

#pragma mark 绘制扫描区域
- (void)drawScanRect {
    
    CGFloat retangleWH = self.scanBgImageView.frame.size.width;
    CGSize sizeRetangle  = CGSizeMake(retangleWH, retangleWH);
    // 扫码区域的边界
    CGFloat y = CGRectGetMidY(self.frame) - sizeRetangle.height / 2;
    CGFloat x = (self.frame.size.width - retangleWH) / 2;
    self.scanBgImageView.frame = CGRectMake(x, y, sizeRetangle.width, sizeRetangle.height);
    self.scanRetangRect = self.scanBgImageView.frame;
}

@end

// =================================================================================================================================================================
