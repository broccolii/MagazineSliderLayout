//
//  MagazineSliderLayout.swift
//  MagazineSliderLayout
//
//  Created by Broccoli on 15/7/23.
//  Copyright (c) 2015年 brocccoli. All rights reserved.
//

import UIKit

let WIDTH: CGFloat = UIScreen.mainScreen().bounds.width
let HEIGHT: CGFloat = UIScreen.mainScreen().bounds.height
let CELL_HEIGHT: CGFloat = 100.0
let CELL_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width
let DRAG_INTERVAL: CGFloat = 170.0
let HEADER_HEIGHT: CGFloat = 0.0
let CELL_CURRHEIGHT: CGFloat = 240.0
let RECT_RANGE: CGFloat = 1000.0
let IMAGEVIEW_ORIGIN_Y: CGFloat = -30.0
let IMAGEVIEW_MOVE_DISTANCE: CGFloat = 160.0
let SC_IMAGEVIEW_HEIGHT: CGFloat = 360.0
let TITLE_HEIGHT: CGFloat = 40.0

protocol MagazineSliderLayoutDelegate {
    func setEffectOfHead(offsetY: CGFloat)
}

class MagazineSliderLayout: UICollectionViewFlowLayout {
    var delegate: MagazineSliderLayoutDelegate?
    var count: CGFloat?
    
