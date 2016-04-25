//
//  LWScanQRCollectionViewCell.m
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import "LWScanQRCollectionViewCell.h"
#import "LWScanQRModel.h"
#import "LWTools.h"

// ====================================================================================================================================================================
@implementation LWScanQRCollectionViewCell

- (UIImageView *)imageView
{
    if (_imageView == nil)
        _imageView = [[UIImageView alloc]init];
    return _imageView;
}

- (UILabel *)titelLabel
{
    if (_titelLabel == nil)
        _titelLabel = [[UILabel alloc]init];
    return _titelLabel;
}

#pragma mark - 重写 initWithFrame:
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        [self addSubview:self.imageView];
        [self addSubview:self.titelLabel];
    }
    return self;
}

- (void)setModel:(LWScanQRModel *)model
{
    _model = model;
    
    UIImage *image = [LWTools iamgeName:model.imageName withBundleName:@"listView"];
    CGFloat margin = 10.0f;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height - margin * 2;
    self.imageView.frame = CGRectMake(x, y, w, h);
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    y = h;
    self.titelLabel.frame = CGRectMake(0, y, w, margin * 2);
    self.titelLabel.text = model.title;
    self.titelLabel.textAlignment = NSTextAlignmentCenter;
    self.titelLabel.font = [UIFont systemFontOfSize:14.0f];
}

@end

// ====================================================================================================================================================================
