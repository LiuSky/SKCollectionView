//
//  PinterestLayout.swift
//  CollectionView(Swift)
//
//  Created by xiaobin liu on 16/3/8.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    
}


class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var photoHeight: CGFloat = 0
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! PinterestLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if attributes.photoHeight == photoHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
    
}



/// 自定义
class PinterestLayout: UICollectionViewLayout {
    
    //每个cell的间距
    var cellPadding: CGFloat = 0
    var delegate: PinterestLayoutDelegate!
    
    //默认一行一个
    var numberOfColumns = 1
    
    //缓存LayoutAttributes
    private var cache = [PinterestLayoutAttributes]()
    
    //整个collectionView的内容高度
    private var contentHeight: CGFloat = 0
    
    //扣除掉insets之后的宽度(算是重要的)
    private var width: CGFloat {
        get {
            let insets = collectionView!.contentInset
            return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
        }
    }
    
    
    override class func layoutAttributesClass() -> AnyClass {
        return PinterestLayoutAttributes.self
    }
    
    
    //返回所有内容的 contentSize，不仅仅是当前可见的
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    //override func prepareLayout() 计算每一个 item 的 size，然后为每一个 item 创建对应的 attributes，并设置 frame，最后放到缓存中去  (核心)
    override func prepareLayout() {
        
        //判断缓存是否为空
        if cache.isEmpty {
            
            //先计算每个Item的可分配宽度
            let columnWidth = width / CGFloat(numberOfColumns)
            
            //偏移量数组
            var xOffsets = [CGFloat]()
            
            //计算每个x轴的偏移量(比如一行有两个,第一个的x坐标是0，第二个就是第一个的宽度)
            for column in 0..<numberOfColumns {
                xOffsets.append(CGFloat(column) * columnWidth)
            }
            
            //y轴的偏移量临时的一个空的
            var yOffsets = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            
            //索引是第一个还是第二
            var column = 0
            
            
            for item in 0..<collectionView!.numberOfItemsInSection(0) {
                print(item)
                //计算出每个IndexPath
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                //计算出每个item的宽度(扣除掉间距)
                let width = columnWidth - (cellPadding * 2)
                
                //每个图片Item的高度(通过回调出去宽度，然后算出等比的高度)
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
                
                //每个annotation的高度
                let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                
                //实际的高度 = cell的间距 ＋ 图片的高度 + 注视的高度 + cell的间距(这边两个cellPadding是因为上面的宽度回调是扣除掉的cellPadding)
                let height = cellPadding + photoHeight + annotationHeight + cellPadding
                
                //item的Frame = x的偏移量, y的偏移量, item的宽度, 高度.
                let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
                
                //计算出真正属于item的Frame
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                
                //为了缓存住attributes
                let attributes = PinterestLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = insetFrame
                attributes.photoHeight = photoHeight
                cache.append(attributes)
                
                
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                
                //计算保存住yOffsets 的偏移量 (等于上一个的add)
                yOffsets[column] = yOffsets[column] + height
                
                //第几个索引。
                if column >= numberOfColumns - 1 {
                    column = 0
                } else {
                    column += 1
                }
            }
        }
    }
    
    // 返回 rect 内所有 cells 和 views 的 layout attributes
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
}
