//
//  CollectionViewShelfLayout.swift
//  SKCollectionView
//
//  Created by xiaobin liu on 2017/5/25.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit

private let ShelfElementKindCollectionHeader = "ShelfElementKindCollectionHeader"
private let ShelfElementKindCollectionFooter = "ShelfElementKindCollectionFooter"

/// An element kind of *Section Header*
public let ShelfElementKindSectionHeader = "ShelfElementKindSectionHeader"
/// An element kind of *Section Footer*
public let ShelfElementKindSectionFooter = "ShelfElementKindSectionFooter"


/// A collection view layout mimics the layout of the iOS App Store.
open class CollectionViewShelfLayout: UICollectionViewLayout {
    
    fileprivate var headerViewLayoutAttributes: CollectionViewShelfLayoutHeaderFooterViewLayoutAttributes?
    fileprivate var footerViewLayoutAttributes: CollectionViewShelfLayoutHeaderFooterViewLayoutAttributes?
    
    fileprivate var sectionsFrame: [CGRect] = []
    fileprivate var sectionsCellFrame: [CGRect] = []
    fileprivate var cellPanningScrollViews: [TrackingScrollView] = []
    
    fileprivate var sectionHeaderViewsLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    fileprivate var sectionFooterViewsLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    fileprivate var cellsLayoutAttributes: [[UICollectionViewLayoutAttributes]] = []
    
    /// 各部分标题的高度。将这个值设置为0.0如果你不想节标题的观点。默认是* 0.0 *
    @IBInspectable open var sectionHeaderHeight: CGFloat = 0.0
    /// 每个部分的高度页脚。将这个值设置为0.0如果你不想节页脚视图。默认是* 0.0 *
    @IBInspectable open var sectionFooterHeight: CGFloat = 0.0
    /// 一个插图插图每个部分的细胞区域一节页眉和页脚视图和视图的集合。默认是* 0 *在每一个方面。
    @IBInspectable open var sectionCellInset: UIEdgeInsets = UIEdgeInsets.zero
    /// 每个cell的大小。
    @IBInspectable open var cellSize: CGSize = CGSize.zero
    /// 水平细胞之间的间距。默认值* 8.0 *
    @IBInspectable open var spacing: CGFloat = 8.0
    
    /// 头集合视图的视图。类似于表视图的* tableHeaderView *
    @IBOutlet open var headerView: UIView?
    /// 页脚视图集合视图。类似于表视图的* tableFooterView *
    @IBOutlet open var footerView: UIView?
    
    /// 一个布尔值表示布局准备细胞平移。这将真正*true*当我们布局由平移电池失效。
    fileprivate var preparingForCellPanning = false
    
    public override init() {
        super.init() 
        register(ShelfHeaderFooterView.self, forDecorationViewOfKind: ShelfElementKindCollectionHeader)
        register(ShelfHeaderFooterView.self, forDecorationViewOfKind: ShelfElementKindCollectionFooter)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register(ShelfHeaderFooterView.self, forDecorationViewOfKind: ShelfElementKindCollectionHeader)
        register(ShelfHeaderFooterView.self, forDecorationViewOfKind: ShelfElementKindCollectionFooter)
    }
    
