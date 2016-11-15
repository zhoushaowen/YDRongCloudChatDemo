//
//  YDRecordingView.m
//  Chat
//
//  Created by 周少文 on 2016/10/26.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import "YDRecordingView.h"
#import "UIView+SWAutoLayout.h"
#import "UIImage+Bundle.h"
#import "UIView+HUD.h"

@interface YDRecordingView ()

@property (nonatomic,strong) NSArray *animationImages;

@end

@implementation YDRecordingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIImage *image = [UIImage imageWithBundleName:@"chat" imageName:@"voice_1"];
        _animationImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _animationImgV.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
        [self addSubview:_animationImgV];
        _animationImgV.image = image;
        _animationImgV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        NSMutableArray *array = [NSMutableArray array];
        for(int i= 0;i<8;i++)
        {
            NSString *name = [NSString stringWithFormat:@"voice_%d",i+1];
            UIImage *image = [UIImage imageWithBundleName:@"chat" imageName:name];
            [array addObject:image];
        }
        _animationImgV.animationDuration = 0.3*array.count;
        _animationImgV.animationImages = array;
        _animationImages = array;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.text = @"手指上滑，取消发送";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label sw_addConstraintsWithFormat:@"H:|-0-[label]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)];
        [label sw_addConstraintsWithFormat:@"V:[_animationImgV]-8-[label(>=14)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label,_animationImgV)];
        
        self.titleLabel = label;
    }
    
    return self;
}

- (void)startAnimating
{
    [self.animationImgV startAnimating];
}

- (void)stopAnimating
{
    [self.animationImgV stopAnimating];
}

- (void)setAnimationImages:(NSArray *)animationImages
{
    _animationImages = animationImages;
    self.animationImgV.animationImages = animationImages;
}



@end
