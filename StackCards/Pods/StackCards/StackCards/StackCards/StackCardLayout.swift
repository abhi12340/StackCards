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
    var tappedItemStatus: (indexPath: IndexPath?, status: CardsPosition?) { get }
    var needToReset: Bool { get set }
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
        lastOffset = 0
        cachedLayoutAttributes.removeAll()
        contentHeight = dataSource.tappedItemStatus.status == .expanded ? 0.0
        : CGFloat(dataSource.configuration.expandedHeight)
        guard let noOfItems = collectionView?.numberOfItems(inSection: 0) else {
            return
        }
        if dataSource.needToReset {
            resetFrame(for: noOfItems)
        } else {
            createFrame(for: noOfItems)
        }
    }
    
    private func resetFrame(for items: Int) {
        for index in 0..<items {
            let layout = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 0))
            layout.frame = resetToCollapse(index: index)
            layout.zIndex = index
            layout.isHidden = false
            cachedLayoutAttributes.append(layout)
        }
    }
    
    private func createFrame(for items: Int) {
        for index in 0..<items {
            let layout = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 0))
            layout.frame = calculateFrame(for: index)
            if dataSource.tappedItemStatus.status == .collapsed && index == dataSource.tappedItemStatus.indexPath?.row{
                contentHeight +=  layout.frame.size.height
            } else {
                if let cell = collectionView?.cellForItem(at: IndexPath(row: index, section: 0)) as? StackCardCell {
                    cell.cellState = .collapsed
                }
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
                if row == 0 {
                    if index > 0 {
                        frameOrigin.y = lastOffset +  CGFloat(dataSource.configuration.cardOffset * Float(index - 1))
                        print("greater","index", index + 1, "row", row, "yOrigin", frameOrigin.y)
                    } else {
                        let offset = (Float(index + 1) * dataSource.configuration.cardOffset)
                        frameOrigin.y = contentHeight - CGFloat(dataSource.configuration.cardHeight - offset)
                        print("less equal","index", index + 1, "row", row, "yOrigin", frameOrigin.y)
                        lastOffset = frameOrigin.y + CGFloat(dataSource.configuration.cardHeight)
                    }
                } else {
                    if index <= row {
                        let offset = (Float(index) * dataSource.configuration.cardOffset)
                        frameOrigin.y = contentHeight - CGFloat(dataSource.configuration.cardHeight - offset)
                        if index == row {
                            lastOffset = frameOrigin.y + CGFloat(dataSource.configuration.cardHeight)
                        }
                        print("less equal","index", index, "row", row, "yOrigin", frameOrigin.y)
                    } else {
                        frameOrigin.y = lastOffset + CGFloat(dataSource.configuration.cardOffset * Float(index - row - 1))
                        print("greater","index", index, "row", row, "yOrigin", frameOrigin.y)
                    }
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
    
    func resetToCollapse(index: Int) -> CGRect {
        var frame = CGRect(origin: CGPoint(x: CGFloat(dataSource.configuration.leftSpacing),
                                           y: 0), size: CGSize(width:UIScreen.main.bounds.width - CGFloat(dataSource.configuration.leftSpacing + dataSource.configuration.rightSpacing), height: CGFloat(dataSource.configuration.cardHeight)))
        var frameOrigin = frame.origin
        frame.origin = frameOrigin
        if index > 0 {
            frameOrigin.y = CGFloat(dataSource.configuration.verticalSpacing + (dataSource.configuration.cardOffset * Float(index)))
        }
        return frame
    }
}
