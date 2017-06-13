//
//  ContentCell.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 2017/6/13.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit

class ContentCell: UICollectionViewCell {
    
    class var reuseIdentifier: String { return "\(self)" }
    class var kind: String { return "ContentCell" }
    
    var label: UILabel!
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = UIColor.white
            
            return label
        }()
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        UIView.performWithoutAnimation {
            self.backgroundColor = nil
        }
    }
    
    // MARK: Layout
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        layoutIfNeeded()
    }
}
