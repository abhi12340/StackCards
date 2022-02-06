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
    var cardsStack: StackCard?
    var nameList = ["Details", "Resume", "Assesment", "practice"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let expandedHeight = Float(UIScreen.main.bounds.size.height - 124)
        
        let config = Configuration(cardOffset: 40, collapsedHeight: 200, expandedHeight: expandedHeight, cardHeight: 200, leftSpacing: 16.0, rightSpacing: 16.0)

        cardsStack = StackCard(stackCardState: cardState, configuration: config, collectionView: collectionView, collectionViewHeight: collectionViewHeightConstaints)
        cardsStack?.registerCell(CardCell.self, forIdentifier: "cardCell")
        cardsStack?.datasource = self
        cardsStack?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: StackCardsManagerDelegate {
    
    func stack(tappded cell: UICollectionViewCell, for indexPath: IndexPath, state: CardsPosition) {
        print("debugging", indexPath.row, "state", state.rawValue)
    }
}

extension ViewController: StackCardManagerDataSource {
    
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

