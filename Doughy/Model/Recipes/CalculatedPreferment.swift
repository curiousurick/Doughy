//
//  CalculatedPreferment.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class CalculatedPreferment: NSObject {
    
    let name: String
    let flourPercentage: Double
    let weight: Double
    let ingredients: [CalculatedIngredient]
    
    init(name: String, flourPercentage: Double,
         weight: Double, ingredients: [CalculatedIngredient]) {
        self.name = name
        self.flourPercentage = flourPercentage
        self.weight = weight
        self.ingredients = ingredients
    }

}
