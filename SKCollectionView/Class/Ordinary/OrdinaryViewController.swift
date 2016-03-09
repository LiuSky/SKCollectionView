//
//  OrdinaryViewController.swift
//  ConllectionView(Swift)
//
//  Created by xiaobin liu on 16/3/8.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit

class OrdinaryViewController: UIViewController {

    
    private lazy var collectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
//        layout.minimumLineSpacing = 20.0
//        layout.minimumInteritemSpacing = 10.0
        layout.itemSize = CGSizeMake(100,100)
        
        let temporartCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        temporartCollectionView.backgroundColor = UIColor.whiteColor()
        temporartCollectionView.backgroundView = nil
        temporartCollectionView.dataSource = self
        temporartCollectionView.delegate = self
        temporartCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
        return temporartCollectionView
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
extension OrdinaryViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    
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
