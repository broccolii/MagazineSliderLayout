//
// MagazineSliderLayout.h
// LiangCang
//
// Created by ZhJian on 15/6/3.
// Copyright (c) 2015年 ZhJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MagazineSliderLayoutDelegate

@optional

-(void)setEffectOfHead:(CGFloat)offsetY;

@end

@interface MagazineSliderLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id delegate;

-(void)setContentSize:(NSUInteger)count;

@end
