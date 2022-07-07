//
//  AddCoffeeOrderViewModel.swift
//  HotCoffee
//
//  Created by BRM13259 on 06/07/22.
//

import Foundation

struct AddCoffeeOrderViewModel {
    var name: String?
    var email: String?
    
    var selectedType: String?
    var selectedSize: String?
    
    var type: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var size: [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }
}
