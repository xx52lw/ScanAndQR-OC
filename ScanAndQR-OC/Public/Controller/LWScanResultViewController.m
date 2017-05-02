//
//  LWScanResultViewController.m
//  ScanAndQR-OC
//
//  Created by liwei on 2017/5/2.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWScanResultViewController.h"

@interface LWScanResultViewController ()

@property (nonatomic, strong) UIImageView *scanImageView;  // 结果图片
@property (nonatomic, strong) UILabel *scanStringLabel;    // 结果字符串
@property (nonatomic, strong) UILabel *scanTypeLabel;      // 结果类型

@end

@implementation LWScanResultViewController

- (UIImageView *)scanImageView {
    if (_scanImageView == nil) {
        CGFloat w = 200.0f;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        _scanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 50, w, w)];
    }
    return  _scanImageView;
}

- (UILabel *)scanStringLabel {
    if (_scanStringLabel == nil) {
        _scanStringLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        _scanStringLabel.textColor = [UIColor blackColor];
        _scanStringLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scanStringLabel;
}

- (UILabel *)scanTypeLabel {
    if (_scanTypeLabel == nil) {
        _scanTypeLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        _scanTypeLabel.textColor = [UIColor blackColor];
        _scanTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scanTypeLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scanImageView];
    [self.view addSubview:self.scanStringLabel];
    [self.view addSubview:self.scanTypeLabel];
    
    if (self.scanResultImage != nil) {
        CGFloat h = (self.scanResultImage.size.height / self.scanResultImage.size.width) * self.scanImageView.frame.size.width;
        self.scanImageView.frame = CGRectMake(self.scanImageView.frame.origin.x, self.scanImageView.frame.origin.y, self.scanImageView.frame.size.width, h);
        self.scanImageView.image = self.scanResultImage;
    }
    self.scanTypeLabel.frame = CGRectMake(0, CGRectGetMaxY(self.scanImageView.frame) + 20, self.view.frame.size.width, 20);
    self.scanTypeLabel.text =self.scanResultType;
    self.scanStringLabel.frame = CGRectMake(0, CGRectGetMaxY(self.scanTypeLabel.frame) + 20, self.view.frame.size.width, 20);
    self.scanStringLabel.text = self.scanResultString;
    
}

@end
