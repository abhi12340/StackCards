//
//  ViewController.swift
//  DemoApplication
//
//  Created by Abhishek Kumar on 06/02/22.
//

import UIKit
import StackCards

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstaints: NSLayoutConstraint!
    
    var cardState: CardsPosition = .collapsed
    var cardsStack: StackCard = StackCard()
    var nameList = ["Details", "Resume", "Assesment"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "cardCell")
        collectionView.dataSource = self
        let expandedHeight = Float(UIScreen.main.bounds.size.height - 124)
        
        let config = Configuration(cardOffset: 60, collapsedHeight: 200, expandedHeight: expandedHeight, cardHeight: 200, downwardThreshold: 20, upwardThreshold: 20, leftSpacing: 16.0, rightSpacing: 16.0)

        cardsStack = StackCard(stackCardState: cardState, configuration: config, collectionView: collectionView, collectionViewHeight: collectionViewHeightConstaints)
        cardsStack.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UICollectionViewDataSource, StackCardsManagerDelegate {
    
    func tappedOnCardsStack(cardsCollectionView: UICollectionView) {
        cardsStack.changeCardsPosition(to: .expanded)
    }
    
    func stackCardsCollectionView(_ cardsCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        cardsStack.changeCardsPosition(to: .collapsed)
    }
    
    func stackCardsPositionChangedTo(position: CardsPosition) {
        print("CardsPosition Changed To \(position.rawValue)")
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cardView = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as? CardCell else {
            fatalError("Failed to downcast to CardView")
        }
        cardView.label.text = nameList[indexPath.item]
        return cardView
    }

}

