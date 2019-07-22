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
    
    
    let cardViewModels:[CardViewModel] = {
        let producer = [
            User.init(name: "Kelly", age: 23, profession: "Music DJ", imageNames: ["kelly1","kelly2","kelly3"]),
            User.init(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1","jane2","jane3"]),
            Adverstiser.init(title: "Slide Out Menu", brandName: "Lets build that app", posterImages: ["slide_out_menu_poster"]),
            User.init(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1","jane2","jane3"])
        ] as [ProducesCardViewModel]
        
        let viewModels = producer.map({return $0.toCardViewModel()})
        return viewModels
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupDummyCards()
        
    }
    
    
    //MARK:- file private method
    
    fileprivate func setupDummyCards() {
        
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
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

