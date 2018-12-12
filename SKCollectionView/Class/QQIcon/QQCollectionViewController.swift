//
//  QQCollectionViewController.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 2017/5/25.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class QQCollectionViewController: UICollectionViewController {

    init() {
        let layout = QQLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.spacing = 20
        layout.horizontalNumber = 3
        layout.verticalNumber = 9
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = .white
        self.collectionView?.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        self.collectionView!.isPagingEnabled = true
        self.collectionView!.register(LabelCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 58
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LabelCell
        cell.contentView.backgroundColor = .yellow
        cell.label.text = "\(indexPath.row)"
        return cell
    }
}



