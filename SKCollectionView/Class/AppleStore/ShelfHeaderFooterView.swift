//
//  ShelfHeaderFooterView.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 2017/5/25.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit

// MARK: - Shelf Layout UICollectionReusableView
public class ShelfHeaderFooterView: UICollectionReusableView {
    
    var view: UIView? {
        willSet {
            view?.removeFromSuperview()
        }
        didSet {
            if let view = view {
                addSubview(view)
                view.topAnchor.constraint(equalTo: topAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            }
        }
    }
    
    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let layoutAttributes = layoutAttributes as? CollectionViewShelfLayoutHeaderFooterViewLayoutAttributes {
            view = layoutAttributes.view
        }
        super.apply(layoutAttributes)
    }
}


// MARK: - App Store Collection Layout Data Types
public class CollectionViewShelfLayoutHeaderFooterViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var view: UIView!
}


public class CollectionViewShelfLayoutInvalidationContext: UICollectionViewLayoutInvalidationContext {
    public let panningScrollView: TrackingScrollView?
    
    override public var invalidateEverything: Bool {
        if panningScrollView == nil {
            return super.invalidateEverything
        } else {
            return false
        }
    }
    
    override public var invalidateDataSourceCounts: Bool {
        if panningScrollView == nil {
            return super.invalidateDataSourceCounts
        } else {
            return false
        }
    }
    
    override init() {
        self.panningScrollView = nil
    }
    
    init(panningScrollView: TrackingScrollView) {
        self.panningScrollView = panningScrollView
        
        super.init()
    }
}
