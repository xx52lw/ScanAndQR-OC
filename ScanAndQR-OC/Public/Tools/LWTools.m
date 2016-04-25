//
//  LWTools.m
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import "LWTools.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation LWTools

+ (UIImage *)iamgeName:(NSString *)imageName withBundleName:(NSString *)bundleName
{
    if (imageName.length <= 0 || bundleName.length <= 0)
        return nil;
    UIImage *image = nil;
    NSString *bName = [NSString stringWithFormat:@"%@.bundle",bundleName];
    NSString *source = [NSString stringWithFormat:@"%@/%@%@",bName,imageName,@"@2x.png"];
    NSString *path = [[NSBundle mainBundle]pathForResource:source ofType:nil];
    image = [UIImage imageWithContentsOfFile:path];
    return image;
}

#pragma mark 检查相机或者相册是否可用
+ (BOOL)checkCameraOrAblumAuthorityWith:(UIImagePickerControllerSourceType) souceType
{
    BOOL isAuthority = NO;
    if (souceType == UIImagePickerControllerSourceTypeCamera)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
            NSLog(@"相机不可用");
        else
        {
            if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
            {
                AVAuthorizationStatus permission =
                [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (permission == AVAuthorizationStatusAuthorized || permission == AVAuthorizationStatusNotDetermined) {
                    isAuthority = YES;
                }
                else
                    NSLog(@"没有授权");
            }
            else
                NSLog(@"相机不可用");
        }
        
    }
    else
    {
        PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
        if ( authorStatus != PHAuthorizationStatusDenied )
            isAuthority = YES;
    }
    return isAuthority;
}



@end
