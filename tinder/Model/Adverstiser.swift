//
//  Adverstiser.swift
//  tinder
//
//  Created by Raghu Sairam on 20/07/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit

struct Adverstiser:ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterImage: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font : UIFont.systemFont(ofSize: 34, weight: .heavy)])
        
        attributedString.append(NSAttributedString(string: "\n\(brandName)", attributes: [.font : UIFont.systemFont(ofSize: 28, weight: .regular)]))
        
        return CardViewModel.init(imageName: posterImage, attributedString: attributedString, textAlignment: .center)
    }
}
