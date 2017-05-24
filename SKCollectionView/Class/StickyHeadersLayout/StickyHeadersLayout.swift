//
//  StickyHeadersLayout.swift
//  CollectionView(Swift)
//
//  Created by xiaobin liu on 16/3/9.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit

/*为了实现这种效果，我们需要遵守三个规则：
section 中第一个 cell 到屏幕顶部的距离为一个 header height 时，header 就不能再向上滑动了（被固定在屏幕顶部）
向下滑动时，section header 一旦和下面的 section 底部距离超过一个 header height 就不能再向下了（同样被固定在屏幕顶部）
在遵循前两个规则的基础上，其余的时间我们使用 contentOffset
*/


class StickyHeadersLayout: UICollectionViewFlowLayout {
    
    
    //返回YES使集合视图重新查询几何信息的布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    //先调用 super，只返回当前可见 elements 的 attributes，包括 cells, supplementary views, 和 decoration views
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        //先调用 super，只返回当前可见 elements 的 attributes，包括 cells, supplementary views, 和 decoration views
        var layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        
        let headersNeedingLayout = NSMutableIndexSet()
        
        //找出当前 cell 对应的 section 索引
        for attributes in layoutAttributes! {
            if attributes.representedElementCategory == .cell {
                headersNeedingLayout.add(attributes.indexPath.section)
            }
        }
        
        // 遍历当前屏幕上显示的所有 header，然后将还显示在屏幕上的 header 对应的索引从 headerNeedingLayout 中移除，这样就只保持了对刚刚移出屏幕 header 的追踪
        for attributes in layoutAttributes! {
            if let elementKind = attributes.representedElementKind {
                if elementKind == UICollectionElementKindSectionHeader {
                    headersNeedingLayout.remove(attributes.indexPath.section)
                }
            }
        }
        
        //将刚移出屏幕的 header（Missing Headers）加入 layoutAttributes
        headersNeedingLayout.enumerate({ index, stop in
            let indexPath = IndexPath(item: 0, section: index)
            let attributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
            layoutAttributes!.append(attributes!)
        })
        
        
        /*经过上面的操作，layoutAttributes 里保存着当前屏幕上所有元素 + 上一个 section header 的 attributes，接下来我们找出这两个 header 的 attributes（接上 TODO）
        */
        
        
        for attributes in layoutAttributes! {
            
            //找出 header 的 attributes 如果是 Cell 的话 representedElementKind 就为 nil
            if let elementKind = attributes.representedElementKind {
                
                
                if elementKind == UICollectionElementKindSectionHeader {
                    
                    // 找出 header 当前所在的 section
                    let section = attributes.indexPath.section
                    
                    //分别返回当前 section 中第一个 item 和 最后一个 item 所对应的 attributes
                    let attributesForFirstItemInSection = layoutAttributesForItem(at: IndexPath(item: 0, section: section))
                    
                    
                    let attributesForLastItemInSection = layoutAttributesForItem(at: IndexPath(item: collectionView!.numberOfItems(inSection: section) - 1, section: section))
                    
                    //得到 header 的 frame
                    var frame = attributes.frame
                    
                    //找出当前的滑动距离
                    let offset = collectionView!.contentOffset.y + 64
                    
                    //接下来我们来践行一开始提到的三个规则
                    let minY = attributesForFirstItemInSection!.frame.minY - frame.height
                    let maxY = attributesForLastItemInSection!.frame.maxY - frame.height
                    
                    //minY ≤ offset ≤ maxY
                    let y = min(max(offset, minY), maxY)
                    
                    frame.origin.y = y
                    
                    
                    attributes.frame = frame
                    attributes.zIndex = 99
                }
            }
        }
        return layoutAttributes
    }
}
