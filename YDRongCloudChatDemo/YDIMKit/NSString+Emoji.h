//
//  NSString+Emoji.h
//  Chat
//
//  Created by 周少文 on 2016/11/1.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)

+ (instancetype)emojiWithHexString:(NSString *)hexStr;

@end
