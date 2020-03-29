//
//  RecipeReader.swift
//  Doughy
//
//  Created by urickg on 3/21/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import CoreData

class RecipeReader: NSObject {
    
    private let coreDataGateway = CoreDataGateway.shared
    
    static let shared = RecipeReader()
    
    private override init() { }
    
    func getRecipes() -> [Recipe] {
        let fetchRequest = NSFetchRequest<Recipe>(entityName: "Recipe")
        
        do {
            return try self.coreDataGateway.managedObjectConext.fetch(fetchRequest)
        }
        catch {
            print("No recipe collections")
        }
        return []
    }
    
    func getRecipes(collection: String) -> [Recipe] {
        let fetchRequest = NSFetchRequest<Recipe>(entityName: "Recipe")
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
