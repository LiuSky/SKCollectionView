//
//  QQLayout.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 2017/5/25.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit


/// MARK - QQ更多Layout
final class QQLayout: UICollectionViewLayout {

    // MARK - sectionInset
    open var sectionInset: UIEdgeInsets = UIEdgeInsets.zero

    // MARK - 水平细胞之间的间距。默认值* 8.0 *
    open var spacing: CGFloat = 8.0
    
    // MARK - 垂直几个
    open var verticalNumber = 0

    // MARK - 水平几个
    open var horizontalNumber = 0
    
    // MARK - 缓存每个Item
    private var cache = [UICollectionViewLayoutAttributes]()
    
    
    /// MARK - 重写size
    override var collectionViewContentSize: CGSize {
        
        guard let collectionView = collectionView else {
            return .zero
        }
        
        let height = collectionView.bounds.height
        let count = collectionView.numberOfItems(inSection: 0)
        let screenIndex = count / (verticalNumber * horizontalNumber) + 1
        let width = CGFloat(screenIndex) * collectionView.bounds.width
        return CGSize(width: width, height: height)
    }
    
    
    
    /// MARK - 重写每个布局
    override func prepare() {
        
        //延迟执行
        defer {
            super.prepare()
        }
        
        guard let collectionView = collectionView else {
            return
        }
        
        guard verticalNumber > 0,
              horizontalNumber > 0 else {
            return
        }
        
        if cache.isEmpty {
           
            let horizontalInsets = CGFloat(horizontalNumber - 1) * spacing
            let verticalInsets = CGFloat(verticalNumber - 1) * spacing
            let itemWidth = (collectionView.bounds.width - sectionInset.left - sectionInset.right - horizontalInsets) / CGFloat(horizontalNumber)
            let itemHeight = (collectionView.bounds.height - sectionInset.top - sectionInset.bottom - verticalInsets) /
                CGFloat(verticalNumber)
            
            var xIndex = 1
            var yIndex = 0
            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                // MARK - 计算现在item属于第几屏
                let screenIndex = item / (verticalNumber * horizontalNumber)
                let width = CGFloat(screenIndex) * collectionView.bounds.width
                
                attributes.frame = CGRect(x: width + sectionInset.left + CGFloat(xIndex - 1)*itemWidth + CGFloat(xIndex - 1) * spacing, y: sectionInset.top + CGFloat(yIndex)*itemHeight + CGFloat(yIndex) * spacing, width: itemWidth, height: itemHeight)
                cache.append(attributes)
                
                if xIndex == horizontalNumber {
                    xIndex = 1
                    yIndex += 1
                } else {
                    xIndex += 1
                }
                
                if yIndex == verticalNumber {
                    yIndex = 0
                }
            }
        }
    }
    
    override  func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
}

