//
//  LWScanViewController.m
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/24.
//  Copyright © 2016年 LW. All rights reserved.
//

#import "LWScanViewController.h"
#import "LWTools.h"
// ====================================================================================================================================================================
#pragma mark - 扫码视图控制器私有方法和属性
@interface LWScanViewController ()

/** 扫码区域 */
@property (nonatomic,strong) LWScanView    *     scanView;

@end

// ====================================================================================================================================================================
#pragma mark - 扫码视图控制tools方法
@interface LWScanViewController (tools)

- (void)initUI;    // 初始化UI
- (void)startScan;  // 开始扫描

@end


// ====================================================================================================================================================================
#pragma mark - 扫码视图控制器
@implementation LWScanViewController

#pragma mark 扫码区域
- (LWScanView *)scanView
{
    if (_scanView == nil) {
        _scanView = [[LWScanView alloc]initWithFrame:self.view.bounds style:self.scanViewStyle];
        _scanView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_scanView startDeviceReadyingWithText:@"相机启动中"];
    }
    return _scanView;
}

#pragma mark 重写viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

#pragma mark 重写viewWillLayoutSubviews
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.view addSubview:self.scanView];
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.3f];
}

#pragma mark 打开相册
- (void)openLocalPhotoAlbum;
{

}
#pragma mark 开关闪光灯
- (void)openOrCloseFlash
{

}

@end

// ====================================================================================================================================================================
#pragma mark - 扫码视图控制tools方法
@implementation LWScanViewController (tools)

#pragma mark 绘制UI
- (void)initUI
{
    self.view.backgroundColor = [UIColor blackColor];
}

#pragma mark 开始扫描
- (void)startScan
{
    if ([LWTools checkCameraOrAblumAuthorityWith:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
        [self.scanView stopDeviceReadying];
        return;
    }
    
}

@end

// ====================================================================================================================================================================