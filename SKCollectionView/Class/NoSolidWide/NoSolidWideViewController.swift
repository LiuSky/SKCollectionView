//
//  NoSolidWideViewController.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 16/3/10.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit

class NoSolidWideViewController: UIViewController {

    fileprivate lazy var collectionView: UICollectionView = {
        
        let layout = NotFixedFlowLayout()
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 5)
        
        let temporaryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        temporaryCollectionView.backgroundColor = UIColor.white
        temporaryCollectionView.backgroundView = nil
        temporaryCollectionView.delegate = self
        temporaryCollectionView.dataSource = self
        temporaryCollectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        temporaryCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
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

// MARK: - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension NoSolidWideViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = array[indexPath.row] as NSString
        let size: CGSize = text.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)])
        let width = checkCellLimitWidth(ceil(size.width))
        return CGSize(width: width, height: 35)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: indexPath)
        cell.contentView.backgroundColor = UIColor.red
        return cell
    }
    
    func  checkCellLimitWidth(_ cellWidth: CGFloat) -> CGFloat {
        
        let limitWidth = self.view.frame.width-12-5
        if  cellWidth >= limitWidth {
            return limitWidth - 12
        }
        return cellWidth + 16
    }
}
