
//
//  UIView+SWAutoLayout.m
//  test
//
//  Created by 周少文 on 16/4/8.
//  Copyright © 2016年 YXCompany. All rights reserved.
//

#import "UIView+SWAutoLayout.h"

@implementation UIView (SWAutoLayout)

- (NSArray<__kindof NSLayoutConstraint*> *)sw_addConstraintsWithFormat:(NSString *)format options:(NSLayoutFormatOptions)options metrics:(NSDictionary*)metrics views:(NSDictionary*)views
{
    [self assert];
    if(self.translatesAutoresizingMaskIntoConstraints)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:format options:options metrics:metrics views:views];
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
    {
        [NSLayoutConstraint activateConstraints:array];
    }
    #else
        [self.superview addConstraints:array];
    #endif

    return array;
}

- (NSLayoutConstraint *)sw_addConstraintToView:(UIView *)view withEqualAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant
{
    [self assert];
    if(self.translatesAutoresizingMaskIntoConstraints)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
   NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view attribute:attribute multiplier:1.0f constant:constant];
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0f)
    {
        constraint.active = YES;
    }
    #else
        [self.superview addConstraint:constraint];
    #endif
    
    return constraint;
}

- (NSLayoutConstraint *)sw_addConstraintWith:(NSLayoutAttribute)attribute1 toView:(UIView *)view attribute:(NSLayoutAttribute)attribute2 constant:(CGFloat)constant
{
    [self assert];
    if(self.translatesAutoresizingMaskIntoConstraints)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute1 relatedBy:NSLayoutRelationEqual toItem:view attribute:attribute2 multiplier:1.0f constant:constant];
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0f)
    {
        constraint.active = YES;
    }
    #else
        [self.superview addConstraint:constraint];
    #endif
    
    return constraint;
}

- (void)assert {
    NSAssert(self.superview != nil, @"添加约束前必须要先addSubView");
}


@end
