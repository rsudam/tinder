//
//  ViewController.swift
//  tinder
//
//  Created by Raghu Sairam on 16/07/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {

    //MARK:- instance variables
    let hud = JGProgressHUD(style: .dark)
    var lastFetchedUser: User?
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupLayout()
        setupFirestoreUserCards()
        fetchDocumentsFromFireStore()
        
    }
    
    
    //MARK:- file private method
    
    @objc fileprivate func handleRefresh() {
        fetchDocumentsFromFireStore()
    }
    
    @objc fileprivate func handleSettings() {
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    fileprivate func setupFirestoreUserCards() {
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
    }
    
    
    
    fileprivate func fetchDocumentsFromFireStore() {
        hud.textLabel.text = "Fetching Users..."
        hud.show(in: self.view)
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if err != nil {
                print("unable to fetch the documents form firestore")
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                let user = User(dictionary: dictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
            })
            //self.setupFirestoreUserCards()
            
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }

}

