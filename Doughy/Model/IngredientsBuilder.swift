//
//  IngredientsBuilder.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class IngredientsBuilder: NSObject {
    private(set) var builders = [IngredientBuilder]()
    
    var isFlour: Bool
    
    init(isFlour: Bool) {
        self.isFlour = isFlour
    }
    
    func addBuilder() {
        let builder = IngredientBuilder(isFlour: self.isFlour)
        builders.append(builder)
    }
    
    func addBuilder(builder: IngredientBuilder) {
        builders.append(builder)
    }
    
    func removeBuilder(builder: IngredientBuilder) {
        builders.removeAll { $0 == builder }
    }
    
    func isReady() -> Bool {
        for builder in builders {
            if !builder.isReady() {
                return false
            }
        }
        if isFlour {
            let totalPercent = builders.map { $0.percent ?? 0 }
                .reduce(0, +)
            return totalPercent == 100
        }
        
        return true
    }
    
    func build() throws -> [Ingredient] {
        var ingredients = [Ingredient]()
        try builders.forEach { ingredients.append(try $0.build()) }
        return ingredients
    }
}

class IngredientBuilder: NSObject {
    var name: String?
    var percent: Double?
    var temperature: Double?
    var isFlour: Bool
    
    init(isFlour: Bool) {
        self.isFlour = isFlour
    }
    
    func isReady() -> Bool {
        return name != nil && percent != nil
    }
    
    func build() throws -> Ingredient {
        guard let name = name else {
            throw RecipeBuilderError.invalidIngredients
        }
        guard let defaultPercentage = percent else {
            throw RecipeBuilderError.invalidIngredients
        }
        return Ingredient(name: name, isFlour: isFlour, defaultPercentage: defaultPercentage, temperature: temperature)
    }
}
