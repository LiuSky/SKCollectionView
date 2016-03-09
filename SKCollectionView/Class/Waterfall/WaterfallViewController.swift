//
//  WaterfallViewController.swift
//  CollectionView(Swift)
//
//  Created by xiaobin liu on 16/3/8.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit

let gridWidth : CGFloat = (UIScreen.mainScreen().bounds.width-4)/2

class WaterfallViewController: UIViewController {

    
    private lazy var collectionView: UICollectionView = {
       
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        let temporaryCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        temporaryCollectionView.backgroundColor = UIColor.whiteColor()
        temporaryCollectionView.backgroundView = nil
        temporaryCollectionView.dataSource = self
        temporaryCollectionView.delegate = self
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
}

// MARK: - <#UICollectionViewDataSource,UICollectionViewDelegate#>
extension WaterfallViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(UICollectionViewCell.self), forIndexPath: indexPath)
        
        cell.contentView.backgroundColor = UIColor.redColor()
        return cell
    }
}

// MARK: - <#CHTCollectionViewDelegateWaterfallLayout#>
extension WaterfallViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if indexPath.row%2 == 0 {
           return CGSizeMake(ceil(gridWidth), 120)
        } else {
            return CGSizeMake(ceil(gridWidth), 130)
        }
    }
}




