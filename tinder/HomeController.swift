//
//  ViewController.swift
//  tinder
//
//  Created by Raghu Sairam on 16/07/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    

    let users = [
        User.init(name: "Kelly", age: 23, profession: "Music DJ", profileImage: "lady5c"),
        User.init(name: "Jane", age: 18, profession: "Teacher", profileImage: "lady4c")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupDummyCards()
        
    }
    
    
    //MARK:- file private method
    
    fileprivate func setupDummyCards() {
        
        users.forEach { (user) in
            let cardView = CardView(frame: .zero)
            
            cardView.imageView.image = UIImage(named: user.profileImage)
            
            let attributedText = NSMutableAttributedString(string: "\(user.name)", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
            
            attributedText.append(NSAttributedString(string: " \(user.age)", attributes: [.font :UIFont.systemFont(ofSize: 28, weight: .regular) ]))
            
            attributedText.append(NSAttributedString(string: "\n\(user.profession)", attributes: [.font :UIFont.systemFont(ofSize: 28, weight: .regular) ]))
            
            cardView.informationLabel.attributedText = attributedText
            
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView,cardsDeckView,bottomStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)

        overallStackView.bringSubviewToFront(cardsDeckView)
    }


}

