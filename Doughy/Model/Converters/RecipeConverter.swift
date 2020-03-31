//
//  RecipeConverter.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class RecipeConverter: NSObject {
    
    let objectFactory = ObjectFactory.shared
    let ingredientConverter = IngredientConverter.shared
    let prefermentConverter = PrefermentConverter.shared
    let instructionConverter = InstructionConverter.shared
    let coreDataGateway = CoreDataGateway.shared
    
    static let shared = RecipeConverter()
    
    private override init() { }
    
    func convertToCoreData(recipe: Recipe) -> XCRecipe {
        let coreData = objectFactory.createRecipe()
        
        coreData.name = recipe.name
        coreData.collection = recipe.collection
        coreData.defaultWeight = NSNumber(floatLiteral: recipe.defaultWeight)
        recipe.ingredients.forEach {
            coreData.addToIngredients(ingredientConverter.convertToCoreData(ingredient: $0))
        }
        recipe.instructions.forEach {
            coreData.addToInstructions(instructionConverter.convertToCoreData(instruction: $0))
        }
        if let preferment = recipe.preferment {
            coreData.preferment = prefermentConverter.convertToCoreData(preferment: preferment)
        }
        
        return coreData
    }
    
    func overWriteCoreData(recipe: Recipe, existing: XCRecipe) -> XCRecipe {
        
        existing.name = recipe.name
        existing.collection = recipe.collection
        existing.defaultWeight = NSNumber(floatLiteral: recipe.defaultWeight)
        self.replaceIngredients(recipe: recipe, existing: existing)
        self.replaceInstructions(recipe: recipe, existing: existing)
        
        if let preferment = recipe.preferment {
            if let existingPreferment = existing.preferment {
                self.coreDataGateway.managedObjectConext.delete(existingPreferment)
            }
            existing.preferment = prefermentConverter.convertToCoreData(preferment: preferment)
        }
        
        return existing
    }
    
    private func replaceIngredients(recipe: Recipe, existing: XCRecipe) {
        let ingredients = existing.ingredients!.array as! [XCIngredient]
        existing.removeFromIngredients(existing.ingredients!)
        ingredients.forEach {
            self.coreDataGateway.managedObjectConext.delete($0)
        }
        recipe.ingredients.forEach {
            existing.addToIngredients(ingredientConverter.convertToCoreData(ingredient: $0))
        }
    }
    
    private func replaceInstructions(recipe: Recipe, existing: XCRecipe) {
        let instructions = existing.instructions!.array as! [XCInstruction]
        existing.removeFromInstructions(existing.instructions!)
        instructions.forEach {
            self.coreDataGateway.managedObjectConext.delete($0)
        }
        recipe.instructions.forEach {
            existing.addToInstructions(instructionConverter.convertToCoreData(instruction: $0))
        }
    }
    
    func convertToExternal(recipe: XCRecipe) -> Recipe {
        let name = recipe.name!
        let collection = recipe.collection!
        let defaultWeight = recipe.defaultWeight!.doubleValue
        let ingredients = (recipe.ingredients!.array as! [XCIngredient]).map {
            ingredientConverter.convertToExternal(ingredient: $0)
        }
        let instructions = (recipe.instructions!.array as! [XCInstruction]).map {
            instructionConverter.convertToExternal(instruction: $0)
        }
        var preferment: Preferment? = nil
        if let xcPreferment = recipe.preferment {
             preferment = prefermentConverter.convertToExternal(preferment: xcPreferment)
        }
        
        return Recipe(name: name, collection: collection, defaultWeight: defaultWeight, ingredients: ingredients, preferment: preferment, instructions: instructions)
        
    }
}
