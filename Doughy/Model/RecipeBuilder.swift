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
    
    func isReadyToAddIngredients() -> Bool {
        return name != nil && collection != nil && defaultWeight != nil
    }
    
    func build() throws -> Recipe {
        let recipe = ObjectFactory.shared.createRecipe()
        guard let collection = collection else {
            throw RecipeBuilderError.missingCollection
        }
        recipe.collection = collection
        guard let name = name else {
            throw RecipeBuilderError.missingName
        }
        recipe.name = name
        guard let defaultWeight = defaultWeight else {
            throw RecipeBuilderError.missingDefaultWeight
        }
        recipe.defaultWeight = NSNumber(floatLiteral: defaultWeight)
        guard let instructions = instructions else {
            throw RecipeBuilderError.missingInstructions
        }
        instructions.forEach { recipe.addToInstructions($0) }
        guard let flourBuilder = flourBuilder else {
            throw RecipeBuilderError.invalidIngredients
        }
        try flourBuilder.build().forEach { recipe.addToIngredients($0) }
        guard let ingredientsBuilder = ingredientsBuilder else {
            throw RecipeBuilderError.invalidIngredients
        }
        try ingredientsBuilder.build().forEach { recipe.addToIngredients($0) }
        return recipe
    }
}

enum RecipeBuilderError: Error {
    case missingName
    case missingCollection
    case missingDefaultWeight
    case missingInstructions
    case invalidIngredients
}
