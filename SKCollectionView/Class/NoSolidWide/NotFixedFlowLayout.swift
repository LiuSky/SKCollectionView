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
    
    override  func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
       
        let attributesToReturn = super.layoutAttributesForElementsInRect(rect)
        for attributes in attributesToReturn! {
            
            if attributes.representedElementKind == nil {
                let indexPath = attributes.indexPath
                attributes.frame = self.layoutAttributesForItemAtIndexPath(indexPath)!.frame
            }
        }
        return attributesToReturn
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let currentItemAttributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        
        let sectionInset = self.sectionInset
        let isFirstItemInSection = indexPath.item == 0
        let layoutWidth = CGRectGetWidth(self.collectionView!.frame) - sectionInset.left - sectionInset.right
        
        if isFirstItemInSection {
            currentItemAttributes?.alignFrameWithSectionInset(sectionInset)
            return currentItemAttributes
        }
        
        let  previousIndexPath = NSIndexPath(forItem: indexPath.item-1, inSection: indexPath.section)
        let  previousFrame = self.layoutAttributesForItemAtIndexPath(previousIndexPath)?.frame
        let  previousFrameRightPoint = previousFrame!.origin.x + previousFrame!.size.width
        let  currentFrame = currentItemAttributes!.frame
        let  strecthedCurrentFrame = CGRectMake(sectionInset.left,
                    currentFrame.origin.y,
                    layoutWidth,
                    currentFrame.size.height)
        
        let isFirstItemInRow = !CGRectIntersectsRect(previousFrame!, strecthedCurrentFrame)
        
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
    
    func alignFrameWithSectionInset(sectionInset: UIEdgeInsets) {
        
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}
