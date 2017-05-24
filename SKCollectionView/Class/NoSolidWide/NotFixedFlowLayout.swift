//
//  NotFixedFlowLayout.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 16/3/10.
//  Copyright © 2016年 Sky. All rights reserved.
//

import UIKit


/// - 不滚宽的排列
class NotFixedFlowLayout: UICollectionViewFlowLayout {
    
    override  func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
       
        let attributesToReturn = super.layoutAttributesForElements(in: rect)
        for attributes in attributesToReturn! {
            
            if attributes.representedElementKind == nil {
                let indexPath = attributes.indexPath
                attributes.frame = self.layoutAttributesForItem(at: indexPath)!.frame
            }
        }
        return attributesToReturn
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)
        
        let sectionInset = self.sectionInset
        let isFirstItemInSection = indexPath.item == 0
        let layoutWidth = self.collectionView!.frame.width - sectionInset.left - sectionInset.right
        
        if isFirstItemInSection {
            currentItemAttributes?.alignFrameWithSectionInset(sectionInset)
            return currentItemAttributes
        }
        
        let  previousIndexPath = IndexPath(item: indexPath.item-1, section: indexPath.section)
        let  previousFrame = self.layoutAttributesForItem(at: previousIndexPath)?.frame
        let  previousFrameRightPoint = previousFrame!.origin.x + previousFrame!.size.width
        let  currentFrame = currentItemAttributes!.frame
        let  strecthedCurrentFrame = CGRect(x: sectionInset.left,
                    y: currentFrame.origin.y,
                    width: layoutWidth,
                    height: currentFrame.size.height)
        
        let isFirstItemInRow = !previousFrame!.intersects(strecthedCurrentFrame)
        
        if  isFirstItemInRow {
            currentItemAttributes?.alignFrameWithSectionInset(sectionInset)
            return currentItemAttributes
        }
        
        var frame = currentItemAttributes?.frame
        frame?.origin.x = previousFrameRightPoint + self.minimumInteritemSpacing
        currentItemAttributes?.frame = frame!
        return currentItemAttributes
    }
}

// MARK: - <#Description#>
extension UICollectionViewLayoutAttributes {
    
    func alignFrameWithSectionInset(_ sectionInset: UIEdgeInsets) {
        
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}
