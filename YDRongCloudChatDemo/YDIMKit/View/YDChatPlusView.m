//
//  YDChatPlusView.m
//  Chat
//
//  Created by 周少文 on 2016/10/24.
//  Copyright © 2016年 周少文. All rights reserved.
//

#import "YDChatPlusView.h"
#import "UIView+SWAutoLayout.h"
#import "YDPlusViewModel.h"
#import "UIColor+Hex.h"
#import "UIImage+Bundle.h"

@interface YDChatPlusCell : UICollectionViewCell

@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UILabel *nameLabel;

@end

@implementation YDChatPlusCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_btn];
        [_btn sw_addConstraintsWithFormat:@"H:|-0-[_btn(60)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btn)];
        [_btn sw_addConstraintsWithFormat:@"V:|-0-[_btn(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btn)];
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel sw_addConstraintsWithFormat:@"V:[_nameLabel(h)]-0-|" options:0 metrics:@{@"h":@(ceil(_nameLabel.font.lineHeight))} views:NSDictionaryOfVariableBindings(_nameLabel)];
        [_nameLabel sw_addConstraintToView:self.contentView withEqualAttribute:NSLayoutAttributeCenterX constant:0];
    }
    
    return self;
}

@end

@interface YDChatPlusView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation YDChatPlusView

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
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(60, 158/2.0f);
    flow.sectionInset = UIEdgeInsetsMake(15, 54/2.0f, 15, 54/2.0f);
    flow.minimumLineSpacing = 54/2.0f;
    flow.minimumInteritemSpacing = 15;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
    [self addSubview:_collectionView];
    [_collectionView registerClass:[YDChatPlusCell class] forCellWithReuseIdentifier:@"cell"];
    
    NSArray *titleNames = @[@"照片",@"拍照",@"定位",@"文件"];
    NSArray *imageNames = @[@"actionbar_picture_icon",@"actionbar_camera_icon",@"actionbar_location_icon",@"actionbar_file_icon"];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
    for(int i = 0;i < 4;i++)
    {
        YDPlusViewModel *model = [[YDPlusViewModel alloc] init];
        model.titleName = titleNames[i];
        model.image = [UIImage imageWithBundleName:@"chat" imageName:imageNames[i]];
        [mutableArr addObject:model];
    }
    self.actionItems = mutableArr;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _actionItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YDChatPlusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    YDPlusViewModel *model = _actionItems[indexPath.row];
    [cell.btn setImage:model.image forState:UIControlStateNormal];
    cell.nameLabel.text = model.titleName;
    cell.btn.tag = indexPath.row;
    [cell.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}

- (void)btnClick:(UIButton *)sender
{
    if(_actionItemClick)
    {
        _actionItemClick(_actionItems[sender.tag]);
    }
}

- (void)setActionItems:(NSArray<id<YDActionItemProtocol>> *)actionItems
{
    _actionItems = actionItems;
    [_collectionView reloadData];
}







@end
