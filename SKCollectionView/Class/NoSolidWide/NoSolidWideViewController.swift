//
//  NoSolidWideViewController.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 16/3/10.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit

class NoSolidWideViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        
        let layout = NotFixedFlowLayout()
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 5)
        
        let temporaryCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        temporaryCollectionView.backgroundColor = UIColor.whiteColor()
        temporaryCollectionView.backgroundView = nil
        temporaryCollectionView.delegate = self
        temporaryCollectionView.dataSource = self
        temporaryCollectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        temporaryCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
        return temporaryCollectionView
    }()
    
    let array = ["哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈","哈哈","第三个","第卅市啊","是的老骥伏枥j","但是肌肤设计的","是否","我企鹅哦","哈"]
    
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

// MARK: - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension NoSolidWideViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let text = array[indexPath.row] as NSString
        let size: CGSize = text.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16.0)])
        let width = checkCellLimitWidth(ceil(size.width))
        return CGSizeMake(width, 35)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(UICollectionViewCell.self), forIndexPath: indexPath)
        cell.contentView.backgroundColor = UIColor.redColor()
        return cell
    }
    
    func  checkCellLimitWidth(var cellWidth: CGFloat) -> CGFloat {
        
        let limitWidth = self.view.frame.width-12-5
        if cellWidth >= limitWidth {
            cellWidth = limitWidth - 12
            return cellWidth
        }
        return cellWidth + 16
    }
}
