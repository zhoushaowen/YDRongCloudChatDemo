//
//  UIView+SWAutoLayout.h
//  test
//
//  Created by 周少文 on 16/4/8.
//  Copyright © 2016年 YXCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SWAutoLayout)

- (NSArray<__kindof NSLayoutConstraint*> *)sw_addConstraintsWithFormat:(NSString *)format options:(NSLayoutFormatOptions)options metrics:(NSDictionary*)metrics views:(NSDictionary*)views;

- (NSLayoutConstraint *)sw_addConstraintToView:(UIView *)view withEqualAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant;

- (NSLayoutConstraint *)sw_addConstraintWith:(NSLayoutAttribute)attribute1 toView:(UIView *)view attribute:(NSLayoutAttribute)attribute2 constant:(CGFloat)constant;

@end
