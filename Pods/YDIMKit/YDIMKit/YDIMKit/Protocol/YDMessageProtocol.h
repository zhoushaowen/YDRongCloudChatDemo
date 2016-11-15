//
//  YDMessageProtocol.h
//  YDIMKit
//
//  Created by 周少文 on 2016/11/11.
//  Copyright © 2016年 Yidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YDMessageDirection) {
    YDMessageDirectionReceive,
    YDMessageDirectionSend,
};

//消息的发送状态
typedef NS_ENUM(NSUInteger, YDMessageSendStatus) {
    YDMessageSendStatusSending,//发送中
    YDMessageSendStatusSuccess,//发送成功
    YDMessageSendStatusFail,//发送失败
};

@protocol YDMessageProtocol <NSObject>

@property (nonatomic) YDMessageDirection messageDirection;
@property (nonatomic,strong) NSString *messageContent;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *headerImageUrl;
@property (nonatomic) BOOL displayTime;
@property (nonatomic,strong) NSString *timeStr;
@property (nonatomic) YDMessageSendStatus messageStatus;
@property (nonatomic,strong,readonly) NSIndexPath *indexPath;

@end
