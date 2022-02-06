//
//  StackCardLayout.swift
//  StackCards
//
//  Created by Abhishek Kumar on 06/02/22.
//

import Foundation
import UIKit

internal protocol StackCardLayoutDatasource: AnyObject {
    var configuration: Configuration { get }
    var tappedItemStatus: (indexPath: IndexPath?, status: StackedCardState?) { get }
}

class StackCardLayout: UICollectionViewLayout {
    var contentHeight: CGFloat = 0.0
    var dataSource: StackCardLayoutDatasource!
    var cachedLayoutAttributes = [UICollectionViewLayoutAttributes]()
    private var lastOffset: CGFloat = 0.0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        let collection = collectionView!
        let width = collection.bounds.size.width
        let height = contentHeight
        return CGSize(width: width, height: height)
    }
    
    override func prepare() {
        cachedLayoutAttributes.removeAll()
        contentHeight = dataSource.tappedItemStatus.status == .expanded ? 0.0
        : CGFloat(dataSource.configuration.expandedHeight)
        guard let noOfItems = collectionView?.numberOfItems(inSection: 0) else {
            return
        }
        for index in 0..<noOfItems {
            let layout = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 0))
            layout.frame = calculateFrame(for: index)
            if dataSource.tappedItemStatus.status == .collapsed && index == dataSource.tappedItemStatus.indexPath?.row{
                contentHeight +=  layout.frame.size.height
            }
            layout.zIndex = index
            layout.isHidden = false
            cachedLayoutAttributes.append(layout)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in cachedLayoutAttributes {
            if attribute.frame.intersects(rect) {
                layoutAttributes.append(cachedLayoutAttributes[attribute.indexPath.item])
            }
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedLayoutAttributes[indexPath.item]
    }
    
    func calculateFrame(for index: Int) -> CGRect {
        var frame = CGRect(origin: CGPoint(x: CGFloat(dataSource.configuration.leftSpacing),
                                           y: 0), size: CGSize(width:UIScreen.main.bounds.width - CGFloat(dataSource.configuration.leftSpacing + dataSource.configuration.rightSpacing), height: CGFloat(dataSource.configuration.cardHeight)))
        var frameOrigin = frame.origin
        let itemStatus = dataSource.tappedItemStatus
        if itemStatus.status != nil && itemStatus.status == .collapsed {
            if let row = itemStatus.indexPath?.row {
                if index <= row {
                    let offset = (Float(index) * dataSource.configuration.cardOffset)
                    frameOrigin.y = contentHeight - CGFloat(dataSource.configuration.cardHeight - offset)
                    if index == row {
                        lastOffset = frameOrigin.y
                    }
                    print("less equal","index", index, "row", row, "yOrigin", frameOrigin.y)
                } else {
                    frameOrigin.y = lastOffset +  CGFloat(dataSource.configuration.cardOffset * Float(index))
                    print("greater","index", index, "row", row, "yOrigin", frameOrigin.y)
                }
            }
            
        } else {
            if index > 0 {
                frameOrigin.y = CGFloat(dataSource.configuration.verticalSpacing + (dataSource.configuration.cardOffset * Float(index)))
            }
        }
        frame.origin = frameOrigin
        return frame
    }
}
