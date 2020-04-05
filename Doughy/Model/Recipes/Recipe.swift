//
//  Recipe.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

protocol RecipeProtocol {
    
    var name: String { get }
    var collection: String { get }
    var defaultWeight: Double { get }
    var ingredients: [Ingredient] { get }
    var instructions: [Instruction] { get }
    
    func containsVariableTemps() -> Bool
}

class Recipe: NSObject, RecipeProtocol {
    
    let name: String
    let collection: String
    let defaultWeight: Double
    let ingredients: [Ingredient]
    let instructions: [Instruction]
    
    init(name: String, collection: String,
         defaultWeight: Double, ingredients: [Ingredient],
         instructions: [Instruction]) {
        self.name = name
        self.collection = collection
        self.defaultWeight = defaultWeight
        self.ingredients = ingredients
        self.instructions = instructions
    }
    
    func containsVariableTemps() -> Bool {
        for ingredient in ingredients {
            if ingredient.temperature != nil {
                return true
            }
        }
        return false
    }
    
}

class PrefermentRecipe: NSObject, RecipeProtocol {
    
    let preferment: Preferment
    
    let name: String
    let collection: String
    let defaultWeight: Double
    let ingredients: [Ingredient]
    let instructions: [Instruction]
    
    init(name: String, collection: String,
         defaultWeight: Double, ingredients: [Ingredient],
         preferment: Preferment, instructions: [Instruction]) {
        self.name = name
        self.collection = collection
        self.defaultWeight = defaultWeight
        self.ingredients = ingredients
        self.preferment = preferment
        self.instructions = instructions
    }
    
    func containsVariableTemps() -> Bool {
        for ingredient in ingredients {
            if ingredient.temperature != nil {
                return true
            }
        }
        for ingredient in preferment.ingredients {
            if ingredient.temperature != nil {
                return true
            }
        }
        return false
    }
}
