//
//  YDChatBaseViewController.h
//  Chat
//
//  Created by 周少文 on 2016/10/24.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDActionItemProtocol.h"
#import "YDMessageProtocol.h"
#import "YDAudioPressShortView.h"
#import "YDCancelSendView.h"
#import "YDRecordingView.h"

typedef NS_ENUM(NSUInteger, YDChatInputStyle) {
    YDChatInputStyleVoice,//语音
    YDChatInputStyleText,//文本
};

@interface YDChatBaseViewController : UIViewController

/**
 设置初始化的消息数据

 @param dataArray 消息数组
 */
- (void)setInitializedDataArray:(NSArray *)dataArray;


/**
 分页加载的消息个数,默认值是15
 */
@property (nonatomic) NSInteger numberOfPageCount;

@property (nonatomic,strong) UIColor *chatTableViewBackgroundColor;
@property (nonatomic,strong) UIColor *chatToolBarBackgroundColor;
@property (nonatomic,strong) UIColor *inputViewBackgroundColor;
@property (nonatomic,strong,readonly) UIButton *voiceButton;
@property (nonatomic,strong) UIColor *emojiSendBtnBackgroundColor;

@property (nonatomic,strong,readonly) YDAudioPressShortView *audioPressShortView;
@property (nonatomic,strong,readonly) YDCancelSendView *cancelSendView;
@property (nonatomic,strong,readonly) YDRecordingView *recordingView;

/**
 设置默认的输入方式,默认一开始的输入方式是语音
 */
@property (nonatomic) YDChatInputStyle defaultInputStyle;

/**
 默认数组中有4个item
 */
@property (nonatomic,strong) NSArray<id<YDActionItemProtocol>> *actionItems;

/**
 为某个类型的消息注册某个类型的cell

 @param messageClass 消息的model类型
 @param cellClass 展示的cell类型
 */
- (void)registerMessageClass:(Class)messageClass forCellClass:(Class)cellClass;


/**
 调用tableView的cellForRow方法的时候就会把数据传给这个方法

 @param cell 当前的cell
 @param model 当前cell对应的数据模型
 @param index 当前索引
 */
- (void)ydConversationCell:(UITableViewCell *)cell forMessageModel:(id<YDMessageProtocol>)model atIndex:(NSInteger)index;

/**
 添加一条消息,内部会自动向dataArray中添加一个数据,并刷新UI

 @param message 消息实例
 */
- (void)chatControllerAddMessage:(id<YDMessageProtocol>)message;

/**
 根据某个索引删除一条消息,内部会自动从dataArray中删除一个数据,并刷新UI

 @param index 消息的索引
 */
- (void)chatControllerDeleteMessageAtIndex:(NSInteger)index;
/**
 删除一条消息,内部会自动从dataArray中删除一个数据,并刷新UI
 
 @param message 消息实例
 */
- (void)chatControllerDeleteMessage:(id<YDMessageProtocol>)message;

- (void)chatControllerReplaceMessageWithNewMessage:(id<YDMessageProtocol>)newMessage atIndex:(NSInteger)index;


/**
 开始发送文本消息

 @param text 要发送到文本
 */
- (void)chatControllerBeginSendText:(NSString *)text;
- (void)chatControllerActionItemClick:(id<YDActionItemProtocol>)item;
- (void)chatControllerDidFinishPickingImage:(UIImage *)image;


/**
 下拉刷新会触发此方法,子类重写此方法获取之前的消息,获取到消息之后不要忘了调用completionHandler

 @param completionHandler 获取完之后之后需要手动调用的block
 */
- (void)chatControllerBeginPullToRefreshCompletionHandler:(void(^)(NSArray *data))completionHandler;


/**
 开始录音
 */
- (void)chatControllerStartRecording;

/**
 暂停录音
 */
- (void)chatControllerSuspendRecording;

/**
 继续录音
 */
- (void)chatControllerContinueRecording;

/**
 取消录音
 */
- (void)chatControllerCancelRecording;

/**
 完成录音
 */
- (void)chatControllerCompleteRecording;

@end

