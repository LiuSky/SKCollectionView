//
//  StickyHeadersCollectionReusableView.swift
//  CollectionView(Swift)
//
//  Created by xiaobin liu on 16/3/9.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit

class StickyHeadersCollectionReusableView: UICollectionReusableView {
    
    private lazy var titleLabel: UILabel = {
       
        let temporaryLabel = UILabel()
        temporaryLabel.backgroundColor = UIColor.clearColor()
        temporaryLabel.textAlignment = .Left
        temporaryLabel.textColor = UIColor.whiteColor()
        return temporaryLabel
    }()
    
    
    func configurationView() {
        addSubview(titleLabel)
    }
    
    
    func configurationLocation() {
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    }
    
    var title: String? {
        didSet {
           titleLabel.text = title.map {
                String.localizedStringWithFormat(NSLocalizedString("%@", comment: "空"), $0)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.redColor()
        configurationView()
        configurationLocation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
