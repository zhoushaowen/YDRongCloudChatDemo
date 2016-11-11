//
//  YDJoyImageMessageCell.h
//  chatList
//
//  Created by r_zhou on 2016/10/28.
//  Copyright © 2016年 r_zhous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDJoyImageMessageCell : UITableViewCell
@property (nonatomic,strong) id dataModel;
- (CGFloat)rowHeightWithModel:(id)model;
@end
