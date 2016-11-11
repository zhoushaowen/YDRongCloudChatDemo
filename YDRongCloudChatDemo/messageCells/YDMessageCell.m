//
//  YDMessageCell.m
//  chatList
//
//  Created by r_zhou on 2016/10/24.
//  Copyright © 2016年 r_zhous. All rights reserved.
//

#import "YDMessageCell.h"

@interface YDMessageCell ()
@property (nonatomic,assign) CGFloat topLength;
@end

@implementation YDMessageCell

- (void)setupUI
{
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.backgroundColor = [UIColor grayColor];
    _timeLabel.font = [UIFont systemFontOfSize:11];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(ceil(_timeLabel.font.lineHeight));
    }];
    
    self.headerImgV = [[UIImageView alloc] init];
    self.headerImgV.backgroundColor = [UIColor redColor];
    _headerImgV.image = [UIImage imageNamed:@"chat_appointment"];
    [self.contentView addSubview:_headerImgV];
    [_headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(83/2.0f);
        make.size.mas_equalTo(44);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:10];
    self.nameLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgV.mas_right).with.offset(20);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width - self.bubbleImgV.frame.size.width - 30, 15));
    }];
    
    self.bubbleImgV = [[UIImageView alloc] init];
    self.bubbleImgV.userInteractionEnabled = YES;
    [self.contentView addSubview:_bubbleImgV];
    [_bubbleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headerImgV.mas_right).offset(10);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(0);
    }];
}

- (void)updateCellLayout
{
    if (self.displayTime) {
        self.topLength = 35;
        self.timeLabel.hidden = NO;
    } else {
        self.topLength = 20;
        self.timeLabel.hidden = YES;
    }
    
    if (self.isReceiver) {
        [_headerImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.topLength);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        self.nameLabel.hidden = YES;
        
        UIImage *image = [UIImage imageNamed:@"chat_to_bg_normal"];
        UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        _bubbleImgV.image = resizableImage;
        
        [_bubbleImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_headerImgV.mas_left).offset(- 10);
            make.top.mas_equalTo(_headerImgV);
        }];
    } else {
        self.nameLabel.hidden = NO;
        
        [_headerImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.topLength);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        [_bubbleImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerImgV.mas_right).offset(10);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(0);
        }];
        
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerImgV.mas_right).with.offset(20);
            make.top.mas_equalTo(self.topLength);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width - self.bubbleImgV.frame.size.width - 30, 15));
        }];

        UIImage *image = [UIImage imageNamed:@"chat_from_bg_normal"];
        UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        _bubbleImgV.image = resizableImage;
    }
}

@end
