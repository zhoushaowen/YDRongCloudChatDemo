//
//  YDChatBottomToolView.m
//  ChatBottom
//
//  Created by 周少文 on 2016/10/24.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import "YDChatBottomToolView.h"

#import "UIImage+Bundle.h"
#import "UIColor+Hex.h"
#import "UIImage+Color.h"

@interface YDChatPlusViewButton : UIButton
@end

@implementation YDChatPlusViewButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    CGFloat dx = bounds.size.width - 44.0f > 0 ? 0 : (bounds.size.width - 44.0f)/2.0f;
    CGFloat dy = bounds.size.height - 44.0f > 0 ? 0 : (bounds.size.height - 44.0f)/2.0f;
    bounds = CGRectInset(bounds, dx, dy);
    return CGRectContainsPoint(bounds, point);
}

@end

CGFloat const YDKeyboardHeight = 215;
NSTimeInterval const YDKeyboardAnimationDuration = 0.25;

@interface YDChatBottomToolView ()<UITextViewDelegate,YDEmojiKeyboardViewDelegate>
{
    CALayer *_lines[2];
    NSDate *_touchDownDate;
}

@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *emojiButton;
@property (nonatomic,strong) UIButton *plusButton;
@property (nonatomic,strong) UITextView *tempTextView;

@end

@implementation YDChatBottomToolView

