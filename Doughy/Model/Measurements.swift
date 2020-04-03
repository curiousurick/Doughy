//
//  IngredientWithPercentage.swift
//  Doughy
//
//  Created by urickg on 3/20/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class MeasuredIngredient {
    let ingredient: Ingredient
    let percent: Double
    let temperature: Temperature?
    
    init(ingredient: Ingredient, percent: Double, temperature: Temperature?) {
        self.ingredient = ingredient
        self.percent = percent
        self.temperature = temperature
    }
}

class MeasuredPreferment {
    let ingredients: [MeasuredIngredient]
    let name: String
    let flourPercentage: Double
    
    init(ingredients: [MeasuredIngredient], name: String, flourPercentage: Double) {
        self.ingredients = ingredients
        self.name = name
        self.flourPercentage = flourPercentage
    }
}
