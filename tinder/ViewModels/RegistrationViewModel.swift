//
//  RegistrationViewModel.swift
//  tinder
//
//  Created by Raghu Sairam on 01/08/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    
    var fullName:String? { didSet { checkFormValidity() } }
    
    var email:String? { didSet { checkFormValidity() } }
    
    var password:String? { didSet { checkFormValidity() } }
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValidation.value = isFormValid
    }
    
    var bindableIsFormValidation = Bindable<Bool>()
    
}
