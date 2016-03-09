//
//  PinterestViewController.swift
//  CollectionView(Swift)
//
//  Created by xiaobin liu on 16/3/8.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit
import AVFoundation

class PinterestViewController: UIViewController {

    
    private lazy var collectionView: UICollectionView = {
        
        let layout = PinterestLayout()
        layout.cellPadding = 5
        layout.delegate = self
        layout.numberOfColumns = 2
        
        let temporaryCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        temporaryCollectionView.backgroundColor = UIColor.whiteColor()
        temporaryCollectionView.backgroundView = nil
        temporaryCollectionView.dataSource = self
        temporaryCollectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        temporaryCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
        return temporaryCollectionView
    }()
    
    
    /**
     配置View
     */
    func configurationView() {
        view.addSubview(collectionView)
    }
    
    /**
     配置位置
     */
    func configurationLocation() {
        collectionView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        configurationView()
        configurationLocation()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PinterestViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(UICollectionViewCell.self), forIndexPath: indexPath)
        if indexPath.row%3 == 0 {
            cell.contentView.backgroundColor = UIColor.redColor()
        } else {
            cell.contentView.backgroundColor = UIColor.yellowColor()
        }
        return cell
    }
}

extension PinterestViewController: PinterestLayoutDelegate {
    
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        
        let size: CGSize!
        
        if indexPath.row%3 == 0 {
            size = CGSizeMake(100, 80)
        } else {
            size = CGSizeMake(100, 110)
        }
        
        
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRectWithAspectRatioInsideRect(size, boundingRect)
        return rect.height
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 60
    }
    
}

