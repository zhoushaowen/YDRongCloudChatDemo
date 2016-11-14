//
//  YDTextMessage.h
//  YDRongCloudChatDemo
//
//  Created by 周少文 on 2016/11/14.
//  Copyright © 2016年 Yidu. All rights reserved.
//

#import "YDBaseMessage.h"
#import <RongIMLib/RongIMLib.h>

@interface YDTextMessage : YDBaseMessage

- (instancetype)initWithRCMessage:(RCMessage *)aRCMessage;

@end
