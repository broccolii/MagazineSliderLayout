//
//  ViewController.swift
//  MagazineSliderLayout
//
//  Created by Broccoli on 15/7/23.
//  Copyright (c) 2015年 brocccoli. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MagazineSliderCellDelegate {

    var magazineView: UICollectionView?
    func switchNavigator(tag: Int) {
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadMagazineData()
    }

    func reloadMagazineData() {
        magazineView?.reloadData()
        self.initCollectionView()
    }
    
    func initCollectionView() {
        var layout = MagazineSliderLayout()
        layout.setContentSize(5)
        
        magazineView = UICollectionView(frame:  CGRectMake(0, 0, CELL_WIDTH, CGRectGetHeight(UIScreen.mainScreen().bounds)), collectionViewLayout: layout)
        magazineView?.registerClass(MagazineSliderCell.self, forCellWithReuseIdentifier: "CELL")
        magazineView?.delegate = self
        magazineView?.dataSource = self
        magazineView?.backgroundColor = UIColor.greenColor()

        self.view.addSubview(magazineView!)
    }
    
//    override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) -> Bool {
//        return UIInterfaceOrientationIsLandscape(toInterfaceOrientation)
//    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! MagazineSliderCell
        cell.delegate = self
        cell.tag = indexPath.row
        cell.setIndex(indexPath.row)
        cell.reset()
        
        if indexPath.row == 0 {
            cell.imageView?.image = nil
        } else {
            if indexPath.row == 1 {
                cell.revisePositionAtFirstCell()
            }
            
            cell.setTitleLabel("我是title --- \(indexPath.row)")
            cell.setDescLabel("我是desc --- \(indexPath.row)")
            cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1)
        }
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSizeMake(CELL_WIDTH, HEADER_HEIGHT)
        } else if indexPath.row == 1{
            return CGSizeMake(CELL_WIDTH, CELL_CURRHEIGHT)
        } else {
            return CGSizeMake(CELL_WIDTH, CELL_HEIGHT)
        }
    }
}











