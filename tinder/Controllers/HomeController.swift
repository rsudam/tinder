//
//  ViewController.swift
//  tinder
//
//  Created by Raghu Sairam on 16/07/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupDummyCards()
        fetchDocumentsFromFireStore()
        
    }
    
    
    //MARK:- file private method
    
    @objc fileprivate func handleSettings() {
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    fileprivate func setupDummyCards() {
        
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
            
        }
        
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        let overallStackView = UIStackView(arrangedSubviews: [topStackView,cardsDeckView,bottomStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)

        overallStackView.bringSubviewToFront(cardsDeckView)
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    }
    
    fileprivate func fetchDocumentsFromFireStore() {
        
        
        Firestore.firestore().collection("users").getDocuments { (snapshot, err) in
            if err != nil {
                print("unable to fetch the documents form firestore")
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                let user = User(dictionary: dictionary)
                self.cardViewModels.append(user.toCardViewModel())
            })
            self.setupDummyCards()
            
        }
    }

}

