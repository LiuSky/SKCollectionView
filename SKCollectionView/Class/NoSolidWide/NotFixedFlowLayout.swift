//
//  NotFixedFlowLayout.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 16/3/10.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit


/// MARK - 协议
protocol NotFixedLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}


/// MARK - 不规则Attributes
final class NotFixedLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var customWidth: CGFloat = 0
    
    // MARK - 实现此方法确保自定义的属性被拷贝
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! NotFixedLayoutAttributes
        copy.customWidth = customWidth
        return copy
    }
    
    // MARK -  在 iOS 7 之后，只有 attributes 改变之后，collection view 才会应用，如何判断改变了呢，就要用到此方法，先实现自定义属性的判断，再调用 super
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? NotFixedLayoutAttributes {
            if attributes.customWidth == customWidth {
                return super.isEqual(object)
            }
        }
        return false
    }   
}


/// - MARK - 不规则的排列
public class NotFixedFlowLayout: UICollectionViewLayout {
    
    // MARK - 每个cell的间距
    var cellPadding: CGFloat = 0
    
    // MARK - 每个cell 的高度
    var cellHeight: CGFloat = 40
    
    // MARK - 委托
    var delegate: NotFixedLayoutDelegate!
    
    // MARK - 缓存LayoutAttributes
    fileprivate var cache = [NotFixedLayoutAttributes]()
    
    // MARK - 整个collectionView的内容高度
    fileprivate var contentHeight: CGFloat = 0
    
    // MARK - 扣除掉insets之后的宽度(算是重要的)
    fileprivate var width: CGFloat {
        get {
            let insets = collectionView!.contentInset
            return collectionView!.bounds.width - (insets.left + insets.right)
        }
    }
    
    
    override public class var layoutAttributesClass : AnyClass {
        return PinterestLayoutAttributes.self
    }
    
    
    // MARK - 返回所有内容的 contentSize，不仅仅是当前可见的
    override public var collectionViewContentSize : CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    // MARK - 计算每个item 的size
    public override func prepare() {
        
        // 如果缓存为空
        if cache.isEmpty {
            
            //遍历每个Item
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
             
                let indexPath = IndexPath(item: item, section: 0)
                
                let itemWidth = delegate.collectionView(collectionView!, widthForPhotoAtIndexPath: indexPath)
                
                let attributes = NotFixedLayoutAttributes(forCellWith: indexPath)
                attributes.customWidth = itemWidth
                
                
                let isFirstItemInRow = indexPath.item == 0
                
                if isFirstItemInRow {
                    
                    attributes.frame = CGRect(x: 0, y: cellPadding, width: itemWidth, height: self.cellHeight)
                    cache.append(attributes)
                } else {
                    
                    let previousFrame = cache[item - 1]
                    let previousFrameRightPoint = previousFrame.frame.origin.x + previousFrame.customWidth
                    let previousFrameYPoint = previousFrame.frame.maxY
                    if previousFrameRightPoint + cellPadding + itemWidth > width {
                        
                        attributes.frame = CGRect(x: 0, y: previousFrameYPoint + cellPadding, width: itemWidth, height: self.cellHeight)
                        cache.append(attributes)
                    } else {
                        
                        attributes.frame = CGRect(x: previousFrameRightPoint + cellPadding, y: previousFrame.frame.origin.y, width: itemWidth, height: self.cellHeight)
                        cache.append(attributes)
                    }
                }
                
                if collectionView!.numberOfItems(inSection: 0) == cache.count {
                    self.contentHeight = cache[cache.count - 1].frame.maxY
                }
            }
        }
    }
    
    
    override  public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
}

