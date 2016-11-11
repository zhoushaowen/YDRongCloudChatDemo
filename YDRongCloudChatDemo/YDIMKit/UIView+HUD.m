//
//  UIView+HUD.m
//  Chat
//
//  Created by 周少文 on 2016/10/26.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import "UIView+HUD.h"
#import "UIColor+Hex.h"

@implementation UIView (HUD)

- (MBProgressHUD *)showHUDAndHideWithDelay:(NSTimeInterval)delay
{
    __block MBProgressHUD *hud = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUD];
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:NO afterDelay:delay];

    });
    
    return hud;
}

- (MBProgressHUD *)showHUDAndHideWithDefaultDelay
{
    __block MBProgressHUD *hud = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUD];
        hud = [self showHUDAndHideWithDelay:0.25f];
    });
    return hud;
}

- (MBProgressHUD *)showHUDWithCustomView:(UIView *)customView
{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:NO];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    hud.customView = customView;
    hud.opacity = 1.0f;
    hud.color = [[UIColor colorWithHexString:@"494D55"] colorWithAlphaComponent:0.6f];

    return hud;
}

- (MBProgressHUD *)showHUD
{
    __block MBProgressHUD *hud = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUD];
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.removeFromSuperViewOnHide = YES;
    });
    return hud;
}

- (BOOL)hideHUD
{
    return [MBProgressHUD hideHUDForView:self animated:NO];
}


@end
