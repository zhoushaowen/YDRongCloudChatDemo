//
//  YDTextMessage.h
//  Chat
//
//  Created by 周少文 on 2016/10/31.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDMessageProtocol.h"

@interface YDBaseMessage : NSObject<YDMessageProtocol>

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *content;

/**
 *   是否是消息接收方 
 *   YES 接收  
 *   NO  发送
 **/
@property (nonatomic) BOOL isReceiver;


@end
