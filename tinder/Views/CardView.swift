//
//  CardView.swift
//  tinder
//
//  Created by Raghu Sairam on 17/07/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let panGessture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGessture)
    }
    
    //MARK:- fileprivate
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded()
        default:
                ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }

    fileprivate func handleEnded() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.transform = .identity
        }) { (_) in
            
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