    open override func prepare() {
        
        //延迟执行
        defer {
            super.prepare()
        }
        
        guard let collectionView = collectionView else {
            return
        }
        
        if preparingForCellPanning {
            self.preparingForCellPanning = false
            return
        }
        
        headerViewLayoutAttributes = nil
        footerViewLayoutAttributes = nil
        sectionsFrame = []
        sectionsCellFrame = []
        sectionHeaderViewsLayoutAttributes = []
        sectionFooterViewsLayoutAttributes = []
        cellsLayoutAttributes = []
        
        let oldPanningScrollViews = cellPanningScrollViews
        cellPanningScrollViews = []
        
        do {
            
            //  当前Y
            var currentY = CGFloat(0.0)
            let collectionBounds = collectionView.bounds
            let collectionViewWidth = collectionBounds.width
            
            //先判断有没有headerView
            if let headerView = headerView {
                
                headerViewLayoutAttributes = CollectionViewShelfLayoutHeaderFooterViewLayoutAttributes(forDecorationViewOfKind: ShelfElementKindCollectionHeader, with: IndexPath(index: 0))
                headerViewLayoutAttributes?.view = headerView
                let headerViewSize = headerView.systemLayoutSizeFitting(CGSize(width: collectionViewWidth, height: 0.0), withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
                headerViewLayoutAttributes?.size = headerViewSize
                headerViewLayoutAttributes?.frame = CGRect(origin: CGPoint(x: collectionBounds.minX, y: currentY), size: headerViewSize)
                currentY += headerViewSize.height
            }
            
            //  MARK - 获取几个Section
            let numberOfSections = collectionView.numberOfSections
            
            for section in 0..<numberOfSections {
                let sectionMinY = currentY
                
                // 跟heightForHeaderInSection 回调类似,如果高度设为0的话，不做任何操作
                if sectionHeaderHeight > 0.0 {
                    let sectionHeaderAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ShelfElementKindSectionHeader, with: IndexPath(index: section))
                    sectionHeaderAttributes.frame = CGRect(
                        origin: CGPoint(x: collectionBounds.minX, y: currentY),
                        size: CGSize(width: collectionBounds.width, height: sectionHeaderHeight)
                    )
                    sectionHeaderViewsLayoutAttributes.append(sectionHeaderAttributes)
                    currentY += sectionHeaderHeight
                }
                
                var currentCellX = collectionBounds.minX + sectionCellInset.left
                
                if section < oldPanningScrollViews.count {
                    // 应用旧滚动抵消之前准备的布局
                    currentCellX -= oldPanningScrollViews[section].contentOffset.x
                }
                
                let cellMinX = currentCellX - sectionCellInset.left
                currentY += sectionCellInset.top
                let topSectionCellMinY = currentY
                
                var cellInSectionAttributes: [UICollectionViewLayoutAttributes] = []
                for item in 0..<collectionView.numberOfItems(inSection: section) {
                    let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: section))
                    cellAttributes.frame = CGRect(
                        origin: CGPoint(x: currentCellX, y: currentY),
                        size: cellSize
                    )
                    currentCellX += cellSize.width + spacing
                    cellInSectionAttributes.append(cellAttributes)
                }
                let sectionCellFrame = CGRect(
                    origin: CGPoint(x: 0.0, y: topSectionCellMinY),
                    size: CGSize(width: currentCellX - spacing + sectionCellInset.right - cellMinX, height: cellSize.height)
                )
                sectionsCellFrame.append(sectionCellFrame)
                
                cellsLayoutAttributes.append(cellInSectionAttributes)
                currentY += cellSize.height + sectionCellInset.bottom
                
                // MARK - 同上
                if sectionFooterHeight > 0.0 {
                    let sectionHeaderAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ShelfElementKindSectionFooter, with: IndexPath(index: section))
                    sectionHeaderAttributes.frame = CGRect(
                        origin: CGPoint(x: collectionBounds.minX, y: currentY),
                        size: CGSize(width: collectionBounds.width, height: sectionFooterHeight)
                    )
                    sectionFooterViewsLayoutAttributes.append(sectionHeaderAttributes)
                    currentY += sectionFooterHeight
                }
                
                let sectionFrame = CGRect(
                    origin: CGPoint(x: 0.0, y: sectionMinY),
                    size: CGSize(width: collectionViewWidth, height: currentY - sectionMinY)
                )
                sectionsFrame.append(sectionFrame)
                
                let panningScrollView = TrackingScrollView(frame: CGRect(origin: CGPoint.zero, size: sectionFrame.size))
                panningScrollView.delegate = self
                panningScrollView.trackingView = collectionView
                panningScrollView.trackingFrame = sectionCellFrame
                if section < oldPanningScrollViews.count {
                    // 应用滚动内容抵消老抵消之前准备的布局
                    panningScrollView.contentOffset = oldPanningScrollViews[section].contentOffset
                }
                
