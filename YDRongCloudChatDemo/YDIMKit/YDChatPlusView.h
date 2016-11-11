//
//  YDChatPlusView.h
//  Chat
//
//  Created by 周少文 on 2016/10/24.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDActionItemProtocol.h"

@interface YDChatPlusView : UIView

@property (nonatomic,strong) NSArray<id<YDActionItemProtocol>> *actionItems;
@property (nonatomic,strong) void(^actionItemClick)(id<YDActionItemProtocol>);
@property (nonatomic,strong) UICollectionView *collectionView;


@end
