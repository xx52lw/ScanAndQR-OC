//
//  LWScanSystem.m
//  OCScanAndQR
//
//  Created by 张星星 on 17/4/24.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWScanSystem.h"
#import "LWScanResult.h"
#import <AVFoundation/AVFoundation.h>

// ====================================================================================================================================================================
#pragma mark 系统扫描的私有方法和属性
@interface LWScanSystem ()
/** 是否需要拍照 */
@property (nonatomic,assign) BOOL                                  isNeedCaptureImage;
/** 焦点 */
@property (nonatomic,assign) CGFloat                               scale;
/** 设备 */
@property (nonatomic,strong) AVCaptureDevice                 *     device;
/** 捕捉设备输入媒体 */
@property (nonatomic,strong) AVCaptureDeviceInput            *     input;
/** 输出数据 */
@property (nonatomic,strong) AVCaptureMetadataOutput         *     output;
/** 会话 */
@property (nonatomic,strong) AVCaptureSession                *     session;
/** 图层 */
@property (nonatomic,strong) AVCaptureVideoPreviewLayer      *     preview;
/** 输出图片 */
@property (nonatomic,strong) AVCaptureStillImageOutput       *     stillImageOutput;
/** 扫码结果 */
@property (nonatomic,strong) NSMutableArray<LWScanResult *>  *     arrayResult;
/** 扫码类型 */
@property (nonatomic,strong) NSArray    *     arrayCodeType;
/** 视频预览显示视图 */
@property (nonatomic,strong) UIView     *     videoPreView;
/** 扫码结果返回 */
@property (nonatomic,copy)   void(^blockScanResult)(NSArray<LWScanResult *> *array);
/** 是否需要扫描结果 */
@property (nonatomic,assign) BOOL                                  isNeedScanResult;

@end

// ====================================================================================================================================================================
#pragma mark - 系统扫描的工具方法
@interface LWScanSystem (tools)
/** 视频采集 */
- (void)preView:(UIView *)preView ObjectType:(NSArray *)objType cropRect:(CGRect)cropRect success:(void(^)(NSArray<LWScanResult *> *array))block;
/** 默认条码类型 */
- (NSArray *)defaultMetaDataObjectTypes;
/** 设置连接 */
- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;
/** 处理扫描后的图像 */
- (void)setCaptureImage;

@end

// ====================================================================================================================================================================
#pragma mark - 系统扫描的工具AVCaptureMetadataOutputObjectsDelegate方法
@interface LWScanSystem (AVCaptureMetadataOutputObjectsDelegate)<AVCaptureMetadataOutputObjectsDelegate>

@end

// ====================================================================================================================================================================
#pragma mark - 系统扫描
@implementation LWScanSystem
#pragma mark   设置扫码成功后是否拍照
- (void)setNeedCaptureImage:(BOOL)isNeedCaptureImage {
    _isNeedCaptureImage = isNeedCaptureImage;
}

#pragma mark  调整摄像头焦距
- (void)setVideoScale:(CGFloat)scale {
    _scale = scale;
    [self.input.device lockForConfiguration:nil];
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    CGFloat zoom = scale / videoConnection.videoScaleAndCropFactor;
    videoConnection.videoScaleAndCropFactor = scale;
    [_input.device unlockForConfiguration];
    CGAffineTransform transform = self.videoPreView.transform;
    self.videoPreView.transform = CGAffineTransformScale(transform, zoom, zoom);
}


#pragma mark 开始扫码
- (void)startScan {
    if (self.input != nil && self.session.isRunning == NO)
    {
        [self.session startRunning];
        self.isNeedScanResult = YES;
        [self.videoPreView.layer insertSublayer:self.preview atIndex:0];
    }
}
#pragma mark 停止扫码
- (void)stopScan {
    if (self.input != nil && self.session.isRunning == YES)
    {
        self.isNeedScanResult = NO;
        [self.session stopRunning];
    }
}
#pragma mark 设置闪光灯
- (void)setTorch:(BOOL)torch {
    [self.input.device lockForConfiguration:nil];
    self.input.device.torchMode = torch ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    [self.input.device unlockForConfiguration];
}
#pragma mark 开关闪光灯
- (void)changeTorch {
    AVCaptureTorchMode torch = self.input.device.torchMode;
    switch (torch) {
        case AVCaptureTorchModeAuto:
            break;
        case AVCaptureTorchModeOff:
            torch = AVCaptureTorchModeOn;
            break;
        case AVCaptureTorchModeOn:
            torch = AVCaptureTorchModeOff;
            break;
        default:
            break;
    }
    [self.input.device lockForConfiguration:nil];
    self.input.device.torchMode = torch;
    [self.input.device unlockForConfiguration];
}
#pragma mark  修改扫码类型：二维码，条形码
- (void)changeScanType:(NSArray *)objTypes {

}

