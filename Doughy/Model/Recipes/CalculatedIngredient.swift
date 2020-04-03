//
//  CalculatedIngredient.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class CalculatedIngredient: NSObject {

    let name: String
    let isFlour: Bool
    var percentage: Double
    var totalPercentage: Double
    let temperature: Temperature?
    let weight: Double
    
    init(name: String, isFlour: Bool,
         percentage: Double, totalPercentage: Double,
         temperature: Temperature?, weight: Double) {
        self.name = name
        self.isFlour = isFlour
        self.percentage = percentage
        self.totalPercentage = totalPercentage
        self.temperature = temperature
        self.weight = weight
    }
    
}
