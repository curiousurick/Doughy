//
//  CalculatedRecipeConverter.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class CalculatedRecipeConverter: NSObject {
    
    let objectFactory = ObjectFactory.shared
    let ingredientConverter = CalculatedIngredientConverter.shared
    let prefermentConverter = CalculatedPrefermentConverter.shared
    let instructionConverter = InstructionConverter.shared
    
    static let shared = CalculatedRecipeConverter()
    
    private override init() { }
    
    func convertToCoreData(recipe: CalculatedRecipe) -> XCCalculatedRecipe {
        let coreData = objectFactory.createCalculatedRecipe()
        
        coreData.name = recipe.name
        coreData.collection = recipe.collection
        coreData.weight = NSNumber(floatLiteral: recipe.weight)
        recipe.ingredients.forEach {
            coreData.addToIngredients(ingredientConverter.convertToCoreData(ingredient: $0))
        }
        if let preferment = recipe.preferment {
            coreData.preferment = prefermentConverter.convertToCoreData(preferment: preferment)
        }
        recipe.instructions.forEach {
            coreData.addToInstructions(instructionConverter.convertToCoreData(instruction: $0))
        }
        
        
        return coreData
    }
    
    func convertToExternal(recipe: XCCalculatedRecipe) -> CalculatedRecipe {
        let name = recipe.name!
        let collection = recipe.collection!
        let weight = recipe.weight!.doubleValue
        let ingredients = (recipe.ingredients!.array as! [XCCalculatedIngredient]).map {
            ingredientConverter.convertToExternal(ingredient: $0)
        }
        var preferment: CalculatedPreferment? = nil
        if let xcPreferment = recipe.preferment {
             preferment = prefermentConverter.convertToExternal(preferment: xcPreferment)
        }
        let instructions = (recipe.instructions!.array as! [XCInstruction]).map {
            instructionConverter.convertToExternal(instruction: $0)
        }
        
        
        return CalculatedRecipe(name: name, collection: collection, weight: weight, ingredients: ingredients, preferment: preferment, instructions: instructions)
        
    }
}