    override init() {
        super.init()
        self.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: CELL_HEIGHT)
        self.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: CELL_HEIGHT)
        self.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
    }
    
    func setContentSize(count: CGFloat) {
        self.count = count
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttributesForItemAtIndexPath(itemIndexPath)
    }
    
    override func collectionViewContentSize() -> CGSize {
        println(DRAG_INTERVAL * (self.count! - 2.0) + HEIGHT)
        return CGSizeMake(CELL_WIDTH, HEADER_HEIGHT + DRAG_INTERVAL * (self.count! - 1.0) + (HEIGHT - DRAG_INTERVAL))
    }
    
    override func prepareLayout() {
        super.prepareLayout()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        let screenY = self.collectionView!.contentOffset.y
        let currentFloor = floor((screenY - HEADER_HEIGHT) / DRAG_INTERVAL) + 1
        let currentMod = fmod((screenY - HEADER_HEIGHT), DRAG_INTERVAL)
        let percent = currentMod / DRAG_INTERVAL
        
        let correctRect: CGRect?
        
        if currentFloor == 0 || currentFloor == 1 {
            correctRect = CGRectMake(0, 0, WIDTH, RECT_RANGE)
        } else {
            correctRect = CGRectMake(0, 2 * HEADER_HEIGHT + CELL_HEIGHT * (currentFloor - 1) , CELL_WIDTH, RECT_RANGE)
        }
        
        var array = super.layoutAttributesForElementsInRect(correctRect!) as! [UICollectionViewLayoutAttributes]

        if screenY >= HEADER_HEIGHT {
            
            for attributes in array {
                let row = attributes.indexPath.row
                
                if CGFloat(row) < currentFloor {
                    attributes.zIndex = 0
                    attributes.frame = CGRectMake(0, (HEADER_HEIGHT - DRAG_INTERVAL) + DRAG_INTERVAL * CGFloat(row), CELL_WIDTH, CELL_CURRHEIGHT)
                    
                    if self.collectionView != nil {
                        self.setEffectViewAlpha(1, indexPath: attributes.indexPath)
                    }
                } else if CGFloat(row) == currentFloor {
                    
                    attributes.zIndex = 1
                    attributes.frame = CGRectMake(0, (HEADER_HEIGHT - DRAG_INTERVAL) + DRAG_INTERVAL * CGFloat(row), CELL_WIDTH, CELL_CURRHEIGHT)
                    if self.collectionView != nil {
                        self.setEffectViewAlpha(1, indexPath: attributes.indexPath)
                    }
                    
                } else if CGFloat(row) == currentFloor + 1 {
                    
                    attributes.zIndex = 2
                    attributes.frame = CGRectMake(0, attributes.frame.origin.y + (currentFloor - 1 - percent) * 70, CELL_WIDTH, CELL_HEIGHT + (CELL_CURRHEIGHT - CELL_HEIGHT) * percent)
                    if self.collectionView != nil {
                        self.setEffectViewAlpha(percent, indexPath: attributes.indexPath)
                    }
                } else {
                    
                    attributes.zIndex = 0
                    attributes.frame = CGRectMake(0, attributes.frame.origin.y + (currentFloor - 1 + percent) * 70, CELL_WIDTH, CELL_HEIGHT)
                    if self.collectionView != nil {
                        self.setEffectViewAlpha(0, indexPath: attributes.indexPath)
                    }
                }
                self.setImageViewOfItem((screenY - attributes.frame.origin.y) / HEIGHT * IMAGEVIEW_MOVE_DISTANCE, indexPath: attributes.indexPath)
            }
        } else {
            for attributes in array {
                if attributes.indexPath.row > 1 {
                    if self.collectionView != nil {
                        self.setEffectViewAlpha(0, indexPath: attributes.indexPath)
                    }
                    
                }
                self.setImageViewOfItem((screenY - attributes.frame.origin.y) / HEIGHT * IMAGEVIEW_MOVE_DISTANCE, indexPath: attributes.indexPath)
            }
        }
        return array
    }
    
    
    func setEffectViewAlpha(percent: CGFloat,indexPath: NSIndexPath) {
        let cell = self.collectionView!.cellForItemAtIndexPath(indexPath) as? MagazineSliderCell
        if cell != nil {
            cell!.viewMask?.alpha = max((1 - percent) * 0.6, 0.2)
            cell!.lblDesc!.frame = CGRectMake(0, 85 + percent * 60, WIDTH, cell!.lblDesc!.frame.size.height)
            cell!.lblDesc!.alpha = percent * 0.8
            cell!.lblTitle!.layer.transform = CATransform3DMakeScale(0.5 + 0.5 * percent, 0.5 + 0.5 * percent, 1)
            cell!.lblTitle!.center = CGPointMake(WIDTH / 2, CELL_HEIGHT / 2 + (CELL_CURRHEIGHT - CELL_HEIGHT) / 2 * percent)
            //            if indexPath.row == 2 {
            //                println("cell 2 ----- \(cell!.frame)")
            //            }
            //            if indexPath.row == 3 {
            //                println("cell 3 ----- \(cell!.frame)")
            //            }
        }
    }
    
    func setImageViewOfItem(distance: CGFloat, indexPath: NSIndexPath) {
        let cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as? MagazineSliderCell
        if cell != nil {
            cell!.imageView!.frame = CGRectMake(0, IMAGEVIEW_ORIGIN_Y + distance, CELL_WIDTH, cell!.imageView!.frame.size.height)
        }
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var destination: CGPoint?
        var positionY: CGFloat?
        var screenY: CGFloat = self.collectionView!.contentOffset.y
        var cc: CGFloat?
        var count: CGFloat?
        
        if screenY < 0 {
            return proposedContentOffset
        }
        
        if velocity.y == 0 {
            count = CGFloat(roundf(Float(((proposedContentOffset.y - HEADER_HEIGHT) / DRAG_INTERVAL))) + 1.0)
            if count == 0 {
                positionY = 0
            } else {
                positionY = HEADER_HEIGHT + (count! - 1) * DRAG_INTERVAL
            }
        } else {
            if velocity.y > 1 {
                cc = 1
            } else if velocity.y < -1{
                cc = -1
            } else {
                cc = velocity.y
            }
            
            
            if velocity.y > 0 {
                count = CGFloat(ceilf(Float(((screenY + cc! * DRAG_INTERVAL - HEADER_HEIGHT) / DRAG_INTERVAL))) + 1.0)
            } else {
                count = CGFloat(floorf(Float(((screenY + cc! * DRAG_INTERVAL - HEADER_HEIGHT) / DRAG_INTERVAL))) + 1.0)
            }
            
            
            if count == 0 {
                positionY = 0
            } else {
                positionY = HEADER_HEIGHT + (count! - 1) * DRAG_INTERVAL
            }
        }
        
        if positionY < 0 {
            positionY = 0
        }
        
        if positionY > self.collectionView!.contentSize.height - HEIGHT {
            positionY = self.collectionView!.contentSize.height - HEIGHT
        }
        
        destination = CGPointMake(0, positionY!)
        self.collectionView?.decelerationRate = 0.8
        if destination!.y > 510.0 {
            destination == CGPointMake(0.0, 510.0)
        }
        return destination!
    }
}



























