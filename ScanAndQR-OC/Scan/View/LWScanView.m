//
//  LWScanView.m
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import "LWScanView.h"
#import "LWScanLineAnimation.h"
#import "LWScanNetAnimation.h"
#import "LWScanViewStyle.h"
// =================================================================================================================================================================
#pragma mark - 扫码显示视图私有属性和方法
@interface LWScanView ()

/** 扫描区域 */
@property (nonatomic,assign) CGRect                  scanRetangRect;
/** 扫码区域类型 */
@property (nonatomic,strong) LWScanViewStyle      *   scanViewStyle;
/** 线性动画 */
@property (nonatomic,strong) LWScanLineAnimation  *  scanLineAnimation;
/** 网格动画 */
@property (nonatomic,strong) LWScanNetAnimation   *  scanNetAnimation;
/** 线条在中间位置保持不动 */
@property (nonatomic,strong) UIImageView          *  scanLineStill;
/** 启动相机时 提示文字 */
@property (nonatomic,strong) UILabel              *  labelReadying;
/** 启动相机时 菊花等待 */
@property (nonatomic,strong) UIActivityIndicatorView    * activityView;

@end

// =================================================================================================================================================================
#pragma mark - 扫码显示视图tools方法
@interface LWScanView (tools)

- (void)drawScanRect;  // 绘制扫描区域

@end

// =================================================================================================================================================================
#pragma mark - 扫码显示视图
@implementation LWScanView

- (instancetype)initWithFrame:(CGRect)frame style:(LWScanViewStyle *)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scanViewStyle = style;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark 重写drawRect:方法
- (void)drawRect:(CGRect)rect
{
    [self drawScanRect];
}

