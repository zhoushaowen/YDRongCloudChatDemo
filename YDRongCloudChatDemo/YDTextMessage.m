//
//  YDTextMessage.m
//  YDRongCloudChatDemo
//
//  Created by 周少文 on 2016/11/14.
//  Copyright © 2016年 Yidu. All rights reserved.
//

#import "YDTextMessage.h"

@implementation YDTextMessage

- (instancetype)initWithRCMessage:(RCMessage *)aRCMessage
{
    self = [super init];
    if(self)
    {
        RCTextMessage *content = (RCTextMessage *)aRCMessage.content;
        self.messageContent = content.content;
        self.messageDirection = aRCMessage.messageDirection == MessageDirection_SEND ? YDMessageDirectionSend:YDMessageDirectionReceive;
        self.nickname = aRCMessage.senderUserId;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:aRCMessage.sentTime/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *str = [formatter stringFromDate:date];
        self.timeStr = str;
    }
    return self;
}


@end
