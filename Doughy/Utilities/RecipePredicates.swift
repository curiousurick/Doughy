//
//  RecipePredicates.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class RecipePredicates: NSObject {
    
    static let shared = RecipePredicates()
    
    private let settings = Settings.shared
    
    private override init() { }
    
    func isRecipeNameTaken(name: String) -> Bool {
        return settings.recipes.flatMap { $0.recipes }
            .map { $0.name }.contains(name)
    }

}

