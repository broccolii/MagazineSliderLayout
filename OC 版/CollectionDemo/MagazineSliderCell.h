//
// MagazineSliderCell.h
// LiangCang
//
// Created by ZhJian on 15/6/3.
// Copyright (c) 2015年 ZhJian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MagazineSliderCellDelegate

@optional

-(void)switchNavigator:(NSUInteger)tag;

@end

@interface MagazineSliderCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *desc;

-(void)setTitleLabel:(NSString *)string;
-(void)setDescLabel:(NSString *)string;
-(void)setIndex:(NSUInteger)index;
-(void)revisePositionAtFirstCell;
-(void)reset;

@property (nonatomic, weak) id delegate;

@end
