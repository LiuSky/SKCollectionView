//
//  OrdinaryViewController.swift
//  ConllectionView(Swift)
//
//  Created by xiaobin liu on 16/3/8.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit

class OrdinaryViewController: UIViewController {

    
    fileprivate lazy var collectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100,height: 100)
        
        let temporartCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        temporartCollectionView.backgroundColor = UIColor.white
        temporartCollectionView.backgroundView = nil
        temporartCollectionView.dataSource = self
        temporartCollectionView.delegate = self
        temporartCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
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
        collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
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
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: indexPath)
        
        cell.contentView.backgroundColor = UIColor.red
        return cell
    }
}
