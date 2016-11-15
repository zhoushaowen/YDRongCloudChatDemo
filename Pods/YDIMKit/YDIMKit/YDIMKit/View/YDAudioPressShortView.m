//
//  YDAudioPressShortView.m
//  Chat
//
//  Created by 周少文 on 2016/10/27.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import "YDAudioPressShortView.h"
#import "UIImage+Bundle.h"
#import "UIView+SWAutoLayout.h"
#import "UIView+HUD.h"

@implementation YDAudioPressShortView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIImage *image = [UIImage imageWithBundleName:@"chat" imageName:@"audio_press_short"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"说话时间太短";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label sw_addConstraintsWithFormat:@"H:|-0-[label]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)];
        [label sw_addConstraintsWithFormat:@"V:[imageView]-8-[label(>=14)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label,imageView)];
        
        self.imageView = imageView;
        self.titleLabel = label;

    }
    
    return self;
}










@end
