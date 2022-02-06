//
//  StackCardLayout.swift
//  StackCards
//
//  Created by Abhishek Kumar on 06/02/22.
//

import Foundation
import UIKit

internal protocol StackCardLayoutDatasource: AnyObject {
    var stackedCardState: StackedCardState { get }
    var configuration: Configuration { get }
}

class StackCardLayout: UICollectionViewLayout {
    var contentHeight: CGFloat = 0.0
    var dataSource: StackCardLayoutDatasource!
    var cachedLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
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
        contentHeight = dataSource.stackedCardState == .expanded ? 0.0
        : CGFloat(dataSource.configuration.expandedHeight)
        guard let noOfItems = collectionView?.numberOfItems(inSection: 0) else {
            return
        }
        for index in 0..<noOfItems {
            let layout = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 0))
            layout.frame = calculateFrame(for: index, cardState: dataSource.stackedCardState)
            if dataSource.stackedCardState == .expanded {
                contentHeight += CGFloat(dataSource.configuration.verticalSpacing) + layout.frame.size.height
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
    
    func calculateFrame(for index: Int, cardState: StackedCardState) -> CGRect {
        var frame = CGRect(origin: CGPoint(x: CGFloat(dataSource.configuration.leftSpacing),
                                           y: 0), size: CGSize(width:UIScreen.main.bounds.width - CGFloat(dataSource.configuration.leftSpacing + dataSource.configuration.rightSpacing), height: CGFloat(dataSource.configuration.cardHeight)))
        var frameOrigin = frame.origin
        switch cardState {
        case .expanded:
            let val = (dataSource.configuration.cardHeight * Float(index))
            frameOrigin.y = CGFloat(Float(dataSource.configuration.verticalSpacing * Float(index)) + val)

        case .collapsed:
            if index > 0 {
                frameOrigin.y = CGFloat(dataSource.configuration.verticalSpacing + (dataSource.configuration.cardOffset * Float(index)))
            }
        }
        frame.origin = frameOrigin
        return frame
    }
}
