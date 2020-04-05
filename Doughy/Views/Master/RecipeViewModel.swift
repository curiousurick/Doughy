//
//  MainViewModel.swift
//  ExpandingStackCells
//
//  Created by József Vesza on 27/06/15.
//  Copyright © 2015 Jozsef Vesza. All rights reserved.
//

import UIKit

struct RecipeViewModel {
    
    private var items = Settings.shared.recipes
    
    mutating func updateData() {
        self.items = Settings.shared.refreshRecipes()
    }
    
    func count() -> Int {
        return items.count
    }
    
    func titleForRow(row: Int) -> String {
        return items[row].name
    }
    
    func recipeForRow(section: Int, row: Int) -> RecipeProtocol {
        return items[section].recipes[row]
    }
    
    func collectionForSection(section: Int) -> RecipeCollection {
        return items[section]
    }
}
