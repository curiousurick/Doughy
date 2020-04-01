//
//  RecipeReader.swift
//  Doughy
//
//  Created by urickg on 3/21/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import CoreData

class CalculatedRecipeReader: NSObject {
    
    private let coreDataGateway = CoreDataGateway.shared
    
    static let shared = CalculatedRecipeReader()
    
    private override init() { }
    
    func getRecipes() -> [XCCalculatedRecipe] {
        let fetchRequest = NSFetchRequest<XCCalculatedRecipe>(entityName: "XCCalculatedRecipe")
        
        do {
            return try self.coreDataGateway.managedObjectConext.fetch(fetchRequest)
        }
        catch {
            print("No calculated recipes")
        }
        return []
    }
    
    func getRecipe(collection: String, name: String) -> XCCalculatedRecipe? {
        let fetchRequest = NSFetchRequest<XCCalculatedRecipe>(entityName: "XCCalculatedRecipe")
        fetchRequest.predicate = NSPredicate(format: "collection == %@", collection)
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try self.coreDataGateway.managedObjectConext.fetch(fetchRequest)
            return results.isEmpty ? nil : results[0]
        }
        catch {
            print("No recipe found for name \(name) collection \(collection)")
        }
        return nil
    }
    
    func getRecipes(collection: String) -> [XCRecipe] {
        let fetchRequest = NSFetchRequest<XCRecipe>(entityName: "XCRecipe")
        fetchRequest.predicate = NSPredicate(format: "collection == %@", collection)
        
        do {
            return try self.coreDataGateway.managedObjectConext.fetch(fetchRequest)
        }
        catch {
            print("No recipe collection with name \(collection)")
        }
        return []
    }

}
