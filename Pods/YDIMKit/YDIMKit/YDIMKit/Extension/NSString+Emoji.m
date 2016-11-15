//
//  NSString+Emoji.m
//  Chat
//
//  Created by 周少文 on 2016/11/1.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import "NSString+Emoji.h"

@implementation NSString (Emoji)

+ (instancetype)emojiWithHexString:(NSString *)hexStr
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexStr];
    unsigned int result = 0;
    [scanner scanHexInt:&result];
    char chars[4];
    int len = 4;
    
    chars[0] = (result >> 24) & (1 << 24) - 1;
    chars[1] = (result >> 16) & (1 << 16) - 1;
    chars[2] = (result >> 8) & (1 << 8) - 1;
    chars[3] = result & (1 << 8) - 1;
    NSString *emojiStr = [[NSString alloc] initWithBytes:chars length:len encoding:NSUTF32StringEncoding];
    return emojiStr;
}

@end
