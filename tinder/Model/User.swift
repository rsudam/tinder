//
//  User.swift
//  tinder
//
//  Created by Raghu Sairam on 18/07/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit

struct User:ProducesCardViewModel {
    let name: String
    let age: Int
    let profession: String
    let profileImage: String
    
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: "\(name)", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        attributedText.append(NSAttributedString(string: " \(age)", attributes: [.font :UIFont.systemFont(ofSize: 24, weight: .regular) ]))
        
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font :UIFont.systemFont(ofSize: 20, weight: .regular) ]))

        
        return CardViewModel.init(imageName: profileImage, attributedString: attributedText, textAlignment: .left)
    }
    
}
