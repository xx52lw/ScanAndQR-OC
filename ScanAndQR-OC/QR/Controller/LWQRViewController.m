//
//  LWQRViewController.m
//  ScanAndQR-OC
//
//  Created by 张星星 on 2017/5/6.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWQRViewController.h"
#import "LWQRTools.h"
// ====================================================================================================================================================================
#pragma mark - 生产二维码展示控制器
@interface LWQRViewController ()

@property (nonatomic,strong) UIImageView    *   qrImageView; // 二维码展示视图
@property (nonatomic,strong) UIButton    *     changeBtn;

- (void)changeBtnClick;

- (void)showQRWithNormal;              // 展示正常的二维码
- (void)showQRWithNormalwithLogo;      // 展示正常的二维码带logo
- (void)showQRWithChangeColor;         // 展示改变颜色的二维码
- (void)showQRWithChangeColorWithLogo; // 展示改变颜色的二维码带logo
- (void)showGeneratorWithNormal;       // 展示正常的条形码
- (void)showGeneratorWithChangeColor;  // 展示改变颜色的条形码

@end
// ====================================================================================================================================================================
#pragma mark - 生产二维码展示控制器
@implementation LWQRViewController

#pragma mark 懒加载二维码展示视图
- (UIImageView *)qrImageView {
    if (_qrImageView == nil) {
        _qrImageView = [[UIImageView alloc] init];
        CGFloat space = 100.0f;
        _qrImageView.frame = CGRectMake(space / 2, space, self.view.frame.size.width - space, self.view.frame.size.width - space);
        _qrImageView.backgroundColor = [UIColor clearColor];
    }
    return _qrImageView;
}

- (UIButton *)changeBtn {
    if (_changeBtn == nil) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setTitle:@"更改样式" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_changeBtn sizeToFit];
        _changeBtn.frame = CGRectMake(self.qrImageView.center.x - _changeBtn.frame.size.width / 2, CGRectGetMaxY(self.qrImageView.frame) + 20, _changeBtn.frame.size.width, _changeBtn.frame.size.height);
    }
    return _changeBtn;
}

#pragma mark 重写viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.qrImageView];
    [self.view addSubview:self.changeBtn];
    [self showQRWithNormal];

}

- (void)changeBtnClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"正常的二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showQRWithNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"正常的二维码带logo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showQRWithNormalwithLogo];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"改变颜色的二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showQRWithChangeColor];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"改变颜色的二维码带logo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showQRWithChangeColorWithLogo];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"正常的条形码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showGeneratorWithNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"改变颜色的条形码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showGeneratorWithChangeColor];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 展示正常的二维码
- (void)showQRWithNormal {
    UIImage *qrImage = [LWQRTools createQRWithString:@"liwei---gitHub地址:https://github.com/xx52lw" withSize:self.qrImageView.frame.size];
    self.qrImageView.image = qrImage;
}
#pragma mark 展示改变颜色的二维码
- (void)showQRWithChangeColor {
    UIImage *qrImage = [LWQRTools createQRWithString:@"liwei---gitHub地址:https://github.com/xx52lw" withSize:self.qrImageView.frame.size withQRColor:[UIColor orangeColor] withBgColor:[UIColor blackColor]];
    self.qrImageView.image = qrImage;
}
#pragma mark 展示正常的二维码带logo
- (void)showQRWithNormalwithLogo {
   UIImage *logo = [UIImage imageNamed:@"logo"];
    logo = [LWQRTools roundedCornerImageWithImage:logo withCornerRadius:20 withBoderWidth:10 withBorderColor:[UIColor redColor]];
    UIImage *qrImage = [LWQRTools createQRWithString:@"liwei---gitHub地址:https://github.com/xx52lw" withSize:self.qrImageView.frame.size withLogoImage:logo withLogoSize:logo.size];
    self.qrImageView.image = qrImage;

}
#pragma mark 展示改变颜色的二维码带logo
- (void)showQRWithChangeColorWithLogo {
    UIImage *logo = [UIImage imageNamed:@"logo"];
    logo = [LWQRTools roundedCornerImageWithImage:logo withCornerRadius:20 withBoderWidth:10 withBorderColor:[UIColor redColor]];
    UIImage *qrImage = [LWQRTools createQRWithString:@"liwei---gitHub地址:https://github.com/xx52lw" withSize:self.qrImageView.frame.size withQRColor:[UIColor orangeColor] withBgColor:[UIColor cyanColor] withLogoImage:logo withLogoSize:logo.size];
    self.qrImageView.image = qrImage;

}
#pragma mark 展示正常的条形码
- (void)showGeneratorWithNormal {
    UIImage *qrImage = [LWQRTools createGenerator:@"123457890" withSize:self.qrImageView.frame.size];
    self.qrImageView.image = qrImage;
}
#pragma mark 展示改变颜色的条形码
- (void)showGeneratorWithChangeColor {
    UIImage *qrImage = [LWQRTools createGenerator:@"123457890" withSize:self.qrImageView.frame.size withColor:[UIColor redColor] withBgColor:[UIColor orangeColor]];
    self.qrImageView.image = qrImage;
}

@end
// ====================================================================================================================================================================
