//
//  Recipe.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class Recipe: NSObject {
    
    let name: String
    let collection: String
    let defaultWeight: Double
    let ingredients: [Ingredient]
    let preferment: Preferment?
    let instructions: [Instruction]
    
    init(name: String, collection: String,
         defaultWeight: Double, ingredients: [Ingredient],
         preferment: Preferment?, instructions: [Instruction]) {
        self.name = name
        self.collection = collection
        self.defaultWeight = defaultWeight
        self.ingredients = ingredients
        self.preferment = preferment
        self.instructions = instructions
    }

}
