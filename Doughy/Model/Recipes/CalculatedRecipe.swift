//
//  CalculatedRecipe.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class CalculatedRecipe: NSObject {
    
    let name: String
    let weight: Double
    let ingredients: [CalculatedIngredient]
    let preferment: CalculatedPreferment?
    let instructions: [Instruction]
    
    init(name: String, weight: Double,
         ingredients: [CalculatedIngredient], preferment: CalculatedPreferment?,
         instructions: [Instruction]) {
        self.name = name
        self.weight = weight
        self.ingredients = ingredients
        self.preferment = preferment
        self.instructions = instructions
    }

}
