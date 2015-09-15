//
//  MagazineSliderCell.swift
//  MagazineSliderLayout
//
//  Created by Broccoli on 15/7/23.
//  Copyright (c) 2015年 brocccoli. All rights reserved.
//

import UIKit

protocol MagazineSliderCellDelegate {
    func switchNavigator(tag: Int)
}

class MagazineSliderCell: UICollectionViewCell {
    var imageView: UIImageView?
    var viewMask: UIView?
    var lblTitle: UILabel?
    var lblDesc: UILabel?
    
    var delegate: MagazineSliderCellDelegate?
    var hasLayout: Bool?
    
    var currentBackURL: NSURL?
    var cellIndex: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUI()
    }
    
    func setUI() {
        self.clipsToBounds = true
        
        self.imageView = UIImageView(frame: CGRectMake(0, IMAGEVIEW_ORIGIN_Y - self.frame.origin.y / HEIGHT * IMAGEVIEW_MOVE_DISTANCE, CELL_WIDTH, SC_IMAGEVIEW_HEIGHT))
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(self.imageView!)
        
        self.viewMask = UIView(frame: CGRectMake(0, 0, CELL_WIDTH, CELL_CURRHEIGHT))
        self.viewMask?.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256) / 256), green: CGFloat(arc4random_uniform(256) / 256), blue: CGFloat(arc4random_uniform(256) / 256), alpha: 1)
        self.viewMask?.alpha = 0.6
        self.addSubview(self.viewMask!)
        
        self.lblTitle = UILabel(frame: CGRectMake(0, (CELL_HEIGHT - TITLE_HEIGHT) / 2, CELL_WIDTH, TITLE_HEIGHT))
        self.lblTitle?.textColor = UIColor.whiteColor()
        self.lblTitle?.font = UIFont.systemFontOfSize(20)
        self.lblTitle?.textAlignment = NSTextAlignment.Center
        self.addSubview(lblTitle!)
        
        self.contentMode = UIViewContentMode.Center
        self.lblTitle?.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        self.lblTitle?.center = self.contentView.center
        self.lblTitle?.backgroundColor = UIColor.clearColor()
        
        self.lblDesc = UILabel(frame: CGRectMake(0, (CELL_HEIGHT - TITLE_HEIGHT) / 2 + 30, 300, 0))
        self.lblDesc?.textColor = UIColor.whiteColor()
        self.lblDesc?.font = UIFont.systemFontOfSize(14)
        self.lblDesc?.alpha = 0
        self.lblDesc?.textAlignment = NSTextAlignment.Center
        self.lblDesc?.backgroundColor = UIColor.clearColor()
        self.addSubview(self.lblDesc!)
        
        self.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256) / 256), green: CGFloat(arc4random_uniform(256) / 256), blue: CGFloat(arc4random_uniform(256) / 256), alpha: 1)
    }
    
    func revisePositionAtFirstCell() {
        if self.tag == 1 {
            self.lblDesc?.frame = CGRectMake(0 , 86 + 60, WIDTH, self.lblDesc!.frame.size.height)
            self.lblTitle?.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8)
            self.lblDesc?.alpha = 0.85
            self.lblTitle?.center = CGPointMake(WIDTH / 2, self.contentView.center.y)
        }
    }
    
    func setIndex(index: Int) {
        self.cellIndex = index
        
        if self.cellIndex == 0 {
            self.viewMask?.alpha = 0
            self.backgroundColor = UIColor.lightGrayColor()
        } else if self.cellIndex == 1 {
            self.viewMask?.alpha = 0.2
        } else {
            self.viewMask?.alpha = 0.6
            self.backgroundColor = UIColor.blueColor()
        }
        
       self.setImageViewPostion()
    }
    
    func setImageViewPostion() {
        if self.imageView != nil {
            self.imageView?.frame = CGRectMake(0, IMAGEVIEW_ORIGIN_Y - 64 - self.frame.origin.y / HEIGHT * IMAGEVIEW_MOVE_DISTANCE, CELL_WIDTH, SC_IMAGEVIEW_HEIGHT)
        }
    }
    
    func setTitleLabel(string: String) {
        let str = NSMutableAttributedString(string: string)
        self.lblTitle?.attributedText = str
    }
    
    func setDescLabel(string: String) {
        if string == "" {
            return
        }
        
        let str = NSMutableAttributedString(string: string)
        
        self.lblDesc?.attributedText = str
        self.lblDesc?.frame = CGRectMake(10, self.lblDesc!.frame.origin.y, 300, 300)
    }
    
    func reset() {
        self.imageView?.image = nil
        self.lblTitle?.text = ""
        self.lblDesc?.text = ""
    }
    
    deinit {
        self.imageView = nil
        self.viewMask = nil
        self.lblTitle = nil
    }
}






































