//
//  LWScanViewController.m
//  OCScanAndQR
//
//  Created by 张星星 on 17/4/24.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWScanViewController.h"
#import "LWScanSystem.h"
#import "LWScanView.h"
#import "LWTools.h"
#import <AVFoundation/AVFoundation.h>
#import "LWScanResult.h"
#import "LWScanResultViewController.h"
// ====================================================================================================================================================================
#pragma mark - 扫码视图控制器私有方法和属性
@interface LWScanViewController ()

/** 扫码区域 */
@property (nonatomic,strong) LWScanView    *     scanView;
@property (nonatomic, strong) LWScanSystem *   scanSystem;

@end

// ====================================================================================================================================================================
#pragma mark - 扫码视图控制tools方法
@interface LWScanViewController (tools)

- (void)initUI;     // 初始化UI
- (void)startScan;  // 开始扫描
- (void)stopScan;   // 结束扫描
- (void)scanResultWithArray:(NSArray<LWScanResult*>*)array;

@end


// ====================================================================================================================================================================
#pragma mark - 扫码视图控制器
@implementation LWScanViewController

#pragma mark 扫码区域
- (LWScanView *)scanView {
    if (_scanView == nil) {
        _scanView = [[LWScanView alloc]initWithFrame:self.view.bounds withBgImage:self.bgImage withAnimationImage:self.animationImage];
        [_scanView startDeviceReadyingWithText:@"相机启动中"];
    }
    return _scanView;
}

#pragma mark 重写viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBar.translucent = NO;
    [self initUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.scanView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startScan];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopScan];
}

#pragma mark 打开相册
- (void)openLocalPhotoAlbum; {

}
#pragma mark 开关闪光灯
- (void)openOrCloseFlash {

}

@end

// ====================================================================================================================================================================
#pragma mark - 扫码视图控制tools方法
@implementation LWScanViewController (tools)

#pragma mark 绘制UI
- (void)initUI {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scanView];
}

#pragma mark 开始扫描
- (void)startScan {
    if ([LWTools checkCameraOrAblumAuthorityWith:UIImagePickerControllerSourceTypeCamera] == NO) {
        [self.scanView stopDeviceReadying];
        return;
    }
    
    if (self.scanSystem == nil) {
        CGRect cropRect = [self.scanView getScanRectWithPreView:self.view];
        if (_isOpenInterestRect == NO) {
            cropRect = CGRectZero;
        }
        UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        videoView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:videoView atIndex:0];
        
        __weak typeof(self) wself = self;
        self.scanSystem = [[LWScanSystem alloc] initWithPreView:videoView ObjectType:nil cropRect:cropRect success:^(NSArray<LWScanResult *> *array) {
            [wself scanResultWithArray:array];
        }];
        [self.scanSystem setTorch:self.isOpenFlash];
        [self.scanSystem setNeedCaptureImage:YES];
        
    }
    [self.scanSystem startScan];
    [self.scanView stopDeviceReadying];
    [self.scanView startScanAnimation];
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark 结束扫描
- (void)stopScan {
    [self.scanSystem stopScan];
    [self.scanView stopDeviceReadying];
    [self.scanView stopScanAniamtion];
}

- (void)scanResultWithArray:(NSArray<LWScanResult*>*)array {
    if (array.count <= 0) {
        return;
    }
    [self stopScan];
    if (self.isPrompt == YES) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); // 震动
    }
    LWScanResult *result = array.lastObject;
    LWScanResultViewController *vc = [[LWScanResultViewController alloc] init];
    vc.scanResultImage = result.scanResultImage;
    vc.scanResultType = result.scanResultType;
    vc.scanResultString = result.scanResultString;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

// ====================================================================================================================================================================
