//
//  IngredientsBuilder.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class IngredientBuilderBase: NSObject {
    var name: String?
    var percent: Double?
    var temperature: Double?
    
    func isReady() -> Bool {
        fatalError()
    }
}

enum IngredientMeasurementMode {
    case percent, weight
}

class IngredientBuilder: IngredientBuilderBase {
    var weight: Double?
    var mode: IngredientMeasurementMode = .percent
    
    override init() { }
    
    init(ingredient: Ingredient) {
        super.init()
        self.name = ingredient.name
        self.percent = ingredient.defaultPercentage
        self.temperature = ingredient.temperature
    }
    
    override func isReady() -> Bool {
        let measurementReady = mode == .percent
            ? percent != nil
            : weight != nil
        return name != nil && measurementReady
    }
    
    func build(totalFlourWeight: Double) throws -> Ingredient {
        guard let name = name else {
            throw RecipeBuilderError.invalidIngredients
        }
        
        if mode == .percent {
            guard let defaultPercentage = percent else {
                throw RecipeBuilderError.invalidIngredients
            }
            return Ingredient(name: name,
                              isFlour: false,
                              defaultPercentage: defaultPercentage,
                              temperature: temperature)
        }
        else {
            guard let weight = weight else {
                throw RecipeBuilderError.invalidIngredients
            }
            let defaultPercent = (weight / totalFlourWeight) * 100
            return Ingredient(name: name,
                              isFlour: false,
                              defaultPercentage: defaultPercent,
                              temperature: temperature)
        }
    }
    
    static func == (lhs: IngredientBuilder, rhs: IngredientBuilder) -> Bool {
        return lhs.name == rhs.name &&
            lhs.percent == rhs.percent &&
            lhs.weight == rhs.weight &&
            lhs.mode == rhs.mode &&
            lhs.temperature == rhs.temperature
    }
}

class FlourBuilder: IngredientBuilderBase {
    
    override init() { }
    
    init(ingredient: Ingredient) {
        super.init()
        self.name = ingredient.name
        self.percent = ingredient.defaultPercentage
        self.temperature = ingredient.temperature
    }
    
    override func isReady() -> Bool {
        return name != nil && percent != nil
    }
    
    func build() throws -> Ingredient {
        guard let name = name else {
            throw RecipeBuilderError.invalidIngredients
        }
        guard let defaultPercentage = percent else {
            throw RecipeBuilderError.invalidIngredients
        }
        return Ingredient(name: name,
                          isFlour: true,
                          defaultPercentage: defaultPercentage,
                          temperature: temperature)
    }
    
    static func == (lhs: FlourBuilder, rhs: FlourBuilder) -> Bool {
        return lhs.name == rhs.name &&
            lhs.percent == rhs.percent &&
            lhs.temperature == rhs.temperature
    }
}
