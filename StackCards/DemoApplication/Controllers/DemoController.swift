//
//  ViewController.swift
//  DemoApplication
//
//  Created by Abhishek Kumar on 06/02/22.
//

import UIKit
import StackCards

class DemoController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstaints: NSLayoutConstraint!
    
    var cardState: CardsPosition = .collapsed
    var cardsStack: StackCard?
    var nameList = ["Details", "Resume", "Assesment", "practice"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let expandedHeight = Float(UIScreen.main.bounds.size.height - 150)
        
        let config = Configuration(cardOffset: 40, collapsedHeight: 200, expandedHeight: expandedHeight, cardHeight: 200, leftSpacing: 16.0, rightSpacing: 16.0)

        cardsStack = StackCard(stackCardState: cardState, configuration: config, collectionView: collectionView, collectionViewHeight: collectionViewHeightConstaints)
        cardsStack?.registerCell(CardCell.self, forIdentifier: "cardCell")
        cardsStack?.datasource = self
        cardsStack?.delegate = self
    }
}

extension DemoController: StackCardsManagerDelegate {
    
    func stack(tappded cell: UICollectionViewCell?, for indexPath: IndexPath?, state: CardsPosition) {
        print("debugging", indexPath?.row ?? 0, "state", state.rawValue)
    }
}

extension DemoController: StackCardManagerDataSource {
    
    func stack(_ cardsCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cardView = cardsStack?.dequeueReusableCellStackCard(withReuseIdentifier: "cardCell", for: indexPath) as? CardCell else {
            fatalError("Failed to downcast to CardView")
        }
        cardView.label.text = nameList[indexPath.item]
        return cardView
    }
    
    func stack(_ cardsCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func numberOfSectionsStackCard(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

