//
//  RecipeBuilder.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class RecipeBuilder: NSObject {
    
    private(set) var isModified: Bool = false
    private(set) var existingName: String?
    private(set) var existingCollection: String?
    
    var name: String? {
        didSet {
            isModified = true
        }
    }
    var collection: String? {
        didSet {
            isModified = true
        }
    }
    var defaultWeight: Double? {
        didSet {
            isModified = true
        }
    }
    var instructions: [Instruction]? {
        didSet {
            isModified = true
        }
    }
    
    private(set) var flourBuilders: [FlourBuilder] = []
    private(set) var ingredientBuilders: [IngredientBuilder] = []
    
    override init() { }

    init(recipe: Recipe) {
        self.existingName = recipe.name
        self.name = recipe.name
        self.existingCollection = recipe.collection
        self.collection = recipe.collection
        self.defaultWeight = recipe.defaultWeight
        self.instructions = recipe.instructions
        let ingredients = recipe.ingredients
        self.flourBuilders = ingredients
            .filter { $0.isFlour }
            .map { FlourBuilder(ingredient: $0) }
        self.ingredientBuilders = ingredients
            .filter { !$0.isFlour }
            .map { IngredientBuilder(ingredient: $0) }
    }
    
    func build() throws -> Recipe {
        guard let collection = collection else {
            throw RecipeBuilderError.missingCollection
        }
        guard let name = name else {
            throw RecipeBuilderError.missingName
        }
        guard let defaultWeight = defaultWeight else {
            throw RecipeBuilderError.missingDefaultWeight
        }
        guard let instructions = instructions else {
            throw RecipeBuilderError.missingInstructions
        }
        guard !flourBuilders.isEmpty else {
            throw RecipeBuilderError.invalidIngredients
        }
        var ingredients = [Ingredient]()
        let flours = try flourBuilders.map { try $0.build() }
        ingredients.append(contentsOf: flours)
        
        guard !ingredientBuilders.isEmpty else {
            throw RecipeBuilderError.invalidIngredients
        }
        let flourWeight = calculateDefaultFlourWeight(defaultWeight: defaultWeight, ingredientBuilders: ingredientBuilders)
        let remainingIngredients = try ingredientBuilders.map { try $0.build(totalFlourWeight: flourWeight) }
        ingredients.append(contentsOf: remainingIngredients)
        return Recipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, preferment: nil, instructions: instructions)
    }
    
    private func calculateDefaultFlourWeight(defaultWeight: Double, ingredientBuilders: [IngredientBuilder]) -> Double {
        let totalUnknownWeight = ingredientBuilders
            .filter { $0.mode == .weight }
            .map { $0.weight ?? 0 }
            .reduce(0, +)
        let totalKnownPercent = ingredientBuilders
            .filter { $0.mode == .percent }
            .map { $0.percent ?? 0 }
            // Start at 100 because flour equals 100
            .reduce(100, +)
        let totalKnownWeight = defaultWeight - totalUnknownWeight
        return (100 / totalKnownPercent) * totalKnownWeight
    }
}

/// Extension to add support for adding and removing ingredient builders.
extension RecipeBuilder {
    
    func addFlour(flourBuilder: FlourBuilder) {
        self.flourBuilders.append(flourBuilder)
        self.isModified = true
    }
    
    func addIngredient(ingredientBuilder: IngredientBuilder) {
        self.ingredientBuilders.append(ingredientBuilder)
        self.isModified = true
    }
    
    func removeFlour(flourBuilder: FlourBuilder) {
        self.flourBuilders.removeAll { $0 == flourBuilder }
        self.isModified = true
    }
    
    func removeIngredient(ingredientBuilder: IngredientBuilder) {
        self.ingredientBuilders.removeAll { $0 == ingredientBuilder }
        self.isModified = true
    }
}

/// Readiness predicate methods for RecipeBuilder
extension RecipeBuilder {
    func isReadyToAddIngredients() -> Bool {
        return name != nil && collection != nil && defaultWeight != nil
    }
    
    func isFlourReady() -> Bool {
        var totalPercent = 0.0
        for flour in flourBuilders {
            if !flour.isReady() {
                return false
            }
            totalPercent += flour.percent!
        }
        return totalPercent == 100
    }
    
    func isIngredientsReady() -> Bool {
        for ingredient in ingredientBuilders {
            if !ingredient.isReady() {
                return false
            }
        }
        return true
    }
}

enum RecipeBuilderError: Error {
    case missingName
    case missingCollection
    case missingDefaultWeight
    case missingInstructions
    case invalidIngredients
}
