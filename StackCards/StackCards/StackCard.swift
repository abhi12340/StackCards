//
//  StackCard.swift
//  StackCards
//
//  Created by Abhishek Kumar on 06/02/22.
//

import Foundation
import UIKit


public protocol StackCardCell: UICollectionViewCell {
    var indexPath: IndexPath? { get set }
    var cellState: CardsPosition { get set }
}

/// Struct for the UI information related to cards.
public struct Configuration {
    
    /// Offset(distance between the top of the consecutive cards) between the cards while the cards are in collapsed state
    public let cardOffset: Float
    
    /// Height of the collection view when the cards are in collapsed state
    public let collapsedHeight:Float
    
    /// Height of the collection view when the cards are in expanded state
    public let expandedHeight:Float
    
    /// Height of the cards
    public let cardHeight: Float
    
    /// Vertical Spacing between the cards while the cards are in expanded state
    public let verticalSpacing: Float
    
    /// Leading space for the cards
    public let leftSpacing: Float
    
    /// Trailing space for the cards
    public let rightSpacing: Float
    
    public init(cardOffset: Float, collapsedHeight: Float,
                expandedHeight: Float, cardHeight: Float,
                leftSpacing: Float = 8.0, rightSpacing: Float = 8.0,
                verticalSpacing: Float = 8.0) {
        
        self.cardOffset = cardOffset
        self.collapsedHeight = collapsedHeight
        self.expandedHeight = expandedHeight
        self.cardHeight = cardHeight
        self.verticalSpacing = verticalSpacing
        self.leftSpacing = leftSpacing
        self.rightSpacing = rightSpacing
    }
}


@objc public enum CardsPosition: Int {
    /// Case when the cards are collapsed
    case collapsed
    
    /// Case when the cards are expanded
    case expanded
}


/// Delegate to get hooks to interaction over cells
@objc public protocol StackCardsManagerDelegate {
    @objc optional func stack(tappded cell: UICollectionViewCell?,
                              for indexPath: IndexPath?,
                              state: CardsPosition)
}

/// Datasource to get hooks to recive the data from the UI
@objc public protocol StackCardManagerDataSource: AnyObject {
    func stack(_ cardsCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func stack(_ cardsCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    @objc optional func numberOfSectionsStackCard(in collectionView: UICollectionView) -> Int
}

public class StackCard {
    
    public weak var delegate: StackCardsManagerDelegate? = nil {
        didSet {
            stackCardsManager.delegate = delegate
        }
    }
    
    public weak var datasource: StackCardManagerDataSource? = nil {
        didSet {
            stackCardsManager.datasource = datasource
        }
    }
    
    internal var stackCardsManager: StackCardsManager
    
    internal var position: CardsPosition
    
    /// init
    ///
    /// - parameter cardsState:           Initial state of the cards
    /// - parameter configuration:        Instance of the Configuration, which holds the UI related information
    /// - parameter collectionView:       UICollectionView
    /// - parameter collectionViewHeight: NSLayoutConstraint, height constraint of the collectionview
    ///
    /// - returns: CardStack
    public init(stackCardState: CardsPosition, configuration: Configuration, collectionView: UICollectionView, collectionViewHeight: NSLayoutConstraint?) {
        
        position = stackCardState
        stackCardsManager = StackCardsManager(stackCardState: stackCardState, configuration: configuration, collectionView: collectionView, heightConstraint: collectionViewHeight)
        stackCardsManager.stackCard = self
    }
    
    /// changeCardsPosition(to position: CardsPosition)
    /// This function can be called on CardStack to change the state of cardsStack. It can be used to programmatically change the states of the cards stack
    /// - parameter position: CardsPosition
    public func changeCardsPosition(to position: CardsPosition) {
        stackCardsManager.updateView(with: position)
    }
    
    public func registerCell<T: StackCardCell>(_ stackCardCell: T.Type?, forIdentifier: String) {
        stackCardsManager.register(stackCardCell, forCellWithReuseIdentifier: forIdentifier)
    }
    
    public func dequeueReusableCellStackCard(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        stackCardsManager.dequeueReusableCellStackCard(withReuseIdentifier: identifier, for: indexPath)
   }
}
