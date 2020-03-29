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
    
    static let shared = RecipeWriter()
    
    private override init() { }
    
    func writeRecipe(recipe: Recipe) {
        print("Writing Recipe \(recipe)")
        
        do {
            try self.coreDataGateway.managedObjectConext.save()
        }
        catch {
            print(error)
        }
    }
    
    func deleteRecipe(recipe: Recipe) {
        print("Deleting Recipe \(recipe)")
        
        self.coreDataGateway.managedObjectConext.delete(recipe)
        
        do {
            try self.coreDataGateway.managedObjectConext.save()
        }
        catch {
            print(error)
        }
    }

}
