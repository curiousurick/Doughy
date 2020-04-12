//
//  Ingredient.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class Ingredient: NSObject {
    
    let name: String
    let isFlour: Bool
    var defaultPercentage: Double
    let temperature: Temperature?
    
    init(name: String, isFlour: Bool, defaultPercentage: Double, temperature: Temperature?) {
        self.name = name
        self.isFlour = isFlour
        self.defaultPercentage = defaultPercentage
        self.temperature = temperature
    }

}
