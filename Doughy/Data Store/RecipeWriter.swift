//
//  RecipesDataStore.swift
//  Doughy
//
//  Created by urickg on 3/20/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import CoreData

class RecipeWriter: NSObject {
    
    private let objectFactory = ObjectFactory.shared
    private let coreDataGateway = CoreDataGateway.shared
    private let recipeConverter = RecipeConverter.shared
    private let recipeReader = RecipeReader.shared
    
    static let shared = RecipeWriter()
    
    private override init() { }
    
    func writeRecipe(recipe: Recipe) {
        print("Writing Recipe \(recipe)")
        
        // Update if there exists a recipe by this name already
        if recipeReader.getRecipe(collection: recipe.collection, name: recipe.name) != nil {
            print("Attempted to write a recipe when one exists in the collection with this name")
            return
        }
        
        let _ = recipeConverter.convertToCoreData(recipe: recipe)
        
        do {
            try self.coreDataGateway.managedObjectConext.save()
        }
        catch {
            print(error)
        }
    }
    
    func updateRecipe(recipe: Recipe) {
        print("Updating Recipe \(recipe)")
        
        // Update if there exists a recipe by this name already
        guard let existingRecipe = recipeReader.getRecipe(collection: recipe.collection, name: recipe.name) else {
            print("Attempted to update a recipe when none exists in the collection with this name")
            return
        }
        
        let _ = recipeConverter.overWriteCoreData(recipe: recipe, existing: existingRecipe)
        
        do {
            try self.coreDataGateway.managedObjectConext.save()
        }
        catch {
            print(error)
        }
    }
    
    func deleteRecipe(recipe: Recipe) {
        print("Deleting Recipe \(recipe)")
        
        guard let coreDataRecipe = recipeReader.getRecipe(collection: recipe.collection, name: recipe.name) else {
            print("Cannot delete recipe. Recipe not found in core data")
            return
        }
        
        self.coreDataGateway.managedObjectConext.delete(coreDataRecipe)
        
        do {
            try self.coreDataGateway.managedObjectConext.save()
        }
        catch {
            print(error)
        }
    }

}