#pragma mark -  设置启动中文提示
- (void)startDeviceReadyingWithText:(NSString *)text;
{
    CGFloat retangleLeft = self.scanViewStyle.lrMarign;
    CGFloat retangleWH = self.frame.size.width - retangleLeft * 2;
    CGSize sizeRetangle  = CGSizeMake(retangleWH, retangleWH);
    if (self.scanViewStyle.whRatio != 1.0f) {
        CGFloat h = retangleWH / self.scanViewStyle.whRatio;
        sizeRetangle = CGSizeMake(retangleWH, h);
    }
    CGFloat scanViewTop = (self.frame.size.height - sizeRetangle.height) * 0.5f - self.scanViewStyle.offsetX;
    // 设备启动状态提醒
    if (self.activityView == nil) {
        // 菊花圈
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 30.0f)];
        CGFloat x = retangleLeft + sizeRetangle.width * 0.5f  - 50;
        CGFloat y = scanViewTop + sizeRetangle.height * 0.5f;
        self.activityView.center = CGPointMake(x, y);
        self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:self.activityView];
        // 提示文字
        x = self.activityView.frame.origin.x + self.activityView.frame.size.width;
        y = self.activityView.frame.origin.y;
        CGFloat w = 100.0f;
        CGFloat h = 30.0f;
        CGRect labelReadyRect = CGRectMake(x, y, w, h);
        self.labelReadying = [[UILabel alloc]initWithFrame:labelReadyRect];
        self.labelReadying.backgroundColor = [UIColor clearColor];
        self.labelReadying.textColor = [UIColor whiteColor];
        self.labelReadying.font = [UIFont systemFontOfSize:18.0f];
        self.labelReadying.text = text;
        [self addSubview:self.labelReadying];
        // 开始转圈
        [self.activityView startAnimating];
        
    }
}
#pragma mark  设备启动完成
- (void)stopDeviceReadying
{
    if (self.activityView != nil) {
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        [self.labelReadying removeFromSuperview];
        self.activityView = nil;
        self.labelReadying = nil;
    }
}
#pragma mark 开始扫描动画
- (void)startScanAnimation
{
    switch (self.scanViewStyle.animationStyle) {
        case LWScanViewAnimationStyle_LineMove: // 线动画
        {
            if (_scanLineAnimation == nil) {
                _scanLineAnimation = [[LWScanLineAnimation alloc]init];
                [_scanLineAnimation startAnimatingWithFrame:self.scanRetangRect inView:self withImage:self.scanViewStyle.animationImage];
            }
        }
            break;
        case LWScanViewAnimationStyle_NetGrid:  // 网格动画
        {
            if (_scanNetAnimation == nil) {
                _scanNetAnimation = [[LWScanNetAnimation alloc]init];
                [_scanNetAnimation startAnimatingWithFrame:self.scanRetangRect inView:self withImage:self.scanViewStyle.animationImage];
            }
        }
            break;
        case LWScanViewAnimationStyle_LineStill: // 静止动画
        {
            if (_scanLineStill == nil) {
                CGFloat x = self.scanRetangRect.origin.x + 10.0f;
                CGFloat y = self.scanRetangRect.origin.y + self.scanRetangRect.size.height * 0.5f;
                CGFloat w = self.scanRetangRect.size.width - 10.0f * 2;
                CGFloat h = 2;
                CGRect rect = CGRectMake(x, y, w, h);
                _scanLineStill = [[UIImageView alloc]initWithFrame:rect];
                _scanLineStill.image = self.scanViewStyle.animationImage;
                _scanLineStill.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:_scanLineStill];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark 结束扫描动画
- (void)stopScanAniamtion
{
    if (_scanLineAnimation)
        [_scanLineAnimation stopAnimating];
    if (_scanNetAnimation)
        [_scanNetAnimation stopAnimating];
    if (_scanLineStill)
        [_scanLineStill removeFromSuperview];
}

#pragma mark 获取矩形框内的识别区域
+ (CGRect)getScanRectWithPreView:(UIView *)view style:(LWScanViewStyle *)style
{
    CGFloat retangleLeft = style.lrMarign;
    CGFloat retangleWH = view.frame.size.width - retangleLeft * 2;
    CGSize sizeRetangle  = CGSizeMake(retangleWH, retangleWH);
    if (style.whRatio != 1.0f) {
        CGFloat h = retangleWH / style.whRatio;
        sizeRetangle = CGSizeMake(retangleWH, h);
    }
    // 计算扫码区域
    CGFloat scanViewTop = (view.frame.size.height - sizeRetangle.height) * 0.5f - style.offsetX;
    CGFloat scanViewLeft = view.frame.size.width - retangleLeft;
    CGRect scanRetangRect = CGRectMake(scanViewLeft, scanViewTop, sizeRetangle.width, sizeRetangle.height);
    // 计算兴趣区域（http://www.cocoachina.com/ios/20141225/10763.html）
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
- (void)drawScanRect
{
    CGFloat retangleLeft = self.scanViewStyle.lrMarign;
    CGFloat retangleWH = self.frame.size.width - retangleLeft * 2;
    CGSize sizeRetangle  = CGSizeMake(retangleWH, retangleWH);
    if (self.scanViewStyle.whRatio != 1.0f) {
        CGFloat h = retangleWH / self.scanViewStyle.whRatio;
        sizeRetangle = CGSizeMake(retangleWH, h);
    }
    // 扫码区域的边界
    CGFloat scanViewTop = (self.frame.size.height - sizeRetangle.height) * 0.5f - self.scanViewStyle.offsetX;
    CGFloat scanViewBottom = scanViewTop + sizeRetangle.height;
    CGFloat scanViewLeft = self.frame.size.width - retangleLeft;
    CGFloat scanViewRight = scanViewLeft + sizeRetangle.width;
    // 开启图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 非扫码区域半透明
    // 设置非识别区域颜色
    CGContextSetRGBFillColor(context, self.scanViewStyle.outRetangColorRed, self.scanViewStyle.outRetangColorGreen, self.scanViewStyle.outRetangColorBlue, self.scanViewStyle.outRetangColorAlpa);
    // 填空矩形
    // 扫码区域top
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, scanViewTop);
    CGContextFillRect(context, rect);
    // 扫码区域left
    rect = CGRectMake(0, scanViewTop, scanViewLeft, sizeRetangle.height);
    CGContextFillRect(context, rect);
    // 扫码区域right
    rect = CGRectMake(scanViewRight, scanViewTop, scanViewLeft, sizeRetangle.height);
    CGContextFillRect(context, rect);
    // 扫码区域bottom
    rect = CGRectMake(0, scanViewBottom, self.frame.size.width, self.frame.size.height - scanViewBottom);
    CGContextFillRect(context, rect);
    // 执行绘画
    CGContextStrokePath(context);
    
    self.scanRetangRect = CGRectMake(scanViewLeft, scanViewTop, sizeRetangle.width, sizeRetangle.height);
    if (self.scanViewStyle.isNeedShowRetangle) {
        // 中间画矩形
        CGContextSetStrokeColorWithColor(context, self.scanViewStyle.retangLineColor.CGColor);
        CGContextSetLineWidth(context, 1.0f);
        CGContextAddRect(context, self.scanRetangRect);
        CGContextStrokePath(context);
    }
    // 画矩形框四个外围相框角
    // 相框角的宽度和高度
    CGFloat angelWidth = self.scanViewStyle.angleSize.width;
    CGFloat angleHeight = self.scanViewStyle.angleSize.height;
    CGFloat angelLineWidth = self.scanViewStyle.angleLineWidth;
    // 直角的坐标
    CGFloat angle = 0.0f;
    switch (self.scanViewStyle.angleStyle) {
        case LWScanViewAngleStyle_Outer: // 框外四个角
            angle = angelLineWidth / 2.0f;
            break;
        case LWScanViewAngleStyle_On:    // 框上
            angle = 0.0f;
            break;
         case LWScanViewAngleStyle_Inner: // 框外
            angle = -angelLineWidth / 2.0f;
            break;
        default:
            angle = angelLineWidth / 2.0f;
            break;
    }
    // 角线颜色
    CGContextSetStrokeColorWithColor(context, self.scanViewStyle.angeleColor.CGColor);
    // 角线宽
    CGContextSetLineWidth(context, angelLineWidth);
    CGFloat angleTop    = scanViewTop - angle;
    CGFloat angelLeft   = scanViewLeft - angle;
    CGFloat angleRight  = scanViewRight + angle;
    CGFloat angelBottom = scanViewBottom + angle;
    
    CGContextSetLineCap(context, kCGLineCapSquare);
    // 左上角
    CGContextMoveToPoint(context, angelLeft + angelWidth, angleTop);
    CGContextAddLineToPoint(context, angelLeft - angelLineWidth * 0.5f, angleTop);
    CGContextAddLineToPoint(context, angelLeft - angelLineWidth * 0.5f, angleTop - angleHeight * 0.5f);
    // 右上角
    CGContextMoveToPoint(context, angleRight + angelLineWidth * 0.5f, angleTop);
    CGContextAddLineToPoint(context, angleRight - angelWidth, angleTop);
    CGContextMoveToPoint(context, angleRight, angleTop - angelLineWidth * 0.5f);
    CGContextAddLineToPoint(context, angleRight, angleTop + angleHeight);
    // 左下角
    CGContextMoveToPoint(context, angelLeft - angelLineWidth * 0.5f, angelBottom);
    CGContextAddLineToPoint(context, angelLeft + angelWidth, angelBottom);
    CGContextMoveToPoint(context, angelLeft , angelBottom + angelLineWidth * 0.5f);
    CGContextAddLineToPoint(context, angelLeft, angelBottom + angleHeight);
    // 右下角
    CGContextMoveToPoint(context, angleRight + angelLineWidth * 0.5f, angelBottom);
    CGContextAddLineToPoint(context, angleRight - angelWidth, angelBottom);
    CGContextMoveToPoint(context, angleRight , angelBottom + angelLineWidth * 0.5f);
    CGContextAddLineToPoint(context, angleRight, angelBottom - angleHeight);
    
    CGContextStrokePath(context);
    // 关闭上下文
    CGContextRelease(context);
}

@end

// =================================================================================================================================================================
