//
//  CardViewModel.swift
//  tinder
//
//  Created by Raghu Sairam on 20/07/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit

class CardViewModel {
    
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageIndex = 0 {
        didSet{
            let imageName = imageUrls[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image)
        }
    }
    
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    func gotoPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
    
    // Reactive programming
    var imageIndexObserver: ((Int, UIImage?) -> ())?
    
    
}
