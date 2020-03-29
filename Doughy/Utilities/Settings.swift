//
//  Settings.swift
//  Doughy
//
//  Created by urickg on 3/20/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

fileprivate let hasInitializedDefaultsKey = "hasInitializedDefaultsKey"

class Settings: NSObject {
    
    private let recipeReader = RecipeReader.shared
    private let recipeWriter = RecipeWriter.shared
    private let defaultRecipeFactory = DefaultRecipeFactory.shared
    private let userDefaults = UserDefaults.standard
    
    lazy var recipes = self.refreshRecipes()
    
    static let shared = Settings()
    
    private override init() {
        super.init()
        
        self.initializeDefaultRecipes()
    }
    
    func refreshRecipes() -> [RecipeCollection] {
        let recipes = recipeReader.getRecipes()
        var collectionsMap = [String : RecipeCollection]()
        for recipe in recipes {
            if let collection = collectionsMap[recipe.collection!] {
                collection.recipes.append(recipe)
            }
            else {
                let newCollection = RecipeCollection(name: recipe.collection!)
                newCollection.recipes.append(recipe)
                collectionsMap[recipe.collection!] = newCollection
            }
        }
        let collections = collectionsMap.values.sorted { (a, b) -> Bool in
            return a.name < b.name
        }
        return collections
    }
}

extension Settings {
    
    func initializeDefaultRecipes() {
        
        if !userDefaults.bool(forKey: hasInitializedDefaultsKey) {
            defaultRecipeFactory.create().forEach {
                recipeWriter.writeRecipe(recipe: $0)
            }
            userDefaults.set(true, forKey: hasInitializedDefaultsKey)
        }
        
    }
    
}
