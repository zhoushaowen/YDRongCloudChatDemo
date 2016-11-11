//
//  UIView+HUD.h
//  Chat
//
//  Created by 周少文 on 2016/10/26.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface UIView (HUD)

- (MBProgressHUD *)showHUDAndHideWithDelay:(NSTimeInterval)delay;
- (MBProgressHUD *)showHUDAndHideWithDefaultDelay;
- (MBProgressHUD *)showHUDWithCustomView:(UIView *)customView;
- (MBProgressHUD *)showHUD;
- (BOOL)hideHUD;

@end