#pragma mark 初始化采集相机
- (instancetype)initWithPreView:(UIView *)preView ObjectType:(NSArray *)objType cropRect:(CGRect)cropRect success:(void(^)(NSArray<LWScanResult *> *array))block {
    self = [super init];
    if (self) {
        [self preView:preView ObjectType:objType cropRect:cropRect success:block];
    }
    return self;
}

@end

// ====================================================================================================================================================================
#pragma mark 系统扫描的工具方法
@implementation LWScanSystem (tools)

#pragma mark 视频采集
- (void)preView:(UIView *)preView ObjectType:(NSArray *)objType cropRect:(CGRect)cropRect success:(void(^)(NSArray<LWScanResult *> *array))block {
    self.arrayCodeType = objType;
    self.blockScanResult = block;
    self.videoPreView = preView;
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_device)
        return;
    // input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.isNeedCaptureImage = YES;
    // output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if (CGRectEqualToRect(cropRect, CGRectZero) == NO) {
        self.output.rectOfInterest = cropRect;
    }
    // 设置图片输出
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    self.stillImageOutput.outputSettings = outputSettings;
    // session
    self.session = [[AVCaptureSession alloc]init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    if ([self.session canAddInput:self.input])
        [self.session addInput:self.input];
    if ([self.session canAddOutput:self.output])
        [self.session addOutput:self.output];
    if ([self.session canAddOutput:self.stillImageOutput])
        [self.session addOutput:self.stillImageOutput];
    if (objType == nil)
      objType = [self defaultMetaDataObjectTypes];
    self.output.metadataObjectTypes = objType;
    
    // preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0, 0, self.videoPreView.frame.size.width, self.videoPreView.frame.size.height);
    self.preview.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor yellowColor]);
    [self.videoPreView.layer insertSublayer:self.preview atIndex:0];
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections: [[self stillImageOutput] connections]];
    CGFloat scale = videoConnection.videoScaleAndCropFactor;
    NSLog(@"==== %f ===",scale);
    // 判断是否支持控制对焦，不然开启自动对焦
    if (self.device.isFocusPointOfInterestSupported && [self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [self.input.device lockForConfiguration:nil];
        [self.input.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [self.input.device unlockForConfiguration];
    }
    
 }

#pragma mark 默认条码类型
- (NSArray *)defaultMetaDataObjectTypes {
    NSMutableArray *types = [@[AVMetadataObjectTypeQRCode,
                               AVMetadataObjectTypeUPCECode,
                               AVMetadataObjectTypeCode39Code,
                               AVMetadataObjectTypeCode39Mod43Code,
                               AVMetadataObjectTypeEAN13Code,
                               AVMetadataObjectTypeEAN8Code,
                               AVMetadataObjectTypeCode93Code,
                               AVMetadataObjectTypeCode128Code,
                               AVMetadataObjectTypePDF417Code,
                               AVMetadataObjectTypeAztecCode] mutableCopy];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
    {
        [types addObjectsFromArray:@[
                                     AVMetadataObjectTypeInterleaved2of5Code,
                                     AVMetadataObjectTypeITF14Code,
                                     AVMetadataObjectTypeDataMatrixCode
                                     ]];
    }
    
    return types;

}

#pragma mark 设置连接
- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
    for (AVCaptureConnection *connection in connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:mediaType]) {
                return connection;
            }
        }
    }
    return nil;
}

#pragma mark 得到扫描后的图像
- (void)setCaptureImage {
    AVCaptureConnection *stillImageConnection =  [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        [self stopScan];
        if (error == nil && imageDataSampleBuffer != nil) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            for (LWScanResult *scanResult in self.arrayResult) {
                scanResult.scanResultImage = image;
            }
        }
        if (self.blockScanResult)
            self.blockScanResult(self.arrayResult);

    }];
}

@end
// ====================================================================================================================================================================
#pragma mark - 系统扫描的工具AVCaptureMetadataOutputObjectsDelegate方法
@implementation LWScanSystem (AVCaptureMetadataOutputObjectsDelegate)

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (self.isNeedScanResult == NO)
        return;
    if (_arrayResult == nil)
        self.arrayResult = [NSMutableArray arrayWithCapacity:1];
    else
        [self.arrayResult removeAllObjects];
        
   // 识别扫码类型
    for (AVMetadataObject *current in metadataObjects)
    {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]])
        {
            self.isNeedScanResult = NO;
            NSLog(@"type:%@",current.type);
            NSString *scanResult = [(AVMetadataMachineReadableCodeObject *)current stringValue];
            LWScanResult *result = [[LWScanResult alloc]init];
            result.scanResultString = scanResult;
            result.scanResultType = current.type;
            [self.arrayResult addObject:result];
        }
        if (self.isNeedCaptureImage == YES)
            [self setCaptureImage];
        else
        {
            [self stopScan];
            if (self.blockScanResult)
                self.blockScanResult(self.arrayResult);
        }
    }
}

@end

// ====================================================================================================================================================================

