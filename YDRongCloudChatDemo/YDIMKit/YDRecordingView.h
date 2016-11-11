//
//  YDRecordingView.h
//  Chat
//
//  Created by 周少文 on 2016/10/26.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDRecordingView : UIView

@property (nonatomic,strong) UIImageView *animationImgV;
@property (nonatomic,strong) UILabel *titleLabel;

- (void)startAnimating;
- (void)stopAnimating;

@end
