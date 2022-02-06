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
    
    var stackedCardState: StackedCardState {
        didSet {
            switch stackedCardState {
            case .collapsed:
                stackCard?.position = .collapsed
                tapGesture.isEnabled = true
                
            case .expanded:
                stackCard?.position = .expanded
                tapGesture.isEnabled = false
            }
        }
    }
    
    var configuration: Configuration
    
    weak var delegate: StackCardsManagerDelegate?
    weak var collectionView: UICollectionView?
    weak var cardsCollectionViewHeight: NSLayoutConstraint?
    weak var stackCard: StackCard? = nil
    var tapGesture = UITapGestureRecognizer()
    

    convenience override init() {
        
        let configuration = Configuration(cardOffset: 40, collapsedHeight: 200, expandedHeight: 500, cardHeight: 200, downwardThreshold: 20, upwardThreshold: 20)
        
        self.init(stackCardState: .collapsed, configuration: configuration, collectionView: nil, heightConstraint: nil)
    }
    
    func cardsStateFromCardsPosition(position: CardsPosition) -> StackedCardState {
        switch position {
        case .expanded:
            return StackedCardState.expanded
        case .collapsed:
            return StackedCardState.collapsed
        }
    }
    
    func cardsPositionFromCardsState(state: StackedCardState) -> CardsPosition? {
        switch state {
        case .collapsed:
            return CardsPosition.expanded
        case .expanded:
            return CardsPosition.collapsed
        }
    }

    init(stackCardState: CardsPosition,
         configuration: Configuration,
         collectionView: UICollectionView?,
         heightConstraint: NSLayoutConstraint?) {
        
        switch stackCardState {
        case .expanded:
            self.stackedCardState = StackedCardState.expanded
        case .collapsed:
            self.stackedCardState = StackedCardState.collapsed
        }

        self.configuration = configuration
        cardsCollectionViewHeight = heightConstraint
        self.collectionView = collectionView
        super.init()
        guard let cardsView = self.collectionView else {
            return
        }
        let stackCardLayout = StackCardLayout()
        stackCardLayout.dataSource = self
        cardsView.collectionViewLayout = stackCardLayout
        cardsView.bounces = true
        cardsView.alwaysBounceVertical = true
        cardsView.delegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedCard))
        cardsView.addGestureRecognizer(tapGesture)
        tapGesture.isEnabled = stackCardState == .collapsed
    }
    
    @objc func tappedCard(tapGesture: UITapGestureRecognizer) {
        guard let cardsCollectionView = collectionView else {
            return
        }

        delegate?.tappedOnCardsStack?(cardsCollectionView: cardsCollectionView)
    }
    
    func triggerStateCallBack() {
        guard let position = cardsPositionFromCardsState(state: stackedCardState) else {
            return
        }
        delegate?.stackCardsPositionChangedTo?(position: position)
    }
    
    func updateView(with position: CardsPosition) {
        var ht:Float = 0.0
        stackedCardState = cardsStateFromCardsPosition(position: position)
        switch stackedCardState {
        case .collapsed:
            ht = configuration.collapsedHeight
            
        case .expanded:
            ht = configuration.expandedHeight
        }
        
        DispatchQueue.main.async { [weak self] in
            
            guard let weakSelf = self else {
                return
            }
            weakSelf.cardsCollectionViewHeight?.constant = CGFloat(ht)
            
            UIView.animate(withDuration: 0.3, animations: {
                weakSelf.collectionView?.collectionViewLayout.invalidateLayout()
                weakSelf.collectionView?.superview?.layoutIfNeeded()
                }, completion: { (finished) in
                    weakSelf.triggerStateCallBack()
            })
        }
    }
}


extension StackCardsManager: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.stackCardsCollectionView?(collectionView, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.stackCardsCollectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}

