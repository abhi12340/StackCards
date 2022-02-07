//
//  CollectionViewCell.swift
//  DemoApplication
//
//  Created by Abhishek Kumar on 06/02/22.
//

import UIKit
import StackCards

class CardCell: UICollectionViewCell, StackCardCell {
   
    var indexPath: IndexPath?
    
    var cellState: CardsPosition = .collapsed
    
    
    lazy var label: UILabel = {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 17)
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .random()
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([self.leadingAnchor.constraint(equalTo: label.leadingAnchor,
                                                                   constant: 8),
                                     self.trailingAnchor.constraint(equalTo: label.trailingAnchor,
                                                                    constant: 8),
                                     self.heightAnchor.constraint(equalToConstant: 40),
                                     self.widthAnchor.constraint(equalToConstant: self.frame.width)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        layer.cornerRadius = 4
        layer.rasterizationScale = UIScreen.main.scale
    }
}


extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
