//
//  RegistrationViewModel.swift
//  tinder
//
//  Created by Raghu Sairam on 01/08/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValidation = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
    
    var fullName:String? { didSet { checkFormValidity() } }
    
    var email:String? { didSet { checkFormValidity() } }
    
    var password:String? { didSet { checkFormValidity() } }
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValidation.value = isFormValid
    }
    
    func performRegistration(completion: @escaping (Error?)-> ()) {
        
        guard let email = email, let password = password else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                completion(err)
                return
            }
            print("succesfully created user account", res?.user.uid ?? "")
            let fileName = UUID().uuidString
            let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
            let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
            
            ref.putData(imageData, metadata: nil, completion: { (metaData, err) in
                if let err = err {
                    completion(err)
                    return
                }
                
                ref.downloadURL(completion: { (url, err) in
                    if let err = err {
                        completion(err)
                        return
                    }
                    
                    print("absoluteString:",url?.absoluteString ?? "unable to get the path of the file")
                    self.bindableIsRegistering.value = false
                })
                
            })
            
        }
    }
    
    
    
}