                cellPanningScrollViews.append(panningScrollView)
            }
            
            // MARK - 添加footview
            if let footerView = footerView {
                footerViewLayoutAttributes = CollectionViewShelfLayoutHeaderFooterViewLayoutAttributes(forDecorationViewOfKind: ShelfElementKindCollectionFooter, with: IndexPath(index: 0))
                footerViewLayoutAttributes?.view = footerView
                let footerViewSize = footerView.systemLayoutSizeFitting(CGSize(width: collectionViewWidth, height: 0.0), withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
                footerViewLayoutAttributes?.size = footerViewSize
                footerViewLayoutAttributes?.frame = CGRect(origin: CGPoint(x: collectionBounds.minX, y: currentY), size: footerViewSize)
                currentY += footerViewSize.height
            }
        }
    }
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        let width = collectionView.bounds.width
        let numberOfSections = CGFloat(collectionView.numberOfSections)
        
        let headerHeight = headerViewLayoutAttributes?.size.height ?? 0.0
        let footerHeight = footerViewLayoutAttributes?.size.height ?? 0.0
        let sectionHeaderHeight = self.sectionHeaderHeight * numberOfSections
        let sectionFooterHeight = self.sectionFooterHeight * numberOfSections
        
        let sectionCellInsetHeight = (sectionCellInset.bottom + sectionCellInset.top) * numberOfSections
        
        return CGSize(
            width: width,
            height: headerHeight + footerHeight + sectionHeaderHeight + sectionFooterHeight + sectionCellInsetHeight + (cellSize.height * numberOfSections)
        )
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let headerAndFooterAttributes: [UICollectionViewLayoutAttributes] = [ headerViewLayoutAttributes, footerViewLayoutAttributes ].compactMap({ $0 }).filter { (attributes) -> Bool in
            return rect.intersects(attributes.frame)
        }
        
        let visibleSections = sectionsFrame.enumerated().filter({ (index: Int, element: CGRect) -> Bool in
            return rect.intersects(element)
        }).map({ $0.offset })
        
        let visibleAttributes = visibleSections.flatMap { (section) -> [UICollectionViewLayoutAttributes] in
            var attributes: [UICollectionViewLayoutAttributes] = []
            if section < self.sectionHeaderViewsLayoutAttributes.count {
                let header = self.sectionHeaderViewsLayoutAttributes[section]
                if rect.intersects(header.frame) {
                    attributes.append(header)
                }
            }
            
            let visibleCellAttributes = self.cellsLayoutAttributes[section].filter({ (attributes) -> Bool in
                return rect.intersects(attributes.frame)
            })
            
            attributes += visibleCellAttributes
            
            if section < self.sectionFooterViewsLayoutAttributes.count {
                let footer = self.sectionFooterViewsLayoutAttributes[section]
                if rect.intersects(footer.frame) {
                    attributes.append(footer)
                }
            }
            
            return attributes
        }
        
        return visibleAttributes + headerAndFooterAttributes
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellsLayoutAttributes[indexPath.section][indexPath.row]
    }
    
    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case ShelfElementKindCollectionHeader:
            return headerViewLayoutAttributes
        case ShelfElementKindCollectionFooter:
            return footerViewLayoutAttributes
        default:
            return nil
        }
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case ShelfElementKindSectionHeader:
            return sectionHeaderViewsLayoutAttributes[indexPath.section]
        case ShelfElementKindSectionFooter:
            return sectionFooterViewsLayoutAttributes[indexPath.section]
        default:
            return nil
        }
    }
    
    // MARK - 该方法使布局的部分区域失效，而不是全局失效。是对invalidateLayout的一种优化，这种优化基于UICollectionViewLayoutInvalidationContext 类型的属性。如果你自定义了UICollectionViewLayoutInvalidationContext ，就应该重载该方法，并使用自定义的类型。重载该方法的时候，必须调用super类。
    open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if let context = context as? CollectionViewShelfLayoutInvalidationContext,
            let panningInformation = context.panningScrollView,
            let indexOfPanningScrollView = cellPanningScrollViews.index(of: panningInformation) {
            
            let panningCellsAttributes = cellsLayoutAttributes[indexOfPanningScrollView]
            let minX = panningCellsAttributes.reduce(CGFloat.greatestFiniteMagnitude, { (currentX, attributes) in
                return min(currentX, attributes.frame.minX)
            }) - sectionCellInset.left
            
            let offset = -panningInformation.contentOffset.x - minX
            
            // UICollectionViewLayout will not guarantee to call prepareLayout on every invalidation.
            // So we do the panning cell translation in the invalidate layout so that we can guarantee that every panning will be accounted.
            panningCellsAttributes.forEach({ (attributes) in
                attributes.frame = attributes.frame.offsetBy(dx: offset, dy: 0.0)
            })
            
            self.preparingForCellPanning = true
        }
        
        super.invalidateLayout(with: context)
    }
    
    
    /// MARK - 当你子类化UICollectionViewLayout，并且使用自定义的 invalidation context对象优化布局更新，重载该方法，返回UICollectionViewLayoutInvalidationContext的子类。当 collection view 需要invalidate你的布局的时候，将会用该方法返回值创建正确的invalidation context 对象。
    open override class var invalidationContextClass: AnyClass {
        return CollectionViewShelfLayoutInvalidationContext.self
    }
    
}


// MARK: - UIScrollViewDelegate methods
extension CollectionViewShelfLayout: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Because we tell Collection View that it has its width of the content size equals to its width of its frame (and bounds).
        // This means that we can use its pan gesture recognizer to scroll our cells
        // Our hack is to use a scroll view per section, steal that scroll view's pan gesture recognizer and add it to collection view.
        // Uses the scroll view's content offset to tell us how uses scroll our cells
        guard let trackingScrollView = scrollView as? TrackingScrollView else { return }
        
        let context = CollectionViewShelfLayoutInvalidationContext(panningScrollView: trackingScrollView)
        invalidateLayout(with: context)
    }
}
