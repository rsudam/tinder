//
//  Bindable.swift
//  tinder
//
//  Created by Raghu Sairam on 03/08/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import Foundation

class Bindable<T>{
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer:((T?)->())?
    
    func bind(observer: @escaping (T?) -> ()){
        self.observer = observer
    }
}
