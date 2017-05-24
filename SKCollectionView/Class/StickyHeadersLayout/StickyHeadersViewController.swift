//
//  StretchyHeadersViewController.swift
//  CollectionView(Swift)
//
//  Created by xiaobin liu on 16/3/9.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit

class StickyHeadersViewController: UIViewController {

    var array = ["星期一","星期二","星期三","星期四","星期五"]
    
    fileprivate lazy var collectionView: UICollectionView = {
        
        let layout = StickyHeadersLayout()
        let width = UIScreen.main.bounds.size.width/2
        layout.itemSize = CGSize(width: width, height: width)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 50)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let temporaryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        temporaryCollectionView.backgroundColor = UIColor.white
        temporaryCollectionView.backgroundView = nil
        temporaryCollectionView.dataSource = self
        temporaryCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
       temporaryCollectionView.register(StickyHeadersCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(StickyHeadersCollectionReusableView.self))
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


// MARK: - <#UICollectionViewDataSource#>
extension StickyHeadersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(StickyHeadersCollectionReusableView.self), for: indexPath) as! StickyHeadersCollectionReusableView
        header.title = array[indexPath.section]
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: indexPath)
        cell.backgroundColor = generateColors().diff
        return cell
    }
    
    
    
    func generateColors() -> (main: UIColor, diff: UIColor) {
        
        let redMain: CGFloat = CGFloat(arc4random_uniform(104))
        let greenMain: CGFloat = redMain + 105.0
        let blueMain: CGFloat = redMain + 83.0
        
        let redColorMain: CGFloat = redMain / 255.0
        let greenColorMain: CGFloat = greenMain / 255.0
        let blueColorMain: CGFloat = blueMain / 255.0
        let main = UIColor(red: redColorMain, green: greenColorMain, blue: blueColorMain, alpha: 0.8)
        
        let redDiff: CGFloat = CGFloat(arc4random_uniform(104))
        let greenDiff: CGFloat = redDiff + 105.0
        let blueDiff: CGFloat = redDiff + 83.0
        
        let redColorDiff: CGFloat = redDiff / 255.0
        let greenColorDiff: CGFloat = greenDiff / 255.0
        let blueColorDiff: CGFloat = blueDiff / 255.0
        let diff = UIColor(red: redColorDiff, green: greenColorDiff, blue: blueColorDiff, alpha: 0.8)
        
        return (main, diff)
    }
}
