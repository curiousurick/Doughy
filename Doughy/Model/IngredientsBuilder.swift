//
//  IngredientsBuilder.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class PrefermentBuilder: NSObject {
    // Used to help removeAll function so we don't delete
    // all builders just because they having matching values
    let builderId = UUID()
    
    var name: String?
    var totalFlourPercent: Double?
    
    var flourBuilders: [PrefermentIngredientBuilder] = []
    var ingredientBuilders: [PrefermentIngredientBuilder] = []
    
    override init() { }
    
    init(preferment: Preferment, totalFlourWeight: Double) {
        self.name = preferment.name
        self.totalFlourPercent = preferment.flourPercentage
        let totalPrefermentFlourWeight = (preferment.flourPercentage / 100) * totalFlourWeight
        self.flourBuilders = preferment.ingredients
            .filter { $0.isFlour }
            .map {
                let weight = ($0.defaultPercentage / 100) * totalPrefermentFlourWeight
                return PrefermentIngredientBuilder(ingredient: $0, weight: weight)
        }
        self.ingredientBuilders = preferment.ingredients
            .filter { !$0.isFlour }
            .map {
                let weight = ($0.defaultPercentage / 100) * totalPrefermentFlourWeight
                return PrefermentIngredientBuilder(ingredient: $0, weight: weight)
        }
    }
    
    func build(totalFlourWeight: Double) throws -> Preferment {
        guard let name = name else {
            throw RecipeBuilderError.invalidIngredients
        }
        guard let totalFlourPercent = totalFlourPercent else {
            throw RecipeBuilderError.invalidIngredients
        }
        
        let prefermentFlourWeight = (totalFlourPercent / 100) * totalFlourWeight
        var ingredients = [Ingredient]()
        let flour = try flourBuilders.map { try $0.build(totalFlourWeight: prefermentFlourWeight) }
        ingredients.append(contentsOf: flour)
        
        let remainingIngredients = try ingredientBuilders.map { try $0.build(totalFlourWeight: prefermentFlourWeight)}
        ingredients.append(contentsOf: remainingIngredients)
        
        return Preferment(name: name, flourPercentage: totalFlourPercent, ingredients: ingredients)
    }
    
    func isReady() -> Bool {
        if self.name == nil || self.totalFlourPercent == nil {
            return false
        }
        let flourReady = self.ingredientBuilders.reduce(true) {
            return $0 && $1.isReady()
        }
        let ingredientsReady = self.ingredientBuilders.reduce(true) {
            return $0 && $1.isReady()
        }
        return flourReady && ingredientsReady
    }
    
    /// Note that builderId is not copied
    override func copy() -> Any {
        let copy = PrefermentBuilder()
        copy.name = self.name
        copy.totalFlourPercent = self.totalFlourPercent
        copy.flourBuilders = self.ingredientBuilders.map {
            $0.copy() as! PrefermentIngredientBuilder
        }
        copy.ingredientBuilders = self.ingredientBuilders.map {
            $0.copy() as! PrefermentIngredientBuilder
        }
        return copy
    }
}

class MainDoughBuilder: NSObject {
    
    // Used to help removeAll function so we don't delete
    // all builders just because they having matching values
    var builderId = UUID()
    
    var flourBuilders: [FlourBuilder] = []
    var ingredientBuilders: [IngredientBuilder] = []
    
    override init() { }
    
    init(ingredients: [Ingredient]) {
        self.flourBuilders = ingredients
            .filter { $0.isFlour }
            .map { FlourBuilder(ingredient: $0) }
        self.ingredientBuilders = ingredients
            .filter { !$0.isFlour }
            .map { IngredientBuilder(ingredient: $0) }
    }
    
    func build(totalFlourWeight: Double, preferment: Preferment?) throws -> [Ingredient] {
        var mainIngredients = [Ingredient]()
        let flour = try flourBuilders.map { try $0.build() }
        mainIngredients.append(contentsOf: flour)
        let remainingIngredients = try ingredientBuilders.map { try $0.build(totalFlourWeight: totalFlourWeight)}
        mainIngredients.append(contentsOf: remainingIngredients)
        
        if let prefIngredients = preferment?.ingredients {
            mainIngredients.forEach {
                let name = $0.name
                if let match = prefIngredients.first(where: { $0.name == name }) {
                    $0.defaultPercentage += match.defaultPercentage
                }
            }
        }
        
        return mainIngredients
    }
    
    override func copy() -> Any {
        let copy = MainDoughBuilder()
        copy.flourBuilders = self.flourBuilders.map { $0.copy() as! FlourBuilder }
        copy.ingredientBuilders = self.ingredientBuilders.map { $0.copy() as! IngredientBuilder }
        return copy
    }
    
}

class IngredientBuilderBase: NSObject {
    // Used to help removeAll function so we don't delete
    // all builders just because they having matching values
    var builderId = UUID()
    
    var name: String?
    var temperature: Temperature?
    
    
    func isReady() -> Bool {
        fatalError()
    }
    
    override func copy() -> Any {
        fatalError("Never use IngredientBuilderBase")
    }
}

enum IngredientMeasurementMode {
    case percent, weight
}

class IngredientBuilder: IngredientBuilderBase {
    var percent: Double?
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
    
    override func copy() -> Any {
        let copy = IngredientBuilder()
        copy.name = self.name
        copy.percent = self.percent
        copy.temperature = self.temperature?.copy() as? Temperature
        copy.weight = self.weight
        copy.mode = self.mode
        return copy
    }
}

class PrefermentIngredientBuilder: IngredientBuilderBase {
    var weight: Double?
    var isFlour: Bool
    
    init(isFlour: Bool) {
        self.isFlour = isFlour
        super.init()
    }
    
    init(ingredient: Ingredient, weight: Double) {
        self.isFlour = ingredient.isFlour
        super.init()
        self.name = ingredient.name
        self.weight = weight
        self.temperature = ingredient.temperature
    }
    
    override func isReady() -> Bool {
        let measurementReady = weight != nil
        return name != nil && measurementReady
    }
    
    func build(totalFlourWeight: Double) throws -> Ingredient {
        guard let name = name else {
            throw RecipeBuilderError.invalidIngredients
        }
        guard let weight = weight else {
            throw RecipeBuilderError.invalidIngredients
        }
        let defaultPercent = (weight / totalFlourWeight) * 100
        return Ingredient(name: name,
                          isFlour: isFlour,
                          defaultPercentage: defaultPercent,
                          temperature: temperature)
    }
    
    override func copy() -> Any {
        let copy = IngredientBuilder()
        copy.name = self.name
        copy.temperature = self.temperature?.copy() as? Temperature
        copy.weight = self.weight
        return copy
    }
}

class FlourBuilder: IngredientBuilderBase {
    
    var percent: Double?
    
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
    
    override func copy() -> Any {
        let copy = FlourBuilder()
        copy.name = self.name
        copy.percent = self.percent
        copy.temperature = self.temperature?.copy() as? Temperature
        return copy
    }
}
