//
//  UIViewController+Authorization.m
//  Chat
//
//  Created by 周少文 on 2016/11/1.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import "UIViewController+Authorization.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIViewController (Authorization)

- (BOOL)isHaveCameraAuthorization
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusRestricted || status ==AVAuthorizationStatusDenied)
    {
        NSDictionary *dic = [NSBundle mainBundle].infoDictionary;
        NSString *appName = dic[@"CFBundleDisplayName"];
        if(!appName)
        {
            appName = dic[@"CFBundleName"];
        }
        [self openSettingWithTitle:@"无法启动相机" message:[NSString stringWithFormat:@"请打开%@的相机权限",appName]];
        return NO;
    }
    
    return YES;
}

- (BOOL)isHavePhotoLibarayAuthorization
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if(status == ALAuthorizationStatusRestricted ||status == ALAuthorizationStatusDenied)
    {
        NSDictionary *dic = [NSBundle mainBundle].infoDictionary;
        NSString *appName = dic[@"CFBundleDisplayName"];
        if(!appName)
        {
            appName = dic[@"CFBundleName"];
        }
        [self openSettingWithTitle:@"无法启动相册" message:[NSString stringWithFormat:@"请打开%@的相册权限",appName]];
        return NO;
    }
    
    return YES;
}


- (void)openSettingWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"现在设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


@end
