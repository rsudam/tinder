//
//  CardView.swift
//  tinder
//
//  Created by Raghu Sairam on 17/07/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? ""
            imageView.image = UIImage(named: imageName)
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            if cardViewModel.imageNames.count > 1 {
                (0..<cardViewModel.imageNames.count).forEach { (_) in
                    let view = UIView()
                    view.backgroundColor = barDeselectedColor
                    view.layer.cornerRadius = 2
                    barStackView.addArrangedSubview(view)
                }
                barStackView.arrangedSubviews.first?.backgroundColor = .white
                setupImageIndexObserver()
            }
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self](index, image) in
            self?.barStackView.arrangedSubviews.forEach { (view) in
                view.backgroundColor = self?.barDeselectedColor
            }
            self?.barStackView.arrangedSubviews[index].backgroundColor = .white
            self?.imageView.image = image
        }
        
    }
    
    //encapsulation 
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    fileprivate let barStackView = UIStackView()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    //MARK:- configuration
    let threshold:CGFloat = 80
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        let panGessture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGessture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    //MARK:- fileprivate
    fileprivate func setupLayout() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperview()
        
        //bars stack view
        setupBarStacksView()
        
        //Add graident layer
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    
    
    fileprivate func setupBarStacksView() {
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
        barStackView.distribution = .fillEqually
        barStackView.spacing = 4
        
    }
    
    fileprivate func setupGradientLayer(){
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.5,1.1]
        layer.addSublayer(gradientLayer)
    }
    
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
                ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: nil)
        //converting degrees to radions(angles)
        
        let degrees: CGFloat = translation.x / 20
        let angle:CGFloat = degrees * .pi / 180
        
        let rotationalTransformation  = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
        

    }

    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        let translationDirection:CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            if shouldDismissCard {
                self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
            //self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
            
        }
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer){
        
        if cardViewModel.imageNames.count > 1 {
            let tapLocation = gesture.location(in: nil)
            
            let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
            
            if shouldAdvanceNextPhoto {
                cardViewModel.advanceToNextPhoto()
            } else {
                cardViewModel.gotoPreviousPhoto()
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
