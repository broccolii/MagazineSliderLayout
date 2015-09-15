//
// MagazineSliderLayout.m
// LiangCang
//
// Created by ZhJian on 15/6/3.
// Copyright (c) 2015年 ZhJian. All rights reserved.
//

#import "MagazineSliderLayout.h"
#import "MagazineSliderCell.h"
#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"

@interface MagazineSliderLayout()
{
    
}

@property(nonatomic, assign) NSUInteger count;
@end

@implementation MagazineSliderLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(WIDTH, CELL_HEIGHT);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
    }
    return self;
}

-(void)setContentSize:(NSUInteger)count
{
    self.count = count;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    return attr;
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(CELL_WIDTH, HEADER_HEIGHT+DRAG_INTERVAL*self.count+(HEIGHT-DRAG_INTERVAL));
}

-(void)prepareLayout
{
    [super prepareLayout];
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    float screen_y = self.collectionView.contentOffset.y;
    float current_floor = floorf((screen_y-HEADER_HEIGHT)/DRAG_INTERVAL)+1;
    float current_mod = fmodf((screen_y-HEADER_HEIGHT), DRAG_INTERVAL);
    float percent = current_mod/DRAG_INTERVAL;
    
    CGRect correctRect;
    if(current_floor == 0 || current_floor == 1){
        correctRect = CGRectMake(0, 0, WIDTH, RECT_RANGE);
    }else{
        correctRect = CGRectMake(0, HEADER_HEIGHT+HEADER_HEIGHT+CELL_HEIGHT*(current_floor-2), CELL_WIDTH, RECT_RANGE);
    }
    
    NSArray* array = [super layoutAttributesForElementsInRect:correctRect];
    
    if(screen_y >= HEADER_HEIGHT){
        
        for(UICollectionViewLayoutAttributes *attributes in array){
            NSInteger row = attributes.indexPath.row;
            if(row < current_floor){
                attributes.zIndex = 0;
                attributes.frame = CGRectMake(0, (HEADER_HEIGHT-DRAG_INTERVAL)+DRAG_INTERVAL*row, CELL_WIDTH, CELL_CURRHEIGHT);
                [self setEffectViewAlpha:1 forIndexPath:attributes.indexPath];
            }else if(row == current_floor){
                attributes.zIndex = 1;
                attributes.frame = CGRectMake(0, (HEADER_HEIGHT-DRAG_INTERVAL)+DRAG_INTERVAL*row, CELL_WIDTH, CELL_CURRHEIGHT);
                [self setEffectViewAlpha:1 forIndexPath:attributes.indexPath];
            }else if(row == current_floor+1){
                attributes.zIndex = 2;
                attributes.frame = CGRectMake(0, attributes.frame.origin.y+(current_floor-1)*70-70*percent, CELL_WIDTH, CELL_HEIGHT+(CELL_CURRHEIGHT-CELL_HEIGHT)*percent);
                [self setEffectViewAlpha:percent forIndexPath:attributes.indexPath];
            }else{
                attributes.zIndex = 0;
                attributes.frame = CGRectMake(0, attributes.frame.origin.y+(current_floor-1)*70+70*percent, CELL_WIDTH, CELL_HEIGHT);
                [self setEffectViewAlpha:0 forIndexPath:attributes.indexPath];
            }
            
            [self setImageViewOfItem:(screen_y-attributes.frame.origin.y)/HEIGHT*IMAGEVIEW_MOVE_DISTANCE withIndexPath:attributes.indexPath];
            
        }
        
    }else{
        
        for(UICollectionViewLayoutAttributes *attributes in array){
            
            if(attributes.indexPath.row > 1){
                [self setEffectViewAlpha:0 forIndexPath:attributes.indexPath];
            }
            [self setImageViewOfItem:(screen_y-attributes.frame.origin.y)/HEIGHT*IMAGEVIEW_MOVE_DISTANCE withIndexPath:attributes.indexPath];
            
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(setEffectOfHead:)])
        [self.delegate setEffectOfHead:screen_y];
    
    return array;
}

/**
 
 设置CELL里imageView的位置偏移动画 *
 @param distance
 @param indexpath */
-(void)setImageViewOfItem:(CGFloat)distance withIndexPath:(NSIndexPath *)indexpath {
    MagazineSliderCell *cell = (MagazineSliderCell *)[self.collectionView cellForItemAtIndexPath:indexpath];
    cell.imageView.frame = CGRectMake(0, IMAGEVIEW_ORIGIN_Y+distance, CELL_WIDTH, cell.imageView.frame.size.height);
}

-(void)setEffectViewAlpha:(CGFloat)percent forIndexPath:(NSIndexPath *)indexPath
{
    MagazineSliderCell *cell = (MagazineSliderCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.maskView.alpha = MAX((1-percent)*0.6, 0.2);
    cell.desc.frame = CGRectMake(0, 85+percent*60, WIDTH, cell.desc.frame.size.height);
    cell.desc.alpha = percent*0.85;
    cell.title.layer.transform = CATransform3DMakeScale(0.5+0.5*percent, 0.5+0.5*percent, 1);
    cell.title.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, CELL_HEIGHT/2+(CELL_CURRHEIGHT-CELL_HEIGHT)/2*percent);
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGPoint destination;
    CGFloat positionY;
    CGFloat screen_y = self.collectionView.contentOffset.y;
    CGFloat cc;
    CGFloat count;
    if (screen_y < 0) {
        return proposedContentOffset;
    }
    if(velocity.y == 0){ //此情况可能由于拖拽不放手，停下时再放手的可能，所以加速度为0
        count = roundf(((proposedContentOffset.y-HEADER_HEIGHT)/DRAG_INTERVAL))+1;
        if(count == 0){
            positionY = 0;
        }else{
            positionY = HEADER_HEIGHT+(count-1)*DRAG_INTERVAL;
        }
    }else{
        if(velocity.y>1){
            cc = 1;
        }else if(velocity.y < -1){
            cc = -1;
        }else{
            cc = velocity.y;
        }
        if (velocity.y > 0) {
            count = ceilf(((screen_y + cc*DRAG_INTERVAL - HEADER_HEIGHT)/DRAG_INTERVAL))+1;
        }else{
            count = floorf(((screen_y + cc*DRAG_INTERVAL - HEADER_HEIGHT)/DRAG_INTERVAL))+1;
        }
        if(count == 0){
            positionY = 0;
        }else{
            positionY = HEADER_HEIGHT+(count-1)*DRAG_INTERVAL;
        }
        
    }
    
    if(positionY < 0){
        positionY = 0;
    }
    if(positionY > self.collectionView.contentSize.height - HEIGHT){
        positionY = self.collectionView.contentSize.height - HEIGHT;
    }
    destination = CGPointMake(0, positionY);
    self.collectionView.decelerationRate = .8;
    return destination;
}
-(void)dealloc
{
    
}
@end
