//
//  YDMessageCell.h
//  chatList
//
//  Created by r_zhou on 2016/10/24.
//  Copyright © 2016年 r_zhous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@interface YDMessageCell : UITableViewCell
@property (strong, nonatomic) UIImageView *headerImgV;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *bubbleImgV;
//@property (strong, nonatomic) NSDictionary *dictionary;
/**
 *   是否是消息接收方
 *   YES 发送
 *   NO  接收
 **/
@property (assign, nonatomic) BOOL isReceiver;
/**
 *   是否显示时间
 *   YES 显示
 *   NO  隐藏
 **/
@property (assign, nonatomic) BOOL displayTime;

@property (nonatomic,strong) id dataModel;
@property (nonatomic,readonly) CGFloat rowHeight;

- (void)setupUI;
- (void)updateCellLayout;

@end
