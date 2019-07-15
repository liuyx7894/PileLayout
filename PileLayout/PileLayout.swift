//
//  PileLayout.swift
//  PileLayout
//
//  Created by Louis Liu on 2019/2/26.
//  Copyright © 2019 Louis Liu. All rights reserved.
//

import UIKit

class PileLayout: UICollectionViewLayout {
    
    public var itemSize: CGSize           = CGSize(width: 140, height: 200) { didSet{ invalidateLayout() } }
    public var minimumLineSpacing:CGFloat = 15 { didSet { invalidateLayout() } }
    public var sectionInset:UIEdgeInsets  = UIEdgeInsets.zero { didSet { invalidateLayout() } }
    public var stackCount:Int             = 1 { didSet { invalidateLayout() } }
    public var minScale:CGFloat           = 0.94 { didSet { invalidateLayout() } }
    public var maxScale:CGFloat           = 1.18 { didSet { invalidateLayout() } }
    
    fileprivate var contentOffset:CGPoint   { return collectionView.contentOffset }
    fileprivate var bounds:CGRect           { return collectionView.bounds }
    fileprivate var totalCount:Int          { return collectionView.numberOfItems(inSection: 0) }
    fileprivate var visibleCount:Int        { return Int(bounds.width/itemSize.width) + 1  }
    fileprivate var baseX:CGFloat           { return itemSize.width/2 }
    fileprivate var minIndex:Int            { return Int(contentOffset.x/itemSize.width) }
    fileprivate var maxIndex:Int            { return totalCount}
    fileprivate var deltaOffset:CGFloat     { return CGFloat(Int(collectionView.contentOffset.x) % Int(collectionView.bounds.width)) }
    fileprivate var percentDelta:CGFloat    { return CGFloat(deltaOffset) / bounds.width }
    fileprivate var defaultAlpha:CGFloat    { return 0.8 }
    fileprivate var scaleSizeOffset:CGFloat { return minimumLineSpacing * 2 }

    override func prepare() {
        super.prepare()
    }
    
    override var collectionView: UICollectionView{
        return super.collectionView!
    }
    
    override var collectionViewContentSize: CGSize{
        let itemsCount = CGFloat(collectionView.numberOfItems(inSection: 0))
        return CGSize(width: itemSize.width * itemsCount + baseX + minimumLineSpacing*2,
                      height: collectionView.bounds.height)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let offset = proposedContentOffset.x/itemSize.width
        let currentPercent = offset - CGFloat(minIndex)
        print(currentPercent)
        if currentPercent < 0.5 {
            return CGPoint(x: CGFloat(minIndex) * itemSize.width, y: 0)
        }else{
            return CGPoint(x: CGFloat(minIndex+1) * itemSize.width, y: 0)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = [UICollectionViewLayoutAttributes]()
        for i in 0..<totalCount {
            let index = IndexPath(row: i, section: 0)
            
            attrs.append(getAttribute(index: index))
        }
        return attrs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return getAttribute(index:indexPath)
    }
    
    func getAttribute(index:IndexPath)->UICollectionViewLayoutAttributes{
        let attr = UICollectionViewLayoutAttributes(forCellWith: index)
        attr.alpha = 1
        attr.size = itemSize
        attr.zIndex = index.row
        var x:CGFloat = 0
        
        let firstVisibleIndex = index.row - minIndex
        let offset = contentOffset.x/itemSize.width
        let alpha = offset - CGFloat(index.row)
        let percent = alpha<0 ? 1 : 1-alpha
        let spacingPercent = minimumLineSpacing*percent
        let scaleOffset = maxScale - 1
        
        x = (itemSize.width * CGFloat(index.row)) + baseX + minimumLineSpacing * CGFloat(firstVisibleIndex + 1)
        attr.alpha = percent < defaultAlpha ? defaultAlpha : percent

        switch firstVisibleIndex {
        case 0:
            x = contentOffset.x + baseX + minimumLineSpacing + spacingPercent
        case 1:
            x += minimumLineSpacing + scaleSizeOffset * abs(alpha)
        case 2...visibleCount:
            let t = 1-(CGFloat(firstVisibleIndex) - abs(alpha))
            x += minimumLineSpacing + spacingPercent + minimumLineSpacing * t
        default:
            attr.alpha = 0
        }
        
        if firstVisibleIndex < 0{
            attr.alpha = defaultAlpha * 1-abs(percent)
            x = contentOffset.x + itemSize.width / 2 + minimumLineSpacing + spacingPercent
        }
        
        if firstVisibleIndex == 0 {
            let defaultS:CGFloat = maxScale - (scaleOffset * (alpha))
            let s = min(defaultS, maxScale)
            attr.size = itemSize.applying(CGAffineTransform(scaleX: s, y: s))
            x += spacingPercent
        }
        
        if firstVisibleIndex == 1 {
            let defaultS:CGFloat = 1 + (scaleOffset * (1 + alpha))
            let s = min(defaultS, maxScale)
            attr.size = itemSize.applying(CGAffineTransform(scaleX: s, y: s))
        }
        
        if firstVisibleIndex == -1{
            let baseScale = 1-abs(percent)
            let scale = baseScale > minScale ? baseScale : minScale
            attr.size = itemSize.applying(CGAffineTransform(scaleX: scale, y: scale))
            
            x += spacingPercent
        }
    
        attr.center = CGPoint(x: x, y: bounds.midY)
        return attr
    }
}


