//
//  StackCardsManager.swift
//  StackCards
//
//  Created by Abhishek Kumar on 06/02/22.
//

import Foundation
import UIKit


internal enum StackedCardState {
    case expanded
    case collapsed
}

class StackCardsManager: NSObject, StackCardLayoutDatasource {
    
    var needToReset: Bool = false
    
    
    var tappedItemStatus: (indexPath: IndexPath?, status: CardsPosition?) {
        return (itemIndexPath, itemStatus)
    }
    
    private var itemIndexPath: IndexPath?
    
    private var itemStatus: CardsPosition?
    
    var configuration: Configuration
    
    weak var delegate: StackCardsManagerDelegate?
    weak var datasource: StackCardManagerDataSource?
    weak var collectionView: UICollectionView?
    weak var cardsCollectionViewHeight: NSLayoutConstraint?
    weak var stackCard: StackCard? = nil
    
    func cardsStateFromCardsPosition(position: CardsPosition?) -> StackedCardState? {
        switch position {
        case .expanded:
            return StackedCardState.expanded
        case .collapsed:
            return StackedCardState.collapsed
        default:
            return nil
        }
    }

    init(stackCardState: CardsPosition,
         configuration: Configuration,
         collectionView: UICollectionView,
         heightConstraint: NSLayoutConstraint?) {

        self.configuration = configuration
        cardsCollectionViewHeight = heightConstraint
        self.collectionView = collectionView
        super.init()
        let stackCardLayout = StackCardLayout()
        stackCardLayout.dataSource = self
        self.collectionView?.collectionViewLayout = stackCardLayout
        self.collectionView?.bounces = true
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.dataSource = self
    }
    
    func updateView(with position: CardsPosition) {
        var ht:Float = 0.0
        let stackedCardState = cardsStateFromCardsPosition(position: position)
        switch stackedCardState {
        case .collapsed:
            ht = configuration.expandedHeight
        case .expanded:
            ht = configuration.collapsedHeight
        default:
            ht = configuration.collapsedHeight
        }
        
        DispatchQueue.main.async { [weak self] in
            
            guard let weakSelf = self else {
                return
            }
            UIView.animate(withDuration: 0.3, animations: {
                weakSelf.needToReset = false
                weakSelf.collectionView?.collectionViewLayout.invalidateLayout()
                weakSelf.cardsCollectionViewHeight?.constant = CGFloat(ht)
                weakSelf.collectionView?.superview?.layoutIfNeeded()
            })
        }
    }
}

extension StackCardsManager: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.stack(collectionView, numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let datasource = datasource else {
            fatalError("datasouce instance not available please check")
        }
        return datasource.stack(collectionView, cellForItemAt: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource?.numberOfSectionsStackCard?(in: collectionView) ?? 0
    }
}

extension StackCardsManager {
    
    func register<T: StackCardCell>(_ cellClass: T.Type?, forCellWithReuseIdentifier identifier: String) {
        collectionView?.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCellStackCard(withReuseIdentifier identifier: String,
                                      for indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionView = collectionView else {
            fatalError("collection view is not present")
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                            for: indexPath) as? StackCardCell else {
            fatalError("cell is not dequed")
        }
        cell.indexPath = indexPath
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTap(_:)))
        cell.addGestureRecognizer(tapGesture)
       return cell
   }
    
    @objc func cellTap(_ sender: UITapGestureRecognizer) {
        needToReset = true
        collectionView?.collectionViewLayout.invalidateLayout()
        if  let cell = sender.view as? StackCardCell {
            itemStatus = cell.cellState
            itemIndexPath = cell.indexPath
            delegate?.stack?(tappded: cell, for: cell.indexPath, state: cell.cellState )
            updateView(with: cell.cellState)
            if cell.cellState == .collapsed {
                cell.cellState = .expanded
            } else {
                cell.cellState = .collapsed
            }
        }
    }
}

