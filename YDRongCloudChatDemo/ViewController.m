//
//  ViewController.m
//  YDRongCloudChatDemo
//
//  Created by 周少文 on 2016/11/11.
//  Copyright © 2016年 Yidu. All rights reserved.
//

#import "ViewController.h"
#import "YDTextMessageCell.h"
#import "YDBaseMessage.h"
#import "YDJoyImageMessageCell.h"
#import "YDImageMessage.h"
#import "ORColorUtil.h"
#import "UIImage+Color.h"
#import <RongIMLib/RongIMLib.h>


@interface ViewController ()<RCIMClientReceiveMessageDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerMessageClass:[YDBaseMessage class] forCellClass:[YDTextMessageCell class]];
    [self registerMessageClass:[YDImageMessage class] forCellClass:[YDJoyImageMessageCell class]];
    self.defaultInputStyle = YDChatInputStyleText;
    self.numberOfPageCount = 16;
    
    // 设置消息接收监听
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
}

#pragma mark - Override
- (void)chatControllerBeginSendText:(NSString *)text
{
    // 构建消息的内容，这里以文本消息为例。
    RCTextMessage *testMessage = [RCTextMessage messageWithContent:text];
    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId name:@"张三" portrait:@""];
    testMessage.senderUserInfo = userInfo;
    YDBaseMessage *message = [YDBaseMessage new];
    message.content = testMessage.content;
    message.name = testMessage.senderUserInfo.name;
    // 调用RCIMClient的sendMessage方法进行发送，结果会通过回调进行反馈。
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:[RCIMClient sharedRCIMClient].currentUserInfo.userId
                                       content:testMessage
                                   pushContent:nil
                                      pushData:nil
                                       success:^(long messageId) {
                                           NSLog(@"发送成功。当前消息ID：%ld", messageId);
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [self chatControllerAddMessage:message];
                                           });
                                       } error:^(RCErrorCode nErrorCode, long messageId) {
                                           NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, nErrorCode);
                                       }];

}

- (void)onReceived:(RCMessage *)message
              left:(int)nLeft
            object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", testMessage.content);
        YDBaseMessage *message = [YDBaseMessage new];
        message.content = testMessage.content;
        message.name = testMessage.senderUserInfo.name;
        message.isReceiver = NO;
        [self chatControllerAddMessage:message];
    }
    
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