@synthesize emojiKeyboardView = _emojiKeyboardView;
@synthesize plusView = _plusView;
@synthesize emojiSendBtnBackgroundColor = _emojiSendBtnBackgroundColor;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
    for(int i = 0;i < 2;i++)
    {
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor lightGrayColor].CGColor;
        [self.layer addSublayer:line];
        _lines[i] = line;
    }
    self.leftButton = [YDChatPlusViewButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.leftButton];
    self.leftButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *leftImage = [UIImage imageWithBundleName:@"chat" imageName:@"keyboard_hover"];
    [self.leftButton setImage:leftImage forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageWithBundleName:@"chat" imageName:@"talk_hover"] forState:UIControlStateSelected];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_leftButton(w)]" options:0 metrics:@{@"w":@(leftImage.size.width)} views:NSDictionaryOfVariableBindings(_leftButton)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_leftButton(h)]-10-|" options:0 metrics:@{@"h":@(leftImage.size.height)} views:NSDictionaryOfVariableBindings(_leftButton)]];
    [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.plusButton = [YDChatPlusViewButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.plusButton];
    self.plusButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *plusImage = [UIImage imageWithBundleName:@"chat" imageName:@"add_hover"];
    [self.plusButton setImage:plusImage forState:UIControlStateNormal];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_plusButton(w)]-8-|" options:0 metrics:@{@"w":@(plusImage.size.width)} views:NSDictionaryOfVariableBindings(_plusButton)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_plusButton(h)]-10-|" options:0 metrics:@{@"h":@(plusImage.size.height)} views:NSDictionaryOfVariableBindings(_plusButton)]];
    [self.plusButton addTarget:self action:@selector(plusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.emojiButton = [YDChatPlusViewButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.emojiButton];
    self.emojiButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *emojiImage = [UIImage imageWithBundleName:@"chat" imageName:@"emoji_hover"];
    [self.emojiButton setImage:emojiImage forState:UIControlStateNormal];
    [self.emojiButton setImage:[UIImage imageWithBundleName:@"chat" imageName:@"keyboard_hover"] forState:UIControlStateSelected];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_emojiButton(w)]-8-[_plusButton]" options:0 metrics:@{@"w":@(emojiImage.size.width)} views:NSDictionaryOfVariableBindings(_emojiButton,_plusButton)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_plusButton(h)]" options:0 metrics:@{@"h":@(plusImage.size.height)} views:NSDictionaryOfVariableBindings(_plusButton)]];
    [[NSLayoutConstraint constraintWithItem:_emojiButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_plusButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0] setActive:YES];
    [self.emojiButton addTarget:self action:@selector(emojiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.centerButton = [YDChatPlusViewButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.centerButton];
    self.centerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_centerButton]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_centerButton)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_leftButton]-8-[_centerButton]-8-[_emojiButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftButton,_centerButton,_emojiButton)]];
    [self.centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.centerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.centerButton.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    self.centerButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.centerButton.layer.cornerRadius = 3;
    self.centerButton.layer.masksToBounds = YES;
    [self.centerButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.centerButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"F9F9F9"]] forState:UIControlStateNormal];
    [self.centerButton setBackgroundImage:[UIImage createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [self.centerButton addTarget:self action:@selector(centerButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerButton addTarget:self action:@selector(centerButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.centerButton addTarget:self action:@selector(centerButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.centerButton addTarget:self action:@selector(centerButtonTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [self.centerButton addTarget:self action:@selector(centerButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.returnKeyType = UIReturnKeySend;
    _textView.delegate = self;
    [self addSubview:_textView];
    _textView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_textView]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_leftButton]-8-[_textView]-8-[_emojiButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftButton,_textView,_emojiButton)]];
    _textView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.cornerRadius = 3;
    _textView.layer.masksToBounds = YES;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.enablesReturnKeyAutomatically = YES;
    
    self.tempTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.tempTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditingNotification:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
    
    [self bringSubviewToFront:_centerButton];
    
    self.audioPressShortSecond = 1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = 1/[UIScreen mainScreen].scale;
    _lines[0].frame = CGRectMake(0, 0, self.frame.size.width, height);
    _lines[1].frame = CGRectMake(0, self.frame.size.height - height, self.frame.size.width, height);
}

- (void)setInputStyle:(YDChatInputStyle)inputStyle
{
    _inputStyle = inputStyle;
    _emojiButton.selected = NO;
    _plusButton.selected = NO;
    [_tempTextView resignFirstResponder];
    if(inputStyle == YDChatInputStyleVoice)
    {
        _leftButton.selected = NO;
        _textView.hidden = YES;
        _centerButton.hidden = NO;
        [self bringSubviewToFront:_centerButton];
        [_textView resignFirstResponder];
    }else if(inputStyle == YDChatInputStyleText){
        _leftButton.selected = YES;
        _textView.hidden = NO;
        _centerButton.hidden = YES;
        [self bringSubviewToFront:_textView];
    }
}

#pragma mark - Action
- (void)leftButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _emojiButton.selected = NO;
    _plusButton.selected = NO;
    [_tempTextView resignFirstResponder];
    if(sender.isSelected)
    {
        _textView.hidden = NO;
        _centerButton.hidden = YES;
        [self bringSubviewToFront:_textView];
        [_textView resignFirstResponder];
        _textView.inputView = nil;
        [_textView becomeFirstResponder];
    }else{
        _textView.hidden = YES;
        _centerButton.hidden = NO;
        [self bringSubviewToFront:_centerButton];
        [_textView resignFirstResponder];
    }
}

- (void)emojiButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _leftButton.selected = YES;
    _plusButton.selected = NO;
    [self bringSubviewToFront:_textView];
    _centerButton.hidden = YES;
    _textView.hidden = NO;
    if(sender.isSelected)
    {
        [_textView resignFirstResponder];
        [_tempTextView resignFirstResponder];
        _tempTextView.inputView = self.emojiKeyboardView;
        [_tempTextView becomeFirstResponder];
    }else{
        [_tempTextView resignFirstResponder];
        [_textView resignFirstResponder];
        _textView.inputView = nil;
        [_textView becomeFirstResponder];
    }
}

- (void)plusButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _leftButton.selected = YES;
    _emojiButton.selected = NO;
    [self bringSubviewToFront:_textView];
    _centerButton.hidden = YES;
    _textView.hidden = NO;
    if(sender.isSelected)
    {
        [_textView resignFirstResponder];
        [_tempTextView resignFirstResponder];
        _tempTextView.inputView = self.plusView;
        [_tempTextView becomeFirstResponder];
    }else{
        [_tempTextView resignFirstResponder];
        [_textView resignFirstResponder];
        _textView.inputView = nil;
        [_textView becomeFirstResponder];
    }
}

- (void)centerButtonTouchUpInside:(UIButton *)sender
{
    [self setCenterBtnTitle:@"按住 说话"];
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitSecond fromDate:_touchDownDate toDate:currentDate options:0];
    BOOL flag;
    if(components.second < self.audioPressShortSecond)
    {
        self.audioPressShortHUD = [self showCustomView:self.audioPressShortView];
        [self.audioPressShortHUD hide:NO afterDelay:0.5f];
        flag = NO;
    }else{
        flag = YES;
        [self hideCustomView];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(chatBottomToolView:recordButtonTouchUpInside:completeRecord:)])
    {
        [_delegate chatBottomToolView:self recordButtonTouchUpInside:sender completeRecord:flag];
    }
}

- (void)centerButtonTouchUpOutside:(UIButton *)sender
{
    [self hideCustomView];
    if(_delegate && [_delegate respondsToSelector:@selector(chatBottomToolView:recordButtonTouchUpOutside:)])
    {
        [_delegate chatBottomToolView:self recordButtonTouchUpOutside:sender];
    }
}

- (void)centerButtonTouchDown:(UIButton *)sender
{
    [self setCenterBtnTitle:@"松开 发送"];
    _touchDownDate = [NSDate date];
    self.recordingHUD = [self showCustomView:self.recordingView];
    if(_delegate && [_delegate respondsToSelector:@selector(chatBottomToolView:recordButtonTouchDown:)])
    {
        [_delegate chatBottomToolView:self recordButtonTouchDown:sender];
    }
}

- (void)centerButtonTouchDragEnter:(UIButton *)sender
{
    [self setCenterBtnTitle:@"松开 发送"];
    self.recordingHUD = [self showCustomView:self.recordingView];
    if(_delegate && [_delegate respondsToSelector:@selector(chatBottomToolView:recordButtonTouchDragEnter:)])
    {
        [_delegate chatBottomToolView:self recordButtonTouchDragEnter:sender];
    }
}

