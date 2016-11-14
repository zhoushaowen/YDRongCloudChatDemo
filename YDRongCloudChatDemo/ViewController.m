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
#import "YDTextMessage.h"


@interface ViewController ()<RCIMClientReceiveMessageDelegate>
{
    long _oldestMessageId;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerMessageClass:[YDTextMessage class] forCellClass:[YDTextMessageCell class]];
    [self registerMessageClass:[YDImageMessage class] forCellClass:[YDJoyImageMessageCell class]];
    self.defaultInputStyle = YDChatInputStyleText;
    
    self.numberOfPageCount = 10;
    // 设置消息接收监听
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    
    NSArray<RCMessage *> *array = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:@"100004" count:(int)self.numberOfPageCount];
    NSLog(@"%@",array);
    _oldestMessageId = [array lastObject].messageId;
    [self setInitializedDataArray:[self getMessageModelsFromRCMessages:array]];
}

- (NSArray *)getMessageModelsFromRCMessages:(NSArray *)rcMessages
{
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
    [rcMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(RCMessage*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.content isKindOfClass:[RCTextMessage class]])
        {
            YDTextMessage *message = [[YDTextMessage alloc] initWithRCMessage:obj];
            [mutableArr addObject:message];
        }
    }];
    return mutableArr;
}

#pragma mark - Override
//下拉加载更多
- (void)chatControllerBeginPullToRefreshCompletionHandler:(void(^)(NSArray<id<YDMessageProtocol>> *newMessages))completionHandler
{
    NSArray<RCMessage *> *array = [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_PRIVATE targetId:@"100004" oldestMessageId:_oldestMessageId count:(int)self.numberOfPageCount];
    _oldestMessageId = [array lastObject].messageId;
    completionHandler([self getMessageModelsFromRCMessages:array]);
}

//发文字
- (void)chatControllerBeginSendText:(NSString *)text
{
    // 构建消息的内容，这里以文本消息为例。
    RCTextMessage *testMessage = [RCTextMessage messageWithContent:text];
    __block YDTextMessage *message = nil;
    // 调用RCIMClient的sendMessage方法进行发送，结果会通过回调进行反馈。
    RCMessage *rcMessage = [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:@"100004"
                                       content:testMessage
                                   pushContent:nil
                                      pushData:nil
                                       success:^(long messageId) {
                                           NSLog(@"发送成功。当前消息ID：%ld", messageId);
                                           message.messageStatus = YDMessageSendStatusSuccess;
                                           NSLog(@"++++++++%ld++++++++++",message.messageStatus);
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                           });
                                       } error:^(RCErrorCode nErrorCode, long messageId) {
                                           NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, nErrorCode);
                                           message.messageStatus = YDMessageSendStatusFail;
                                       }];
    message = [[YDTextMessage alloc] initWithRCMessage:rcMessage];
    [self chatControllerAddMessage:message];

}

//发图片
- (void)chatControllerDidFinishPickingImage:(UIImage *)image
{
    RCImageMessage *testMessage = [RCImageMessage messageWithImage:image];
    YDImageMessage *imageMessage = [YDImageMessage new];
    imageMessage.timeStr = @"10:12";
    imageMessage.name = @"李四";
    imageMessage.contentImage  = testMessage.thumbnailImage;
    imageMessage.isReceiver = YES;
    imageMessage.displayTime = NO;
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:[RCIMClient sharedRCIMClient].currentUserInfo.userId
                                       content:testMessage
                                   pushContent:nil
                                      pushData:nil
                                       success:^(long messageId) {
                                           NSLog(@"发送成功。当前消息ID：%ld", messageId);
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [self chatControllerAddMessage:imageMessage];
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
        YDTextMessage *textMessage = [[YDTextMessage alloc] initWithRCMessage:message];
        [self chatControllerAddMessage:textMessage];
    }
    
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
