//
//  AppStoreCollectionViewController.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 2017/5/25.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class AppStoreCollectionViewController: UICollectionViewController {
    
    // MARK - 头部View
    private lazy var headerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .yellow
        
        let label = UILabel()
        label.text = "这边可以换成轮播"
        label.textAlignment = .center
        view.addSubview(label)
        
        
        
        label.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(100)
            make.bottom.equalTo(-80)
        }
        return view
    }()
    
    init() {
        let layout = CollectionViewShelfLayout()
        layout.sectionHeaderHeight = 30
        layout.cellSize = CGSize(width: 100, height: 100)
        layout.sectionCellInset = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        super.init(collectionViewLayout: layout)
        layout.headerView = self.headerView
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView!.register(AppStoreCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(AppStoreCollectionSectionHeaderView.self, forSupplementaryViewOfKind: ShelfElementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        
        if let view = view as? AppStoreCollectionSectionHeaderView {
            view.label.text = "第\(indexPath)个"
        }
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



/// MARK - SectionHeaderView
class AppStoreCollectionSectionHeaderView: UICollectionReusableView {
    
    public var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        self.backgroundColor = .white
        label.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.right.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK - Cell
class AppStoreCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



