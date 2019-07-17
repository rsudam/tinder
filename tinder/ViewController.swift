//
//  ViewController.swift
//  tinder
//
//  Created by Raghu Sairam on 16/07/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let topStackView = TopNavigationStackView()
    let blueView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueView.backgroundColor = .blue
        setupLayout()
        
    }
    
    
    //MARK:- file private method
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView,blueView,bottomStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }


}