- (void)centerButtonTouchDragExit:(UIButton *)sender
{
    [self setCenterBtnTitle:@"按住 说话"];
    self.cancelSendHUD = [self showCustomView:self.cancelSendView];
    if(_delegate && [_delegate respondsToSelector:@selector(chatBottomToolView:recordButtonTouchDragExit:)])
    {
        [_delegate chatBottomToolView:self recordButtonTouchDragExit:sender];
    }
}

- (void)setCenterBtnTitle:(NSString *)title
{
    [_centerButton setTitle:title forState:UIControlStateNormal];
}

- (MBProgressHUD *)showCustomView:(UIView *)customView
{
    return [[UIApplication sharedApplication].keyWindow showHUDWithCustomView:customView];
}

- (void)hideCustomView
{
    [[UIApplication sharedApplication].keyWindow hideHUD];
}

#pragma mark - Notification
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification
{
    if(_delegate && [_delegate respondsToSelector:@selector(chatBottomToolView:keyboardWillChangeFrameNotification:)])
    {
        [_delegate chatBottomToolView:self keyboardWillChangeFrameNotification:notification];
    }
}

- (void)textViewDidBeginEditingNotification:(NSNotification *)notification
{
    if(notification.object == _textView)
    {
        _emojiButton.selected = NO;
        _plusButton.selected = NO;
    }
}

- (void)textViewTextDidChangeNotification:(NSNotification *)notification
{
    if(notification.object != _textView)
        return;
    if(_delegate && [_delegate respondsToSelector:@selector(chatBottomToolView:textViewTextDidChange:)])
    {
        UITextView *textView = notification.object;
        [_delegate chatBottomToolView:self textViewTextDidChange:textView];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [self sendText];
        return NO;
    }
    return YES;
}


#pragma mark - YDEmojiKeyboardViewDelegate
- (void)emojiKeyboardView:(YDEmojiKeyboardView *)view didSelected:(NSString *)emojiString isDelete:(BOOL)isDelete
{
    if(isDelete)
    {
        [_textView deleteBackward];
    }else{
        
        [_textView insertText:emojiString];
    }
}

- (void)emojiKeyboardViewDidClickSendButton:(YDEmojiKeyboardView *)view
{
    [self sendText];
}

- (void)sendText
{
    if(_textView.text.length < 1)
        return;
    if(_delegate && [_delegate respondsToSelector:@selector(chatBottomToolView:didClickSendButton:)])
    {
        NSString *str = _textView.text;
        [_delegate chatBottomToolView:self didClickSendButton:str];
        _textView.text = nil;
        [_delegate chatBottomToolView:self textViewTextDidChange:_textView];
    }
}

#pragma mark - Lazy
- (YDEmojiKeyboardView *)emojiKeyboardView
{
    if(!_emojiKeyboardView)
    {
        _emojiKeyboardView = [[YDEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, YDKeyboardHeight)];
        _emojiKeyboardView.delegate = self;
    }
    
    return _emojiKeyboardView;
}

- (YDChatPlusView *)plusView
{
    if(!_plusView)
    {
        _plusView = [[YDChatPlusView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, YDKeyboardHeight)];
        __weak typeof(self) weakSelf = self;
        _plusView.actionItemClick = ^(id<YDActionItemProtocol> item){
            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBottomToolView:actionItemClick:)])
            {
                [weakSelf.delegate chatBottomToolView:weakSelf actionItemClick:item];
            }
        };
        _inputViewBackgroundColor = _plusView.collectionView.backgroundColor;
    }
    return _plusView;
}

- (YDRecordingView *)recordingView
{
    if(!_recordingView)
    {
        _recordingView = [[YDRecordingView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _recordingView;
}

- (YDCancelSendView *)cancelSendView
{
    if(!_cancelSendView)
    {
        _cancelSendView = [[YDCancelSendView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _cancelSendView;
}

- (YDAudioPressShortView *)audioPressShortView
{
    if(!_audioPressShortView)
    {
        _audioPressShortView = [[YDAudioPressShortView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    
    return _audioPressShortView;
}

- (void)resignTextViewFirstResponder
{
    [_textView resignFirstResponder];
    [_tempTextView resignFirstResponder];
}

- (void)setInputViewBackgroundColor:(UIColor *)inputViewBackgroundColor
{
    _inputViewBackgroundColor = inputViewBackgroundColor;
    self.plusView.collectionView.backgroundColor = inputViewBackgroundColor;
    self.emojiKeyboardView.collectionView.backgroundColor = inputViewBackgroundColor;
}

- (void)setEmojiSendBtnBackgroundColor:(UIColor *)emojiSendBtnBackgroundColor
{
    _emojiSendBtnBackgroundColor = emojiSendBtnBackgroundColor;
    self.emojiKeyboardView.emojiSendBtnBackgroundColor = emojiSendBtnBackgroundColor;
}

- (UIColor *)emojiSendBtnBackgroundColor
{
    return self.emojiKeyboardView.emojiSendBtnBackgroundColor;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

























@end
