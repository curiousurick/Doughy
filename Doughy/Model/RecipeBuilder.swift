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
    
    var flourBuilder: IngredientsBuilder? {
        didSet {
            isModified = true
        }
    }
    var ingredientsBuilder: IngredientsBuilder? {
        didSet {
            isModified = true
        }
    }
    
    override init() { }

    init(recipe: Recipe) {
        self.existingName = recipe.name
        self.name = recipe.name
        self.existingCollection = recipe.collection
        self.collection = recipe.collection
        self.defaultWeight = recipe.defaultWeight
        self.instructions = recipe.instructions
        let ingredients = recipe.ingredients
        self.flourBuilder = IngredientsBuilder(ingredients: ingredients, isFlour: true)
        self.ingredientsBuilder = IngredientsBuilder(ingredients: ingredients, isFlour: false)
    }

    func isReadyToAddIngredients() -> Bool {
        return name != nil && collection != nil && defaultWeight != nil
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
        guard let flourBuilder = flourBuilder else {
            throw RecipeBuilderError.invalidIngredients
        }
        var ingredients = [Ingredient]()
        ingredients.append(contentsOf: try flourBuilder.build())
        guard let ingredientsBuilder = ingredientsBuilder else {
            throw RecipeBuilderError.invalidIngredients
        }
        ingredients.append(contentsOf: try ingredientsBuilder.build())
        return Recipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, preferment: nil, instructions: instructions)
    }
}

enum RecipeBuilderError: Error {
    case missingName
    case missingCollection
    case missingDefaultWeight
    case missingInstructions
    case invalidIngredients
}
