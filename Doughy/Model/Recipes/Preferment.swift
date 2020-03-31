//
//  Preferment.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class Preferment: NSObject {
    
    let name: String
    let flourPercentage: Double
    let ingredients: [Ingredient]
    
    init(name: String, flourPercentage: Double, ingredients: [Ingredient]) {
        self.name = name
        self.flourPercentage = flourPercentage
        self.ingredients = ingredients
    }

}
